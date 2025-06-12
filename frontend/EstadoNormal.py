import os

class EstadoNormal:
    def __init__(self, grafo):
        self.G = grafo
        self.localAtual = list(grafo.nodes)[0]  
        self.opcoes = {
            'andar': self.andar,
            'base': self.base,
            'explorar': self.explorar,
            'mainmenu': self.end
        }

    def showMenu(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        nome = self.G.nodes[self.localAtual]["nome"]
        print(f'Menu\n')
        print(f'Você se encontra no(a) {nome}.\n')
        print('O que deseja fazer?\n\n' +
              'Viajar para outro local: andar\n' +
              'Examinar a sua base: base\n' +
              'Explorar este local: explorar\n' +
              'Retornar ao menu principal: mainmenu\n\n------------\n')

    def menu(self):
        self.showMenu()
        entrada = input('Digite a opção desejada: ')
        nome = self.opcoes.get(entrada, self.default)
        nome()
        if entrada == "mainmenu":
            return False
        self.default()

    def andar(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Para onde deseja ir?\n')

        vizinhos = sorted(self.G.neighbors(self.localAtual))
        for v in vizinhos:
            nome = self.G.nodes[v]["nome"]
            custo = self.G[self.localAtual][v]["weight"]
            print(f'{v} - {nome} (Custo: {custo})')

        print('Digite "menu" para voltar ao menu principal.\n------------\n')

        entrada = input('Digite o ID do local desejado: ')
        if entrada == "menu":
            return

        try:
            destino = int(entrada)
            if destino in vizinhos:
                custo = self.G[self.localAtual][destino]["weight"]
                self.localAtual = destino
                print(f'\nVocê foi para {self.G.nodes[destino]["nome"]}, isso custou {custo} de energia.')
                input("Pressione Enter para continuar.")
            else:
                print("Destino inválido!")
                input("Pressione Enter para voltar.")
        except ValueError:
            print("Entrada inválida.")
            input("Pressione Enter para voltar.")

    def base(self):
        print('\n\nA sua base está linda nesse dia horrendo! :D\n\n')
        input('Pressione Enter')

    def explorar(self):
        print('\n\nVocê anda um pouco e examina esse lugar, você não encontra nada de interesse.\n\n')
        input('Pressione Enter')

    def end(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        exit()

    def default(self):
        self.menu()
