-- =======================================
-- FUNÇÕES DE EVENTOS E MISSÕES
-- =======================================

-- Função para criar encontro com inimigos
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

-- Função para criar acontecimento mundo
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

-- Função para criar missão matar
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

-- Função para criar missão entregar
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
-- FUNÇÕES DE INTEGRIDADE
-- =======================================

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
-- FUNÇÕES DE INSERÇÃO DE ITENS
-- =======================================

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

CREATE OR REPLACE FUNCTION inserir_utilizavel(tipo CHAR(1), nome_utilizavel CHAR(50), preco INT, atributo CHAR(10), valor SMALLINT)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO item_controle (tipo) VALUES (tipo) RETURNING id_item INTO novo_id;
    INSERT INTO utilizavel (id_util, nome, preco, atributo, valor) VALUES (novo_id, nome_utilizavel, preco, atributo, valor);
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

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

-- =======================================
-- PROCEDURES DE MISSÕES
-- =======================================

CREATE OR REPLACE PROCEDURE resetar_status_missoes_matar()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Deixa todas as missões de matar como inativas
    UPDATE missao SET status = 'C' WHERE id_evento IN (
        SELECT m.id_evento FROM missao m
        JOIN requisitos r ON m.id_requisito = r.id_requisito
        WHERE r.tipo = 'MATAR'
    );
    -- Ativa apenas as primeiras missões de cada cadeia (menor id_evento para cada alvo)
    UPDATE missao SET status = 'A' WHERE id_evento IN (
        SELECT MIN(m.id_evento) FROM missao m
        JOIN requisitos r ON m.id_requisito = r.id_requisito
        WHERE r.tipo = 'MATAR'
        GROUP BY r.alvo
    );
END;
$$;

-- =======================================
-- FUNÇÕES DE STATUS E ATRIBUTOS
-- =======================================

CREATE OR REPLACE FUNCTION atualizar_status_inst_prota(p_id_ser INT) RETURNS VOID AS $$
DECLARE
    v_id_inst INT;
    v_hp_base INT;
    v_str_base INT;
    v_dex_base INT;
    v_def_base INT;
    v_res_fogo INT;
    v_res_gelo INT;
    v_res_elet INT;
    v_res_radi INT;
    v_res_cort INT;
    v_res_cont INT;
    v_fome_base INT;
    v_sede_base INT;
    v_carga_base INT;
    -- Modificadores
    mod_hp INT := 0;
    mod_str INT := 0;
    mod_dex INT := 0;
    mod_def INT := 0;
    mod_res_fogo INT := 0;
    mod_res_gelo INT := 0;
    mod_res_elet INT := 0;
    mod_res_radi INT := 0;
    mod_res_cort INT := 0;
    mod_res_cont INT := 0;
    mod_fome INT := 0;
    mod_sede INT := 0;
    mod_carga INT := 0;
    -- IDs dos equipamentos e mutações atuais
    eq_cabeca INT; eq_torso INT; eq_maos INT; eq_pernas INT; eq_pes INT;
    mut_cabeca INT; mut_torso INT; mut_maos INT; mut_pernas INT; mut_pes INT;
    -- Variável para laço sobre SELECT
    modif RECORD;
