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
('Base', 0),                             -- ID: 1
('Travessia da Poeira', 1),              -- ID: 2
('Posto de Vigia Abandonado', 1),        -- ID: 3
('Cidade Fantasma', 2),                  -- ID: 4
('Terra Chamuscada', 1),                 -- ID: 5
('Subúrbio dos Esquecidos', 2),          -- ID: 6
('Base dos Pisa Poeira', 0),             -- ID: 7
('Escola Amanhecer Dourado', 1),         -- ID: 8
('Cemitério das Máquinas', 3),           -- ID: 9
('Colinas Negras', 3),                   -- ID: 10
('Mercabunker', 0),                      -- ID: 11
('Poço de água', 0),                     -- ID: 12
('Hospital Subterrâneo', 4),             -- ID: 13
('Aeroporto Militar', 5),                -- ID: 14
('Pátio do Ferro-Velho', 1),             -- ID: 15
('Lugar Algum', 0),                      -- ID: 16
('Mêtro do Surfista', 0),                -- ID: 17
('Estação de Tratamento de Água', 2),    -- ID: 18

-- Rota dos Nigrum Sanguinem
('Portão Esquecido', 10),                -- ID: 19
('Vales da Praga', 10),                  -- ID: 20
('Santuário da Desfiguração', 20),       -- ID: 21
('Coração de Sanguinem', 30),            -- ID: 22

-- Rota da Hidra de Carne
('Brejo Mórbido', 5),                    -- ID: 23
('Trilho Encharcado', 15),               -- ID: 24
('Covil da Hidra de Carne', 30),         -- ID: 25

-- ROTA da Omni-Mente

('Túnel de Rastro Químico', 10),         -- ID: 26
('Ninho de Operárias', 15),              -- ID: 27
('Centro de Comando Feromon', 20),       -- ID: 28
('Trono da Omni-Mente', 35);             -- ID: 29

-- =======================================
-- 1A. FACCOES (necessário para alinhamento de inteligentes)
-- =======================================
INSERT INTO faccao (id_faccao, nome_faccao) VALUES
(1, 'Neutro'),
(2, 'Nigrum Sanguinem'),
(3, 'Hostil'),
(4, 'Catadores');

-- =======================================
-- 2. ITENS COLETÁVEIS, EQUIPAMENTOS, MUTAÇÕES E UTILIZÁVEIS (usando procedures)
-- =======================================
-- Coletáveis (inclui moeda id 1)
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Moeda' AS CHAR(50)), 0);         -- id 1
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Madeira' AS CHAR(50)), 5);       -- id 2
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Ferro' AS CHAR(50)), 10);        -- id 3
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Núcleo Radioativo Fundido' AS CHAR(50)), 50); -- id 4
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Pele de Lagarto' AS CHAR(50)), 8);  -- id 5
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Pedras' AS CHAR(50)), 12); -- id 6
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Plástico' AS CHAR(50)), 4);      -- id 7
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Tecido' AS CHAR(50)), 6);        -- id 8
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Sucata Eletrônica' AS CHAR(50)), 15); -- id 9

-- Equipamentos (id 10+)
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Capacete de Metal' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('cabe' AS CHAR(4)), 30);   -- id 10
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Colete de Couro' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('tors' AS CHAR(4)), 35);     -- id 11
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Luvas de Proteção' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('maos' AS CHAR(4)), 18);   -- id 12
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Botas de Borracha' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('pes' AS CHAR(4)), 20);    -- id 13
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Calças Reforçadas' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('pern' AS CHAR(4)), 25);   -- id 14
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Espada Laser' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('maos' AS CHAR(4)), 800);        -- id 15

-- Mutações (id 15+)
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Visão Noturna' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('cabe' AS CHAR(4)));      -- id 16
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Braço Extra' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('maos' AS CHAR(4)));        -- id 17
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Pele Resistente' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('tors' AS CHAR(4)));    -- id 18
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Pernas Saltadoras' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('pern' AS CHAR(4)));  -- id 19
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Garras Afiadas' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('maos' AS CHAR(4)));

