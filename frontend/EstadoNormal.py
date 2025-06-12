import os

class PI():
	
	def __init__(self, id_pi, nome):
		
		self.id_pi = id_pi
		self.nome = nome

class Conexao():

	def __init__(self, orig, dest, custo):
		
		self.orig = orig
		self.dest = dest
		self.custo = custo

class EstadoNormal():

	def __init__(self):
		
		self.localAtual = PI(1,'Base')
		
		self.opcoes = {
			'andar': self.andar,
			'base' : self.base,
			'explorar': self.explorar,
			'mainmenu' : self.end
		}
		
		self.locais = {}
		
		self.conex = []
		
	def addPIList(self, PIList):
		for Pi in PIList:
			nomePI = Pi.nome
			idPI = str(Pi.id_pi)
			self.locais[idPI] = nomePI
			
	def addConList(self, ConList):
		for con in ConList:
			ConOrig = str(con.orig)
			ConDest = str(con.dest)
			temp = Conexao(ConOrig, ConDest, con.custo)
			self.conex.append(temp)
			
		
	def showMenu(self):
		os.system('cls' if os.name == 'nt' else 'clear')
		print(f'Menu\n')
		print(f'Você se encontra no(a) {self.localAtual.nome}.\n')
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
				
		self.acessiveis = {}
	
		currLoc = str(self.localAtual.id_pi)
		
		for con in self.conex:
			if(con.orig == currLoc):
				nomeLoc = self.locais[con.dest]
				self.acessiveis[con.dest] = nomeLoc
			elif(con.dest == currLoc):
				nomeLoc = self.locais[con.orig]
				self.acessiveis[con.orig] = nomeLoc
				
		print(f'Para onde deseja ir?\n')
		for key in self.acessiveis:
			print(f'{self.acessiveis[key]}: {key}')
		print(f'------------\n')
		
		entrada = input('Digite a opção desejada: ')
		if(entrada == "menu"):
			return False
		nome = self.acessiveis.get(entrada, "notALoca")
		
		for con in self.conex:
			if (con.orig == currLoc and con.dest == entrada) or (con.dest == currLoc and con.orig == entrada):
				prec = con.custo
				break 
		
		if(prec == -1):
			self.localAtual = nome
			return True
		
		if(nome == "notALoca"):
			
			print(f'\n\nIsto não é um local válido.\n\n')
			entrada = input('Pressione Enter')
					
			return False
		
		print(f'\n\nVocê foi a(o) {nome}, isso te custou {prec} de fome.\n\n')
		
		self.localAtual = PI(entrada, nome)
		
		entrada = input('Pressione Enter')
		
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
		
		
con1 = Conexao(1,5,5)
con2 = Conexao(1,3,5)
con3 = Conexao(1,4,5)
con4 = Conexao(1,2,7)
con5 = Conexao(2,16,9)
con6 = Conexao(3,6,8)
con7 = Conexao(4,13,7)
con8 = Conexao(5,10,7)
con9 = Conexao(5,11,8)
con10 = Conexao(5,12,7)
con11 = Conexao(6,7,4)
con12 = Conexao(11,19,10)
con13 = Conexao(13,17,9)
con14 = Conexao(13,14,20)
con15 = Conexao(14,15,30)
con16 = Conexao(16,8,20)
con17 = Conexao(16,9,30)

pi1 = PI(1, 'Base')
pi2 = PI(2, 'Travessia da Poeira')
pi3 = PI(3, 'Posto de Vigia Abandonado')
pi4 = PI(4, 'Cidade Fantasma')
pi5 = PI(5, 'Terra Chamuscada')
pi6 = PI(6, 'Subúrbio dos Esquecidos')
pi7 = PI(7, 'Nigrum Sanguinem')
pi8 = PI(8, 'Base dos Pisa Poeira')
pi9 = PI(9, 'Escola Amanhecer Dourado')
pi10 = PI(10, 'Cemitério das Máquinas')
pi11 = PI(11, 'Colinas Negras')
pi12 = PI(12, 'Mercabunker')
pi13 = PI(13, 'Poço de água')
pi14 = PI(14, 'Hospital Subterrâneo')
pi15 = PI(15, 'Aeroporto Militar')
pi16 = PI(16, 'Pátio do Ferro-Velho')
pi17 = PI(17, 'Lugar Algum')
pi18 = PI(18, 'Mêtro do Surfista')
pi19 = PI(19, 'Estação de Tratamento de Água')

EN = EstadoNormal()

listPI = [pi1, pi2, pi3, pi4, pi5, pi6, pi7, pi8, pi9, pi10, pi11, pi12, pi13, pi14, pi15, pi16, pi17, pi18, pi19]
listCON = [con1, con2, con3, con4, con5, con6, con7, con8, con9, con10, con11, con12, con13, con14, con15, con16, con17] 

EN.addPIList(listPI)
EN.addConList(listCON)

EN.default()