BEGIN
    -- Busca o id_inst mais recente
    SELECT id_inst INTO v_id_inst FROM inst_prota WHERE id_ser = p_id_ser ORDER BY id_inst DESC LIMIT 1;
    -- Busca os status base
    SELECT hp_base, str_base, dex_base, def_base, res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont, fome_base, sede_base, carga_base
    INTO v_hp_base, v_str_base, v_dex_base, v_def_base, v_res_fogo, v_res_gelo, v_res_elet, v_res_radi, v_res_cort, v_res_cont, v_fome_base, v_sede_base, v_carga_base
    FROM prota WHERE id_ser = p_id_ser;
    -- Busca equipamentos atuais
    SELECT cabeca, torso, maos, pernas, pes INTO eq_cabeca, eq_torso, eq_maos, eq_pernas, eq_pes FROM equipamento_atual WHERE id_ser = p_id_ser;
    -- Busca mutações atuais
    SELECT cabeca, torso, maos, pernas, pes INTO mut_cabeca, mut_torso, mut_maos, mut_pernas, mut_pes FROM mutacao_atual WHERE id_ser = p_id_ser;
    -- Soma modificadores dos equipamentos
    FOR modif IN SELECT atributo, valor FROM modificador WHERE id_item IN (eq_cabeca, eq_torso, eq_maos, eq_pernas, eq_pes) LOOP
        IF modif.atributo = 'hp' THEN mod_hp := mod_hp + modif.valor;
        ELSIF modif.atributo = 'str' THEN mod_str := mod_str + modif.valor;
        ELSIF modif.atributo = 'dex' THEN mod_dex := mod_dex + modif.valor;
        ELSIF modif.atributo = 'def' THEN mod_def := mod_def + modif.valor;
        ELSIF modif.atributo = 'res_fogo' THEN mod_res_fogo := mod_res_fogo + modif.valor;
        ELSIF modif.atributo = 'res_gelo' THEN mod_res_gelo := mod_res_gelo + modif.valor;
        ELSIF modif.atributo = 'res_elet' THEN mod_res_elet := mod_res_elet + modif.valor;
        ELSIF modif.atributo = 'res_radi' THEN mod_res_radi := mod_res_radi + modif.valor;
        ELSIF modif.atributo = 'res_cort' THEN mod_res_cort := mod_res_cort + modif.valor;
        ELSIF modif.atributo = 'res_cont' THEN mod_res_cont := mod_res_cont + modif.valor;
        ELSIF modif.atributo = 'fome' THEN mod_fome := mod_fome + modif.valor;
        ELSIF modif.atributo = 'sede' THEN mod_sede := mod_sede + modif.valor;
        ELSIF modif.atributo = 'carga' THEN mod_carga := mod_carga + modif.valor;
        END IF;
    END LOOP;
    -- Soma modificadores das mutações
    FOR modif IN SELECT atributo, valor FROM modificador WHERE id_item IN (mut_cabeca, mut_torso, mut_maos, mut_pernas, mut_pes) LOOP
        IF modif.atributo = 'hp' THEN mod_hp := mod_hp + modif.valor;
        ELSIF modif.atributo = 'str' THEN mod_str := mod_str + modif.valor;
        ELSIF modif.atributo = 'dex' THEN mod_dex := mod_dex + modif.valor;
        ELSIF modif.atributo = 'def' THEN mod_def := mod_def + modif.valor;
        ELSIF modif.atributo = 'res_fogo' THEN mod_res_fogo := mod_res_fogo + modif.valor;
        ELSIF modif.atributo = 'res_gelo' THEN mod_res_gelo := mod_res_gelo + modif.valor;
        ELSIF modif.atributo = 'res_elet' THEN mod_res_elet := mod_res_elet + modif.valor;
        ELSIF modif.atributo = 'res_radi' THEN mod_res_radi := mod_res_radi + modif.valor;
        ELSIF modif.atributo = 'res_cort' THEN mod_res_cort := mod_res_cort + modif.valor;
        ELSIF modif.atributo = 'res_cont' THEN mod_res_cont := mod_res_cont + modif.valor;
        ELSIF modif.atributo = 'fome' THEN mod_fome := mod_fome + modif.valor;
        ELSIF modif.atributo = 'sede' THEN mod_sede := mod_sede + modif.valor;
        ELSIF modif.atributo = 'carga' THEN mod_carga := mod_carga + modif.valor;
        END IF;
    END LOOP;
    -- Soma o peso dos itens do inventário do protagonista
    DECLARE
        v_carga_atual INT := 0;
    BEGIN
        SELECT COALESCE(SUM(i.quant * m.valor), 0)
        INTO v_carga_atual
        FROM inventario i
        JOIN modificador m ON i.id_item = m.id_item AND m.atributo = 'peso';
        -- Atualiza inst_prota com os valores finais
        UPDATE inst_prota SET
            hp_max = v_hp_base + mod_hp,
            str_atual = v_str_base + mod_str,
            dex_atual = v_dex_base + mod_dex,
            def_atual = v_def_base + mod_def,
            res_fogo_at = v_res_fogo + mod_res_fogo,
            res_gelo_at = v_res_gelo + mod_res_gelo,
            res_elet_at = v_res_elet + mod_res_elet,
            res_radi_at = v_res_radi + mod_res_radi,
            res_cort_at = v_res_cort + mod_res_cort,
            res_cont_at = v_res_cont + mod_res_cont,
            fome_max = v_fome_base + mod_fome,
            sede_max = v_sede_base + mod_sede,
            carga_max = v_carga_base + mod_carga,
            carga_atual = v_carga_atual
        WHERE id_ser = p_id_ser AND id_inst = v_id_inst;
    END;
