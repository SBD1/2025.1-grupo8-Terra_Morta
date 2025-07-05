from frontend.Acontecimento_mundo import processar_acontecimentos

def explorar(self):
    print('\nVocê explora o local em busca de algo interessante...')
    # Gasta sede ao explorar
    sede_atual, sede_max = self.get_sede()
    nova_sede = max(0, sede_atual - 10)
    self.set_sede(nova_sede)
    print(f'\nSua boca fica um pouco mais seca, isso custou 10 de sede.')
    if nova_sede <= 0:
        nome_prota = self.get_nome()
        print(f'\n{nome_prota} ficou desidratado demais para continuar, voltou para casa e descansou.\n')
        self.set_localizacao(1)  # 1 = Base
        self.set_sede(sede_max)
        self.localAtual = 1
        input('Pressione Enter para continuar.')
        return
    with self.get_conn() as conn:
        teve_acontecimento = processar_acontecimentos(conn, self.localAtual, self)
        if not teve_acontecimento:
            print('\nVocê não encontrou nada de especial desta vez.')
            input('Pressione Enter para continuar.')
