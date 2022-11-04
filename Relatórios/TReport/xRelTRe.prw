#INCLUDE 'protheus.ch'
#INCLUDE 'topconn.ch'

User Function xRelTRe()
    Local cProdDe  := Space(TamSX3('B1_COD')[01])
    Local cProdAt  := Space(TamSX3('B1_COD')[01])
    Local aPergs   := {}
    
    aAdd(aPergs, {1, "Produto De",  cProdDe,  "", ".T.", "SB1", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Produto Até", cProdAt,  "", ".T.", "SB1", ".T.", 80,  .T.})
    
    If ParamBox(aPergs, "Informe os parâmetros")

        ReportDef()

    EndIf

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbCloseArea())
	EndIF
	
Return

Static Function ReportDef()
    Private oReport := Nil
    Private oSecCab := Nil
	oReport := TReport():New("RCOMR01","Cadastro de Produtos",,{|oReport| PrintReport()},"Impressão de cadastro de produtos.")
	oReport:SetLandscape(.T.)
	oSecCab := TRSection():New( oReport , "Produtos", "QRY")
	
	TRCell():New( oSecCab, "B1_COD"     , "QRY")
	TRCell():New( oSecCab, "B1_DESC"    , "QRY")
	TRCell():New( oSecCab, "B1_TIPO"    , "QRY")
	TRCell():New( oSecCab, "BM_DESC"    , "QRY")
    TRCell():New( oSecCab, "B1_PRV1"    , "QRY")
    TRCell():New( oSecCab, "B2_QATU"    , "QRY")
    TRCell():New( oSecCab, "B2_CM1 "    , "QRY")
    TRCell():New( oSecCab, "CustoTotal" , "QRY", "Custo Total")
    TRFunction():New(oSecCab:Cell("B1_COD"), , "COUNT", , , , , .F., .T., .F., oSecCab)

    oReport:PrintDialog()
Return

Static Function PrintReport()
    BeginSql alias 'QRY'
        SELECT 
            SB1.B1_COD, SB1.B1_DESC, 
            SB1.B1_TIPO, SB1.B1_UM,
            B1_PRV1, SBM.BM_DESC,
            B2_CM1, B2_QATU,
            (B2_CM1 * B2_QATU) AS CustoTotal
        FROM  %table:SB1% SB1   
            LEFT JOIN %table:SBM% SBM ON (SB1.B1_FILIAL = SBM.BM_FILIAL AND SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.%notDel%)
            LEFT JOIN %table:SB2% SB2 ON (SB1.B1_FILIAL = SB2.B2_FILIAL AND SB1.B1_COD = SB2.B2_COD AND SB2.%notDel%)
        WHERE SB1.B1_FILIAL = %exp:xFilial("SB1")%
            AND SB1.B1_COD BETWEEN %exp:mv_par01% AND %exp:mv_par02%
            AND SB1.%notDel%

    EndSql

	oSecCab:Print()
Return
