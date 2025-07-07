import os
import inquirer
from frontend.Encontro_Inimigo import processar_encontros, lidar_com_inimigos_ativos

def andar(self):
    os.system('cls' if os.name == 'nt' else 'clear')
    # Verifica carga antes de permitir andar
    with self.get_conn() as conn:
        cur = conn.cursor()
        cur.execute("SELECT carga_atual, carga_max FROM inst_prota WHERE id_ser = %s ORDER BY id_inst DESC LIMIT 1", (self.id_prota,))
        row = cur.fetchone()
        if row and row[0] > row[1]:
            print(f'Você está sobrecarregado! Carga atual: {row[0]}/{row[1]}. Esvazie seu inventário para poder andar.')
            input('Pressione Enter para continuar.')
            return
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
        # Atualiza radiação
        nivel_rad = self.G.nodes[destino].get("nivel_rad", 0)
        if hasattr(self, 'get_radiacao') and hasattr(self, 'set_radiacao'):
            rad_atual = self.get_radiacao()
            self.set_radiacao(rad_atual + nivel_rad)
        elif hasattr(self, 'radiacao'):
            self.radiacao = getattr(self, 'radiacao', 0) + nivel_rad
        print(f'\nVocê foi para {self.G.nodes[destino]["nome"]}, isso custou {custo} de fome e {nivel_rad} de radiação.\n')
        self.set_localizacao(destino)
        self.localAtual = destino
        input("Pressione Enter para continuar.")

    # Encontro com inimigos ao chegar no novo local
    with self.get_conn() as conn:
        resultado = lidar_com_inimigos_ativos(conn, self.localAtual, self)
        if resultado == "derrota_protagonista":
            return "derrota_protagonista"
        elif resultado == "conseguiu_fugir":
            return "continua"
        elif resultado == "vitoria_protagonista":
            return "continua"

        encontrou = processar_encontros(conn, self.localAtual, self.localAtual)
        if encontrou:
            novo_resultado = lidar_com_inimigos_ativos(conn, self.localAtual, self)
            if novo_resultado == "derrota_protagonista":
                return "derrota_protagonista"
            elif novo_resultado == "conseguiu_fugir":
                return "continua"
            elif novo_resultado == "vitoria_protagonista":
                return "continua"
