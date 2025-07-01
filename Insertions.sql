-- =======================================
-- LIMPEZA OPCIONAL PARA TESTES REINICIADOS
-- =======================================
DELETE FROM inst_ser;
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
-- Protagonistas
(1, 'P'), (2, 'P'), (3, 'P'), (4, 'P'), (5, 'P'), (6, 'P'),

-- Inimigos Não Inteligentes Fáceis
(101, 'N'), (102, 'N'), (103, 'N'), (104, 'N'), (105, 'N'), (106, 'N'),

-- Inimigos Não Inteligentes Médios
(201, 'N'), (202, 'N'), (203, 'N'),

-- Inimigos Não Inteligentes Difíceis
(301, 'N'), (302, 'N'), (303, 'N'),

-- Bosses Não Inteligentes
(997, 'N'), (998, 'N'),

-- Inimigos Inteligentes Fáceis
(107, 'I'), (108, 'I'),

-- Inimigos Inteligentes Médios
(204, 'I'), (205, 'I'),

-- Inimigos Inteligentes Difíceis
(304, 'I'), (305, 'I'),

-- Nigrum Sanguinem (hierarquia)
(401, 'I'), (402, 'I'), (403, 'I'), (404, 'I'),

-- Boss Inteligente
(999, 'I');

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
('Nigrum Sanguinem'),
('Inimigo Hostil'),
('Neutros');

-- =======================================
-- 9. INIMIGOS NÃO INTELIGENTES
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
(105, 'Pombo Radioativo',    22,  3, 11, 1,  0, 0, 0, 2, 0, 0,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, 2),
(106, 'Perereca Mutante',    20,  4, 13, 0,  0, 0, 1, 0, 0, 0,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  0),



-- Inimigos Médios
(201, 'Cachorro Mutante',    75, 12, 12, 3,  5, 0, 0, 0, 2, 0,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  5),
(202, 'Robô de Segurança',  110, 15,  6, 6, 10, 5,15, 5, 5,10,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  0),
(203, 'Jacaré Mutante',        90, 16,  6, 4,  3, 0, 0, 0, 3, 3,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  7),


-- Inimigos Difíceis
(301, 'Brutamontes Mutante',180, 20,  6,10, 10, 5, 0, 0, 8, 6,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  20),
(302, 'Ecohorror',          140, 18, 16, 4,  0,10, 0,10, 5, 4,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE, 15),
(303, 'Urubu de Aço',         130, 14, 18, 3,  0, 3, 0, 7, 3, 2,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, 10),


-- BOSSES Não Inteligente
(998, 'Hidra de Carne', 320, 28, 12, 9, 5, 5, 5, 15, 9, 7, TRUE, TRUE, TRUE, TRUE, TRUE, 25),
(997, 'Omni-mente', 280, 22, 20, 6, 3, 6, 10, 18, 6, 5, TRUE, TRUE, FALSE, TRUE, FALSE, 30);




-- =======================================
-- 10. INIMIGOS INTELIGENTES
-- =======================================

INSERT INTO inteligente (
    id_ser, nome, hp_base, str_base, dex_base, def_base,
    res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont,
    cabeca, torso, maos, pernas, pes, alinhamento
) VALUES 

-- Inimigos Inteligentes Fáceis
(107, 'Catador',        55,  7, 10, 1,  0, 0, 0, 0, 1, 0,  TRUE, TRUE, TRUE, TRUE, TRUE, 4),
(108, 'Fanático Desconhecido',   50,  6,  8, 2,  0, 1, 0, 1, 0, 1,  TRUE, TRUE, TRUE, TRUE, TRUE, 2),

-- Inimigos Médios
(204, 'Sobrevivente Hostil',  90, 11, 10, 2,  0, 0, 0, 0, 1, 1,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3),
(205, 'Canibal',              85, 13,  9, 4,  0, 0, 0, 0, 3, 2,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3),

-- Inimigos Difíceis
(304, 'Pessoa Mutante',      130, 16, 12, 6,  5, 5, 5, 0, 5, 5,  TRUE, TRUE,  TRUE, TRUE,  TRUE, 3),
(305, 'Ex-Militar Enlouquecido',160, 18, 11, 6,  2, 0, 0, 0, 4, 4, TRUE, TRUE, TRUE, TRUE, TRUE, 3),


-- Nigrum Sanguinem: Hierarquia com nomes próprios

(401, 'Discípulo da Luz Verde',      60,  9,  9, 1,  0, 1, 1, 2, 1, 0, TRUE, TRUE, TRUE, TRUE, TRUE, 2),
(402, 'Portador da Chama',   75, 12, 10, 2,  0, 2, 2, 4, 2, 1, TRUE, TRUE, TRUE, TRUE, TRUE, 2),
(403, 'Sacerdote da Mutação',       95, 14, 11, 3,  1, 3, 2, 6, 2, 2, TRUE, TRUE, TRUE, TRUE, TRUE, 2),
(404, 'Profeta Isótopo',           140, 17, 12, 4,  2, 5, 3, 8, 4, 3, TRUE, TRUE, TRUE, TRUE, TRUE, 2),


-- BOSSES Inteligentes
(999, 'Avatar do Núcleo', 300, 25, 15, 10, 8, 10, 10, 20, 10, 8, TRUE, TRUE, TRUE, TRUE, TRUE, 2);

-- =======================================
-- 11. ENCONTROS COM INIMIGOS 
-- =======================================

SELECT criar_encontro(103, 1, 2, NULL::INT, '1', '50');