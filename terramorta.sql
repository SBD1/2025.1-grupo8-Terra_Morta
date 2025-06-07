create table ser_controle(
	id_ser smallserial primary key not null,
	tipo char(1) not null
);

create table faccao(
	id_faccao smallserial primary key not null,
	nome_faccao char(50) not null
);

create table item_controle(
	id_item smallserial primary key not null,
	tipo char(1)
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

create table equipamento(
	id_equip smallint primary key not null,
	nome char(50) not null,
	nivel smallint not null,
	parte_corpo char(4),
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

CREATE TABLE evento (
    id_evento SMALLSERIAL PRIMARY KEY,
    max_ocorrencia SMALLINT 
);

CREATE TABLE ponto_de_interesse (
    id_pi SMALLSERIAL PRIMARY KEY,
    nome VARCHAR(50),
    custo SMALLINT, 
    nivel_rad DECIMAL(5,2) 
);

CREATE TABLE requisitos (
    id_evento SMALLINT PRIMARY KEY,
    req VARCHAR(50), 
    status BOOLEAN, 
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);

CREATE TABLE ocorre(
    id_evento smallint ,
    id_pi smallint ,
    PRIMARY KEY(id_evento,id_pi),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
    FOREIGN KEY (id_pi) REFERENCES ponto_de_interesse(id_pi)
);

CREATE TABLE missao (
    id_evento SMALLINT PRIMARY KEY,
    status CHAR(1) CHECK (status IN ('C', 'A', 'F', 'N')),
    prox SMALLINT, 
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
    FOREIGN KEY (prox) REFERENCES evento(id_evento)
);

CREATE TABLE base (
    id_pi SMALLINT PRIMARY KEY,
    nome VARCHAR(50),
    id_instalacao SMALLINT,
    FOREIGN KEY (id_pi) REFERENCES ponto_de_interesse(id_pi),
    FOREIGN KEY (id_instalacao) REFERENCES instalacao_base(id_instalacao)
);

CREATE TABLE instalacao_base (
    id_instalacao SMALLSERIAL PRIMARY KEY,
    nome VARCHAR(50),
    nivel SMALLINT,
    requisito VARCHAR(100) 
);

CREATE TABLE evento_dropa(
    id_item SMALLINT,
    id_evento SMALLINT,
    PRIMARY KEY(id_item,id_evento),
    FOREIGN KEY (id_item) REFERENCES item_controle(id_item),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);