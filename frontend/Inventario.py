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
                SELECT i.id_item, COALESCE(c.nome, e.nome, m.nome, u.nome, 'Desconhecido'), inv.quant,
                       CASE WHEN e.id_equip IS NOT NULL THEN 'equipamento' WHEN m.id_mutacao IS NOT NULL THEN 'mutacao' WHEN u.id_util IS NOT NULL THEN 'utilizavel' ELSE 'outro' END as tipo
                FROM inventario inv
                LEFT JOIN coletavel c ON inv.id_item = c.id_item
                LEFT JOIN equipamento e ON inv.id_item = e.id_equip
                LEFT JOIN mutacao m ON inv.id_item = m.id_mutacao
                LEFT JOIN utilizavel u ON inv.id_item = u.id_util
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
            return "voltar"
        idx = opcoes.index(resposta['item'])
        if idx >= len(itens):
            return
        id_item, nome, quant, tipo = itens[idx]
        print(f"\n--- Detalhes do item ---")
        print(f"Nome: {nome.strip()} (ID: {id_item})\nQuantidade: {quant}")
        acoes = []
        if tipo == 'equipamento':
            acoes = ["Equipar", "Destruir", "Voltar"]
        elif tipo == 'utilizavel':
            acoes = ["Consumir", "Destruir", "Voltar"]
        else:
            acoes = ["Destruir", "Voltar"]
        os.system('cls' if os.name == 'nt' else 'clear')  # Limpa terminal ao entrar no submenu de ações
        perguntas_acao = [
            inquirer.List(
                'acao',
                message="O que deseja fazer com este item?",
                choices=acoes
            )
        ]
        resposta_acao = inquirer.prompt(perguntas_acao)
        if not resposta_acao or resposta_acao['acao'] == "Voltar":
            return
        acao = resposta_acao['acao']
        if acao == "Destruir":
            with self.get_conn() as conn:
                cur = conn.cursor()
                if quant > 1:
                    cur.execute("UPDATE inventario SET quant = quant - 1 WHERE id_item = %s", (id_item,))
                else:
                    cur.execute("DELETE FROM inventario WHERE id_item = %s", (id_item,))
                conn.commit()
            print(f"Item '{nome.strip()}' destruído!")
            input('Pressione Enter para continuar.')
            return
        if tipo == 'equipamento' and acao == "Equipar":
            os.system('cls' if os.name == 'nt' else 'clear')  # Limpa terminal ao entrar no submenu de equipar
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
                input('Pressione Enter para continuar.')
        elif tipo == 'utilizavel' and acao == "Consumir":
            os.system('cls' if os.name == 'nt' else 'clear')  # Limpa terminal ao entrar no submenu de consumir
            with self.get_conn() as conn:
                cur = conn.cursor()
                cur.execute('SELECT atributo, valor FROM utilizavel WHERE id_util = %s', (id_item,))
                util = cur.fetchone()
                if util:
                    atributo, valor = util
                    print(f"Atributo: {atributo.strip()} | Valor: {valor}")
                    if atributo.strip() == 'hp':
                        hp = self.estado.get_hp()
                        if hp:
                            hp_atual, hp_max = hp
                            novo_hp = max(0, min(hp_max, hp_atual + valor))
                            self.estado.set_hp(novo_hp)
                    elif atributo.strip() == 'fome':
                        fome = self.estado.get_fome()
                        if fome:
                            fome_atual, fome_max = fome
                            novo_fome = max(0, min(fome_max, fome_atual + valor))
                            self.estado.set_fome(novo_fome)
                    elif atributo.strip() == 'sede':
                        sede = self.estado.get_sede()
                        if sede:
                            sede_atual, sede_max = sede
                            novo_sede = max(0, min(sede_max, sede_atual + valor))
                            self.estado.set_sede(novo_sede)
                    elif atributo.strip() == 'rad':
                        rad = self.estado.get_radiacao()
                        if isinstance(rad, tuple):
                            rad_atual, rad_max = rad
                        else:
                            rad_atual = rad
                            rad_max = 100
                        novo_rad = max(0, min(rad_max, rad_atual + valor))
                        self.estado.set_radiacao(novo_rad)
                    print(f"\n{nome.strip()} usado com sucesso!")
                    # Remove do inventário
                    if quant > 1:
                        cur.execute("UPDATE inventario SET quant = quant - 1 WHERE id_item = %s", (id_item,))
                    else:
                        cur.execute("DELETE FROM inventario WHERE id_item = %s", (id_item,))
                    conn.commit()
                else:
                    print("Item não encontrado.")
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
