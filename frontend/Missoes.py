import psycopg
import json

class Missoes:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal
        self.db_params = estado.db_params
        self.id_prota = estado.id_prota
        self.progresso_temp = {}  # progresso temporário em memória

    def get_conn(self):
        return psycopg.connect(**self.db_params)

    def listar_missoes(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute('''
                SELECT m.id_evento, r.tipo, r.alvo, r.quantidade, m.status, m.recompensas,
                CASE 
                    WHEN r.tipo = 'MATAR' THEN 
                        COALESCE((SELECT nome FROM nao_inteligente WHERE id_ser = r.alvo), (SELECT nome FROM inteligente WHERE id_ser = r.alvo), 'Desconhecido')
                    WHEN r.tipo = 'ENTREGAR' THEN 
                        (SELECT nome FROM coletavel WHERE id_item = r.alvo)
                    ELSE 'Desconhecido'
                END as nome_alvo
                FROM missao m
                JOIN requisitos r ON m.id_requisito = r.id_requisito
                WHERE m.status = 'A'
            ''')
            missoes = cur.fetchall()
        return missoes

    def progresso_missao(self, id_evento):
        # Primeiro verifica progresso temporário em memória
        if id_evento in self.progresso_temp:
            return self.progresso_temp[id_evento]
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Descobre o alvo da missão
            cur.execute('''
                SELECT r.alvo FROM missao m
                JOIN requisitos r ON m.id_requisito = r.id_requisito
                WHERE m.id_evento = %s
            ''', (id_evento,))
            alvo = cur.fetchone()
            if not alvo:
                return 0
            id_inimigo = alvo[0]
            # Conta quantos inimigos desse tipo já foram mortos (hp_atual <= 0)
            cur.execute('''
                SELECT COUNT(*) FROM inst_ser
                WHERE id_ser = %s AND hp_atual <= 0
            ''', (id_inimigo,))
            mortos = cur.fetchone()[0]
            return mortos

    def checar_completas(self):
        completas = []
        for missao in self.listar_missoes():
            id_evento, tipo, alvo, quantidade, status, recompensas, *_ = missao
            progresso = self.progresso_missao(id_evento)
            if progresso >= quantidade:
                completas.append(missao)
        return completas

    def resgatar_recompensa(self):
        completas = self.checar_completas()
        if not completas:
            print('Nenhuma missão completa para resgatar.')
            input('Pressione Enter para voltar.')
            return
        with self.get_conn() as conn:
            cur = conn.cursor()
            for missao in completas:
                id_evento, tipo, alvo, quantidade, status, recompensas, *resto = missao
                recomp_dict = json.loads(recompensas) if recompensas else {}
                moedas = recomp_dict.get('moeda', 0)
                if moedas > 0:
                    cur.execute('UPDATE inventario SET quant = quant + %s WHERE id_item = 1', (moedas,))
                    if cur.rowcount == 0:
                        cur.execute('INSERT INTO inventario (id_item, quant) VALUES (1, %s)', (moedas,))
                cur.execute("UPDATE missao SET status = 'F' WHERE id_evento = %s", (id_evento,))
            conn.commit()
        print('Recompensas resgatadas!')
        input('Pressione Enter para voltar.')

    def menu_missoes(self):
        while True:
            print('\n==== MISSÕES DISPONÍVEIS ====' )
            missoes = self.listar_missoes()
            for m in missoes:
                id_evento, tipo, alvo, quantidade, status, recompensas, nome_alvo = m
                progresso = self.progresso_missao(id_evento)
                print(f'ID: {id_evento} | Tipo: {tipo} | Alvo: {nome_alvo.strip() if nome_alvo else alvo} | Quant: {quantidade} | Progresso: {progresso}/{quantidade} | Status: {status}')
            print('\n1. Resgatar recompensas')
            print('2. Voltar')
            op = input('Escolha: ')
            if op == '1':
                self.resgatar_recompensa()
            else:
                break

    def incrementar_progresso(self, id_evento):
        if id_evento not in self.progresso_temp:
            self.progresso_temp[id_evento] = 1
        else:
            self.progresso_temp[id_evento] += 1