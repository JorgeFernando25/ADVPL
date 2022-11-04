#Include 'Fileio.ch'
#Include 'Protheus.ch'

User Function MT010INC
Local aCampos:= {}
Local nLinha

aadd(aCampos, "Codigo do Produto")
aadd(aCampos, SB1->B1_COD)
aadd(aCampos, "Descricao do Produto")
aadd(aCampos, SB1->B1_DESC)
aadd(aCampos, "Tipo do Produto")
aadd(aCampos, SB1->B1_TIPO)

aadd(aCampos, "Unidade")
aadd(aCampos, SB1->B1_UM)

nArquivo := Fcreate("C:\Relatorios\ARQUIVO.TXT", FC_NORMAL)
if ferror() # 0
  MsgAlert("ERRO AO CRIAR O ARQUIVO, ERRO: ", + str(ferror())) 
   lFalha := .t.
else
   for nLinha := 1 to len(aCampos)
       fwrite(nArquivo, aCampos[nLinha] + chr(13) + chr(10))
       if ferror() # 0
          MsgAlert("ERRO AO CRIAR O ARQUIVO, ERRO: ", + str(ferror())) 
          lFalha := .t.
       endif
   next
endif
fclose(nArquivo)
return
