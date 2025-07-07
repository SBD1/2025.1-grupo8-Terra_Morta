### 🧩 **faccao**
| Atributo    | Tipo        | PK  | FK  | Obrigatório | Descrição                     |
| ----------- | ----------- | --- | --- | ----------- | ----------------------------- |
| id_faccao   | SMALLSERIAL | ✅  |     | Sim         | Identificador único da facção |
| nome_faccao | CHAR(50)    |     |     | Sim         | Nome da facção                |

---

### 🧩 **ser_controle**
| Atributo | Tipo        | PK  | FK  | Obrigatório | Descrição                      |
| -------- | ----------- | --- | --- | ----------- | ------------------------------ |
| id_ser   | SMALLSERIAL | ✅  |     | Sim         | Identificador único do ser     |
| tipo     | CHAR(1)     |     |     | Sim         | Tipo do ser (P, N, I, etc.)    |

---

### 🧩 **prota**
| Atributo    | Tipo        | PK  | FK           | Obrigatório | Descrição                  |
| ----------- | ----------- | --- | ------------| ----------- | -------------------------- |
| id_ser      | SMALLINT    | ✅  | ser_controle| Sim         | Identificador do ser       |
| nome        | CHAR(50)    |     |             | Sim         | Nome do personagem         |
| hp_base     | SMALLINT    |     |             | Sim         | Vida máxima                |
| str_base    | SMALLINT    |     |             | Sim         | Força                      |
| dex_base    | SMALLINT    |     |             | Sim         | Destreza                   |
| def_base    | SMALLINT    |     |             | Sim         | Defesa                     |
| res_fogo    | SMALLINT    |     |             | Sim         | Resistência a fogo         |
| res_gelo    | SMALLINT    |     |             | Sim         | Resistência a gelo         |
| res_elet    | SMALLINT    |     |             | Sim         | Resistência a eletricidade |
| res_radi    | SMALLINT    |     |             | Sim         | Resistência a radiação     |
| res_cort    | SMALLINT    |     |             | Sim         | Resistência a corte        |
| res_cont    | SMALLINT    |     |             | Sim         | Resistência a contusão     |
| fome_base   | SMALLINT    |     |             | Sim         | Fome base                  |
| sede_base   | SMALLINT    |     |             | Sim         | Sede base                  |
| carga_base  | SMALLINT    |     |             | Sim         | Capacidade de carga        |

---

### 🧩 **nao_inteligente**
| Atributo    | Tipo        | PK  | FK           | Obrigatório | Descrição                  |
| ----------- | ----------- | --- | ------------| ----------- | -------------------------- |
| id_ser      | SMALLINT    | ✅  | ser_controle| Sim         | Identificador do ser       |
| nome        | CHAR(50)    |     |             | Sim         | Nome do personagem         |
| hp_base     | SMALLINT    |     |             | Sim         | Vida máxima                |
| str_base    | SMALLINT    |     |             | Sim         | Força                      |
| dex_base    | SMALLINT    |     |             | Sim         | Destreza                   |
| def_base    | SMALLINT    |     |             | Sim         | Defesa                     |
| res_fogo    | SMALLINT    |     |             | Sim         | Resistência a fogo         |
| res_gelo    | SMALLINT    |     |             | Sim         | Resistência a gelo         |
| res_elet    | SMALLINT    |     |             | Sim         | Resistência a eletricidade |
| res_radi    | SMALLINT    |     |             | Sim         | Resistência a radiação     |
| res_cort    | SMALLINT    |     |             | Sim         | Resistência a corte        |
| res_cont    | SMALLINT    |     |             | Sim         | Resistência a contusão     |
| cabeca      | BOOLEAN     |     |             | Sim         | Possui cabeça              |
| torso       | BOOLEAN     |     |             | Sim         | Possui torso               |
| maos        | BOOLEAN     |     |             | Sim         | Possui mãos                |
| pernas      | BOOLEAN     |     |             | Sim         | Possui pernas              |
| pes         | BOOLEAN     |     |             | Sim         | Possui pés                 |
| rad_dano    | SMALLINT    |     |             | Sim         | Dano de radiação           |

---

