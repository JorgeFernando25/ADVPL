#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
 
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Colunas
#Define COL_GRUPO   0015
#Define COL_DESCR   0095

//Cores
#Define COR_CINZA   RGB(180, 180, 180)
#Define COR_PRETO   RGB(000, 000, 000)
 
User Function zRelFwPr()
    Local lAdjustToLegacy := .F.
    Local lDisableSetup := .T.
    Local oPrinter
    Local cNomeFont := "Arial"
    Local oFontDet  := TFont():New(cNomeFont, 9, 10, .T., .F., 5, .T., 5, .T., .F.)
    Local nLinha    := 80
    Local cTexto    := ""
    Local nTamLin   := 010
    Local nLinCab   := 030
    Local nColIni   := 010
    Local nColFin   := 550
    Local nColMeio  := (nColFin-nColIni)/2
    Local oFontDetN := TFont():New(cNomeFont, 9, -10, .T., .T., 5, .T., 5, .T., .F.)
    Local oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)


    oPrinter := FWMSPrinter():New("Relatório_", IMP_PDF, lAdjustToLegacy, , lDisableSetup)
    oPrinter:SetResolution(72)
    oPrinter:SetPortrait()
    oPrinter:SetPaperSize(DMPAPER_A4)
    oPrinter:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
    oPrinter:cPathPDF := "C:\Relatórios\" // Caso seja utilizada impressão em IMP_PDF

    // DbSelectArea("QRY")
    // QRY->(DbGoTop())
    // QRY->(DbSetOrder(1))
    // QRY->(DbSeek("000010" + "001"))
    // QRY->(Eof())
    // QRY->(DbCloseArea())
    // QRY->(DbSkip())

    BeginSql alias 'QRY'
        SELECT SA1.R_E_C_N_O_ AS RECNO
        FROM %table:SA1% AS SA1
        WHERE SA1.A1_FILIAL = %exp:xFilial("SA1")%
            AND SA1.%notDel%
    EndSql
        
    DbSelectArea("QRY")

    while !QRY->(Eof())
        DbSelectArea('SA1')
        SA1->(DbGoTop()) 
        SA1->(DbGoTo(QRY->RECNO))

            oPrinter:SayAlign(nLinha, 15, SA1->A1_COD, oFontDet, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrinter:SayAlign(nLinha, 95, SA1->A1_NOME,  oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrinter:SayAlign(nLinha, 220, SA1->A1_END, oFontDet, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrinter:SayAlign(nLinha, 320, SA1->A1_CGC, oFontDet, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinha += nTamLin
        
        QRY->(DbSkip())   
    end
    
    QRY->(DbCloseArea())

    cTexto := "Relação de Clientes"
    oPrinter:SayAlign(nLinCab, nColMeio - 120, cTexto, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
     
    //Linha Separatória
    nLinCab += (nTamLin * 2)
    oPrinter:Line(nLinCab, nColIni, nLinCab, nColFin, COR_PRETO)
     
    //Cabeçalho das colunas
    nLinCab += nTamLin
    oPrinter:SayAlign(nLinCab, 15, "Grupo",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrinter:SayAlign(nLinCab, 95, "Nome", oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrinter:SayAlign(nLinCab, 220, "Endereço", oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrinter:SayAlign(nLinCab, 320, "CNPJ/CPF", oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin

    oPrinter:Preview()
Return
