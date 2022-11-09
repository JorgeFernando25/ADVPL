#Include "Protheus.ch"
#include "TBICONN.CH"

User Function zCrExAut()
    Local cFunc  := " "
    Local aPergs := {}
    Local aCombo := {"1", "3", "4", "5", "6"}

    aAdd(aPergs, {2, "Escolha a fun��o",  "3",  aCombo, 50, "", .F.})

    If ParamBox(aPergs, "Informe os par�metros")
        
        cFunc := Val(mv_par01)
        
        lDeuCerto := .F.
  
        //Pegando o modelo de dados, setando a opera��o de inclus�o
        oModel := FWLoadModel("MATA030")
        oModel:SetOperation(cFunc)
        oModel:Activate()
        
        
        //Pegando o model dos campos da SA1
        oSA1Mod:= oModel:getModel("MATA030_SA1")
        oSA1Mod:setValue("A1_COD",       GetSxeNum("SA1", "A1_COD") ) // Codigo 
        oSA1Mod:setValue("A1_LOJA",      "01"                       ) // Loja
        oSA1Mod:setValue("A1_NOME",      "Samsung"                  ) // Nome             
        oSA1Mod:setValue("A1_NREDUZ",    "Sams"                     ) // Nome reduz. 
        oSA1Mod:setValue("A1_END",       "R. 501"                   ) // Endereco
        oSA1Mod:setValue("A1_TIPO",      "F"                        ) // Tipo 
        oSA1Mod:setValue("A1_EST",       "CE"                       ) // Estado
        oSA1Mod:setValue("A1_MUN",       "Fortaleza"                ) // Municipio

        
        //Se conseguir validar as informa��es
        If oModel:VldData()
            
            //Tenta realizar o Commit
            If oModel:CommitData()
                lDeuCerto := .T.
                
            //Se n�o deu certo, altera a vari�vel para false
            Else
                lDeuCerto := .F.
            EndIf
            
        //Se n�o conseguir validar as informa��es, altera a vari�vel para false
        Else
            lDeuCerto := .F.
        EndIf
        
        //Se não deu certo a inclus�o, mostra a mensagem de erro
        If ! lDeuCerto
            //Busca o Erro do Modelo de Dados
            aErro := oModel:GetErrorMessage()
            
            //Monta o Texto que será mostrado na tela
            AutoGrLog("Id do formul�rio de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
            AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
            AutoGrLog("Id do formul�rio de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
            AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
            AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
            AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
            AutoGrLog("Mensagem da solu��o: "        + ' [' + AllToChar(aErro[07]) + ']')
            AutoGrLog("Valor atribu�do: "            + ' [' + AllToChar(aErro[08]) + ']')
            AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
            
            //Mostra a mensagem de Erro
            MostraErro()
        EndIf
        
        //Desativa o modelo de dados
        oModel:DeActivate() 
        EndIf
Return
