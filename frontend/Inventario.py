import psycopg

class Inventario:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_inventario(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute('''
                SELECT i.id_item, COALESCE(c.nome, e.nome, m.nome, 'Desconhecido'), inv.quant
                FROM inventario inv
                LEFT JOIN coletavel c ON inv.id_item = c.id_item
                LEFT JOIN equipamento e ON inv.id_item = e.id_equip
                LEFT JOIN mutacao m ON inv.id_item = m.id_mutacao
                JOIN item_controle i ON inv.id_item = i.id_item
                ORDER BY inv.id_item
            ''')
            itens = cur.fetchall()
        print("\n--- Inventário ---")
        if not itens:
            print("Inventário vazio.")
        else:
            for id_item, nome, quant in itens:
                print(f"{nome.strip()} (ID: {id_item}) - Quantidade: {quant}")
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
