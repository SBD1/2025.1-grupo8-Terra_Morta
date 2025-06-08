INSERT INTO ponto_de_interesse (nome, custo, nivel_rad) VALUES
('Base', 0, 0),
('Travessia da Poeira', 5, 1),
('Posto de Vigia Abandonado', 5, 1),
('Cidade Fantasma', 6, 2),
('Terra Chamuscada', 5, 1),
('Subúrbio dos Esquecidos', 7, 2),
('Nigrum Sanguinem', 30, 30),
('Base dos Pisa Poeira', 10, 0),
('Escola Amanhecer Dourado', 7, 1),
('Cemitério das Máquinas', 20, 3),
('Colinas Negras', 8, 3),
('Mercabunker', 7, 0),
('Poço de água', 5, 0),
('Hospital Subterrâneo', 10, 4),
('Aeroporto Militar', 12, 5),
('Pátio do Ferro-Velho', 6, 1),
('Subúrbio dos Esquecidos', 7, 2),
('Lugar Algum', 9, 0),
('Mêtro do Surfista', 9, 0),
('Estação de Tratamento de Água', 6, 2);

INSERT INTO item_controle (id_item, tipo) VALUES
('C'),
('C'),
('C');

INSERT INTO coletavel (id_item, nome) VALUES
('1','Madeira'),
('2','Ferro'),
('3','Núcleo Radioativo Fundido');

INSERT INTO instalacao_base (nome, nivel, id_item, qtd) VALUES
('Acampamento Improvisado', 0, NULL, NULL),
('Refúgio de Madeira', 1, 1, 5),
('Fortificação de Madeira', 2, 1, 15),
('Depósito de Ferro Reforçado', 3, 2, 5),
('Complexo Técnico Avançado', 4, 2, 15),
('Santuário do Núcleo', 5, 3, 3);

INSERT INTO base (id_pi, nome, id_instalacao) VALUES 
(1, 'Base Central', 0);

INSERT INTO ser_controle (tipo) VALUES 
('P'),
('P'),
('P'),
('P'),
('P'),
('P');

INSERT INTO prota (
    id_ser, nome, hp_base, str_base, dex_base, def_base,
    res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont,
    fome_base, sede_base, carga_base
) VALUES 
(
    1, 'Julio Lobo-Guará', 100, 12, 13, 0,
    0, 0, 0, 0, 0, 0,
    100, 100, 130
),
(
    2, 'Mamba Negra', 100, 8, 17, 0,
    0, 0, 0, 0, 0, 0,
    120, 120, 90
),
(
    3, 'Você', 60, 5, 5, 0,
    0, 0, 0, 0, 0, 0,
    40, 40, 30
),
(
    4, 'All, the Baran', 100, 15, 0, 10,
    0, 0, 0, 0, 0, 0,
    100, 100, 200
),
(
    5, 'Dr. Brasília', 100, 22, 22, -1,
    22, 22, 22, 22, 22, 22,
    220, 220, 220
),
(
    6, 'Alyx', 100, 13, 10, 2,
    0, 0, 0, 0, 0, 0,
    80, 75, 120
);