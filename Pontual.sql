-- Procedure para atualizar os status do inst_prota com modificadores de equipamentos e mutações atuais
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
        carga_max = v_carga_base + mod_carga
    WHERE id_ser = p_id_ser AND id_inst = v_id_inst;
END;
$$ LANGUAGE plpgsql;

-- Função trigger para equipamento_atual
CREATE OR REPLACE FUNCTION trigger_atualizar_status_equip() RETURNS TRIGGER AS $$
BEGIN
    PERFORM atualizar_status_inst_prota(NEW.id_ser);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função trigger para mutacao_atual
CREATE OR REPLACE FUNCTION trigger_atualizar_status_mut() RETURNS TRIGGER AS $$
BEGIN
    PERFORM atualizar_status_inst_prota(NEW.id_ser);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop triggers antigos se existirem
DROP TRIGGER IF EXISTS trigger_atualizar_status_equip ON equipamento_atual;
DROP TRIGGER IF EXISTS trigger_atualizar_status_mut ON mutacao_atual;

-- Trigger para atualizar status ao equipar equipamento
CREATE TRIGGER trigger_atualizar_status_equip
AFTER UPDATE OR INSERT ON equipamento_atual
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_equip();

-- Trigger para atualizar status ao equipar mutação
CREATE TRIGGER trigger_atualizar_status_mut
AFTER UPDATE OR INSERT ON mutacao_atual
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_mut();