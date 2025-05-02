
### 🧩 **Facção**

| Atributo   | Tipo    | PK | FK | Obrigatório | Descrição                     |
| ---------- | ------- | -- | -- | ----------- | ----------------------------- |
| ID_Facção  | Inteiro | ✅ |    | Sim         | Identificador único da facção |

---

### 🧩 **Ser_Controle**

| Atributo | Tipo    | PK | FK | Obrigatório | Descrição                      |
| -------- | ------- | -- | -- | ----------- | ------------------------------ |
| ID_Ser   | Inteiro | ✅ |    | Sim         | Identificador único do ser     |
| Tipo     | Texto   |    |    | Sim         | Tipo do ser (Prota, NPC, etc.) |

---

### 🧩 **Prota**

| Atributo     | Tipo    | PK | FK            | Obrigatório | Descrição                  |
| ------------ | ------- | -- | ------------- | ----------- | -------------------------- |
| ID_Ser       | Inteiro | ✅ | Ser_Controle  | Sim         | Identificador do ser       |
| Nome         | Texto   |    |               | Sim         | Nome do personagem         |
| Max_HP       | Inteiro |    |               | Sim         | Vida máxima                |
| Str          | Inteiro |    |               | Sim         | Força                      |
| Dex          | Inteiro |    |               | Sim         | Destreza                   |
| Def          | Inteiro |    |               | Sim         | Defesa                     |
| Vantagens    | Texto   |    |               | Não         | Vantagens do personagem    |
| Desvantagens | Texto   |    |               | Não         | Desvantagens do personagem |
| Facção       | Inteiro |    | Facção        | Sim         | Facção à qual pertence     |
| Fome         | Inteiro |    |               | Não         | Fome do personagem         |
| Sede         | Inteiro |    |               | Não         | Sede                       |
| Rad_Atual    | Inteiro |    |               | Não         | Radiação atual             |
| Cap_Carga    | Inteiro |    |               | Não         | Capacidade de carga        |
| Localização  | Texto   |    |               | Não         | Localização atual          |

---

### 🧩 **Inteligentes**

| Atributo     | Tipo    | PK | FK     | Obrigatório | Descrição             |
| ------------ | ------- | -- | ------ | ----------- | --------------------- |
| ID_Ser       | Inteiro | ✅ |        | Sim         | ID do ser inteligente |
| Nome         | Texto   |    |        | Sim         | Nome                  |
| Max_HP       | Inteiro |    |        | Sim         | Vida máxima           |
| Str          | Inteiro |    |        | Sim         | Força                 |
| Dex          | Inteiro |    |        | Sim         | Destreza              |
| Def          | Inteiro |    |        | Sim         | Defesa                |
| Vantagens    | Texto   |    |        | Não         | Vantagens             |
| Desvantagens | Texto   |    |        | Não         | Desvantagens          |
| Alinhamento  | Texto   |    |        | Não         | Alinhamento moral     |
| Facção       | Inteiro |    | Facção | Não         | Facção associada      |

---

### 🧩 **Não_Inteligentes**

| Atributo     | Tipo    | PK | FK | Obrigatório | Descrição        |
| ------------ | ------- | -- | -- | ----------- | ---------------- |
| ID_Ser       | Inteiro | ✅ |    | Sim         | ID do ser        |
| Nome         | Texto   |    |    | Sim         | Nome             |
| Max_HP       | Inteiro |    |    | Sim         | Vida máxima      |
| Str          | Inteiro |    |    | Sim         | Força            |
| Dex          | Inteiro |    |    | Sim         | Destreza         |
| Def          | Inteiro |    |    | Sim         | Defesa           |
| Vantagens    | Texto   |    |    | Não         | Vantagens        |
| Desvantagens | Texto   |    |    | Não         | Desvantagens     |
| Rad_dano     | Inteiro |    |    | Não         | Dano de radiação |
| Membros      | Texto   |    |    | Não         | Membros do corpo |

---

### 🧩 **Mutação_Atual**

| Atributo | Tipo    | PK | FK                    | Obrigatório | Descrição          |
| -------- | ------- | -- | --------------------- | ----------- | -------------------|
| ID_Ser   | Inteiro | ✅ | Ser_Controle          | Sim         | ID do ser          |
| Cabeça   | Inteiro |    |            Mutação    | Não         | Mutação na cabeça  |
| Torso    | Inteiro |    |            Mutação    | Não         | Mutação no torso   |
| Mãos     | Inteiro |    |            Mutação    | Não         | Mutação nas mãos   |
| Pernas   | Inteiro |    |            Mutação    | Não         | Mutação nas pernas |
| Pés      | Inteiro |    |            Mutação    | Não         | Mutação nos pés    |

