#Include "Protheus.ch"
#Include "Totvs.ch"


User Function yMsgYesNo()
Local cTitulo  := "Seja Bem-vindo!"
Local cMsg     := "Tudo bem?"
Local lRtrn     := .F.
 
MsgYesNo(cTitulo, cMsg)

IF lRtrn
    MsgInfo("Tudo bem!", "Resposta")
ELSE
    MsgInfo("Não está tudo bem!", "Resposta")
ENDIF

Return
