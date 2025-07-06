import psycopg
import inquirer
import os

class Inventario:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_inventario(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute('''
                SELECT i.id_item, COALESCE(c.nome, e.nome, m.nome, 'Desconhecido'), inv.quant,
                       CASE WHEN e.id_equip IS NOT NULL THEN 'equipamento' WHEN m.id_mutacao IS NOT NULL THEN 'mutacao' ELSE 'outro' END as tipo
                FROM inventario inv
                LEFT JOIN coletavel c ON inv.id_item = c.id_item
                LEFT JOIN equipamento e ON inv.id_item = e.id_equip
                LEFT JOIN mutacao m ON inv.id_item = m.id_mutacao
                JOIN item_controle i ON inv.id_item = i.id_item
                ORDER BY inv.id_item
            ''')
            itens = cur.fetchall()
        if not itens:
            print("\nInventário vazio.")
            input('Pressione Enter para continuar.')
            return
        opcoes = [f"{nome.strip()} (ID: {id_item}) - Quantidade: {quant}" for id_item, nome, quant, _ in itens]
        opcoes.append("Voltar")
        perguntas = [
            inquirer.List(
                'item',
                message="Selecione um item para ver detalhes:",
                choices=opcoes
            )
        ]
        resposta = inquirer.prompt(perguntas)
        if not resposta or resposta['item'] == "Voltar":
            return
        idx = opcoes.index(resposta['item'])
        if idx >= len(itens):
            return
        id_item, nome, quant, tipo = itens[idx]
        print(f"\n--- Detalhes do item ---")
        print(f"Nome: {nome.strip()} (ID: {id_item})\nQuantidade: {quant}")
        if tipo == 'equipamento':
            with self.get_conn() as conn:
                cur = conn.cursor()
                cur.execute('SELECT parte_corpo FROM equipamento WHERE id_equip = %s', (id_item,))
                parte = cur.fetchone()
                parte_nome = {
                    'cabe': 'Cabeça',
                    'tors': 'Torso',
                    'maos': 'Mãos',
                    'pern': 'Pernas',
                    'pes': 'Pés'
                }.get(parte[0].strip(), parte[0].strip()) if parte else 'Desconhecida'
                print(f"Parte do corpo: {parte_nome}")
                cur.execute('SELECT atributo, valor FROM modificador WHERE id_item = %s', (id_item,))
                mods = cur.fetchall()
                if mods:
                    print("Modificadores:")
                    for atributo, valor in mods:
                        print(f"  {atributo.strip()}: {valor:+}")
                else:
                    print("Sem modificadores.")
                confirma = input(f"\nDeseja equipar este item em {parte_nome}? (s/n): ").strip().lower()
                if confirma == 's':
                    # Equipar
                    coluna_map = {
                        'cabe': 'cabeca',
                        'tors': 'torso',
                        'maos': 'maos',
                        'pern': 'pernas',
                        'pes': 'pes'
                    }
                    coluna = coluna_map.get(parte[0].strip(), parte[0].strip())
                    cur.execute(f"""
                        INSERT INTO equipamento_atual (id_ser, {coluna})
                        VALUES (%s, %s)
                        ON CONFLICT (id_ser) DO UPDATE SET {coluna} = EXCLUDED.{coluna}
                    """, (self.estado.id_prota, id_item))
                    conn.commit()
                    print(f"\n{nome.strip()} equipado em {parte_nome}!")
                else:
                    print("Ação cancelada.")
                input('Pressione Enter para continuar.')
        else:
            input('\nPressione Enter para continuar.')

    def adicionar_moedas_debug(self):
        try:
            quant = int(input("\nQuantas moedas deseja adicionar ao inventário? "))
            if quant <= 0:
                print("Quantidade inválida.")
                input('Pressione Enter para continuar.')
                return
        except ValueError:
            print("Valor inválido.")
            input('Pressione Enter para continuar.')
            return
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT quant FROM inventario WHERE id_item = 1 LIMIT 1")
            row = cur.fetchone()
            if row:
                cur.execute("UPDATE inventario SET quant = quant + %s WHERE id_item = 1", (quant,))
            else:
                cur.execute("INSERT INTO inventario (id_item, quant) VALUES (1, %s)", (quant,))
            conn.commit()
        print(f"\n{quant} moedas adicionadas ao inventário!")
        input('Pressione Enter para continuar.')
