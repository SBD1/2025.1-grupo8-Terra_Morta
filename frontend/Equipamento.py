import psycopg
import inquirer
import os

class Equipamento:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_equipamentos_atuais(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute('''
                SELECT cabeca, torso, maos, pernas, pes
                FROM equipamento_atual
                WHERE id_ser = %s
            ''', (self.estado.id_prota,))
            row = cur.fetchone()
            partes = ['Cabeça', 'Torso', 'Mãos', 'Pernas', 'Pés']
            equipamentos = {}
            if row:
                for idx, id_equip in enumerate(row):
                    if id_equip:
                        cur.execute('SELECT nome FROM equipamento WHERE id_equip = %s', (id_equip,))
                        nome = cur.fetchone()
                        equipamentos[partes[idx]] = nome[0].strip() if nome else 'Desconhecido'
                    else:
                        equipamentos[partes[idx]] = 'Nenhum'
            else:
                for parte in partes:
                    equipamentos[parte] = 'Nenhum'
        print('\n--- Equipamentos Atuais ---')
        for parte, nome in equipamentos.items():
            print(f"{parte}: {nome}")
        input('\nPressione Enter para continuar.')

    def selecionar_equipar_equipamento(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Busca todos os equipamentos do inventário
            cur.execute('''
                SELECT e.id_equip, e.nome, e.parte_corpo, inv.quant
                FROM inventario inv
                JOIN equipamento e ON inv.id_item = e.id_equip
                WHERE inv.quant > 0 AND inv.id_item = e.id_equip
                ORDER BY e.id_equip
            ''')
            equipamentos = cur.fetchall()
        if not equipamentos:
            print("\nVocê não possui equipamentos no inventário.")
            input('Pressione Enter para continuar.')
            return
        opcoes = [f"{nome.strip()} (ID: {id_equip}) - Parte: {parte_corpo.strip()} - Quantidade: {quant}" for id_equip, nome, parte_corpo, quant in equipamentos]
        opcoes.append("Cancelar")
        perguntas = [
            inquirer.List(
                'equip',
                message="Selecione o equipamento para equipar:",
                choices=opcoes
            )
        ]
        resposta = inquirer.prompt(perguntas)
        if not resposta or resposta['equip'] == "Cancelar":
            return
        idx = opcoes.index(resposta['equip'])
        if idx >= len(equipamentos):
            return
        id_equip, nome, parte_corpo, quant = equipamentos[idx]
        parte_corpo = parte_corpo.strip()
        parte_nome = {
            'cabe': 'Cabeça',
            'tors': 'Torso',
            'maos': 'Mãos',
            'pern': 'Pernas',
            'pes': 'Pés'
        }.get(parte_corpo, parte_corpo)
        print(f"\nVocê selecionou: {nome.strip()} para {parte_nome}.")
        confirma = input(f"Deseja equipar este item em {parte_nome}? (s/n): ").strip().lower()
        if confirma != 's':
            print("Ação cancelada.")
            input('Pressione Enter para continuar.')
            return
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Atualiza equipamento_atual para o protagonista
            # Remove equipamento anterior da parte (se houver)
            cur.execute(f"""
                INSERT INTO equipamento_atual (id_ser, {parte_corpo})
                VALUES (%s, %s)
                ON CONFLICT (id_ser) DO UPDATE SET {parte_corpo} = EXCLUDED.{parte_corpo}
            """, (self.estado.id_prota, id_equip))
            conn.commit()
        print(f"\n{nome.strip()} equipado em {parte_nome}!")
        input('Pressione Enter para continuar.')