---

### 🧩 **Equipamento_Atual**

| Atributo | Tipo    | PK | FK                    | Obrigatório | Descrição                     |
| -------- | ------- | -- | --------------------- | ----------- | ----------------------------- |
| ID_Ser   | Inteiro | ✅ | Ser_Controle          | Sim         | ID do ser                     |
| Cabeça   | Inteiro |    | Equipamento           | Não         | Equipamento na cabeça         |
| Torso    | Inteiro |    |       Equipamento     | Não         | Equipamento no torso          |
| Mãos     | Inteiro |    |    Equipamento        | Não         | Equipamento nas mãos          |
| Pernas   | Inteiro |    |  Equipamento          | Não         | Equipamento nas pernas        |
| Pés      | Inteiro |    |         Equipamento   | Não         | Equipamento nos pés           |

---
### 🧩 **Equipamento**

| Atributo     | Tipo    | PK | FK              | Obrigatório | Descrição                 |
| ------------ | ------- | -- | --------------- | ----------- | ------------------------- |
| ID_Item      | Inteiro | ✅ |  Item_Controle  | Sim         | ID do equipamento/mutação |
| Nome         | Texto   |    |                 | Sim         | Nome                      |
| Nível        | Inteiro |    |                 | Sim         | Nível do item             |
| Parte_Corpo  | Texto   |    |                 | Sim         | Parte do corpo afetada    |

---

### 🧩 **Mutação**

| Atributo    | Tipo    | PK | FK              | Obrigatório | Descrição                 |
| ------------| ------- | -- | --------------- | ----------- | ------------------------- |
| ID_Item     | Inteiro | ✅ |  Item_Controle  | Sim         | ID do equipamento/mutação |
| Nome        | Texto   |    |                 | Sim         | Nome                      |
| Nível       | Inteiro |    |                 | Sim         | Nível do item             |
| Parte_Corpo | Texto   |    |                 | Sim         | Parte do corpo afetada    |

---
### 🧩 **Inventário**

| Atributo        | Tipo    | PK |      FK        | Obrigatório | Descrição             |
| --------------- | ------- | -- | ---------------| ----------- | --------------------- |
| Pos_Inventário  | Inteiro | ✅ |                | Sim         | Posição no inventário |
| ID_Item         | Inteiro |    | Item_Controle  | Sim         | Item armazenado       |
| Quantidade      | Inteiro |    |                | Sim         | Quantidade            |

---

### 🧩 **Item_Controle**

| Atributo | Tipo    | PK | FK | Obrigatório | Descrição                    |
| -------- | ------- | -- | -- | ----------- | ---------------------------- |
| ID_Item  | Inteiro | ✅ |    | Sim         | ID do item                   |
| Tipo     | Texto   |    |    | Sim         | Tipo de item (equip/mutação) |

---

### 🧩 **Modificador**

| Atributo | Tipo    | PK |      FK     | Obrigatório | Descrição            |
| -------- | ------- | -- | ------------| ----------- | -------------------- |
| ID_Item  | Inteiro | ✅ |Item_Controle| Sim         | Item relacionado     |
| Atributo | Texto   | ✅ |             | Sim         | Atributo afetado     |
| Valor    | Inteiro |    |             | Sim         | Valor da modificação |

---

### 🧩 **Evento**

| Atributo         | Tipo    | PK | FK | Obrigatório | Descrição            |
| ---------------- | ------- | -- | -- | ----------- | -------------------- |
| ID_Evento        | Inteiro | ✅ |    | Sim         | ID do evento         |
| Max_Coordenadas  | Texto   |    |    | Sim         | Coordenadas máximas  |
| Recompensa       | Texto   |    |    | Sim         | Recompensa do evento |

---

### 🧩 **Requisitos**

| Atributo   | Tipo    | PK |   FK   | Obrigatório | Descrição             |
| ---------- | ------- | -- | ------ | ----------- | ----------------------|
| ID_Evento  | Inteiro | ✅ |        | Sim         | Evento relacionado    |
| Req        | Texto   |    |        | Sim         | Requisito para evento |
| Status     | Texto   |    |        | Sim         | Status do requisito   |

---



### 🧩 **EventoDropa**

| Atributo   | Tipo    | PK | FK            | Obrigatório | Descrição              |
| ---------- | ------- | -- | ------------- | ----------- | ---------------------- |
| ID_Evento  | Inteiro | ✅ | Evento        | Sim         | Evento em questão      | 
| ID_Ser     | Inteiro | ✅ | Ser_Controle  | Sim         | Ser que participa      |
| Req        | Texto   |    | ID_Evento     | Sim         | Requisitos para evento |

---