-- Utilizáveis
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Curativo' AS CHAR(50)), CAST(25 AS SMALLINT), CAST('hp' AS CHAR(10)), CAST(25 AS SMALLINT));
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Kit de Primeiros Socorros' AS CHAR(50)), CAST(50 AS SMALLINT), CAST('hp' AS CHAR(10)), CAST(60 AS SMALLINT));
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Carne Seca' AS CHAR(50)), CAST(20 AS SMALLINT), CAST('fome' AS CHAR(10)), CAST(20 AS SMALLINT));
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Frutas em Conserva' AS CHAR(50)), CAST(35 AS SMALLINT), CAST('fome' AS CHAR(10)), CAST(40 AS SMALLINT));
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Água Potável' AS CHAR(50)), CAST(15 AS SMALLINT), CAST('sede' AS CHAR(10)), CAST(20 AS SMALLINT));
SELECT inserir_utilizavel(CAST('U' AS CHAR(1)), CAST('Água Purificada' AS CHAR(50)), CAST(30 AS SMALLINT), CAST('sede' AS CHAR(10)), CAST(45 AS SMALLINT));

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

-- Hidra de Carne (Lagartos Mutados)
(501, 'N'), (502, 'N'), (503, 'N'),

-- Omni-Mente (Formigas Mutadas)
(601, 'N'), (602, 'N'), (603, 'N'),

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
(1,5,5),         -- Base → Terra Chamuscada
(1,3,5),         -- Base → Posto de Vigia Abandonado
(1,4,5),         -- Base → Cidade Fantasma
(1,2,7),         -- Base → Travessia da Poeira
(2,15,9),        -- Travessia da Poeira → Pátio do Ferro-Velho 
(3,6,8),         -- Posto de Vigia Abandonado → Subúrbio dos Esquecidos
(4,12,7),        -- Cidade Fantasma → Poço de água 
(5,9,7),        -- Terra Chamuscada → Cemitério das Máquinas
(5,10,8),        -- Terra Chamuscada → Colinas Negras
(5,11,7),        -- Terra Chamuscada → Mercabunker
(10,18,10),      -- Colinas Negras → Estação de Tratamento de Água
(12,16,9),       -- Poço de água → Lugar Algum
(12,13,20),      -- Poço de água → Hospital Subterrâneo
(13,14,30),      -- Hospital Subterrâneo → Aeroporto Militar
(15,7,20),       -- Pátio do Ferro-Velho → Base dos Pisa Poeira
(15,8,30),       -- Pátio do Ferro-Velho → Escola Amanhecer Dourado
(18,17,8),         -- Estação de Tratamento de Água → Mêtro do Surfista
(17,9,10),        -- Mêtro do Surfista → Cemitério das Máquinas

-- Rota dos Nigrum Sanguinem
(3, 19, 10),         -- Posto de Vigia Abandonado → Portão Esquecido
(19, 20, 12),         -- Portão Esquecido → Vales da Praga
(20, 21, 15),        -- Vales da Praga → Santuário da Desfiguração
(21, 22, 20),        -- Santuário da Desfiguração → Coração de Sanguinem

-- Rota da Hidra de Carne
(12, 23, 15),         -- Poço de Água → Brejo Mórbido
(13, 23, 12),         -- Hospital Subterrâneo → Brejo Mórbido
(23, 24, 20),        -- Brejo Mórbido → Trilho Encharcado
(24, 25, 20),        -- Trilho Encharcado → Covil da Hidra de Carne

-- Rota da Omni-Mente
(10, 26, 10),         -- Colinas Negras → Túnel de Rastro Químico
(26, 27, 10),         -- Túnel de Rastro Químico → Ninho de Operárias
(27, 28, 15),        -- Ninho de Operárias → Centro de Comando Feromon
(28, 29, 20),        -- Centro de Comando Feromon → Trono da Omni-Mente
(26, 28, 15);         -- Túnel de Rastro Químico → Centro de Comando Feromon 

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
(106, 'Cururu Mutante',    20,  4, 13, 0,  0, 0, 1, 0, 0, 0,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  0),



-- Inimigos Médios
(201, 'Cachorro Mutante',    75, 12, 12, 3,  5, 0, 0, 0, 2, 0,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  5),
(202, 'Robô de Segurança',  110, 15,  6, 6, 10, 5,15, 5, 5,10,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  0),
(203, 'Jacaré Mutante',        90, 16,  6, 4,  3, 0, 0, 0, 3, 3,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  7),


-- Inimigos Difíceis
(301, 'Brutamontes Mutante',180, 20,  6,10, 10, 5, 0, 0, 8, 6,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  20),
(302, 'Ecohorror',          140, 18, 16, 4,  0,10, 0,10, 5, 4,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE, 15),
(303, 'Urubu de Aço',         130, 14, 18, 3,  0, 3, 0, 7, 3, 2,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, 10),

