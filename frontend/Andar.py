import os
import inquirer
from frontend.Encontro_Inimigo import processar_encontros, lidar_com_inimigos_ativos

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