END;
$$ LANGUAGE plpgsql;

-- =======================================
-- FUNÇÕES DE TRIGGER
-- =======================================

CREATE OR REPLACE FUNCTION trigger_atualizar_status_inventario() RETURNS TRIGGER AS $$
DECLARE
    v_id_ser INT;
BEGIN
    -- Descobre o id_ser do protagonista dono do inventário
    SELECT id_ser INTO v_id_ser FROM prota WHERE id_ser IS NOT NULL LIMIT 1;
    -- Chama a função de atualização de status
    IF v_id_ser IS NOT NULL THEN
        PERFORM atualizar_status_inst_prota(v_id_ser);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =======================================
-- TRIGGERS DE MUTACAO_ATUAL PARA ATUALIZAR ATRIBUTOS
-- =======================================

CREATE OR REPLACE FUNCTION trigger_atualizar_status_mut_update() RETURNS TRIGGER AS $$
BEGIN
    PERFORM atualizar_status_inst_prota(NEW.id_ser);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_atualizar_status_mut_delete() RETURNS TRIGGER AS $$
BEGIN
    PERFORM atualizar_status_inst_prota(OLD.id_ser);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- =======================================
-- TRIGGER FUNCTION: Adiciona mutação ao atingir certos níveis de radiação
-- =======================================

CREATE OR REPLACE FUNCTION trigger_mutacao_por_radiacao() RETURNS TRIGGER AS $$
DECLARE
    v_rad_novo INT;
    v_id_ser INT;
    v_slots TEXT[] := ARRAY['cabeca', 'torso', 'maos', 'pernas', 'pes'];
    v_slot_livre TEXT;
    v_id_mutacao INT;
    v_mutacao INT;
BEGIN
    v_rad_novo := NEW.rad_atual;
    v_id_ser := NEW.id_ser;
    -- Só age se atingiu 5, 10 ou 15 de radiação
    IF v_rad_novo IN (50, 100, 150) THEN
        -- Procura um slot livre em mutacao_atual
        SELECT unnest(v_slots) INTO v_slot_livre
        FROM mutacao_atual
        WHERE id_ser = v_id_ser
        AND (
            cabeca IS NULL OR torso IS NULL OR maos IS NULL OR pernas IS NULL OR pes IS NULL
        )
        LIMIT 1;
        IF v_slot_livre IS NOT NULL THEN
            -- Sorteia uma mutação aleatória que não esteja equipada
            SELECT id_mutacao INTO v_id_mutacao
            FROM mutacao
            WHERE parte_corpo = v_slot_livre
            AND id_mutacao NOT IN (
                SELECT cabeca FROM mutacao_atual WHERE id_ser = v_id_ser
                UNION
                SELECT torso FROM mutacao_atual WHERE id_ser = v_id_ser
                UNION
                SELECT maos FROM mutacao_atual WHERE id_ser = v_id_ser
                UNION
                SELECT pernas FROM mutacao_atual WHERE id_ser = v_id_ser
                UNION
                SELECT pes FROM mutacao_atual WHERE id_ser = v_id_ser
            )
            ORDER BY random() LIMIT 1;
            IF v_id_mutacao IS NOT NULL THEN
                -- Atualiza o slot livre com a mutação sorteada
                EXECUTE format('UPDATE mutacao_atual SET %I = $1 WHERE id_ser = $2', v_slot_livre)
                USING v_id_mutacao, v_id_ser;
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Os comandos de CREATE TRIGGER devem ser executados no arquivo triggers.sql, mas as funções ficam aqui.