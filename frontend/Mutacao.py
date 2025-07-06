import os
import psycopg

class Mutacao:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_mutacoes_atuais(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute('''
                SELECT cabeca, torso, maos, pernas, pes
                FROM mutacao_atual
                WHERE id_ser = %s
            ''', (self.estado.id_prota,))
            row = cur.fetchone()
            partes = ['Cabeça', 'Torso', 'Mãos', 'Pernas', 'Pés']
            mutacoes = {}
            if row:
                for idx, id_mut in enumerate(row):
                    if id_mut:
                        cur.execute('SELECT nome FROM mutacao WHERE id_mutacao = %s', (id_mut,))
                        nome = cur.fetchone()
                        mutacoes[partes[idx]] = nome[0].strip() if nome else 'Desconhecida'
                    else:
                        mutacoes[partes[idx]] = 'Nenhuma'
            else:
                for parte in partes:
                    mutacoes[parte] = 'Nenhuma'
        print('\n--- Mutações Atuais ---')
        for parte, nome in mutacoes.items():
            print(f"{parte}: {nome}")
        input('\nPressione Enter para continuar.')