### 🧩 **inteligente**
| Atributo    | Tipo        | PK  | FK           | Obrigatório | Descrição                  |
| ----------- | ----------- | --- | ------------| ----------- | -------------------------- |
| id_ser      | SMALLINT    | ✅  | ser_controle| Sim         | Identificador do ser       |
| nome        | CHAR(50)    |     |             | Sim         | Nome do personagem         |
| hp_base     | SMALLINT    |     |             | Sim         | Vida máxima                |
| str_base    | SMALLINT    |     |             | Sim         | Força                      |
| dex_base    | SMALLINT    |     |             | Sim         | Destreza                   |
| def_base    | SMALLINT    |     |             | Sim         | Defesa                     |
| res_fogo    | SMALLINT    |     |             | Sim         | Resistência a fogo         |
| res_gelo    | SMALLINT    |     |             | Sim         | Resistência a gelo         |
| res_elet    | SMALLINT    |     |             | Sim         | Resistência a eletricidade |
| res_radi    | SMALLINT    |     |             | Sim         | Resistência a radiação     |
| res_cort    | SMALLINT    |     |             | Sim         | Resistência a corte        |
| res_cont    | SMALLINT    |     |             | Sim         | Resistência a contusão     |
| cabeca      | BOOLEAN     |     |             | Sim         | Possui cabeça              |
| torso       | BOOLEAN     |     |             | Sim         | Possui torso               |
| maos        | BOOLEAN     |     |             | Sim         | Possui mãos                |
| pernas      | BOOLEAN     |     |             | Sim         | Possui pernas              |
| pes         | BOOLEAN     |     |             | Sim         | Possui pés                 |
| alinhamento | SMALLINT    |     | faccao      | Sim         | Alinhamento/facção         |

---

### 🧩 **item_controle**
| Atributo | Tipo        | PK  | FK  | Obrigatório | Descrição                    |
| -------- | ----------- | --- | --- | ----------- | ---------------------------- |
| id_item  | SMALLSERIAL | ✅  |     | Sim         | ID do item                   |
| tipo     | CHAR(1)     |     |     |             | Tipo de item (C/E/M)         |

---

### 🧩 **inventario**
| Atributo | Tipo        | PK  | FK           | Obrigatório | Descrição                    |
| -------- | ----------- | --- | ------------| ----------- | ---------------------------- |
| pos_inv  | SMALLSERIAL | ✅  |             | Sim         | Posição no inventário        |
| id_item  | SMALLINT    |     | item_controle| Sim         | ID do item                   |
| quant    | SMALLINT    |     |             | Sim         | Quantidade                   |

---

### 🧩 **npc_dropa**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_item  | SMALLINT | ✅  | item_controle| Sim         | ID do item                   |
| id_ser   | SMALLINT | ✅  | ser_controle| Sim         | ID do ser                    |
| chance   | SMALLINT |     |             | Sim         | Chance de drop               |
| quant    | SMALLINT |     |             | Sim         | Quantidade                   |

---

### 🧩 **coletavel**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_item  | SMALLINT | ✅  | item_controle| Sim         | ID do item                   |
| nome     | CHAR(50) |     |             | Sim         | Nome                         |
| preco    | INT      |     |             | Sim         | Preço                        |

---
### 🧩 **utilizavel**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_util  | SMALLINT | ✅  | item_controle| Sim         | ID do item                   |
| nome     | CHAR(50) |     |             | Sim         | Nome                         |
| preco    | INT      |     |             | Sim         | Preço                        |
| atributo | CHAR(10) |     |             | Sim         | Atributo afetado             |
| valor    | SMALLINT |     |             | Sim         | Valor                        |

---
### 🧩 **equipamento**
| Atributo    | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| ----------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_equip    | SMALLINT | ✅  | item_controle| Sim         | ID do equipamento            |
| nome        | CHAR(50) |     |             | Sim         | Nome                         |
| nivel       | SMALLINT |     |             | Sim         | Nível                        |
| parte_corpo | CHAR(4)  |     |             |             | Parte do corpo               |
| preco       | INT      |     |             | Sim         | Preço                        |

---
### 🧩 **equipamento_atual**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_ser   | SMALLINT | ✅  | ser_controle| Sim         | ID do ser                    |
| cabeca   | SMALLINT |     | equipamento | Não         | Equipamento na cabeça        |
| torso    | SMALLINT |     | equipamento | Não         | Equipamento no torso         |
| maos     | SMALLINT |     | equipamento | Não         | Equipamento nas mãos         |
| pernas   | SMALLINT |     | equipamento | Não         | Equipamento nas pernas       |
| pes      | SMALLINT |     | equipamento | Não         | Equipamento nos pés          |

---
### 🧩 **mutacao**
| Atributo    | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| ----------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_mutacao  | SMALLINT | ✅  | item_controle| Sim         | ID da mutação                |
| nome        | CHAR(50) |     |             | Sim         | Nome                         |
| nivel       | SMALLINT |     |             | Sim         | Nível                        |
| parte_corpo | CHAR(4)  |     |             |             | Parte do corpo               |

