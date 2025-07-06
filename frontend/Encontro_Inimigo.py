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
    print(f"\nVocê encontrou um inimigo!\nInimigo ID: {id_inimigo} | Quantidade: {quantidade} (Prioridade: {prioridade})")
    criar_instancia_inimigo(conn, id_inimigo, local, quantidade)
    return True


def inimigos_ativos_no_local(conn, id_pi):
    with conn.cursor() as cur:
        cur.execute("""
            SELECT i.id_ser, i.id_inst, s.tipo, COALESCE(n.nome, intel.nome), i.hp_max, i.hp_atual, i.str_atual, i.dex_atual, i.def_atual
            FROM inst_ser i
            JOIN ser_controle s ON i.id_ser = s.id_ser
            LEFT JOIN nao_inteligente n ON n.id_ser = i.id_ser
            LEFT JOIN inteligente intel ON intel.id_ser = i.id_ser
            WHERE i.localizacao = %s
        """, (id_pi,))
        return cur.fetchall() 

def lidar_com_inimigos_ativos(conn, id_pi, estado):
    inimigos = inimigos_ativos_no_local(conn, id_pi)
    if inimigos:
        print("\nVocê já encontrou inimigos aqui!")
        for inimigo in inimigos:
            id_ser, id_inst, tipo, nome, hp_max, hp_atual, str_atual, dex_atual, def_atual = inimigo
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
            if estado.tentar_fuga():
                print("Você conseguiu fugir!")
                estado.set_localizacao(1)  #Volta para base
                estado.localAtual = 1
                input("Pressione Enter para continuar.")
                
                return "conseguiu_fugir"
            else:
                estado.print_clr("Você falhou ao fugir! O combate começa!")
                resultado_luta = estado.iniciar_luta(inimigos)
                input("Pressione Enter para continuar.")
                
                if resultado_luta == "derrota_protagonista":
                    return "derrota_protagonista"
                elif resultado_luta == "conseguiu_fugir":
                    return "conseguiu_fugir"
                elif resultado_luta == "vitoria_protagonista":
                    return "vitoria_protagonista"

        estado.print_clr("Você decidiu enfrentar o inimigo!")
        resultado_luta = estado.iniciar_luta(inimigos)
        input("Pressione Enter para continuar.")
        
        if resultado_luta == "derrota_protagonista":
            return "derrota_protagonista"
        elif resultado_luta == "conseguiu_fugir":
            return "conseguiu_fugir"
        elif resultado_luta == "vitoria_protagonista":
            return "vitoria_protagonista"
    
    return "sem_inimigos_ativos"