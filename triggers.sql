-- =======================================
-- TRIGGERS DE INTEGRIDADE
-- =======================================

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


-- =======================================
-- TRIGGERS DE MISSÃO E EVENTOS
-- =======================================

-- =======================================
-- TRIGGER PARA ATIVAR PRÓXIMA MISSÃO AUTOMATICAMENTE
-- =======================================
CREATE OR REPLACE FUNCTION ativar_proxima_missao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'F' AND NEW.prox IS NOT NULL THEN
        UPDATE missao SET status = 'A' WHERE id_evento = NEW.prox;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_ativar_proxima_missao ON missao;
CREATE TRIGGER trigger_ativar_proxima_missao
AFTER UPDATE OF status ON missao
FOR EACH ROW
WHEN (OLD.status <> 'F' AND NEW.status = 'F')
EXECUTE FUNCTION ativar_proxima_missao();


-- =======================================
-- TRIGGERS DE STATUS E ATRIBUTOS
-- =======================================

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
DROP TRIGGER IF EXISTS trigger_atualizar_status_inventario ON inventario;
DROP TRIGGER IF EXISTS trigger_remover_equipamento_atual ON inventario;
DROP TRIGGER IF EXISTS trigger_atualizar_status_apos_remover_equipamento ON equipamento_atual;
DROP TRIGGER IF EXISTS trigger_mutacao_por_radiacao ON inst_prota;

-- Trigger para atualizar status ao equipar equipamento
CREATE TRIGGER trigger_atualizar_status_equip
AFTER UPDATE OR INSERT ON equipamento_atual
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_equip();

-- Trigger para atualizar status ao equipar mutação
CREATE TRIGGER trigger_atualizar_status_mut
AFTER UPDATE OR INSERT ON mutacao_atual
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_mut();

-- Trigger para atualizar status ao inserir ou atualizar inventário
CREATE TRIGGER trigger_atualizar_status_inventario
AFTER INSERT OR UPDATE OR DELETE ON inventario
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_inventario();

-- Trigger para remover equipamento_atual ao deletar item do inventário
CREATE TRIGGER trigger_remover_equipamento_atual
AFTER DELETE ON inventario
FOR EACH ROW EXECUTE FUNCTION trigger_remover_equipamento_atual();

-- Trigger para atualizar atributos ao remover equipamento_atual
CREATE TRIGGER trigger_atualizar_status_apos_remover_equipamento
AFTER DELETE ON equipamento_atual
FOR EACH ROW EXECUTE FUNCTION trigger_atualizar_status_apos_remover_equipamento();

-- Trigger para adicionar mutação ao atingir certos níveis de radiação
CREATE TRIGGER trigger_mutacao_por_radiacao
AFTER UPDATE OF rad_atual ON inst_prota
FOR EACH ROW EXECUTE FUNCTION trigger_mutacao_por_radiacao();


-- =======================================
-- TRIGGERS DE MUTACAO_ATUAL PARA ATUALIZAR ATRIBUTOS
-- =======================================

DROP TRIGGER IF EXISTS mutacao_atual_update_trigger ON mutacao_atual;
CREATE TRIGGER mutacao_atual_update_trigger
AFTER UPDATE ON mutacao_atual
FOR EACH ROW
EXECUTE FUNCTION trigger_atualizar_status_mut_update();

DROP TRIGGER IF EXISTS mutacao_atual_delete_trigger ON mutacao_atual;
CREATE TRIGGER mutacao_atual_delete_trigger
AFTER DELETE ON mutacao_atual
FOR EACH ROW
EXECUTE FUNCTION trigger_atualizar_status_mut_delete();