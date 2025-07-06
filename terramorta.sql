-- SQLBook: Code
create table ser_controle(
	id_ser smallserial primary key not null,
	tipo char(1) not null
);

create table faccao(
	id_faccao smallserial primary key not null,
	nome_faccao char(50) not null
);

CREATE TABLE prota(
    id_ser SMALLINT PRIMARY KEY NOT NULL,
    nome CHAR(50) NOT NULL,
    hp_base SMALLINT NOT NULL,
    str_base SMALLINT NOT NULL,
    dex_base SMALLINT NOT NULL,
    def_base SMALLINT NOT NULL,
    res_fogo SMALLINT NOT NULL,
    res_gelo SMALLINT NOT NULL,
    res_elet SMALLINT NOT NULL,
    res_radi SMALLINT NOT NULL,
    res_cort SMALLINT NOT NULL,
    res_cont SMALLINT NOT NULL,
    fome_base SMALLINT NOT NULL,
    sede_base SMALLINT NOT NULL,
    carga_base SMALLINT NOT NULL,
    FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser)
);

CREATE TABLE nao_inteligente(
    id_ser SMALLINT PRIMARY KEY NOT NULL,
    nome CHAR(50) NOT NULL,
    hp_base SMALLINT NOT NULL,
    str_base SMALLINT NOT NULL,
    dex_base SMALLINT NOT NULL,
    def_base SMALLINT NOT NULL,
    res_fogo SMALLINT NOT NULL,
    res_gelo SMALLINT NOT NULL,
    res_elet SMALLINT NOT NULL,
    res_radi SMALLINT NOT NULL,
    res_cort SMALLINT NOT NULL,
    res_cont SMALLINT NOT NULL,
    cabeca BOOLEAN NOT NULL,
    torso BOOLEAN NOT NULL,
    maos BOOLEAN NOT NULL,
    pernas BOOLEAN NOT NULL,
    pes BOOLEAN NOT NULL,
    rad_dano SMALLINT NOT NULL,
    FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser)
);

CREATE TABLE inteligente(
    id_ser SMALLINT PRIMARY KEY NOT NULL,
    nome CHAR(50) NOT NULL,
    hp_base SMALLINT NOT NULL,
    str_base SMALLINT NOT NULL,
    dex_base SMALLINT NOT NULL,
    def_base SMALLINT NOT NULL,
    res_fogo SMALLINT NOT NULL,
    res_gelo SMALLINT NOT NULL,
    res_elet SMALLINT NOT NULL,
    res_radi SMALLINT NOT NULL,
    res_cort SMALLINT NOT NULL,
    res_cont SMALLINT NOT NULL,
    cabeca BOOLEAN NOT NULL,
    torso BOOLEAN NOT NULL,
    maos BOOLEAN NOT NULL,
    pernas BOOLEAN NOT NULL,
    pes BOOLEAN NOT NULL,
    alinhamento SMALLINT NOT NULL,
    FOREIGN KEY (alinhamento) REFERENCES faccao(id_faccao),
    FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser)
);

create table item_controle(
	id_item smallserial primary key not null,
	tipo char(1)
);

CREATE TABLE inventario(
    pos_inv SMALLSERIAL PRIMARY KEY NOT NULL,
    id_item SMALLINT NOT NULL,
    quant SMALLINT NOT NULL,
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item)
);

CREATE TABLE npc_dropa(
    id_item SMALLINT NOT NULL,
    id_ser SMALLINT NOT NULL,
    chance SMALLINT NOT NULL,
    PRIMARY KEY(id_item,id_ser),
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item),
    FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser)
);

CREATE TABLE coletavel(
    id_item SMALLINT PRIMARY KEY NOT NULL,
    nome CHAR(50) NOT NULL,
    preco INT NOT NULL,
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item)
);

create table equipamento(
	id_equip smallint primary key not null,
	nome char(50) not null,
	nivel smallint not null,
	parte_corpo char(4),
	preco INT NOT NULL,
	FOREIGN KEY (id_equip) REFERENCES item_controle(id_item)
);

create table equipamento_atual(
	id_ser smallint primary key not null,
	cabeca smallint,
	torso smallint,
	maos smallint,
	pernas smallint,
	pes smallint,
	FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser),
	FOREIGN KEY (cabeca) REFERENCES equipamento(id_equip),
	FOREIGN KEY (torso) REFERENCES equipamento(id_equip),
	FOREIGN KEY (maos) REFERENCES equipamento(id_equip),
	FOREIGN KEY (pernas) REFERENCES equipamento(id_equip),
	FOREIGN KEY (pes) REFERENCES equipamento(id_equip)
);

create table mutacao(
	id_mutacao smallint primary key not null,
	nome char(50) not null,
	nivel smallint not null,
	parte_corpo char(4),
	FOREIGN KEY (id_mutacao) REFERENCES item_controle(id_item)
);

create table mutacao_atual(
	id_ser smallint primary key not null,
	cabeca smallint,
	torso smallint,
	maos smallint,
	pernas smallint,
	pes smallint,
	FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser),
	FOREIGN KEY (cabeca) REFERENCES mutacao(id_mutacao),
	FOREIGN KEY (torso) REFERENCES mutacao(id_mutacao),
	FOREIGN KEY (maos) REFERENCES mutacao(id_mutacao),
	FOREIGN KEY (pernas) REFERENCES mutacao(id_mutacao),
	FOREIGN KEY (pes) REFERENCES mutacao(id_mutacao)
);

CREATE TABLE modificador(
    id_item SMALLINT PRIMARY KEY NOT NULL,
    atributo CHAR(50) NOT NULL,
    valor SMALLINT NOT NULL,
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item)
);

CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    max_ocorrencia SMALLINT,
    prioridade CHAR(1),
    probabilidade CHAR(3),
    tipo VARCHAR(20) NOT NULL -- 'MISSAO', 'ENCONTRO', 'ACONTECIMENTO MUNDO'
);

CREATE TABLE evento_dropa(
    id_item SMALLINT,
    id_evento SMALLINT,
    PRIMARY KEY(id_item,id_evento),
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);

CREATE TABLE ponto_de_interesse (
    id_pi SMALLSERIAL PRIMARY KEY,
    nome VARCHAR(50), 
    nivel_rad DECIMAL(5,2) 
);

CREATE TABLE ocorre(
    id_evento smallint,
    id_pi smallint ,
    PRIMARY KEY(id_evento,id_pi),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
    FOREIGN KEY (id_pi) REFERENCES ponto_de_interesse(id_pi)
);

CREATE TYPE status_enum AS ENUM ('C', 'A', 'F', 'N');

CREATE TABLE requisitos (
    id_requisito SERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,      -- 'MATAR' ou 'ENTREGAR'
    alvo SMALLINT,
    quantidade SMALLINT,
    status BOOLEAN DEFAULT FALSE
);

CREATE TABLE missao (
    id_evento SMALLINT PRIMARY KEY,
    id_requisito INT UNIQUE NOT NULL,
    status status_enum,
    recompensas TEXT,
    prox SMALLINT,
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
    FOREIGN KEY (prox) REFERENCES evento(id_evento),
    FOREIGN KEY (id_requisito) REFERENCES requisitos(id_requisito)
);

CREATE TABLE encontro (
    id_evento INT PRIMARY KEY REFERENCES evento(id_evento),
    id_inimigo INT REFERENCES ser_controle(id_ser),
    quantidade INT
);

CREATE TABLE acontecimento_mundo (
    id_evento INT PRIMARY KEY REFERENCES evento(id_evento),
    atributo INT REFERENCES ser_controle(id_ser),
    valor INT,
    texto VARCHAR
);

CREATE TABLE instalacao_base (
    id_instalacao SMALLSERIAL PRIMARY KEY,
    nome VARCHAR(50),
    nivel SMALLINT,
    id_item SMALLINT,
    qtd SMALLINT,
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item)
);

CREATE TABLE base (
    id_pi SMALLINT PRIMARY KEY,
    nome VARCHAR(50),
    id_instalacao SMALLINT,
    FOREIGN KEY (id_pi) REFERENCES ponto_de_interesse(id_pi),
    FOREIGN KEY (id_instalacao) REFERENCES instalacao_base(id_instalacao)
);

CREATE TABLE inst_ser(
    id_ser SMALLINT NOT NULL,
    id_inst SMALLSERIAL NOT NULL,
    hp_max SMALLINT NOT NULL,
    hp_atual SMALLINT NOT NULL,
    str_atual SMALLINT NOT NULL,
    dex_atual SMALLINT NOT NULL,
    def_atual SMALLINT NOT NULL,
    localizacao SMALLINT NOT NULL,
    PRIMARY KEY(id_ser,id_inst),
    FOREIGN KEY (id_ser) REFERENCES ser_controle(id_ser),
    FOREIGN KEY (localizacao) REFERENCES ponto_de_interesse(id_pi)
);

CREATE TABLE inst_prota(
    id_ser SMALLINT NOT NULL,
    id_inst SMALLSERIAL NOT NULL,
    hp_max SMALLINT NOT NULL,
    hp_atual SMALLINT NOT NULL,
    str_atual SMALLINT NOT NULL,
    dex_atual SMALLINT NOT NULL,
    def_atual SMALLINT NOT NULL,
    res_fogo_at SMALLINT NOT NULL,
    res_gelo_at SMALLINT NOT NULL,
    res_elet_at SMALLINT NOT NULL,
    res_radi_at SMALLINT NOT NULL,
    res_cort_at SMALLINT NOT NULL,
    res_cont_at SMALLINT NOT NULL,
    fome_max SMALLINT NOT NULL,
    sede_max SMALLINT NOT NULL,
    fome_atual SMALLINT NOT NULL,
    sede_atual SMALLINT NOT NULL,
    carga_max SMALLINT NOT NULL,
    carga_atual SMALLINT NOT NULL,
    faccao SMALLINT,
    rad_atual SMALLINT NOT NULL,
    localizacao SMALLINT NOT NULL,
    PRIMARY KEY(id_ser,id_inst),
    FOREIGN KEY (id_ser) REFERENCES prota(id_ser),
    FOREIGN KEY (faccao) REFERENCES faccao(id_faccao),
    FOREIGN KEY (localizacao) REFERENCES ponto_de_interesse(id_pi)
);

CREATE TABLE conexao (
    origem SMALLINT NOT NULL,
    destino SMALLINT NOT NULL,
    custo SMALLINT NOT NULL,
    PRIMARY KEY (origem, destino),
    FOREIGN KEY (origem) REFERENCES ponto_de_interesse(id_pi),
    FOREIGN KEY (destino) REFERENCES ponto_de_interesse(id_pi)
);

CREATE TABLE inst_coletavel (
    id_inst_coletavel SERIAL PRIMARY KEY,
    id_item SMALLINT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_item) REFERENCES coletavel(id_item)
);

CREATE TABLE inst_equipamento (
    id_inst_equipamento SERIAL PRIMARY KEY,
    id_equip SMALLINT NOT NULL,
    FOREIGN KEY (id_equip) REFERENCES equipamento(id_equip)
);

CREATE TABLE inst_mutacao (
    id_inst_mutacao SERIAL PRIMARY KEY,
    id_mutacao SMALLINT NOT NULL,
    FOREIGN KEY (id_mutacao) REFERENCES mutacao(id_mutacao)
);