### 🧩 **Facção**

| Atributo   | Tipo    | PK | FK | Obrigatório | Descrição                     |
| ---------- | ------- | -- | -- | ----------- | ----------------------------- |
| ID_Facção  | INT | ✅ |    | Sim         | Identificador único da facção |

---

### 🧩 **Ser_Controle**

| Atributo | Tipo    | PK | FK | Obrigatório | Descrição                      |
| -------- | ------- | -- | -- | ----------- | ------------------------------ |
| ID_Ser   | INT | ✅ |    | Sim         | Identificador único do ser     |
| Tipo     | CHAR(15)   |    |    | Sim         | Tipo do ser (Prota, NPC, etc.) |

---

### 🧩 **Prota**

| Atributo     | Tipo    | PK | FK            | Obrigatório | Descrição                  |
| ------------ | ------- | -- | ------------- | ----------- | -------------------------- |
| ID_Ser       | INT | ✅ | Ser_Controle  | Sim         | Identificador do ser       |
| Nome         | CHAR(100)   |    |               | Sim         | Nome do personagem         |
| Max_HP       | INT |    |               | Sim         | Vida máxima                |
| Str          | INT |    |               | Sim         | Força                      |
| Dex          | INT |    |               | Sim         | Destreza                   |
| Def          | INT |    |               | Sim         | Defesa                     |
| Vantagens    | CHAR(200)   |    |               | Não         | Vantagens do personagem    |
| Desvantagens | CHAR(200)   |    |               | Não         | Desvantagens do personagem |
| Facção       | INT |    | Facção        | Sim         | Facção à qual pertence     |
| Fome         | INT |    |               | Não         | Fome do personagem         |
| Sede         | INT |    |               | Não         | Sede                       |
| Rad_Atual    | INT |    |               | Não         | Radiação atual             |
| Cap_Carga    | INT |    |               | Não         | Capacidade de carga        |
| Localização  | CHAR(20)   |    |               | Não         | Localização atual          |

---

### 🧩 **Inteligentes**

| Atributo     | Tipo    | PK | FK     | Obrigatório | Descrição             |
| ------------ | ------- | -- | ------ | ----------- | --------------------- |
| ID_Ser       | INT | ✅ |        | Sim         | ID do ser inteligente |
| Nome         | CHAR(100)   |    |        | Sim         | Nome                  |
| Max_HP       | INT |    |        | Sim         | Vida máxima           |
| Str          | INT |    |        | Sim         | Força                 |
| Dex          | INT |    |        | Sim         | Destreza              |
| Def          | INT |    |        | Sim         | Defesa                |
| Vantagens    | CHAR(200)   |    |        | Não         | Vantagens             |
| Desvantagens | CHAR(200)   |    |        | Não         | Desvantagens          |
| Alinhamento  | CHAR(15)   |    |        | Não         | Alinhamento moral     |
| Facção       | INT |    | Facção | Não         | Facção associada      |

---

### 🧩 **Não_Inteligentes**

| Atributo     | Tipo    | PK | FK | Obrigatório | Descrição        |
| ------------ | ------- | -- | -- | ----------- | ---------------- |
| ID_Ser       | INT | ✅ |    | Sim         | ID do ser        |
| Nome         | CHAR(100)   |    |    | Sim         | Nome             |
| Max_HP       | INT |    |    | Sim         | Vida máxima      |
| Str          | INT |    |    | Sim         | Força            |
| Dex          | INT |    |    | Sim         | Destreza         |
| Def          | INT |    |    | Sim         | Defesa           |
| Vantagens    | CHAR(200)   |    |    | Não         | Vantagens        |
| Desvantagens | CHAR(200)   |    |    | Não         | Desvantagens     |
| Rad_dano     | INT |    |    | Não         | Dano de radiação |
| Membros      | CHAR(10)   |    |    | Não         | Membros do corpo |

---

### 🧩 **Item_Controle**

| Atributo | Tipo    | PK | FK | Obrigatório | Descrição                    |
| -------- | ------- | -- | -- | ----------- | ---------------------------- |
| ID_Item  | INT | ✅ |    | Sim         | ID do item                   |
| Tipo     | CHAR(15)   |    |    | Sim         | Tipo de item (equip/mutação) |

