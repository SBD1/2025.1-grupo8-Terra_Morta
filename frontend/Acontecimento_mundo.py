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
    # Exemplo de efeitos: dano na vida, recuperar fome, sede, etc.
    if 'vida' in texto:
        hp_atual, hp_max = estado.get_fome()  # Substitua por get_hp se existir
        novo_hp = max(0, hp_atual - valor)
        # estado.set_hp(novo_hp)  # Implemente se necessário
    elif 'fome' in texto:
        fome_atual, fome_max = estado.get_fome()
        novo_fome = min(fome_max, fome_atual + valor)
        estado.set_fome(novo_fome)
    elif 'sede' in texto:
        pass
    elif 'radiação' in texto:
        pass
    input('Pressione Enter para continuar.')
    return True
