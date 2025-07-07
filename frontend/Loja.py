import os
import inquirer

class Loja:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_moedas(self):
        return self.estado.get_moedas()

    def comprar_item(self, id_item, nome, preco):
        with self.estado.get_conn() as conn:
            cur = conn.cursor()
            # Desconta moedas
            cur.execute("SELECT quant FROM inventario WHERE id_item = 1 LIMIT 1")
            row = cur.fetchone()
            if row and row[0] >= preco:
                cur.execute("UPDATE inventario SET quant = quant - %s WHERE id_item = 1", (preco,))
            else:
                print("Erro ao descontar moedas.")
                input('Pressione Enter para continuar.')
                return False
            # Adiciona item ao inventário
            cur.execute("SELECT quant FROM inventario WHERE id_item = %s LIMIT 1", (id_item,))
            row = cur.fetchone()
            if row:
                cur.execute("UPDATE inventario SET quant = quant + 1 WHERE id_item = %s", (id_item,))
            else:
                cur.execute("INSERT INTO inventario (id_item, quant) VALUES (%s, 1)", (id_item,))
            conn.commit()
        print(f"\nVocê comprou: {nome.strip()} por {preco} moedas!")
        input('Pressione Enter para continuar.')
        return True

    def abrir_loja(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        nome_local = self.estado.G.nodes[self.estado.localAtual]["nome"]
        if "base" not in nome_local.lower():
            print('\nVocê não está na base para acessar a loja!\n')
            input('Pressione Enter para continuar.')
            return
        with self.estado.get_conn() as conn:
            cur = conn.cursor()
            # Exclui moedas (id_item = 1) da listagem
            cur.execute("SELECT id_item, nome, preco FROM coletavel WHERE id_item <> 1 UNION ALL SELECT id_equip, nome, preco FROM equipamento UNION ALL SELECT id_util, nome, preco FROM utilizavel")
            itens = cur.fetchall()
        moedas = self.get_moedas()
        print(f"\nBem-vindo à loja da base!\nVocê possui {moedas} moedas.")
        print("Itens disponíveis:")
        opcoes = [f"{nome.strip()} (ID: {id_item}) - Preço: {preco}" for id_item, nome, preco in itens]
        opcoes.append("Voltar ao menu")
        perguntas = [
            inquirer.List(
                'item',
                message="Selecione o item para comprar:",
                choices=opcoes
            )
        ]
        resposta = inquirer.prompt(perguntas)
        if not resposta or resposta['item'] == "Voltar ao menu":
            return
        escolha_idx = opcoes.index(resposta['item'])
        id_item, nome, preco = itens[escolha_idx] if escolha_idx < len(itens) else (None, None, None)
        if id_item is None:
            return
        if moedas < preco:
            print(f"\nVocê não tem moedas suficientes para comprar {nome.strip()}!")
            input('Pressione Enter para continuar.')
        else:
            self.comprar_item(id_item, nome, preco)