-- Hidra de Carne (Lagartos Mutados)
(501, 'Lagarto Mutante',      60, 12, 10, 2,  2, 0, 0, 2, 2, 1,  TRUE, TRUE, TRUE, TRUE, TRUE, 5),
(502, 'Lagarto Putrefato',    90, 16, 12, 4,  3, 0, 0, 4, 3, 2,  TRUE, TRUE, TRUE, TRUE, TRUE, 10),
(503, 'Lagarto Espinhoso',    75, 14, 11, 3,  2, 0, 0, 3, 4, 2,  TRUE, TRUE, TRUE, TRUE, TRUE, 8),

-- Omni-Mente (Formigas Mutadas)
(601, 'Formiga Operária',     25,  6, 14, 0,  0, 0, 0, 2, 1, 0,  TRUE, TRUE, TRUE, TRUE, TRUE, 3),
(602, 'Formiga Soldado',      55, 12, 12, 2,  1, 0, 0, 4, 2, 1,  TRUE, TRUE, TRUE, TRUE, TRUE, 7),
(603, 'Formiga Anciã',     90, 15, 10, 4,  2, 0, 0, 6, 3, 2,  TRUE, TRUE, TRUE, TRUE, TRUE, 12),


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
-- ENCONTROS INICIAIS FÁCEIS (PI 2, 3, 4, 5)

-- ENCONTROS INICIAIS FÁCEIS (PI 2, 3, 4, 5)

-- PI 2: Travessia da Poeira
SELECT criar_encontro(101, 2, 2, NULL::INT, '1', '30');  -- 2 Baratas Mutantes
SELECT criar_encontro(107, 1, 2, NULL::INT, '1', '60');  -- 1 Catador

-- PI 3: Posto de Vigia Abandonado
SELECT criar_encontro(103, 2, 3, NULL::INT, '1', '35');  -- 2 Ratos Carniceiros

-- PI 4: Cidade Fantasma
SELECT criar_encontro(105, 3, 4, NULL::INT, '1', '25');  -- 3 Pombos Radioativos
SELECT criar_encontro(107, 1, 4, NULL::INT, '1', '60');  -- 1 Catador

-- PI 5: Terra Chamuscada
SELECT criar_encontro(106, 2, 5, NULL::INT, '1', '30');  -- 2 Cururus Mutantes

-- PI 6: Subúrbio dos Esquecidos
SELECT criar_encontro(103, 2, 6, NULL::INT, '1', '30'); -- 2 Ratos Carniceiros
SELECT criar_encontro(107, 1, 6, NULL::INT, '1', '25'); -- 1 Catador
SELECT criar_encontro(102, 1, 6, NULL::INT, '1', '15'); -- 1 Cachorro Faminto

-- PI 7: Base dos Pisa Poeira
SELECT criar_encontro(107, 1, 7, NULL::INT, '1', '20'); -- 1 Catador

-- PI 8: Escola Amanhecer Dourado
SELECT criar_encontro(103, 2, 8, NULL::INT, '1', '25'); -- 2 Ratos Carniceiros
SELECT criar_encontro(107, 1, 8, NULL::INT, '1', '20'); -- 1 Catador

-- PI 9: Cemitério das Máquinas
SELECT criar_encontro(202, 1, 9, NULL::INT, '2', '20'); -- 1 Robô de Segurança
SELECT criar_encontro(303, 1, 9, NULL::INT, '3', '10'); -- 1 Urubu de Aço
SELECT criar_encontro(107, 1, 9, NULL::INT, '1', '10'); -- 1 Catador

-- PI 10: Colinas Negras
SELECT criar_encontro(104, 2, 10, NULL::INT, '1', '25'); -- 2 Corvos Mutantes
SELECT criar_encontro(105, 2, 10, NULL::INT, '2', '15'); -- 2 Pombos Radioativos
SELECT criar_encontro(301, 1, 10, NULL::INT, '3', '10'); -- 1 Brutamontes Mutante

-- PI 11: Mercabunker
SELECT criar_encontro(107, 1, 11, NULL::INT, '1', '20'); -- 1 Catador

-- PI 12: Poço de água
SELECT criar_encontro(106, 2, 12, NULL::INT, '1', '25'); -- 2 Cururus Mutantes
SELECT criar_encontro(103, 2, 12, NULL::INT, '1', '15'); -- 2 Ratos Carniceiros

-- PI 13: Hospital Subterrâneo
SELECT criar_encontro(301, 1, 13, NULL::INT, '3', '20'); -- 1 Brutamontes Mutante
SELECT criar_encontro(302, 1, 13, NULL::INT, '4', '10'); -- 1 Ecohorror
SELECT criar_encontro(304, 1, 13, NULL::INT, '4', '10'); -- 1 Pessoa Mutante

