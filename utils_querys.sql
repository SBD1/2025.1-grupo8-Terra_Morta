
-- ======================================================
-- COMPÊNDIO DE QUERYS ÚTEIS
-- ======================================================

-- ===========================
-- 1. Listagem de todos os protagonistas jogáveis
-- Uso: Tela de seleção de personagem pelo jogador
-- ===========================
SELECT id_ser, nome, hp_base, str_base, dex_base, def_base
FROM prota;

-- ===========================
-- 2. Confirmar personagem escolhido pelo jogador
-- Uso: Confirmação da escolha antes de iniciar o jogo
-- ===========================
SELECT nome
FROM prota
WHERE id_ser = 2; -- Exemplo com o id_ser 2

-- ===========================
-- 3. Criar instância inicial do personagem escolhido
-- Uso: Inicialização do jogador no mundo
-- ===========================
INSERT INTO inst_prota (
    id_ser, id_inst, hp_max, hp_atual, str_atual, dex_atual, def_atual,
    res_fogo_at, res_gelo_at, res_elet_at, res_radi_at, res_cort_at, res_cont_at,
    fome_max, sede_max, fome_atual, sede_atual, carga_max, carga_atual,
    rad_atual, localizacao, faccao
)
SELECT
    p.id_ser,
    nextval('instancia_sequence'),
    p.hp_base,
    p.hp_base,
    p.str_base,
    p.dex_base,
    p.def_base,
    p.res_fogo,
    p.res_gelo,
    p.res_elet,
    p.res_radi,
    p.res_cort,
    p.res_cont,
    p.fome_base,
    p.sede_base,
    p.fome_base,
    p.sede_base,
    p.carga_base,
    p.carga_base,
    0,
    1,
    NULL
FROM prota p
WHERE p.id_ser = 2;

-- ===========================
-- 4. Listar todos os inimigos existentes
-- Uso: Popular o compêndio com todos os inimigos conhecidos
-- ===========================
SELECT s.id_ser, COALESCE(ni.nome, i.nome) AS nome, 
       CASE 
           WHEN ni.id_ser IS NOT NULL THEN 'Não Inteligente'
           WHEN i.id_ser IS NOT NULL THEN 'Inteligente'
           ELSE 'Desconhecido'
       END AS tipo
FROM ser_controle s
LEFT JOIN nao_inteligente ni ON s.id_ser = ni.id_ser
LEFT JOIN inteligente i ON s.id_ser = i.id_ser;

-- ===========================
-- 5. Tabela de controle de inimigos derrotados por jogador
-- Uso: Criar se ainda não existir
-- ===========================
CREATE TABLE IF NOT EXISTS inimigos_derrotados (
    id_jogador SMALLINT NOT NULL,
    id_ser SMALLINT NOT NULL,
    qtd_derrotas SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY(id_jogador, id_ser),
    FOREIGN KEY(id_ser) REFERENCES ser_controle(id_ser)
);

-- ===========================
-- 6. Listar inimigos derrotados por um jogador
-- Uso: Mostrar parte do compêndio com inimigos já enfrentados
-- ===========================
SELECT s.id_ser, COALESCE(ni.nome, i.nome) AS nome, idd.qtd_derrotas
FROM inimigos_derrotados idd
JOIN ser_controle s ON idd.id_ser = s.id_ser
LEFT JOIN nao_inteligente ni ON s.id_ser = ni.id_ser
LEFT JOIN inteligente i ON s.id_ser = i.id_ser
WHERE idd.id_jogador = 1;

-- ===========================
-- 7. Listar inimigos nunca derrotados
-- Uso: Mostrar ao jogador quais inimigos ele ainda não conhece
-- ===========================
SELECT s.id_ser, COALESCE(ni.nome, i.nome) AS nome
FROM ser_controle s
LEFT JOIN nao_inteligente ni ON s.id_ser = ni.id_ser
LEFT JOIN inteligente i ON s.id_ser = i.id_ser
WHERE s.id_ser NOT IN (
    SELECT id_ser
    FROM inimigos_derrotados
    WHERE id_jogador = 1
);

-- ===========================
-- 8. Incrementar contador de inimigos derrotados
-- Uso: Chamar ao derrotar um inimigo
-- ===========================
INSERT INTO inimigos_derrotados (id_jogador, id_ser, qtd_derrotas)
VALUES (1, 5, 1)
ON CONFLICT (id_jogador, id_ser)
DO UPDATE SET qtd_derrotas = inimigos_derrotados.qtd_derrotas + 1;

-- ===========================
-- 9. Consultar o inventário geral
-- Uso: Exibir todos os itens no inventário com suas quantidades
-- ===========================
SELECT i.id_item, i.tipo, inv.quant
FROM inventario inv
JOIN item_controle i ON inv.id_item = i.id_item;

-- ===========================
-- 10. Equipamento atual de um personagem
-- Uso: Mostrar o que o personagem está vestindo/equipando
-- ===========================
SELECT eq.nome AS equipamento, eq.parte_corpo
FROM equipamento_atual ea
LEFT JOIN equipamento eq ON ea.cabeca = eq.id_equip OR
                             ea.torso = eq.id_equip OR
                             ea.maos = eq.id_equip OR
                             ea.pernas = eq.id_equip OR
                             ea.pes = eq.id_equip
WHERE ea.id_ser = 10;

-- ===========================
-- 11. Mutações atuais de um personagem
-- Uso: Mostrar mutações ativas
-- ===========================
SELECT m.nome AS mutacao, m.parte_corpo
FROM mutacao_atual ma
LEFT JOIN mutacao m ON ma.cabeca = m.id_mutacao OR
                       ma.torso = m.id_mutacao OR
                       ma.maos = m.id_mutacao OR
                       ma.pernas = m.id_mutacao OR
                       ma.pes = m.id_mutacao
WHERE ma.id_ser = 10;

-- ===========================
-- 12. Conexões entre pontos de interesse (mapa)
-- Uso: Calcular caminhos, movimentação, etc.
-- ===========================
SELECT p1.nome AS origem, p2.nome AS destino, c.custo
FROM conexao c
JOIN ponto_de_interesse p1 ON c.origem = p1.id_pi
JOIN ponto_de_interesse p2 ON c.destino = p2.id_pi;

-- ===========================
-- 13. Status e progresso das missões
-- Uso: Monitoramento das missões por status (Concluída, Ativa, etc)
-- ===========================
SELECT m.id_evento, m.status, m.prox
FROM missao m;

-- ===========================
-- 14. Itens coletáveis
-- Uso: Mostrar todos os itens coletáveis conhecidos
-- ===========================
SELECT c.nome
FROM coletavel c;

-- ===========================
-- 15. Instalações de uma base
-- Uso: Exibir estrutura de uma base
-- ===========================
SELECT b.nome AS base, i.nome AS instalacao, i.nivel, i.qtd
FROM base b
JOIN instalacao_base i ON b.id_instalacao = i.id_instalacao;

-- ===========================
-- 16. Localização atual de um personagem
-- Uso: Saber onde o personagem está no mundo
-- ===========================
SELECT ip.localizacao
FROM inst_prota ip
WHERE ip.id_ser = 15;

-- ===========================
-- 17. Requisitos de um evento
-- Uso: Verificar pré-requisitos para disparar eventos
-- ===========================
SELECT r.req, r.status
FROM requisitos r
WHERE r.id_evento = 8;