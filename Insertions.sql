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
INSERT INTO ser_controle (id_ser, tipo) VALUES 
(1, 'P'), (2, 'P'), (3, 'P'), (4, 'P'), (5, 'P'), (6, 'P'),  -- Protagonistas
(101, 'N'), (102, 'N'), (103, 'N'), (104, 'N'),              -- Inimigos Fáceis
(201, 'N'), (202, 'I'), (203, 'I'), (204, 'N'),              -- Inimigos Médios
(301, 'I'), (302, 'N'), (303, 'N');                          -- Inimigos Difíceis

-- Tipos:
-- 'P' = Protagonista
-- 'N' = Não Inteligente
-- 'I' = Inteligente

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
(1,3,5),
(1,4,5),
(1,2,7),
(2,16,9),
(3, 6, 8),
(4,13,7),
(5,10,7),
(5,11,8),
(5,12,7),
(6, 7, 4),
(11,19,10),
(13,17,9),
(13,14,20),
(14,15,30),
(16,8,20),
(16,9,30);

-- =======================================
-- 8. FACÇÕES
-- =======================================
INSERT INTO faccao (
    nome_faccao
) 
VALUES
('Pisa Poeira'),
('Nigrum Sanguinem')
('Inimigo Hostil');

-- =======================================
-- 8. INIMIGOS NÃO INTELIGENTES
-- =======================================
INSERT INTO nao_inteligente (
    id_ser, nome, hp_base, str_base, dex_base, def_base,
    res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont,
    cabeca, torso, maos, pernas, pes, rad_dano
) VALUES 
-- Inimigos Fáceis
(101, 'Barata Mutante',      20,  4,  8, 0,  0, 0, 0, 0, 0, 0,  FALSE, TRUE,  FALSE, TRUE,  TRUE,  0),
(102, 'Cachorro Faminto',    40,  7, 10, 1,  0, 0, 0, 0, 0, 0,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  0),
(103, 'Rato Carniceiro',     25,  6,  9, 0,  0, 0, 0, 0, 0, 0,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  0),
(104, 'Corvo Mutante',       30,  5, 12, 1,  0, 0, 0, 0, 0, 0,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, 0),

-- Inimigos Médios
(201, 'Cachorro Mutante',    75, 12, 12, 3,  5, 0, 0, 0, 2, 0,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  0),
(204, 'Robô de Segurança',  110, 15,  6, 6, 10, 5,15, 5, 5,10,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  0),

-- Inimigos Difíceis
(302, 'Brutamontes Mutante',180, 20,  6,10, 10, 5, 0, 0, 8, 6,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  0),
(303, 'Ecohorror',          140, 18, 16, 4,  0,10, 0,10, 5, 4,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE, 15);


-- =======================================
-- 9. INIMIGOS INTELIGENTES
-- =======================================

INSERT INTO inteligente (
    id_ser, nome, hp_base, str_base, dex_base, def_base,
    res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont,
    cabeca, torso, maos, pernas, pes, alinhamento
) VALUES 
-- Inimigos Médios
(202, 'Sobrevivente Hostil',  90, 11, 10, 2,  0, 0, 0, 0, 1, 1,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3),
(203, 'Canibal',              85, 13,  9, 4,  0, 0, 0, 0, 3, 2,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3),

-- Inimigos Difíceis
(301, 'Pessoa Mutante',      130, 16, 12, 6,  5, 5, 5, 0, 5, 5,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3);
