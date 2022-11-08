//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function zRelFwEx()
    Local aArea        := GetArea()
    Local oFWMsExcel
    Local oExcel
    Local cArquivo    := GetTempPath()+'zTstExc1.xml'
 
   BeginSql alias 'QRY'
        SELECT SA1.R_E_C_N_O_ AS RECNO
        FROM %table:SA1% AS SA1
        WHERE SA1.A1_FILIAL = %exp:xFilial("SA1")%
            AND SA1.%notDel%
    EndSql

    oFWMsExcel := FWMSExcel():New() 
    oFWMsExcel:AddworkSheet("Clientes")
        
        oFWMsExcel:AddTable("Clientes","Dados dos Clientes")
            oFWMsExcel:AddColumn("Clientes","Dados dos Clientes","Codigo",1)
            oFWMsExcel:AddColumn("Clientes","Dados dos Clientes","Descricao",1)
            oFWMsExcel:AddColumn("Clientes","Dados dos Clientes","Endereço",1)
            oFWMsExcel:AddColumn("Clientes","Dados dos Clientes","CNPJ/CPF",1)

            While !(QRY->(EoF()))
            DbSelectArea('SA1')
            SA1->(DbGoTop()) 
            SA1->(DbGoTo(QRY->RECNO))
                oFWMsExcel:AddRow("Clientes","Dados dos Clientes",{;
                    SA1->A1_COD, SA1->A1_NOME,;
                    SA1->A1_END, SA1->A1_CGC })

                QRY->(DbSkip())
            EndDo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    oExcel := MsExcel():New()             
    oExcel:WorkBooks:Open(cArquivo)     
    oExcel:SetVisible(.T.)                
    oExcel:Destroy()                       
     
    QRY->(DbCloseArea())
    RestArea(aArea)
Return
