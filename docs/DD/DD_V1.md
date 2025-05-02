---

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
