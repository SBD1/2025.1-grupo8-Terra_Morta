import os
import inquirer
import psycopg
from frontend.Encontro_Inimigo import processar_encontros,lidar_com_inimigos_ativos


class EstadoNormal:
    def __init__(self, grafo, id_prota, db_params):
        self.G = grafo
        self.localAtual = list(grafo.nodes)[0]
        self.id_prota = id_prota
        self.db_params = db_params
        self.opcoes = {
            'Andar para outro local': self.andar,
            'Examinar a base': self.base,
            'Explorar o local': self.explorar,
            'Retornar ao menu principal': self.end
        }

    def get_conn(self):
        return psycopg.connect(**self.db_params)

    def get_fome(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT fome_atual, fome_max FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            return cur.fetchone()

    def set_fome(self, nova_fome):
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Busca o id_inst mais recente para o protagonista
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            if row:
                id_inst = row[0]
                cur.execute("UPDATE inst_prota SET fome_atual = %s WHERE id_inst = %s", (nova_fome, id_inst))
                conn.commit()

    def set_localizacao(self, novo_local):
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Busca o id_inst mais recente para o protagonista
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            if row:
                id_inst = row[0]
                cur.execute("UPDATE inst_prota SET localizacao = %s WHERE id_inst = %s", (novo_local, id_inst))
                conn.commit()

    def get_nome(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT nome FROM prota WHERE id_ser = %s", (self.id_prota,))
            return cur.fetchone()[0].strip()

    def menu(self):
        while True:
            os.system('cls' if os.name == 'nt' else 'clear')
            nome = self.G.nodes[self.localAtual]["nome"]
            fome_atual, fome_max = self.get_fome()
            print(f'\nVocê se encontra no(a) {nome}.')
            print(f'Fome: {fome_atual}/{fome_max}\n')

            perguntas = [
                inquirer.List(
                    'acao',
                    message="O que deseja fazer?",
                    choices=list(self.opcoes.keys())
                )
            ]

            resposta = inquirer.prompt(perguntas)
            if not resposta:
                continue  # caso o usuário cancele com Ctrl+C ou Enter

            acao = resposta['acao']
            if acao == 'Retornar ao menu principal':
                print("\nRetornando ao menu principal...\n")
                break

            self.opcoes[acao]()

    def andar(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Para onde deseja ir?\n')

        vizinhos = sorted(self.G.neighbors(self.localAtual))
        escolhas = [
            f'{v} - {self.G.nodes[v]["nome"]} (Custo: {self.G[self.localAtual][v]["weight"]})'
            for v in vizinhos
        ]
        escolhas.append("Voltar ao menu")

        pergunta = [
            inquirer.List(
                'destino',
                message="Escolha um destino:",
                choices=escolhas
            )
        ]
        resposta = inquirer.prompt(pergunta)
        if not resposta or resposta['destino'] == "Voltar ao menu":
            return

        entrada = resposta['destino'].split(' - ')[0]
        destino = int(entrada)
        custo = self.G[self.localAtual][destino]["weight"]

        # Atualiza fome
        fome_atual, fome_max = self.get_fome()
        nova_fome = fome_atual - custo

        if nova_fome <= 0:
            nome_prota = self.get_nome()
            print(f'\n{nome_prota} estava cansado demais para continuar, voltou para casa e tirou um belo cochilo.\n')
            self.set_localizacao(1)  # 1 = Base
            self.set_fome(fome_max)
            self.localAtual = 1
            input("Pressione Enter para continuar.")
        else:
            self.set_fome(nova_fome)
            self.set_localizacao(destino)
            self.localAtual = destino
            print(f'\nVocê foi para {self.G.nodes[destino]["nome"]}, isso custou {custo} de fome.')
            input("Pressione Enter para continuar.")

        # Encontro com inimigos ao chegar no novo local
        with self.get_conn() as conn:
            resultado = lidar_com_inimigos_ativos(conn, self.localAtual, self)
            if resultado == True or resultado == "input_ja_foi":
                return
            elif resultado == False:
                return

            encontrou = processar_encontros(conn, self.localAtual, self.localAtual)
            if encontrou:
                novo_resultado = lidar_com_inimigos_ativos(conn, self.localAtual, self)
                if novo_resultado == "input_ja_foi":
                    return

    def base(self):
        nome_local = self.G.nodes[self.localAtual]["nome"]

        if "base" in nome_local.lower():
            print('\nA sua base está linda nesse dia horrendo! :D\n')
        else:
            print('\nVocê não está na sua base para examinar!\n')

        input('Pressione Enter para continuar.')

    def explorar(self):
        # Novo comportamento: explorar não lida mais com encontros de inimigos
        print('\nVocê explora o local em busca de algo interessante...')
        # Aqui você pode implementar outra lógica de exploração futuramente
        input('Pressione Enter para continuar.')

    def end(self):
        pass