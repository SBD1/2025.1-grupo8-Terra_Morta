INSERT INTO ponto_de_interesse (nome, custo, nivel_rad) VALUES
('Base Central', 0, 0.00),
('Refinaria Abandonada', 120, 3.75),
('Estação de Trem Velha', 60, 1.20),
('Hospital Subterrâneo', 200, 4.90),
('Zona de Comércio Queimada', 80, 2.10),
('Laboratório Químico', 150, 5.00),
('Aeroporto Militar', 180, 3.95),
('Bunker da Resistência', 220, 1.85),
('Cidade Fantasma', 100, 2.65),
('Parque Industrial', 140, 3.30),
('Estação de Tratamento de Água', 90, 1.50);

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