---

### 🧩 **Coletável**

| Atributo     | Tipo    | PK | FK              | Obrigatório | Descrição                 |
| ------------ | ------- | -- | --------------- | ----------- | ------------------------- |
| ID_Item      | INT | ✅ |  Item_Controle  | Sim         | ID do equipamento/mutação |
| Nome         | CHAR(100)   |    |                 | Sim         | Nome                      |

---

### 🧩 **Equipamento**

| Atributo     | Tipo    | PK | FK              | Obrigatório | Descrição                 |
| ------------ | ------- | -- | --------------- | ----------- | ------------------------- |
| ID_Item      | INT | ✅ |  Item_Controle  | Sim         | ID do equipamento/mutação |
| Nome         | CHAR(100)   |    |                 | Sim         | Nome                      |
| Nível        | INT |    |                 | Sim         | Nível do item             |
| Parte_Corpo  | CHAR(10)   |    |                 | Sim         | Parte do corpo afetada    |

---

### 🧩 **Mutação**

| Atributo    | Tipo    | PK | FK              | Obrigatório | Descrição                 |
| ------------| ------- | -- | --------------- | ----------- | ------------------------- |
| ID_Item     | INT | ✅ |  Item_Controle  | Sim         | ID do equipamento/mutação |
| Nome        | CHAR(100)   |    |                 | Sim         | Nome                      |
| Nível       | INT |    |                 | Sim         | Nível do item             |
| Parte_Corpo | CHAR(10)   |    |                 | Sim         | Parte do corpo afetada    |

---

### 🧩 **Inventário**

| Atributo        | Tipo    | PK | FK             | Obrigatório | Descrição             |
| --------------- | ------- | -- | ---------------| ----------- | --------------------- |
| Pos_Inventário  | INT | ✅ |                | Sim         | Posição no inventário |
| ID_Item         | INT |    | Item_Controle  | Sim         | Item armazenado       |
| Quantidade      | INT |    |                | Sim         | Quantidade            |

---

### 🧩 **Mutação_Atual**

| Atributo | Tipo    | PK | FK                    | Obrigatório | Descrição          |
| -------- | ------- | -- | --------------------- | ----------- | -------------------|
| ID_Ser   | INT | ✅ | Ser_Controle          | Sim         | ID do ser          |
| Cabeça   | INT |    | Mutação               | Não         | Mutação na cabeça  |
| Torso    | INT |    | Mutação               | Não         | Mutação no torso   |
| Mãos     | INT |    | Mutação               | Não         | Mutação nas mãos   |
| Pernas   | INT |    | Mutação               | Não         | Mutação nas pernas |
| Pés      | INT |    | Mutação               | Não         | Mutação nos pés    |

---

### 🧩 **Equipamento_Atual**

| Atributo | Tipo    | PK | FK                    | Obrigatório | Descrição                     |
| -------- | ------- | -- | --------------------- | ----------- | ----------------------------- |
| ID_Ser   | INT | ✅ | Ser_Controle          | Sim         | ID do ser                     |
| Cabeça   | INT |    | Equipamento           | Não         | Equipamento na cabeça         |
| Torso    | INT |    | Equipamento           | Não         | Equipamento no torso          |
| Mãos     | INT |    | Equipamento           | Não         | Equipamento nas mãos          |
| Pernas   | INT |    | Equipamento           | Não         | Equipamento nas pernas        |
| Pés      | INT |    | Equipamento           | Não         | Equipamento nos pés           |

---

### 🧩 **NpcDropa**

| Atributo         | Tipo    | PK | FK      | Obrigatório | Descrição                  |
| ---------------- | ------- | -- | ------- | ----------- | -------------------------- |
| ID_Ser           | INT | ✅ | ID_Ser  | Sim         | Qual NCP dropa             |
| ID_Item          | INT | ✅ | ID_Item | Sim         | Qual item dropa            |
| Chance           | INT |    |         | Sim         | Chance do NPC dropar algo  |

---

### 🧩 **Modificador**

