import random


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

    # Escolhe o de maior prioridade (menor valor)
    encontro_escolhido = max(ativados, key=lambda x: x[5]) 
    id_evento, id_inimigo, quantidade, tipo, probabilidade, prioridade = encontro_escolhido
    print(f"\nVocê encontrou um inimigo!\nInimigo ID: {id_inimigo} | Quantidade: {quantidade} (Prioridade: {prioridade})")
    criar_instancia_inimigo(conn, id_inimigo, local, quantidade)
    return True