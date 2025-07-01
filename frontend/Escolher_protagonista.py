import inquirer

def escolher_protagonista(conn):
    cur = conn.cursor()

    # Verifica se já há instância ativa de protagonista
    cur.execute("""
        SELECT inst_prota.id_ser, nome FROM inst_prota
        JOIN prota ON inst_prota.id_ser = prota.id_ser
        LIMIT 1
    """)
    inst_existente = cur.fetchone()

    if inst_existente:
        id_salvo, nome_salvo = inst_existente

        pergunta = [
            inquirer.List(
                'acao',
                message=f"Você já tem um jogo salvo com '{nome_salvo.strip()}'. Deseja continuar ou começar um novo jogo?",
                choices=["Continuar", "Novo Jogo"]
            )
        ]
        resposta = inquirer.prompt(pergunta)

        if resposta and resposta['acao'] == "Continuar":
            cur.close()
            return id_salvo
        else:
            iniciar_novo_jogo(conn)

    # Escolha de novo protagonista
    cur.execute("SELECT id_ser, nome FROM prota")
    protagonistas = cur.fetchall()

    escolhas = [f'{id_ser} - {nome.strip()}' for id_ser, nome in protagonistas]
    pergunta = [
        inquirer.List(
            'prota',
            message="Escolha seu protagonista:",
            choices=escolhas
        )
    ]
    resposta = inquirer.prompt(pergunta)
    if not resposta:
        print("Nenhum protagonista escolhido. Encerrando o jogo.")
        exit()

    id_prota = int(resposta['prota'].split(' - ')[0])

    # Buscar atributos do protagonista
    cur.execute("""
        SELECT hp_base, str_base, dex_base, def_base,
               res_fogo, res_gelo, res_elet, res_radi,
               res_cort, res_cont,
               fome_base, sede_base, carga_base
        FROM prota WHERE id_ser = %s
    """, (id_prota,))
    (pv, fo, dx, df,
     rf, rg, re, rr,
     rc, rct,
     fome, sede, carga) = cur.fetchone()

    # Garante que o evento inicial existe
    cur.execute("""
    INSERT INTO evento (id_evento, max_ocorrencia, tipo, prioridade, probabilidade)
    VALUES (1, NULL, 'MISSAO', '1', '100')
    ON CONFLICT DO NOTHING
""")

    # Inserir na inst_prota
    cur.execute("""
        INSERT INTO inst_prota (
            id_ser, id_inst, hp_max, hp_atual, str_atual,
            dex_atual, def_atual,
            res_fogo_at, res_gelo_at, res_elet_at, res_radi_at,
            res_cort_at, res_cont_at,
            fome_max, sede_max, fome_atual, sede_atual,
            carga_max, carga_atual, faccao, rad_atual, localizacao
        )
        VALUES (%s, DEFAULT, %s, %s, %s,
                %s, %s,
                %s, %s, %s, %s,
                %s, %s,
                %s, %s, %s, %s,
                %s, %s, NULL, 0, 1)
    """, (id_prota, pv, pv, fo, dx, df,
          rf, rg, re, rr,
          rc, rct,
          fome, sede, fome, sede,
          carga, 0))

    conn.commit()
    cur.close()
    return id_prota

def iniciar_novo_jogo(conn):
    with conn.cursor() as cur:
        cur.execute("DELETE FROM inst_ser;")
        # Limpe outras tabelas se quiser resetar mais coisas
    conn.commit()