-- PI 14: Aeroporto Militar
SELECT criar_encontro(302, 1, 14, NULL::INT, '3', '20'); -- 1 Ecohorror
SELECT criar_encontro(305, 1, 14, NULL::INT, '4', '10'); -- 1 Ex-Militar Enlouquecido
SELECT criar_encontro(304, 1, 14, NULL::INT, '4', '10'); -- 1 Pessoa Mutante

-- PI 15: Pátio do Ferro-Velho
SELECT criar_encontro(202, 1, 15, NULL::INT, '2', '20'); -- 1 Robô de Segurança
SELECT criar_encontro(303, 1, 15, NULL::INT, '3', '10'); -- 1 Urubu de Aço
SELECT criar_encontro(107, 1, 15, NULL::INT, '1', '10'); -- 1 Catador

-- PI 16: Lugar Algum
SELECT criar_encontro(103, 1, 16, NULL::INT, '1', '10'); -- 1 Rato Carniceiro

-- PI 17: Mêtro do Surfista
SELECT criar_encontro(103, 2, 17, NULL::INT, '1', '20'); -- 2 Ratos Carniceiros
SELECT criar_encontro(105, 2, 17, NULL::INT, '1', '10'); -- 2 Pombos Radioativos

-- PI 18: Estação de Tratamento de Água
SELECT criar_encontro(106, 2, 18, NULL::INT, '1', '20'); -- 2 Cururus Mutantes
SELECT criar_encontro(203, 1, 18, NULL::INT, '2', '10'); -- 1 Jacaré Mutante

-- =======================================
-- ENCONTROS TEMÁTICOS COM LAGARTOS MUTADOS DA HIDRA DE CARNE
-- =======================================

-- PI 23: Brejo Mórbido (encontros fáceis)
SELECT criar_encontro(501, 1, 23, NULL::INT, '1', '30'); -- 1 Lagarto Mutante
SELECT criar_encontro(501, 2, 23, NULL::INT, '1', '25'); -- 2 Lagartos Mutantes
SELECT criar_encontro(502, 1, 23, NULL::INT, '2', '10'); -- 1 Lagarto Putrefato
SELECT criar_encontro(501, 2, 23, NULL::INT, '2', '10'); -- 2 Lagartos Mutantes
SELECT criar_encontro(501, 1, 23, NULL::INT, '2', '10'); -- 1 Lagarto Mutante

-- PI 24: Trilho Encharcado (encontros intermediários)
SELECT criar_encontro(501, 2, 24, NULL::INT, '2', '25'); -- 2 Lagartos Mutantes
SELECT criar_encontro(502, 1, 24, NULL::INT, '2', '25'); -- 1 Lagarto Putrefato
SELECT criar_encontro(503, 1, 24, NULL::INT, '3', '20'); -- 1 Lagarto Espinhoso
SELECT criar_encontro(502, 2, 24, NULL::INT, '3', '15'); -- 2 Lagartos Putrefatos
SELECT criar_encontro(503, 2, 24, NULL::INT, '3', '10'); -- 2 Lagartos Espinhosos
SELECT criar_encontro(502, 1, 24, NULL::INT, '3', '10'); -- 1 Lagarto Putrefato
SELECT criar_encontro(503, 1, 24, NULL::INT, '3', '10'); -- 1 Lagarto Espinhoso

-- Encontro com a Hidra de Carne

-- PI 25: Covil da Hidra de Carne (boss)
SELECT criar_encontro(998, 1, 25, NULL::INT, '5', '100'); -- 1 Hidra de Carne (boss)

-- =======================================
-- ENCONTROS TEMÁTICOS COM FORMIGAS MUTADAS DA OMNI-MENTE
-- =======================================

-- PI 26: Túnel de Rastro Químico (encontros fáceis)
SELECT criar_encontro(601, 2, 26, NULL::INT, '1', '30'); -- 2 Formigas Operárias
SELECT criar_encontro(601, 3, 26, NULL::INT, '1', '20'); -- 3 Formigas Operárias
SELECT criar_encontro(601, 1, 26, NULL::INT, '2', '15'); -- 1 Formiga Operária