---
### 🧩 **mutacao_atual**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_ser   | SMALLINT | ✅  | ser_controle| Sim         | ID do ser                    |
| cabeca   | SMALLINT |     | mutacao     | Não         | Mutação na cabeça            |
| torso    | SMALLINT |     | mutacao     | Não         | Mutação no torso             |
| maos     | SMALLINT |     | mutacao     | Não         | Mutação nas mãos             |
| pernas   | SMALLINT |     | mutacao     | Não         | Mutação nas pernas           |
| pes      | SMALLINT |     | mutacao     | Não         | Mutação nos pés              |

---
### 🧩 **modificador**
| Atributo | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_item  | SMALLINT | ✅  | item_controle| Sim         | ID do item                   |
| atributo | CHAR(50) | ✅  |             | Sim         | Atributo afetado             |
| valor    | SMALLINT |     |             | Sim         | Valor                        |

---
### 🧩 **evento**
| Atributo        | Tipo        | PK  | FK  | Obrigatório | Descrição                    |
| --------------  | ----------  | --- | --- | ----------- | ---------------------------- |
| id_evento       | SERIAL      | ✅  |     | Sim         | Identificador do evento      |
| max_ocorrencia  | SMALLINT    |     |     |             | Máximo de ocorrências        |
| prioridade      | CHAR(1)     |     |     |             | Prioridade                   |
| probabilidade   | CHAR(3)     |     |     |             | Probabilidade                |
| tipo            | VARCHAR(20) |     |     | Sim         | Tipo do evento               |

---
### 🧩 **evento_dropa**
| Atributo  | Tipo     | PK  | FK           | Obrigatório | Descrição                    |
| --------- | -------- | --- | ------------| ----------- | ---------------------------- |
| id_item   | SMALLINT | ✅  | item_controle| Sim         | ID do item                   |
| id_evento | SMALLINT | ✅  | evento      | Sim         | ID do evento                 |

---
### 🧩 **ponto_de_interesse**
| Atributo   | Tipo         | PK  | FK  | Obrigatório | Descrição                    |
| ---------- | ------------ | --- | --- | ----------- | ---------------------------- |
| id_pi      | SMALLSERIAL  | ✅  |     | Sim         | Identificador do ponto       |
| nome       | VARCHAR(50)  |     |     |             | Nome                         |
| nivel_rad  | DECIMAL(5,2) |     |     |             | Nível de radiação            |

---
### 🧩 **ocorre**
| Atributo  | Tipo     | PK  | FK      | Obrigatório | Descrição                    |
| --------- | -------- | --- | ------- | ----------- | ---------------------------- |
| id_evento | SMALLINT | ✅  | evento  | Sim         | ID do evento                 |
| id_pi     | SMALLINT | ✅  | ponto_de_interesse | Sim | ID do ponto de interesse     |

---
### 🧩 **requisitos**
| Atributo    | Tipo        | PK  | FK  | Obrigatório | Descrição                    |
| ----------- | ----------- | --- | --- | ----------- | ---------------------------- |
| id_requisito| SERIAL      | ✅  |     | Sim         | Identificador do requisito   |
| tipo        | VARCHAR(20) |     |     | Sim         | Tipo de requisito            |
| alvo        | SMALLINT    |     |     |             | Alvo                         |
| quantidade  | SMALLINT    |     |     |             | Quantidade                   |
| status      | BOOLEAN     |     |     |             | Status                       |

---
### 🧩 **missao**
| Atributo     | Tipo      | PK  | FK           | Obrigatório | Descrição                    |
| ------------ | --------- | --- | ------------| ----------- | ---------------------------- |
| id_evento    | SMALLINT  | ✅  | evento      | Sim         | ID do evento                 |
| id_requisito | INT       |     | requisitos  | Sim         | ID do requisito              |
| status       | status_enum|     |             |             | Status da missão             |
| recompensas  | TEXT      |     |             |             | Recompensas                  |
| prox         | SMALLINT  |     | evento      |             | Próxima missão               |

---
### 🧩 **encontro**
| Atributo   | Tipo | PK  | FK           | Obrigatório | Descrição                    |
| ---------- | ---- | --- | ------------| ----------- | ---------------------------- |
| id_evento  | INT  | ✅  | evento      | Sim         | ID do evento                 |
| id_inimigo | INT  |     | ser_controle|             | ID do inimigo                |
| quantidade | INT  |     |             |             | Quantidade                   |

---
### 🧩 **acontecimento_mundo**
| Atributo   | Tipo | PK  | FK           | Obrigatório | Descrição                    |
| ---------- | ---- | --- | ------------| ----------- | ---------------------------- |
| id_evento  | INT  | ✅  | evento      | Sim         | ID do evento                 |
| atributo   | INT  |     | ser_controle|             | Atributo afetado             |
| valor      | INT  |     |             |             | Valor                        |
| texto      | VARCHAR |   |             |             | Texto                        |

