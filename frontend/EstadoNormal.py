import os
import inquirer
import psycopg
from frontend.Andar import andar
from frontend.Explorar import explorar
from frontend.Loja import Loja
from frontend.Inventario import Inventario
from frontend.Mutacao import Mutacao
from frontend.Equipamento import Equipamento
from frontend.Atributos import Atributos




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
        self.loja_obj = Loja(self)
        self.inventario_obj = Inventario(self)
        self.mutacao_obj = Mutacao(self)
        self.equipamento_obj = Equipamento(self)
        self.atributos_obj = Atributos(self)
        self.opcoes = {
            'Andar para outro local': self.andar,
            'Examinar a base': self.base,
            'Explorar o local': self.explorar,
            'Inventário': self.inventario_obj.visualizar_inventario,
            'Equipamentos Atuais': self.equipamento_obj.visualizar_equipamentos_atuais,
            'Mutações Atuais': self.mutacao_obj.visualizar_mutacoes_atuais,
            'Atributos do Protagonista': self.atributos_obj.visualizar_atributos,
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

    def get_moedas(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Supondo que o id do item moeda seja 1
            cur.execute("SELECT quant FROM inventario WHERE id_item = 1 AND quant > 0 LIMIT 1")
            row = cur.fetchone()
            return row[0] if row else 0

    def loja(self):
        self.loja_obj.abrir_loja()

    def adicionar_moedas_debug(self):
        self.inventario_obj.adicionar_moedas_debug()

    def menu(self):
        while True:
            os.system('cls' if os.name == 'nt' else 'clear')
            nome = self.G.nodes[self.localAtual]["nome"]
            fome_atual, fome_max = self.get_fome()
            sede_atual, sede_max = self.get_sede()
            print(f'\nVocê se encontra no(a) {nome}.')
            print(f'Fome: {fome_atual}/{fome_max}')
            print(f'Sede: {sede_atual}/{sede_max}\n')

            opcoes_menu = list(self.opcoes.keys())
            if "base" in nome.lower():
                opcoes_menu.insert(1, "Acessar loja da base")
                opcoes_menu.insert(2, "DEBUG: Adicionar moedas")

            perguntas = [
                inquirer.List(
                    'acao',
                    message="O que deseja fazer?",
                    choices=opcoes_menu
                )
            ]

            resposta = inquirer.prompt(perguntas)
            if not resposta:
                continue  # caso o usuário cancele com Ctrl+C ou Enter

            acao = resposta['acao']
            if acao == 'Retornar ao menu principal':
                print("\nRetornando ao menu principal...\n")
                break
            if acao == 'Acessar loja da base':
                self.loja()
            elif acao == 'DEBUG: Adicionar moedas':
                self.adicionar_moedas_debug()
            elif acao == 'Inventário':
                self.inventario_obj.visualizar_inventario()
            elif acao == 'Equipamentos Atuais':
                self.equipamento_obj.visualizar_equipamentos_atuais()
            elif acao == 'Mutações Atuais':
                self.mutacao_obj.visualizar_mutacoes_atuais()
            else:
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