-- =======================================
-- Criar Encontro com Inimigos
-- =======================================

CREATE OR REPLACE FUNCTION criar_encontro(
    p_id_inimigo INT,
    p_quantidade INT,
    p_local INT,
    p_max_ocorrencia INT DEFAULT 1,
    p_prioridade CHAR(1) DEFAULT '1',
    p_probabilidade CHAR(3) DEFAULT '50'
)
RETURNS INT AS $criar_encontro$
DECLARE
    v_id_evento INT;
BEGIN
    -- Cria o evento do tipo ENCONTRO
    INSERT INTO evento (max_ocorrencia, prioridade, probabilidade, tipo)
    VALUES (p_max_ocorrencia, p_prioridade, p_probabilidade, 'ENCONTRO')
    RETURNING id_evento INTO v_id_evento;

    -- Cria o encontro vinculado ao evento
    INSERT INTO encontro (id_evento, id_inimigo, quantidade)
    VALUES (v_id_evento, p_id_inimigo, p_quantidade);

    -- Relaciona o evento ao ponto de interesse
    INSERT INTO ocorre (id_evento, id_pi)
    VALUES (v_id_evento, p_local);

    RETURN v_id_evento;
END;
$criar_encontro$ LANGUAGE plpgsql;

-- =======================================
-- Criar Acontecimentos
-- =======================================

CREATE OR REPLACE FUNCTION criar_acontecimento_mundo(
    p_atributo INT,
    p_valor INT,
    p_texto VARCHAR,
    p_local INT,
    p_max_ocorrencia INT DEFAULT 1,
    p_prioridade CHAR(1) DEFAULT '1',
    p_probabilidade CHAR(3) DEFAULT '50'
)
RETURNS INT AS $criar_acontecimento$
DECLARE
    v_id_evento INT;
BEGIN
    -- Cria o evento do tipo ACONTECIMENTO MUNDO
    INSERT INTO evento (max_ocorrencia, prioridade, probabilidade, tipo)
    VALUES (p_max_ocorrencia, p_prioridade, p_probabilidade, 'ACONTECIMENTO MUNDO')
    RETURNING id_evento INTO v_id_evento;

    -- Cria o acontecimento_mundo vinculado ao evento
    INSERT INTO acontecimento_mundo (id_evento, atributo, valor, texto)
    VALUES (v_id_evento, p_atributo, p_valor, p_texto);

    -- Relaciona o evento ao ponto de interesse
    INSERT INTO ocorre (id_evento, id_pi)
    VALUES (v_id_evento, p_local);

    RETURN v_id_evento;
END;
$criar_acontecimento$ LANGUAGE plpgsql;


-- =======================================
-- Criar Missão Matar
-- =======================================

CREATE OR REPLACE FUNCTION criar_missao_matar(
    p_id_inimigo INT,
    p_quantidade INT,
    p_max_ocorrencia INT DEFAULT 1,
    p_prioridade CHAR(1) DEFAULT '1',
    p_probabilidade CHAR(3) DEFAULT '50',
    p_recompensas TEXT DEFAULT NULL,
    p_prox INT DEFAULT NULL
)
RETURNS INT AS $criar_missao_matar$
DECLARE
    v_id_evento INT;
    v_id_requisito INT;
BEGIN
    -- Cria o evento do tipo MISSAO
    INSERT INTO evento (max_ocorrencia, prioridade, probabilidade, tipo)
    VALUES (p_max_ocorrencia, p_prioridade, p_probabilidade, 'MISSAO')
    RETURNING id_evento INTO v_id_evento;

    -- Cria o requisito do tipo MATAR
    INSERT INTO requisitos (tipo, alvo, quantidade)
    VALUES ('MATAR', p_id_inimigo, p_quantidade)
    RETURNING id_requisito INTO v_id_requisito;

    -- Cria a missão vinculando ao requisito
    INSERT INTO missao (id_evento, id_requisito, status, recompensas, prox)
    VALUES (v_id_evento, v_id_requisito, 'A', p_recompensas, p_prox);

    RETURN v_id_evento;
END;
$criar_missao_matar$ LANGUAGE plpgsql;


-- =======================================
-- Criar Missão Item
-- =======================================

CREATE OR REPLACE FUNCTION criar_missao_entregar(
    p_id_item INT,
    p_quantidade INT,
    p_max_ocorrencia INT DEFAULT 1,
    p_prioridade CHAR(1) DEFAULT '1',
    p_probabilidade CHAR(3) DEFAULT '50',
    p_recompensas TEXT DEFAULT NULL,
    p_prox INT DEFAULT NULL
)
RETURNS INT AS $criar_missao_entregar$
DECLARE
    v_id_evento INT;
    v_id_requisito INT;
BEGIN
    -- Cria o evento do tipo MISSAO
    INSERT INTO evento (max_ocorrencia, prioridade, probabilidade, tipo)
    VALUES (p_max_ocorrencia, p_prioridade, p_probabilidade, 'MISSAO')
    RETURNING id_evento INTO v_id_evento;

    -- Cria o requisito do tipo ENTREGAR
    INSERT INTO requisitos (tipo, alvo, quantidade)
    VALUES ('ENTREGAR', p_id_item, p_quantidade)
    RETURNING id_requisito INTO v_id_requisito;

    -- Cria a missão vinculando ao requisito
    INSERT INTO missao (id_evento, id_requisito, status, recompensas, prox)
    VALUES (v_id_evento, v_id_requisito, 'A', p_recompensas, p_prox);

    RETURN v_id_evento;
END;
$criar_missao_entregar$ LANGUAGE plpgsql;