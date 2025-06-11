-- =======================================
-- LIMPEZA OPCIONAL PARA TESTES REINICIADOS
-- =======================================
DELETE FROM base;
DELETE FROM instalacao_base;
DELETE FROM coletavel;
DELETE FROM item_controle;
DELETE FROM prota;
DELETE FROM ser_controle;
DELETE FROM ponto_de_interesse;

-- =======================================
-- REINICIAR SEQUÊNCIAS (SEQUENCES)
-- Descubra os nomes com:
-- SELECT pg_get_serial_sequence('nome_tabela', 'nome_coluna');
-- =======================================
ALTER SEQUENCE ponto_de_interesse_id_pi_seq RESTART WITH 1;
ALTER SEQUENCE item_controle_id_item_seq RESTART WITH 1;
ALTER SEQUENCE ser_controle_id_ser_seq RESTART WITH 1;
ALTER SEQUENCE instalacao_base_id_instalacao_seq RESTART WITH 1;

-- =======================================
-- 1. PONTOS DE INTERESSE
-- =======================================
INSERT INTO ponto_de_interesse (nome,  nivel_rad) VALUES
('Base', 0),
('Travessia da Poeira', 1),
('Posto de Vigia Abandonado', 1),
('Cidade Fantasma', 2),
('Terra Chamuscada', 1),
('Subúrbio dos Esquecidos', 2),
('Nigrum Sanguinem', 30),
('Base dos Pisa Poeira', 0),
('Escola Amanhecer Dourado', 1),
('Cemitério das Máquinas', 3),
('Colinas Negras', 3),
('Mercabunker', 0),
('Poço de água', 0),
('Hospital Subterrâneo', 4),
('Aeroporto Militar', 5),
('Pátio do Ferro-Velho', 1),
('Lugar Algum', 0),
('Mêtro do Surfista', 0),
('Estação de Tratamento de Água', 2);

-- =======================================
-- 2. ITENS COLETÁVEIS
-- =======================================
INSERT INTO item_controle (tipo) VALUES
('C'), ('C'), ('C');  -- C = Coletável

INSERT INTO coletavel (id_item, nome) VALUES
(1, 'Madeira'),
(2, 'Ferro'),
(3, 'Núcleo Radioativo Fundido');

-- =======================================
-- 3. INSTALAÇÕES DE BASE
-- (requer itens já existentes)
-- =======================================
INSERT INTO instalacao_base (nome, nivel, id_item, qtd) VALUES
('Acampamento Improvisado', 0, NULL, NULL),
('Refúgio de Madeira', 1, 1, 5),
('Fortificação de Madeira', 2, 1, 15),
('Depósito de Ferro Reforçado', 3, 2, 5),
('Complexo Técnico Avançado', 4, 2, 15),
('Santuário do Núcleo', 5, 3, 3);

-- =======================================
-- 4. BASE
-- Base inicial no ponto de interesse id 1, com instalação id 1
-- =======================================
INSERT INTO base (id_pi, nome, id_instalacao) VALUES 
(1, 'Base Central', 1);

-- =======================================
-- 5. SERES DE CONTROLE
-- =======================================
INSERT INTO ser_controle (tipo) VALUES 
('P'), ('P'), ('P'), ('P'), ('P'), ('P');  -- P = Protagonista

-- =======================================
-- 6. DADOS DOS PROTAGONISTAS
-- =======================================
INSERT INTO prota (
    id_ser, nome, hp_base, str_base, dex_base, def_base,
    res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont,
    fome_base, sede_base, carga_base
) VALUES 
(1, 'Julio Lobo-Guará', 100, 12, 13, 0,  0, 0, 0, 0, 0, 0,  100, 100, 130),
(2, 'Mamba Negra',      100, 8, 17, 0,   0, 0, 0, 0, 0, 0,  120, 120, 90),
(3, 'Você',             60,  5, 5,  0,   0, 0, 0, 0, 0, 0,  40,  40,  30),
(4, 'All, the Baran',   100, 15, 0, 10,  0, 0, 0, 0, 0, 0,  100, 100, 200),
(5, 'Dr. Brasília',     100, 22, 22, -1, 22, 22, 22, 22, 22, 22,  220, 220, 220),
(6, 'Alyx',             100, 13, 10, 2,  0, 0, 0, 0, 0, 0,  80, 75, 120);

-- =======================================
-- 7. Conexões entre PIs
-- =======================================
INSERT INTO conexao(
    origem,destino,custo
) VALUES
(1,5,5),
(5,10,7),
(5,11,8),
(5,12,7),
(11,19,10),
(1,4,5),
(4,13,7),
(13,17,9),
(13,14,20),
(14,15,30),
(1,2,7),
(2,16,9),
(16,8,20),
(16,9,30);

