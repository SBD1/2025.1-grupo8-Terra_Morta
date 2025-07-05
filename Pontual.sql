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


-- Triggers para coletavel
DROP TRIGGER IF EXISTS trg_garantir_integridade_coletavel_insert ON coletavel;
CREATE TRIGGER trg_garantir_integridade_coletavel_insert
BEFORE INSERT ON coletavel
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_coletavel();

DROP TRIGGER IF EXISTS trg_garantir_integridade_coletavel_delete ON coletavel;
CREATE TRIGGER trg_garantir_integridade_coletavel_delete
AFTER DELETE ON coletavel
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_coletavel();

-- Triggers para equipamento
DROP TRIGGER IF EXISTS trg_garantir_integridade_equipamento_insert ON equipamento;
CREATE TRIGGER trg_garantir_integridade_equipamento_insert
BEFORE INSERT ON equipamento
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_equipamento();

DROP TRIGGER IF EXISTS trg_garantir_integridade_equipamento_delete ON equipamento;
CREATE TRIGGER trg_garantir_integridade_equipamento_delete
AFTER DELETE ON equipamento
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_equipamento();

-- Triggers para mutacao
DROP TRIGGER IF EXISTS trg_garantir_integridade_mutacao_insert ON mutacao;
CREATE TRIGGER trg_garantir_integridade_mutacao_insert
BEFORE INSERT ON mutacao
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_mutacao();

DROP TRIGGER IF EXISTS trg_garantir_integridade_mutacao_delete ON mutacao;
CREATE TRIGGER trg_garantir_integridade_mutacao_delete
AFTER DELETE ON mutacao
FOR EACH ROW EXECUTE FUNCTION garantir_integridade_mutacao();


-- Para coletável
CREATE OR REPLACE FUNCTION inserir_coletavel(tipo CHAR, nome_coletavel VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO coletavel (id_item, nome) VALUES (novo_id, nome_coletavel);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Para equipamento
CREATE OR REPLACE FUNCTION inserir_equipamento(tipo CHAR, nome_equip VARCHAR, nivel SMALLINT, parte_corpo CHAR(4))
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO equipamento (id_equip, nome, nivel, parte_corpo) VALUES (novo_id, nome_equip, nivel, parte_corpo);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Para mutação
CREATE OR REPLACE FUNCTION inserir_mutacao(tipo CHAR, nome_mutacao VARCHAR, nivel SMALLINT, parte_corpo CHAR(4))
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO mutacao (id_mutacao, nome, nivel, parte_corpo) VALUES (novo_id, nome_mutacao, nivel, parte_corpo);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;