-- PI 27: Ninho de Operárias (encontros intermediários)
SELECT criar_encontro(601, 2, 27, NULL::INT, '2', '25'); -- 2 Formigas Operárias
SELECT criar_encontro(602, 1, 27, NULL::INT, '2', '25'); -- 1 Formiga Soldado
SELECT criar_encontro(601, 1, 27, NULL::INT, '2', '20'); -- 1 Formiga Operária
SELECT criar_encontro(602, 2, 27, NULL::INT, '3', '15'); -- 2 Formigas Soldado
SELECT criar_encontro(601, 1, 27, NULL::INT, '3', '10'); -- 1 Formiga Operária
SELECT criar_encontro(602, 1, 27, NULL::INT, '3', '10'); -- 1 Formiga Soldado

-- PI 28: Centro de Comando Feromon (encontros difíceis)
SELECT criar_encontro(602, 2, 28, NULL::INT, '3', '20'); -- 2 Formigas Soldado
SELECT criar_encontro(603, 1, 28, NULL::INT, '3', '20'); -- 1 Formiga Anciã
SELECT criar_encontro(602, 1, 28, NULL::INT, '4', '15'); -- 1 Formiga Soldado
SELECT criar_encontro(603, 2, 28, NULL::INT, '4', '10'); -- 2 Formigas Anciã
SELECT criar_encontro(602, 1, 28, NULL::INT, '4', '10'); -- 1 Formiga Soldado
SELECT criar_encontro(603, 1, 28, NULL::INT, '4', '10'); -- 1 Formiga Anciã

-- PI 29: Trono da Omni-Mente (boss)
SELECT criar_encontro(997, 1, 29, NULL::INT, '5', '100'); -- 1 Omni-Mente (boss)

-- =======================================
-- ENCONTROS TEMÁTICOS COM O CULTO
-- =======================================

-- PI 19: Portão Esquecido (encontros fáceis)
SELECT criar_encontro(401, 1, 19, NULL::INT, '1', '30'); -- 1 Discípulo da Luz Verde
SELECT criar_encontro(401, 2, 19, NULL::INT, '1', '25'); -- 2 Discípulos da Luz Verde
SELECT criar_encontro(402, 1, 19, NULL::INT, '2', '15'); -- 1 Portador da Chama
SELECT criar_encontro(401, 2, 19, NULL::INT, '2', '10'); -- 2 Discípulos da Luz Verde
SELECT criar_encontro(402, 1, 19, NULL::INT, '2', '10'); -- 1 Portador da Chama

-- PI 20: Vales da Praga (encontros intermediários)
SELECT criar_encontro(402, 2, 20, NULL::INT, '2', '25'); -- 2 Portadores da Chama
SELECT criar_encontro(403, 1, 20, NULL::INT, '2', '25'); -- 1 Sacerdote da Mutação
SELECT criar_encontro(402, 1, 20, NULL::INT, '3', '20'); -- 1 Portador da Chama
SELECT criar_encontro(403, 1, 20, NULL::INT, '3', '15'); -- 1 Sacerdote da Mutação
SELECT criar_encontro(402, 2, 20, NULL::INT, '3', '10'); -- 2 Portadores da Chama
SELECT criar_encontro(403, 1, 20, NULL::INT, '3', '10'); -- 1 Sacerdote da Mutação

-- PI 21: Santuário da Desfiguração (encontros difíceis)
SELECT criar_encontro(403, 2, 21, NULL::INT, '3', '25'); -- 2 Sacerdotes da Mutação
SELECT criar_encontro(404, 1, 21, NULL::INT, '3', '25'); -- 1 Profeta Isótopo
SELECT criar_encontro(403, 1, 21, NULL::INT, '4', '20'); -- 1 Sacerdote da Mutação
SELECT criar_encontro(404, 1, 21, NULL::INT, '4', '15'); -- 1 Profeta Isótopo
SELECT criar_encontro(403, 2, 21, NULL::INT, '4', '10'); -- 2 Sacerdotes da Mutação
SELECT criar_encontro(404, 1, 21, NULL::INT, '4', '10'); -- 1 Profeta Isótopo

-- PI 22: Coração de Sanguinem (boss)
SELECT criar_encontro(999, 1, 22, NULL::INT, '5', '100'); -- 1 Avatar do Núcleo (boss)

-- =======================================
-- 12. ACONTECIMENTOS DE MUNDO
-- =======================================

