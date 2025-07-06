import random
import inquirer


def buscar_encontros(conn, id_pi):
    with conn.cursor() as cur:
        cur.execute("""
            SELECT e.id_evento, en.id_inimigo, en.quantidade, s.tipo, e.probabilidade, e.prioridade
            FROM ocorre o
            JOIN evento e ON o.id_evento = e.id_evento
            JOIN encontro en ON en.id_evento = e.id_evento
            JOIN ser_controle s ON en.id_inimigo = s.id_ser
            WHERE o.id_pi = %s
        """, (id_pi,))
        return cur.fetchall()

def criar_instancia_inimigo(conn, id_inimigo, local, quantidade):
    with conn.cursor() as cur:
        # Descobre o tipo do inimigo
        cur.execute("SELECT tipo FROM ser_controle WHERE id_ser = %s", (id_inimigo,))
        tipo = cur.fetchone()[0]
        if tipo == 'N':
            cur.execute("""
                SELECT hp_base, str_base, dex_base, def_base
                FROM nao_inteligente
                WHERE id_ser = %s
            """, (id_inimigo,))
        else:
            cur.execute("""
                SELECT hp_base, str_base, dex_base, def_base
                FROM inteligente
                WHERE id_ser = %s
            """, (id_inimigo,))
        row = cur.fetchone()
        if row:
            hp_base, str_base, dex_base, def_base = row
            for _ in range(quantidade):
                cur.execute("""
                    INSERT INTO inst_ser (id_ser, hp_max, hp_atual, str_atual, dex_atual, def_atual, localizacao)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (id_inimigo, hp_base, hp_base, str_base, dex_base, def_base, local))
        conn.commit()

    
def processar_encontros(conn, id_pi, local):
    encontros = buscar_encontros(conn, id_pi)
    ativados = []
    for encontro in encontros:
        id_evento, id_inimigo, quantidade, tipo, probabilidade, prioridade = encontro
        prob = int(probabilidade)
        if random.randint(1, 100) <= prob:
            ativados.append(encontro)
    if not ativados:
        return False

    encontro_escolhido = max(ativados, key=lambda x: x[5]) 
    id_evento, id_inimigo, quantidade, tipo, probabilidade, prioridade = encontro_escolhido
    # Buscar nome do inimigo
    with conn.cursor() as cur:
        cur.execute("""
            SELECT COALESCE(n.nome, intel.nome) FROM ser_controle s
            LEFT JOIN nao_inteligente n ON n.id_ser = s.id_ser
            LEFT JOIN inteligente intel ON intel.id_ser = s.id_ser
            WHERE s.id_ser = %s
        """, (id_inimigo,))
        nome = cur.fetchone()[0] if cur.rowcount else 'Desconhecido'
    print(f"\nQuantidade: {quantidade} | Inimigo: {nome.strip() if nome else 'Desconhecido'}")
    criar_instancia_inimigo(conn, id_inimigo, local, quantidade)
    return True


def inimigos_ativos_no_local(conn, id_pi):
    with conn.cursor() as cur:
        cur.execute("""
            SELECT i.id_ser, s.tipo, COALESCE(n.nome, intel.nome), i.hp_atual
            FROM inst_ser i
            JOIN ser_controle s ON i.id_ser = s.id_ser
            LEFT JOIN nao_inteligente n ON n.id_ser = i.id_ser
            LEFT JOIN inteligente intel ON intel.id_ser = i.id_ser
            WHERE i.localizacao = %s
        """, (id_pi,))
        return cur.fetchall()
    
def tentar_fuga():
    return random.random() < 0.5  

def lidar_com_inimigos_ativos(conn, id_pi, estado):
    inimigos = inimigos_ativos_no_local(conn, id_pi)
    if inimigos:
        print("\nInimigos:")
        for inimigo in inimigos:
            id_ser, tipo, nome, hp_atual = inimigo
            print(f"{nome.strip() if nome else 'Desconhecido'} (Vida: {hp_atual})")

        pergunta = [
            inquirer.List(
                'acao',
                message="O que deseja fazer?",
                choices=["Lutar", "Fugir"]
            )
        ]
        resposta = inquirer.prompt(pergunta)
        if not resposta:
            print("Nenhuma ação escolhida. Encerrando o jogo.")
            exit()

        if resposta['acao'] == "Fugir":
            if tentar_fuga():
                print("Você conseguiu fugir!")
                estado.set_localizacao(1)  #Volta para base
                estado.localAtual = 1
                input("Pressione Enter para continuar.")
                return "input_ja_foi"  # Sinaliza que já pediu input
            else:
                print("Você falhou ao fugir! O combate começa!")
                input("Pressione Enter para continuar.")
                return "input_ja_foi"

        print("Você decidiu enfrentar o inimigo!")
        input("Pressione Enter para continuar.")
        return "input_ja_foi"
    return None