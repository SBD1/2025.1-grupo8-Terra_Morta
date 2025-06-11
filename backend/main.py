import psycopg
import networkx as nx

# Conecta ao banco de dados
conn = psycopg.connect("dbname=seu_banco user=seu_usuario password=senha")
cur = conn.cursor()

# Consulta os pontos de interesse
cur.execute("SELECT id_pi, nome FROM ponto_de_interesse")
pontos = cur.fetchall()

# Cria o grafo não direcionado
G = nx.Graph()

# Adiciona os nós no grafo
G.add_nodes_from([(id_pi, {"nome": nome}) for (id_pi, nome) in pontos])

# Exemplo: imprime os nós e seus atributos
for node, attrs in G.nodes(data=True):
    print(f"ID: {node}, Nome: {attrs['nome']}")

# Fecha a conexão
cur.close()
conn.close()