SELECT criar_acontecimento_mundo(NULL, 10, 'Você encontrou uma fogueira com comida, ele pegou um pouco... e recuperou 10 de fome!', 3, NULL::INT, '1', '25');  -- PI 3: Fogueira (recupera fome)
SELECT criar_acontecimento_mundo(NULL, 10, 'Você encontrou uma fogueira com comida, recuperou 10 de fome!', 3, NULL::INT, '1', '25');
SELECT criar_acontecimento_mundo(NULL, 8, 'Achou uma garrafa d''água esquecida, recuperou 8 de sede!', 3, NULL::INT, '1', '20');
SELECT criar_acontecimento_mundo(NULL, 12, 'Você tropeçou em destroços e se feriu, perdeu 12 de vida.', 2, NULL::INT, '1', '15');
SELECT criar_acontecimento_mundo(NULL, 5, 'Passou por uma área contaminada, ganhou 5 de radiação.', 2, NULL::INT, '1', '10');
SELECT criar_acontecimento_mundo(NULL, -7, 'Ratos roubaram parte da sua comida, perdeu 7 de fome.', 2, NULL::INT, '1', '10');
SELECT criar_acontecimento_mundo(NULL, -6, 'Derramou sua água, perdeu 6 de sede.', 2, NULL::INT, '1', '10');
SELECT criar_acontecimento_mundo(NULL, 15, 'Descansou em um abrigo seguro, recuperou 15 de vida.', 2, NULL::INT, '1', '10');
SELECT criar_acontecimento_mundo(NULL, -4, 'Encontrou um antídoto, perdeu 4 de radiação.', 2, NULL::INT, '1', '10');
SELECT criar_acontecimento_mundo(NULL, 20, 'Banquete improvisado! Recuperou 20 de fome.', 1, NULL::INT, '1', '5');
SELECT criar_acontecimento_mundo(NULL, 10, 'Chuva inesperada, recuperou 10 de sede.', 1, NULL::INT, '1', '5');
SELECT criar_acontecimento_mundo(NULL, 7, 'Você encontrou frutas silvestres e recuperou 7 de fome.', 2, NULL::INT, '2', '18');
SELECT criar_acontecimento_mundo(NULL, 5, 'Bebeu água de uma poça, recuperou 5 de sede, mas sente-se estranho.', 2, NULL::INT, '2', '15');
SELECT criar_acontecimento_mundo(NULL, -8, 'Sua comida estragou, perdeu 8 de fome.', 2, NULL::INT, '2', '10');
SELECT criar_acontecimento_mundo(NULL, 6, 'Descansou sob uma sombra, recuperou 6 de vida.', 2, NULL::INT, '2', '12');
SELECT criar_acontecimento_mundo(NULL, 3, 'Achou um cantil velho, recuperou 3 de sede.', 2, NULL::INT, '3', '10');
SELECT criar_acontecimento_mundo(NULL, 4, 'Encontrou cogumelos comestíveis, recuperou 4 de fome.', 2, NULL::INT, '3', '10');
SELECT criar_acontecimento_mundo(NULL, -5, 'Foi atacado por insetos, perdeu 5 de vida.', 2, NULL::INT, '3', '8');
SELECT criar_acontecimento_mundo(NULL, 2, 'Choveu, recuperou 2 de sede.', 2, NULL::INT, '1', '7');
SELECT criar_acontecimento_mundo(NULL, 8, 'Encontrou um abrigo improvisado, recuperou 8 de vida.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -3, 'Perdeu parte da água ao atravessar destroços, perdeu 3 de sede.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 6, 'Achou um pacote de biscoitos, recuperou 6 de fome.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 5, 'Bebeu água de chuva, recuperou 5 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -4, 'Foi picado por um animal, perdeu 4 de vida.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 3, 'Encontrou um pouco de comida enlatada, recuperou 3 de fome.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 2, 'Achou um pouco de água, recuperou 2 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -2, 'Teve um pesadelo, perdeu 2 de vida.', 2, NULL::INT, '1', '7');
SELECT criar_acontecimento_mundo(NULL, 9, 'Descansou em um banco, recuperou 9 de vida.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -6, 'Foi surpreendido por um ladrão, perdeu 6 de fome.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 4, 'Achou um filtro de água, recuperou 4 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 7, 'Encontrou um esconderijo com comida, recuperou 7 de fome.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -5, 'Foi exposto à radiação, ganhou 5 de radiação.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 6, 'Achou um kit de primeiros socorros, recuperou 6 de vida.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 3, 'Encontrou uma fonte limpa, recuperou 3 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -4, 'Teve um mal-estar, perdeu 4 de vida.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 5, 'Achou um saco de arroz, recuperou 5 de fome.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 2, 'Bebeu água de um poço, recuperou 2 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -3, 'Foi atacado por um animal selvagem, perdeu 3 de vida.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 8, 'Encontrou um refúgio seguro, recuperou 8 de vida.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, -7, 'Foi roubado durante a noite, perdeu 7 de fome.', 2, NULL::INT, '1', '8');
SELECT criar_acontecimento_mundo(NULL, 4, 'Achou um galão de água, recuperou 4 de sede.', 2, NULL::INT, '1', '1');
SELECT criar_acontecimento_mundo(NULL, 10, 'Banquete inesperado! Recuperou 10 de fome.', 2, NULL::INT, '1', '1');
-- =======================================
-- 13. MODIFICADORES DE EQUIPAMENTOS E MUTAÇÕES
-- =======================================
-- Exemplo: (id_item, atributo, valor)
-- Equipamentos
INSERT INTO modificador (id_item, atributo, valor) VALUES
(10, 'def', 5),      -- Capacete de Metal: +5 defesa (nível 1)
(11, 'def', 8),      -- Colete de Couro: +8 defesa (nível 1)
(12, 'dex', 3),      -- Luvas de Proteção: +3 destreza (nível 1)
(13, 'def', 4),      -- Botas de Borracha: +4 defesa (nível 1)
(14, 'def', 10),   -- Calças Reforçadas: +10 carga (nível 1)
(15, 'str', 100);     -- Espada laser: +100 str (nível 1)

-- Modificadores adicionais para equipamentos de múltiplos níveis (exemplo: se algum equipamento tiver mais de 1 nível, adicionar aqui)
-- (No exemplo atual, todos os equipamentos estão como nível 1, então não há modificadores extras necessários)

-- Mutações
INSERT INTO modificador (id_item, atributo, valor) VALUES
(16, 'dex', 1),    -- Visão Noturna: +1 visão (nível 1)
(17, 'str', 2),      -- Braço Extra: +2 força (nível 1)
(18, 'def', 2),      -- Pele Resistente: +2 defesa (nível 1)
(19, 'dex', 2),      -- Pernas Saltadoras: +2 destreza (nível 1)
(20, 'str', 1);      -- Garras Afiadas: +1 força (nível 1)

-- Modificadores adicionais para mutações de múltiplos níveis
INSERT INTO modificador (id_item, atributo, valor) VALUES
(17, 'dex', 2),      -- Braço Extra: +2 destreza (nível 2)
(18, 'res_cort', 2), -- Pele Resistente: +2 resistência corte (nível 2)
(19, 'dex', 2);     -- Pernas Saltadoras: +2 pulo (nível 2)

-- Peso dos Equipamentos
INSERT INTO modificador (id_item, atributo, valor) VALUES
(10, 'peso', 5),   -- Capacete de Metal: 5kg
(11, 'peso', 8),   -- Colete de Couro: 8kg
(12, 'peso', 2),   -- Luvas de Proteção: 2kg
(13, 'peso', 3),   -- Botas de Borracha: 3kg
(14, 'peso', 4),   -- Calças Reforçadas: 4kg
(15, 'peso', 7);   -- Espada Laser: 7kg

-- Peso dos Coletáveis
INSERT INTO modificador (id_item, atributo, valor) VALUES
(1, 'peso', 0),    -- Moeda: 0kg
(2, 'peso', 1),    -- Madeira: 1kg
(3, 'peso', 2),    -- Ferro: 2kg
(4, 'peso', 3),    -- Núcleo Radioativo Fundido: 3kg
(5, 'peso', 1),    -- Pele de Lagarto: 1kg
(6, 'peso', 1),    -- Pedras: 1kg
(7, 'peso', 1),    -- Plástico: 1kg
(8, 'peso', 1),    -- Tecido: 1kg
(9, 'peso', 1);    -- Sucata Eletrônica: 1kg

-- Peso dos Utilizáveis
INSERT INTO modificador (id_item, atributo, valor) VALUES
(21, 'peso', 1),   -- Curativo: 1kg
(22, 'peso', 2),   -- Kit de Primeiros Socorros: 2kg
(23, 'peso', 1),   -- Carne Seca: 1kg
(24, 'peso', 1),   -- Frutas em Conserva: 1kg
(25, 'peso', 1),   -- Água Potável: 1kg
(26, 'peso', 1);   -- Água Purificada: 1kg

-- =======================================
-- 14. MISSÕES DE MATAR INIMIGOS POR MOEDAS
-- =======================================
-- Exemplo: matar 3 baratas mutantes (id 101) para ganhar 20 moedas
SELECT criar_missao_matar(101, 3, 1, '1', '100', '{"moeda":20}', NULL);
-- Matar 2 ratos carniceiros (id 103) para ganhar 15 moedas
SELECT criar_missao_matar(103, 2, 1, '1', '100', '{"moeda":15}', NULL);
-- Matar 1 cachorro faminto (id 102) para ganhar 10 moedas
SELECT criar_missao_matar(102, 1, 1, '1', '100', '{"moeda":10}', NULL);
-- Matar 2 catadores (id 107) para ganhar 25 moedas
SELECT criar_missao_matar(107, 2, 1, '1', '100', '{"moeda":25}', NULL);
-- Matar 1 robô de segurança (id 202) para ganhar 30 moedas
SELECT criar_missao_matar(202, 1, 1, '1', '100', '{"moeda":30}', NULL);

-- Barata Mutante
SELECT criar_missao_matar(101, 3, 1, '1', '100', '{"moeda":20}', NULL); -- id_evento = A
SELECT criar_missao_matar(101, 15, 1, '1', '100', '{"moeda":100}', NULL); -- id_evento = B
-- UPDATE missao SET prox = B WHERE id_evento = A;
-- UPDATE missao SET status = 'C' WHERE id_evento = B;

-- Rato Carniceiro
SELECT criar_missao_matar(103, 2, 1, '1', '100', '{"moeda":15}', NULL); -- id_evento = C
SELECT criar_missao_matar(103, 10, 1, '1', '100', '{"moeda":70}', NULL); -- id_evento = D
-- UPDATE missao SET prox = D WHERE id_evento = C;
-- UPDATE missao SET status = 'C' WHERE id_evento = D;

-- Catador
SELECT criar_missao_matar(107, 2, 1, '1', '100', '{"moeda":25}', NULL); -- id_evento = E
SELECT criar_missao_matar(107, 8, 1, '1', '100', '{"moeda":90}', NULL); -- id_evento = F
-- UPDATE missao SET prox = F WHERE id_evento = E;
-- UPDATE missao SET status = 'C' WHERE id_evento = F;

-- Robô de Segurança
SELECT criar_missao_matar(202, 1, 1, '1', '100', '{"moeda":30}', NULL); -- id_evento = G
SELECT criar_missao_matar(202, 5, 1, '1', '100', '{"moeda":150}', NULL); -- id_evento = H
-- UPDATE missao SET prox = H WHERE id_evento = G;
-- UPDATE missao SET status = 'C' WHERE id_evento = H;

-- Cachorro Faminto
SELECT criar_missao_matar(102, 1, 1, '1', '100', '{"moeda":10}', NULL); -- id_evento = I
SELECT criar_missao_matar(102, 6, 1, '1', '100', '{"moeda":50}', NULL); -- id_evento = J
-- UPDATE missao SET prox = J WHERE id_evento = I;
-- UPDATE missao SET status = 'C' WHERE id_evento = J;

-- Exemplo: entregar itens para ganhar moedas ou recompensas especiais
SELECT criar_missao_entregar(2, 5, 1, '1', '100', '{"moeda":10}', NULL); -- Entregar 5 Madeiras para ganhar 10 moedas
SELECT criar_missao_entregar(8, 3, 1, '1', '100', '{"moeda":15}', NULL); -- Entregar 3 Tecidos para ganhar 15 moedas
SELECT criar_missao_entregar(9, 1, 1, '1', '100', '{"moeda":20}', NULL); -- Entregar 1 Sucata Eletrônica para ganhar 20 moedas
SELECT criar_missao_entregar(4, 1, 1, '1', '100', '{"espada_laser":1}', NULL); -- id_evento = M

-- Chama procedure para resetar status das missões de matar
CALL resetar_status_missoes_matar();

-- =======================================
-- 15. DROPS DE INIMIGOS
-- =======================================
-- Exemplo: (id_item, id_ser, chance, quantidade)
-- Equipamentos
INSERT INTO npc_dropa (id_item, id_ser, chance, quant) VALUES
(1, 101, 100, 2), --moeda de baratas mutantes
(2, 103, 50, 1), --madeira de ratos carniceiros
(7, 107, 50, 2), --plastíco de catadores
(8, 107, 36, 3), --tecido de catadores
(9, 202, 75, 1), --sucata eletronica de robôs de segurança
(4, 997, 100, 1), -- Núcleo Radioativo Fundido 
(4, 998, 100, 1), -- Núcleo Radioativo Fundido 
(4, 999, 100, 1); -- Núcleo Radioativo Fundido

