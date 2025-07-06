import random

def buscar_acontecimentos(conn, id_pi):
    with conn.cursor() as cur:
        cur.execute('''
            SELECT e.id_evento, am.valor, am.texto, e.probabilidade
            FROM ocorre o
            JOIN evento e ON o.id_evento = e.id_evento
            JOIN acontecimento_mundo am ON am.id_evento = e.id_evento
            WHERE o.id_pi = %s
        ''', (id_pi,))
        return cur.fetchall()

def processar_acontecimentos(conn, id_pi, estado):
    acontecimentos = buscar_acontecimentos(conn, id_pi)
    ativados = []
    for id_evento, valor, texto, probabilidade in acontecimentos:
        prob = int(probabilidade)
        if random.randint(1, 100) <= prob:
            ativados.append((id_evento, valor, texto))
    if not ativados:
        return False

    # Executa o acontecimento de maior valor (pode ser alterado para outro critério)
    id_evento, valor, texto = max(ativados, key=lambda x: x[1])
    print(f"\n{texto}")
    # Efeitos: dano/recuperação de vida, fome, sede, radiação
    if 'vida' in texto:
        hp = estado.get_hp()
        if hp:
            hp_atual, hp_max = hp
            novo_hp = max(0, min(hp_max, hp_atual + valor))
            estado.set_hp(novo_hp)
    elif 'fome' in texto:
        fome = estado.get_fome()
        if fome:
            fome_atual, fome_max = fome
            novo_fome = max(0, min(fome_max, fome_atual + valor))
            estado.set_fome(novo_fome)
    elif 'sede' in texto:
        sede = estado.get_sede()
        if sede:
            sede_atual, sede_max = sede
            novo_sede = max(0, min(sede_max, sede_atual + valor))
            estado.set_sede(novo_sede)
    elif 'radiação' in texto or 'radiacao' in texto:
        rad = estado.get_radiacao()
        # get_radiacao pode retornar só o valor atual
        if isinstance(rad, tuple):
            rad_atual, rad_max = rad
        else:
            rad_atual = rad
            rad_max = 100  # valor padrão se não houver máximo
        novo_rad = max(0, min(rad_max, rad_atual + valor))
        estado.set_radiacao(novo_rad)
    input('Pressione Enter para continuar.')
    return True
