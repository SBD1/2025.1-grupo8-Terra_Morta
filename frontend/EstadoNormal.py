import os
import inquirer
import psycopg
from frontend.Andar import andar
from frontend.Explorar import explorar




class EstadoNormal:
    def get_sede(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT sede_atual, sede_max FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            return cur.fetchone()

    def set_sede(self, nova_sede):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            if row:
                id_inst = row[0]
                cur.execute("UPDATE inst_prota SET sede_atual = %s WHERE id_inst = %s", (nova_sede, id_inst))
                conn.commit()
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
            sede_atual, sede_max = self.get_sede()
            print(f'\nVocê se encontra no(a) {nome}.')
            print(f'Fome: {fome_atual}/{fome_max}')
            print(f'Sede: {sede_atual}/{sede_max}\n')

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
        return andar(self)

    def base(self):
        nome_local = self.G.nodes[self.localAtual]["nome"]

        if "base" in nome_local.lower():
            print('\nA sua base está linda nesse dia horrendo! :D\n')
        else:
            print('\nVocê não está na sua base para examinar!\n')

        input('Pressione Enter para continuar.')

    def explorar(self):
        return explorar(self)

    def end(self):
        pass