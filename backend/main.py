import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import psycopg
import networkx as nx
from dotenv import load_dotenv
import os
from frontend.EstadoNormal import EstadoNormal

# Carrega as variáveis do arquivo .env
load_dotenv()

# Pega os valores das variáveis de ambiente
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")

# Conecta ao banco de dados PostgreSQL
conn = psycopg.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cur = conn.cursor()

# Consulta os pontos de interesse
cur.execute("SELECT id_pi, nome FROM ponto_de_interesse")
pontos = cur.fetchall()

# Cria o grafo não direcionado
G = nx.Graph()

# Adiciona os nós no grafo
G.add_nodes_from([(id_pi, {"nome": nome}) for (id_pi, nome) in pontos])

# Consulta as conexões entre os pontos
cur.execute("SELECT origem, destino, custo FROM conexao")
conexao = cur.fetchall()

# Adiciona as arestas ao grafo (com peso)
for origem, destino, custo in conexao:
    G.add_edge(origem, destino, weight=custo)

# Fecha a conexão
cur.close()
conn.close()

EN = EstadoNormal(G)
EN.menu()