---
### 🧩 **instalacao_base**
| Atributo     | Tipo        | PK  | FK           | Obrigatório | Descrição                    |
| ------------ | ----------- | --- | ------------| ----------- | ---------------------------- |
| id_instalacao| SMALLSERIAL | ✅  |             | Sim         | ID da instalação             |
| nome         | VARCHAR(50) |     |             |             | Nome                         |
| nivel        | SMALLINT    |     |             |             | Nível                        |
| id_item      | SMALLINT    |     | item_controle|             | ID do item                   |
| qtd          | SMALLINT    |     |             |             | Quantidade                   |

---
### 🧩 **base**
| Atributo     | Tipo        | PK  | FK           | Obrigatório | Descrição                    |
| ------------ | ----------- | --- | ------------| ----------- | ---------------------------- |
| id_pi        | SMALLINT    | ✅  | ponto_de_interesse | Sim | ID do ponto de interesse     |
| nome         | VARCHAR(50) |     |             |             | Nome                         |
| id_instalacao| SMALLINT    |     | instalacao_base|             | ID da instalação             |

---
### 🧩 **inst_ser**
| Atributo    | Tipo        | PK  | FK           | Obrigatório | Descrição                    |
| ----------- | ----------- | --- | ------------| ----------- | ---------------------------- |
| id_ser      | SMALLINT    | ✅  | ser_controle| Sim         | ID do ser                    |
| id_inst     | SMALLSERIAL | ✅  |             | Sim         | ID da instância              |
| hp_max      | SMALLINT    |     |             | Sim         | Vida máxima                  |
| hp_atual    | SMALLINT    |     |             | Sim         | Vida atual                   |
| str_atual   | SMALLINT    |     |             | Sim         | Força atual                  |
| dex_atual   | SMALLINT    |     |             | Sim         | Destreza atual               |
| def_atual   | SMALLINT    |     |             | Sim         | Defesa atual                 |
| localizacao | SMALLINT    |     | ponto_de_interesse | Sim | Localização                  |

---
### 🧩 **inst_prota**
| Atributo      | Tipo        | PK  | FK           | Obrigatório | Descrição                    |
| ------------- | ----------- | --- | ------------| ----------- | ---------------------------- |
| id_ser        | SMALLINT    | ✅  | prota       | Sim         | ID do protagonista           |
| id_inst       | SMALLSERIAL | ✅  |             | Sim         | ID da instância              |
| hp_max        | SMALLINT    |     |             | Sim         | Vida máxima                  |
| hp_atual      | SMALLINT    |     |             | Sim         | Vida atual                   |
| str_atual     | SMALLINT    |     |             | Sim         | Força atual                  |
| dex_atual     | SMALLINT    |     |             | Sim         | Destreza atual               |
| def_atual     | SMALLINT    |     |             | Sim         | Defesa atual                 |
| res_fogo_at   | SMALLINT    |     |             | Sim         | Resistência a fogo           |
| res_gelo_at   | SMALLINT    |     |             | Sim         | Resistência a gelo           |
| res_elet_at   | SMALLINT    |     |             | Sim         | Resistência a eletricidade   |
| res_radi_at   | SMALLINT    |     |             | Sim         | Resistência a radiação       |
| res_cort_at   | SMALLINT    |     |             | Sim         | Resistência a corte          |
| res_cont_at   | SMALLINT    |     |             | Sim         | Resistência a contusão       |
| fome_max      | SMALLINT    |     |             | Sim         | Fome máxima                  |
| sede_max      | SMALLINT    |     |             | Sim         | Sede máxima                  |
| fome_atual    | SMALLINT    |     |             | Sim         | Fome atual                   |
| sede_atual    | SMALLINT    |     |             | Sim         | Sede atual                   |
| carga_max     | SMALLINT    |     |             | Sim         | Capacidade de carga máxima   |
| carga_atual   | SMALLINT    |     |             | Sim         | Carga atual                  |
| faccao        | SMALLINT    |     | faccao      |             | Facção                       |
| rad_atual     | SMALLINT    |     |             | Sim         | Radiação atual               |
| localizacao   | SMALLINT    |     | ponto_de_interesse | Sim | Localização                  |

---
### 🧩 **conexao**
| Atributo | Tipo     | PK  | FK                  | Obrigatório | Descrição                    |
| -------- | -------- | --- | ------------------- | ----------- | ---------------------------- |
| origem   | SMALLINT | ✅  | ponto_de_interesse  | Sim         | Origem                       |
| destino  | SMALLINT | ✅  | ponto_de_interesse  | Sim         | Destino                      |
| custo    | SMALLINT |     |                     | Sim         | Custo                        |
