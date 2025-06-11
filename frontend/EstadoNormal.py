import os

class EstadoNormal():

	def __init__(self):
		
		self.localAtual = "Base"
		
		self.opcoes = {
			'andar': self.andar,
			'base' : self.base,
			'explorar': self.explorar,
			'mainmenu' : self.end
		}
		
		self.locais = {
			'b' : "Base",
			'cf' : "Cidade Fantasma",
			'pva' : "Posto de Vigia Abandonado",
			'tp' : "Travessia da Poeira",
			'tc' : "Terra Chamuscada"
		}
		
		self.custos = {
			'b' : -1,
			'cf' : 2,
			'pva' : 5,
			'tp' : 8,
			'tc' : 4
		}
		
	def showMenu(self):
		os.system('cls' if os.name == 'nt' else 'clear')
		print(f'Menu\n')
		print(f'Você se encontra no(a) {self.localAtual}.\n')
		print(f'O que deseja fazer?\n\n' + 
		'Viajar para outro local: andar\n' + 
		'Examinar a sua base: base\n' + 
		'Explorar este local: explorar\n' + 
		'Retornar ao menu principal(fechar o jogo por enquanto): mainmenu\n\n------------\n')
		
	def menu(self):
		self.showMenu()
		
		entrada = input('Digite a opção desejada: ')
		nome = self.opcoes.get(entrada, self.default)
		nome()
		if(entrada == "mainmenu"):
			return False
		self.default()
		
	def andar(self):
		os.system('cls' if os.name == 'nt' else 'clear')
		print(f'Para onde deseja ir?\n')
		for key in self.locais:
    			print(f'{self.locais[key]}: {key}')
		print(f'------------\n')
		
		entrada = input('Digite a opção desejada: ')
		if(entrada == "menu"):
			return False
		nome = self.locais.get(entrada, self.default)
		prec = self.custos.get(entrada, self.default)
		
		if(prec == -1):
			self.localAtual = nome
			return True
		
		print(f'\n\nVocê foi a(o) {nome}, isso te custou {prec} de fome.\n\n')
		
		entrada = input('Pressione Enter')
		
		self.localAtual = nome
		
		return True
		
	def base(self):
		print(f'\n\nA sua base está linda nesse dia horrendo! :D\n\n')
		
		entrada = input('Pressione Enter')
		
		return True
			
	def explorar(self):
		print(f'\n\nVocê anda um pouco e examina esse lugar, você não encontra nada de interesse.\n\n')
		
		entrada = input('Pressione Enter')
		
		return True
		
	def end(self):
		os.system('cls' if os.name == 'nt' else 'clear')
		exit()
		
	def default(self):
		self.menu()
		
EN = EstadoNormal()
EN.default()