| Atributo | Tipo    | PK | FK           | Obrigatório | Descrição            |
| -------- | ------- | -- | ------------ | ----------- | -------------------- |
| ID_Item  | INT | ✅ | Item_Controle| Sim         | Item relacionado     |
| Atributo | CHAR(15)   | ✅ |              | Sim         | Atributo afetado     |
| Valor    | INT |    |              | Sim         | Valor da modificação |

---

### 🧩 **Pontos de Interesse**

| Atributo    | Tipo    | PK | FK | Obrigatório | Descrição           |
| ----------- | ------- | -- | -- | ----------- | ------------------- |
| ID_PI       | INT | ✅ |    | Sim         | Identificador único |
| Nome        | CHAR(100)   |    |    | Sim         | Nome do local       |
| Localização | CHAR(20)   |    |    | Sim         | Posição do local    |
| Nível_Rad   | INT |    |    | Sim         | Nível de radiação   |

---

### 🧩 **Base**

| Atributo   | Tipo    | PK | FK | Obrigatório | Descrição           |
| ---------- | ------- | -- | -- | ----------- | --------------------|
| Nome       | CHAR(100)   | ✅ |    | Sim         | Nome da base        |
| Localização| INT |    |    | Sim         | Localização da base |
| Nível_Rad  | INT |    |    | Sim         | Nível de radiação   |

---

### 🧩 **Instalação_Base**

| Atributo       | Tipo    | PK | FK | Obrigatório | Descrição                   |
| -------------- | ------- | -- | -- | ----------- | --------------------------- |
| ID_Instalação  | INT | ✅ |    | Sim         | Identificador da instalação |
| Nome           | CHAR(100)   |    |    | Sim         | Nome da instalação          |
| Nível          | INT |    |    | Sim         | Nível de dificuldade        |
| Requisito      | CHAR(200)   |    |    | Não         | Requisito necessário        |

---

### 🧩 **Evento**

| Atributo         | Tipo    | PK | FK | Obrigatório | Descrição            |
| ---------------- | ------- | -- | -- | ----------- | -------------------- |
| ID_Evento        | INT | ✅ |    | Sim         | ID do evento         |
| Max_Ocorrências  | INT   |    |    | Sim         | Ocorrências máximas  |

---


### 🧩 **Ocorre**

| Atributo   | Tipo    | PK | FK                  | Obrigatório | Descrição                       |
| ---------- | ------- | -- | ------------------- | ----------- | ------------------------------- |
| ID_Evento  | INT | ✅ | Evento              | Sim         | Identificador único evento      | 
| ID_PI      | INT | ✅ | Ponto de Interesse  | Sim         | Identificador único PI          |

---

### 🧩 **Requisito**

| Atributo   | Tipo    | PK | FK     | Obrigatório | Descrição             |
| ---------- | ------- | -- | ------ | ----------- | ----------------------|
| ID_Evento  | INT | ✅ |        | Sim         | Evento relacionado    |
| Req        | CHAR(200)   | ✅ |        | Sim         | Requisito para evento |
| Status     | BOOLEAN   |    |        | Sim         | Status do requisito   |

---

### 🧩 **EventoDropa**

| Atributo   | Tipo    | PK | FK            | Obrigatório | Descrição              |
| ---------- | ------- | -- | ------------- | ----------- | ---------------------- |
| ID_Evento  | INT | ✅ | Evento        | Sim         | Evento em questão      | 
| ID_Ser     | INT | ✅ | Ser_Controle  | Sim         | Ser que participa      |
| Req        | CHAR(200)   |    | ID_Evento     | Sim         | Requisitos para evento |

---

### 🧩 **Missão**

| Atributo         | Tipo    | PK | FK     | Obrigatório | Descrição                  |
| ---------------- | ------- | -- | ------ | ----------- | -------------------------- |
| ID_Evento        | INT | ✅ | Evento | Sim         | Evento relacionado         |
| Max_Ocorrências  | INT   |    |        | Sim         | Ocorrências máximas        |
| Status           | INT   |    |        | Sim         | Status da missão           |
| Prox             | INT   |    |        | Não         | Próxima missão, se existir |

---
