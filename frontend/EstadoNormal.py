import os
import inquirer

class EstadoNormal:
    def __init__(self, grafo):
        self.G = grafo
        self.localAtual = list(grafo.nodes)[0]
        self.opcoes = {
            'Andar para outro local': self.andar,
            'Examinar a base': self.base,
            'Explorar o local': self.explorar,
            'Retornar ao menu principal': self.end
        }

    def menu(self):
        while True:
            os.system('cls' if os.name == 'nt' else 'clear')
            nome = self.G.nodes[self.localAtual]["nome"]
            print(f'\nVocê se encontra no(a) {nome}.\n')

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

            # Executa a ação escolhida
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
        self.localAtual = destino
        print(f'\nVocê foi para {self.G.nodes[destino]["nome"]}, isso custou {custo} de energia.')
        input("Pressione Enter para continuar.")

    def base(self):
        nome_local = self.G.nodes[self.localAtual]["nome"]

        if "base" in nome_local.lower():
            print('\nA sua base está linda nesse dia horrendo! :D\n')
        else:
            print('\nVocê não está na sua base para examinar!\n')

        input('Pressione Enter para continuar.')

    def explorar(self):
        print('\nVocê anda um pouco e examina esse lugar, mas não encontra nada de interesse.\n')
        input('Pressione Enter para continuar.')

    def end(self):
        # Apenas quebra o loop do menu
        pass