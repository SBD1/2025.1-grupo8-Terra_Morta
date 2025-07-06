import psycopg
import os

class Atributos:
    def __init__(self, estado):
        self.estado = estado  # EstadoNormal

    def get_conn(self):
        return psycopg.connect(**self.estado.db_params)

    def visualizar_atributos(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        with self.get_conn() as conn:
            cur = conn.cursor()
            # Busca os atributos da instância atual do protagonista
            cur.execute('''
                SELECT hp_max, hp_atual, str_atual, dex_atual, def_atual, res_fogo_at, res_gelo_at, res_elet_at, res_radi_at, res_cort_at, res_cont_at, fome_max, fome_atual, sede_max, sede_atual, carga_max, carga_atual, rad_atual, localizacao
                FROM inst_prota
                WHERE id_ser = %s
                ORDER BY id_inst DESC LIMIT 1
            ''', (self.estado.id_prota,))
            inst = cur.fetchone()
            cur.execute('''
                SELECT nome, hp_base, str_base, dex_base, def_base, res_fogo, res_gelo, res_elet, res_radi, res_cort, res_cont, fome_base, sede_base, carga_base
                FROM prota
                WHERE id_ser = %s
            ''', (self.estado.id_prota,))
            base = cur.fetchone()
        print('\n--- Atributos do Protagonista ---')
        if base:
            print(f"Nome: {base[0].strip()}")
            print(f"HP Base: {base[1]}")
            print(f"STR Base: {base[2]}")
            print(f"DEX Base: {base[3]}")
            print(f"DEF Base: {base[4]}")
            print(f"Resistências Base: Fogo={base[5]}, Gelo={base[6]}, Elet={base[7]}, Radi={base[8]}, Cort={base[9]}, Cont={base[10]}")
            print(f"Fome Base: {base[11]}")
            print(f"Sede Base: {base[12]}")
            print(f"Carga Base: {base[13]}")
        if inst:
            print(f"\n--- Status Atuais ---")
            print(f"HP: {inst[1]}/{inst[0]}")
            print(f"STR: {inst[2]}")
            print(f"DEX: {inst[3]}")
            print(f"DEF: {inst[4]}")
            print(f"Resistências: Fogo={inst[5]}, Gelo={inst[6]}, Elet={inst[7]}, Radi={inst[8]}, Cort={inst[9]}, Cont={inst[10]}")
            print(f"Fome: {inst[12]}/{inst[11]}")
            print(f"Sede: {inst[14]}/{inst[13]}")
            print(f"Carga: {inst[16]}/{inst[15]}")
            print(f"Radiação Atual: {inst[17]}")
            print(f"Localização (id): {inst[18]}")
        input('\nPressione Enter para continuar.')
