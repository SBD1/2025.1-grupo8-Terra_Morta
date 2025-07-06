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
        'Fugir': self.fugir_da_luta
        }
        
    def luta_turno_prota(self):
        while self.dados_inimigos:
            print(f'\nTurno do Protagonista\n\nVida atual: {self.estado.get_hp()[0]}/{self.estado.get_hp()[1]}\n\nInimigos:')
            for index, inimigo in enumerate(self.dados_inimigos,0):
                id_ser, id_inst, tipo, nome, hp_max, hp_atual, str_atual, dex_atual, def_atual = inimigo
                print(f'{index} - {nome.strip()}( {id_inst} ) - Vida: ({hp_atual}/{hp_max})\n')
            
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
            
            # Executa a ação escolhida
            resultado_opcao = self.opcoes_luta[acao]()
            
            if acao == 'Fugir':
                if resultado_opcao == "conseguiu_fugir":
                    return "conseguiu_fugir"
            if acao == "Atacar":
                if resultado_opcao == "voltar":
                    continue
                
            if self.dados_inimigos:
                resultado = self.luta_turno_inimigos()
                if resultado == "derrota_protagonista":
                    self.estado.print_clr("Você foi derrotado! Fim de jogo.\n")
                    return "derrota_protagonista"
                elif resultado == "turno_inimigo_finalizado":
                    os.system('cls' if os.name == 'nt' else 'clear')
                    continue
        
        if not self.dados_inimigos:
            self.estado.print_clr("Todos os inimigos foram derrotados! Você venceu a luta!\n")
            return "vitoria_protagonista"
        
    def luta_turno_inimigos(self):
        while self.dados_inimigos:
            print(f'\nTurno dos Inimigos\n\nVida atual: {self.estado.get_hp()[0]}/{self.estado.get_hp()[1]}\n\nInimigos:')

            # Turno dos inimigos
            for inimigo in self.dados_inimigos:
                id_ser, id_inst, tipo, nome, hp_max, hp_atual, str_atual, dex_atual, def_atual = inimigo
                dano = max(0, str_atual - def_atual)
                new_hp = self.estado.get_hp()[0] - dano
                
                if new_hp > 0:
                    self.estado.set_hp(new_hp)
                    print(f'\nO {nome.strip()}({id_inst}) atacou você e causou {dano} de dano!\n\nVida atual: {new_hp}/{self.estado.get_hp()[1]}\n')
                    input("Pressione Enter para continuar.")
                else:
                    return "derrota_protagonista"
                
            return "turno_inimigo_finalizado"  # Sinaliza que o turno dos inimigos terminou
                    
    def atacar_inimigo(self):
        self.estado.print_clr(f'Qual inimigo deseja atacar?\n')
        
        escolhas = []
        
        for index, inimigo in enumerate(self.dados_inimigos, 0):
            id_ser, id_inst, tipo, nome, hp_max, hp_atual, str_atual, dex_atual, def_atual = inimigo
            linha = f'{index} - {nome.strip()}: {id_inst}'
            escolhas.append(linha)
        
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
            return "voltar"
        
        entrada = resposta['inimigo'].split(':')[1]
        entrada2 = resposta['inimigo'].split(' - ')[0]
        index_inst = int(entrada2)
        id_inst_ser = int(entrada)
        
        str_prota = self.estado.get_str()[0]
        hp_inimigo = self.dados_inimigos[index_inst][5] # hp_atual do inimigo
        
        new_hp = hp_inimigo - str_prota
        
        if new_hp > 0:
            self.set_hp_inimigo(new_hp, id_inst_ser)
            inimigo_lista = list(self.dados_inimigos[index_inst])
            inimigo_lista[5] = new_hp
            self.dados_inimigos[index_inst] = tuple(inimigo_lista)
            self.estado.print_clr(f'Vôce atacou o {self.dados_inimigos[index_inst][3].strip()} e deu {hp_inimigo - new_hp} de dano!')
        else:
            self.estado.print_clr(f'Vôce matou o {self.dados_inimigos[index_inst][3].strip()}!\n')
            self.deletar_inst_ser(id_inst_ser)
            self.dados_inimigos.pop(index_inst)
        
    def usar_item(self):
        self.estado.print_clr(f'Vôce usou!')
        return "usou_item"
        
    def fugir_da_luta(self):
        if self.estado.tentar_fuga():
            self.estado.print_clr(f'Vôce conseguiu fugir! Voltando para a base...\n')
            self.estado.set_localizacao(1)  # Volta para base
            self.estado.localAtual = 1
            return "conseguiu_fugir"
        self.estado.print_clr(f'Vôce falhou ao fugir! O combate continua!')
        return "falhou_fugir"

    def set_hp_inimigo(self, novo_hp, id_inst_ser):
        with self.conn.cursor() as cur:
            cur.execute("UPDATE inst_ser SET hp_atual = %s WHERE id_inst = %s", (novo_hp, id_inst_ser))
            self.conn.commit()
            
    def deletar_inst_ser(self, id_inst_ser):
        with self.conn.cursor() as cur:
            cur.execute("DELETE FROM inst_ser WHERE id_inst = %s", (id_inst_ser,))
            self.conn.commit()
        
    def end(self):
        pass