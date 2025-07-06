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
('Covil da Hidra de Carne', 30),         -- ID: 56

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
-- 2. ITENS COLETÁVEIS, EQUIPAMENTOS E MUTAÇÕES (usando procedures)
-- =======================================
-- Coletáveis (inclui moeda id 1)
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Moeda' AS CHAR(50)), 0);         -- id 1
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Madeira' AS CHAR(50)), 5);       -- id 2
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Ferro' AS CHAR(50)), 10);        -- id 3
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Núcleo Radioativo Fundido' AS CHAR(50)), 50); -- id 4
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Água Potável' AS CHAR(50)), 8);  -- id 5
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Comida Enlatada' AS CHAR(50)), 12); -- id 6
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Plástico' AS CHAR(50)), 4);      -- id 7
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Tecido' AS CHAR(50)), 6);        -- id 8
SELECT inserir_coletavel(CAST('C' AS CHAR(1)), CAST('Sucata Eletrônica' AS CHAR(50)), 15); -- id 9

-- Equipamentos (id 10+)
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Capacete de Metal' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('cabe' AS CHAR(4)), 30);   -- id 10
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Colete de Couro' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('tors' AS CHAR(4)), 35);     -- id 11
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Luvas de Proteção' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('maos' AS CHAR(4)), 18);   -- id 12
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Botas de Borracha' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('pes' AS CHAR(4)), 20);    -- id 13
SELECT inserir_equipamento(CAST('E' AS CHAR(1)), CAST('Calças Reforçadas' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('pern' AS CHAR(4)), 25);   -- id 14

-- Mutações (id 15+)
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Visão Noturna' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('cabe' AS CHAR(4)));      -- id 15
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Braço Extra' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('maos' AS CHAR(4)));        -- id 16
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Pele Resistente' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('tors' AS CHAR(4)));    -- id 17
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Pernas Saltadoras' AS CHAR(50)), CAST(2 AS SMALLINT), CAST('pern' AS CHAR(4)));  -- id 18
SELECT inserir_mutacao(CAST('M' AS CHAR(1)), CAST('Garras Afiadas' AS CHAR(50)), CAST(1 AS SMALLINT), CAST('maos' AS CHAR(4)));     -- id 19

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
(1,5,5),         -- Base → Terra Chamuscada
(1,3,5),         -- Base → Posto de Vigia Abandonado
(1,4,5),         -- Base → Cidade Fantasma
(1,2,7),         -- Base → Travessia da Poeira
(2,16,9),        -- Travessia da Poeira → Pátio do Ferro-Velho
(3,6,8),         -- Posto de Vigia Abandonado → Subúrbio dos Esquecidos
(4,13,7),        -- Cidade Fantasma → Poço de água
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
(106, 'Cururu Mutante',    20,  4, 13, 0,  0, 0, 1, 0, 0, 0,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  0),



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


-- =======================================
-- 12. ACONTECIMENTOS DE MUNDO
-- =======================================

SELECT criar_acontecimento_mundo(NULL, 10, 'Você encontrou uma fogueira com comida, ele pegou um pouco... e recuperou 10 de fome!', 3, NULL::INT, '1', '25');  -- PI 3: Fogueira (recupera fome)

-- =======================================
-- 13. MODIFICADORES DE EQUIPAMENTOS E MUTAÇÕES
-- =======================================
-- Exemplo: (id_item, atributo, valor)
-- Equipamentos
INSERT INTO modificador (id_item, atributo, valor) VALUES
(10, 'def', 5),      -- Capacete de Metal: +5 defesa
(11, 'def', 8),      -- Colete de Couro: +8 defesa
(12, 'dex', 3),      -- Luvas de Proteção: +3 destreza
(13, 'def', 4),      -- Botas de Borracha: +4 defesa
(14, 'carga', 10);   -- Calças Reforçadas: +10 carga

-- Mutações
INSERT INTO modificador (id_item, atributo, valor) VALUES
(15, 'visao', 1),    -- Visão Noturna: +1 visão
(16, 'str', 2),      -- Braço Extra: +2 força
(17, 'def', 4),      -- Pele Resistente: +4 defesa
(18, 'dex', 2),      -- Pernas Saltadoras: +2 destreza
(19, 'atk', 3);      -- Garras Afiadas: +3 ataque