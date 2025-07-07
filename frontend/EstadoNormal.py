import os
import random
import inquirer
import psycopg
from frontend.Andar import andar
from frontend.Explorar import explorar
from frontend.Loja import Loja
from frontend.Inventario import Inventario
from frontend.Mutacao import Mutacao
from frontend.Equipamento import Equipamento
from frontend.Atributos import Atributos
from frontend.Missoes import Missoes




class EstadoNormal:
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
        self.missoes_obj = Missoes(self)
        self.opcoes = {
            'Andar para outro local': self.andar,
            'Examinar a base': self.base,
            'Explorar o local': self.explorar,
            'Inventário': self.inventario_obj.visualizar_inventario,
            'Equipamentos Atuais': self.equipamento_obj.visualizar_equipamentos_atuais,
            'Mutações Atuais': self.mutacao_obj.visualizar_mutacoes_atuais,
            'Atributos do Protagonista': self.atributos_obj.visualizar_atributos,
            'Missões': self.missoes_obj.menu_missoes,
            'Retornar ao menu principal': self.end
        }
    
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
                   
    def get_hp(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT hp_atual, hp_max FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            return cur.fetchone()
        
    def set_hp(self, novo_hp):
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Busca o id_inst mais recente para o protagonista
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            if row:
                id_inst = row[0]
                cur.execute("UPDATE inst_prota SET hp_atual = %s WHERE id_inst = %s", (novo_hp, id_inst))
                conn.commit()
                
    def get_str(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT str_atual FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            return cur.fetchone()

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

    def get_radiacao(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT rad_atual FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            return row[0] if row else 0

    def set_radiacao(self, nova_radiacao):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            row = cur.fetchone()
            if row:
                id_inst = row[0]
                cur.execute("UPDATE inst_prota SET rad_atual = %s WHERE id_inst = %s", (nova_radiacao, id_inst))
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
            hp_atual, hp_max = self.get_hp()
            fome_atual, fome_max = self.get_fome()
            sede_atual, sede_max = self.get_sede()
            print(f'Você se encontra no(a) {nome}.')
            print(f'Vida: {hp_atual}/{hp_max}')
            print(f'Fome: {fome_atual}/{fome_max}')
            print(f'Sede: {sede_atual}/{sede_max}\n')

            opcoes_menu = list(self.opcoes.keys())
            if "base" in nome.lower():
                opcoes_menu.insert(1, "Acessar loja da base")
                opcoes_menu.insert(2, "DEBUG: Adicionar moedas")
                if 'Missões' not in opcoes_menu:
                    opcoes_menu.insert(3, 'Missões')

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
            elif acao == 'Missões':
                self.missoes_obj.menu_missoes()
            else:
                resultado_acao = self.opcoes[acao]()
                
                if resultado_acao == "derrota_protagonista":
                    self.derrota_prota()
                    break
    
    def andar(self):
        lol = andar(self)
        return lol

    def base(self):
        nome_local = self.G.nodes[self.localAtual]["nome"]

        if "base" in nome_local.lower():
            print('\nA sua base está linda nesse dia horrendo! :D\n')
        else:
            print('\nVocê não está na sua base para examinar!\n')

        input('Pressione Enter para continuar.')
        
    def iniciar_luta(self, inimigos):
        from frontend.Luta import Luta
        luta = Luta(self.get_conn(), self, inimigos)
        return luta.luta_turno_prota()
        
    def print_clr(self, string):
        os.system('cls' if os.name == 'nt' else 'clear')
        print(string)
        
    def tentar_fuga(self):
        return random.random() < 0.5

    def explorar(self):
        return explorar(self)
    
    def derrota_prota(self):
        with self.get_conn() as conn:
            cur = conn.cursor()
            cur.execute("DELETE FROM inst_ser")
            cur.execute("DELETE FROM inventario")
            cur.execute("SELECT id_inst FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
            id_inst = cur.fetchone()[0]
            cur.execute("DELETE FROM inst_prota WHERE id_ser = %s AND id_inst = %s", (self.id_prota, id_inst))
            conn.commit()

    def end(self):
        pass