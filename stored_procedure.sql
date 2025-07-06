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

-- =======================================
-- Garantias de Integridade
-- =======================================

-- Garantias para COLETAVEL
CREATE OR REPLACE FUNCTION garantir_integridade_coletavel()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Cria item_controle se não existir
        IF NOT EXISTS (SELECT 1 FROM item_controle WHERE id_item = NEW.id_item) THEN
            INSERT INTO item_controle (id_item, tipo) VALUES (NEW.id_item, 'C');
        END IF;
        -- Impede duplicidade
        IF EXISTS (SELECT 1 FROM equipamento WHERE id_equip = NEW.id_item) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como equipamento e não pode ser coletável ao mesmo tempo.', NEW.id_item;
        END IF;
        IF EXISTS (SELECT 1 FROM mutacao WHERE id_mutacao = NEW.id_item) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como mutação e não pode ser coletável ao mesmo tempo.', NEW.id_item;
        END IF;
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE' THEN
        DELETE FROM item_controle WHERE id_item = OLD.id_item;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Garantias para EQUIPAMENTO
CREATE OR REPLACE FUNCTION garantir_integridade_equipamento()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Cria item_controle se não existir
        IF NOT EXISTS (SELECT 1 FROM item_controle WHERE id_item = NEW.id_equip) THEN
            INSERT INTO item_controle (id_item, tipo) VALUES (NEW.id_equip, 'E');
        END IF;
        -- Impede duplicidade
        IF EXISTS (SELECT 1 FROM coletavel WHERE id_item = NEW.id_equip) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como coletável e não pode ser equipamento ao mesmo tempo.', NEW.id_equip;
        END IF;
        IF EXISTS (SELECT 1 FROM mutacao WHERE id_mutacao = NEW.id_equip) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como mutação e não pode ser equipamento ao mesmo tempo.', NEW.id_equip;
        END IF;
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE' THEN
        DELETE FROM item_controle WHERE id_item = OLD.id_equip;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Garantias para MUTACAO
CREATE OR REPLACE FUNCTION garantir_integridade_mutacao()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Cria item_controle se não existir
        IF NOT EXISTS (SELECT 1 FROM item_controle WHERE id_item = NEW.id_mutacao) THEN
            INSERT INTO item_controle (id_item, tipo) VALUES (NEW.id_mutacao, 'M');
        END IF;
        -- Impede duplicidade
        IF EXISTS (SELECT 1 FROM coletavel WHERE id_item = NEW.id_mutacao) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como coletável e não pode ser mutação ao mesmo tempo.', NEW.id_mutacao;
        END IF;
        IF EXISTS (SELECT 1 FROM equipamento WHERE id_equip = NEW.id_mutacao) THEN
            RAISE EXCEPTION 'O item % já está cadastrado como equipamento e não pode ser mutação ao mesmo tempo.', NEW.id_mutacao;
        END IF;
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE' THEN
        DELETE FROM item_controle WHERE id_item = OLD.id_mutacao;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- =======================================
-- Funções para Inserção de Itens
-- =======================================

-- Para coletável
CREATE OR REPLACE FUNCTION inserir_coletavel(tipo CHAR(1), nome_coletavel CHAR(50), preco INT)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO coletavel (id_item, nome, preco) VALUES (novo_id, nome_coletavel, preco);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Para equipamento
CREATE OR REPLACE FUNCTION inserir_equipamento(tipo CHAR(1), nome_equip CHAR(50), nivel SMALLINT, parte_corpo CHAR(4), preco INT)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO equipamento (id_equip, nome, nivel, parte_corpo, preco) VALUES (novo_id, nome_equip, nivel, parte_corpo, preco);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Para mutação
CREATE OR REPLACE FUNCTION inserir_mutacao(tipo CHAR(1), nome_mutacao CHAR(50), nivel SMALLINT, parte_corpo CHAR(4))
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO mutacao (id_mutacao, nome, nivel, parte_corpo) VALUES (novo_id, nome_mutacao, nivel, parte_corpo);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;