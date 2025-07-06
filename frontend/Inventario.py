import psycopg
import inquirer

class Inventario:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_inventario(self):
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

    def visualizar_equipamentos_atuais(self):
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
