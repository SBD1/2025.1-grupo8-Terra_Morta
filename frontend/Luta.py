import os
import inquirer
import psycopg

class Luta:
    
    def __init__(self, conn, estado, dados_inimigos):
        self.conn = conn
        self.estado = estado
        self.dados_inimigos = dados_inimigos
        self.opcoes_luta = {
        'Atacar': self.atacar_inimigo,
        'Item': self.usar_item,
        'Fugir': self.fugir_da_luta,
        'Retornar ao menu principal': self.end
        }
        
    def luta_turno_prota(self):
        while self.dados_inimigos:
            print(f'\nTurno do Protagonista\n\nInimigos:')
            for index, inimigo in enumerate(self.dados_inimigos,0):
                id_ser, id_inst, nome, hp_max, hp_atual, str_atual, dex_atual, def_atual = inimigo
                print(f'{index} - {nome}( {id_inst} ) - Vida: ({hp_atual}/{hp_max})\n')
            
            perguntas = [
                inquirer.List(
                    'acao',
                    message="O que deseja fazer?",
                    choices=list(self.opcoes_luta.keys())
                )
            ]

            resposta = inquirer.prompt(perguntas)
            if not resposta:
                continue  # caso o usuário cancele com Ctrl+C ou Enter

            acao = resposta['acao']
            if acao == 'Retornar ao menu principal':
                print("\nRetornando ao menu principal...\n")
                break
            
            # Executa a ação escolhida
            self.opcoes[acao]()
            
    def atacar_inimigo(self):
        print(f'\n\nQual inimigo deseja atacar?\n')
        
        escolhas = [
            f'{index} - {i["nome"]}: {i["id_inst"]}'
            for index, i in enumerate(self.dados_inimigos, 0)
        ]
        escolhas.append("Voltar")
        
        pergunta = [
            inquirer.List(
                'inimigo',
                message="Escolha um:",
                choices=escolhas
            )
        ]
        resposta = inquirer.prompt(pergunta)
        if not resposta or resposta['inimigo'] == "Voltar":
            return
        
        entrada = resposta['inimigo'].split(':')[1]
        entrada2 = resposta['inimigo'].split(' - ')[0]
        index_inst = int(entrada2)
        id_inst_ser = int(entrada)
        
        str_prota = self.estado.get_str()
        hp_inimigo = self.dados_inimigos[index_inst]["hp_atual"]
        
        new_hp = hp_inimigo - str_prota
        
        if new_hp > 0:
            self.set_hp_inimigo(new_hp, id_inst_ser)
            self.dados_inimigos[index_inst]["hp_atual"] = new_hp
            self.print_clr(f'Vôce atacou o inimigo de id {id_inst_ser} e deu {hp_inimigo - new_hp}!\n')
        else:
            self.deletar_inst_ser(id_inst_ser)
            self.dados_inimigos[index_inst].remove()
            self.print_clr(f'Vôce matou o inimigo de id {id_inst_ser}!\n')
        
    def usar_item(self):
        self.print_clr(f'Vôce usou!\n')
        
    def fugir_da_luta(self):
        self.print_clr(f'Vôce fugiu!\n')
        
    def set_hp_inimigo(self, novo_hp, id_inst_ser):
        with self.conn as conn:
            cur = conn.cursor()
            cur.execute("UPDATE inst_ser SET hp_atual = %s WHERE id_inst = %s", (novo_hp, id_inst_ser))
            conn.commit()
            
    def deletar_inst_ser(self, id_inst_ser):
        with self.conn as conn:
            cur = conn.cursor()
            cur.execute("DELETE FROM inst_ser WHERE id_inst = %s", (id_inst_ser))
            conn.commit()
            
    def print_clr(self, string):
        os.system('cls' if os.name == 'nt' else 'clear')
        print(string)
        
    def end(self):
        pass