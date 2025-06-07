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