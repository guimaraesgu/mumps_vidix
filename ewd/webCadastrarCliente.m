webCadastrarCliente ;---[FormSubmit]

setClient(sessid) ;
 s msg=""
 s clientRegNumber=$$getSessionValue^%zewdAPI("clientRegNumber",sessid)
 s clientTypeSelect=$$getSessionValue^%zewdAPI("clientTypeSelect",sessid)
 s clientRS=$ZCONVERT($$getSessionValue^%zewdAPI("clientRS",sessid),"U")
 s clientDtCad=+$h
 s clientDtFund=$$getSessionValue^%zewdAPI("clientDtFund",sessid)
 s mesDtFund=$EXTRACT(clientDtFund,6,7)
 s diaDtFund=$EXTRACT(clientDtFund,9,10)
 s anoDtFund=$EXTRACT(clientDtFund,1,4)
 s clientDtFund=$$CDN^%H(mesDtFund_"/"_diaDtFund_"/"_anoDtFund)
 s clientFamily=$$getSessionValue^%zewdAPI("clientFamily",sessid)
 s limiteCred=$TR($$getSessionValue^%zewdAPI("limiteCred",sessid),".,","")
 s saleType=$$getSessionValue^%zewdAPI("saleType",sessid)
 s clientCEP=$$getSessionValue^%zewdAPI("clientCEP",sessid)
 s clientStreet=$ZCONVERT($$getSessionValue^%zewdAPI("clientStreet",sessid),"U")
 s clientNeighb=$ZCONVERT($$getSessionValue^%zewdAPI("clientNeighb",sessid),"U")
 s clientCity=$ZCONVERT($$getSessionValue^%zewdAPI("clientCity",sessid),"U")
 s clientUF=$$getSessionValue^%zewdAPI("clientUF",sessid)
 s clientIBGE=$$getSessionValue^%zewdAPI("clientIBGE",sessid)
 s clientName=$ZCONVERT($$getSessionValue^%zewdAPI("clientName",sessid),"U")
 s clientPhone=$$getSessionValue^%zewdAPI("clientPhone",sessid)
 s clientEmail=$ZCONVERT($$getSessionValue^%zewdAPI("clientEmail",sessid),"L")
 s payOpt=$$getSessionValue^%zewdAPI("payOpt",sessid)
 s payTax=$$getSessionValue^%zewdAPI("payTax",sessid)
 if clientTypeSelect="J" do
 . set clientCNPJ=$$getSessionValue^%zewdAPI("clientCNPJ",sessid)
 . if clientCNPJ'=0 If $d(^FTCLIj(clientCNPJ)) set msg="Erro no Cadastro. CNPJ já cadastrado" goto sair
 . set clientIE=""
 . set clientIE=$$getSessionValue^%zewdAPI("clientIE",sessid)
 . set ^FTCLI(clientRegNumber)=clientRS_"^"_clientStreet_"^"_clientNeighb_"^"_clientCity_"^"_clientUF_"^"_clientCEP_"^"_clientPhone_"^"_clientCNPJ_"^"_clientIE_"^"_clientEmail_"^^^"_clientName_"^"_clientFamily_"^"_clientDtFund_"^"_clientDtCad_"^0^^^^^^"_clientIBGE_"^"
 . set ^FTCLIj(clientCNPJ,clientRegNumber)=""
 . set ^FTCLIa(clientRS,clientRegNumber)=""
 . if payOpt'="" do 
 .. set ^FTNEG(clientRegNumber)=limiteCred_"^"_saleType_"^"
 .. set ^FTNEG(clientRegNumber,payOpt)=payTax_"^S^"
 . set proxClientRegNumber=clientRegNumber+1
 . set ^FTCLIprox(0)=proxClientRegNumber
 if clientTypeSelect="I" do
 . set clientCNPJ=$$getSessionValue^%zewdAPI("clientCNPJ",sessid)
 . if clientCNPJ'=0 If $d(^FTCLIj(clientCNPJ)) set msg="Erro no Cadastro. CNPJ já cadastrado" goto sair
 . set clientIE=""
 . set clientIE=$$getSessionValue^%zewdAPI("clientIE",sessid)
 . set ^FTCLI(clientRegNumber)=clientRS_"^"_clientStreet_"^"_clientNeighb_"^"_clientCity_"^"_clientUF_"^"_clientCEP_"^"_clientPhone_"^"_clientCNPJ_"^"_clientIE_"^"_clientEmail_"^^^"_clientName_"^"_clientFamily_"^"_clientDtFund_"^"_clientDtCad_"^0^^^^^^"_clientIBGE_"^"
 . set ^FTCLIj(clientCNPJ,clientRegNumber)=""
 . set ^FTCLIa(clientRS,clientRegNumber)=""
 . if payOpt'="" do 
 .. set ^FTNEG(clientRegNumber)=limiteCred_"^"_saleType_"^"
 .. set ^FTNEG(clientRegNumber,payOpt)=payTax_"^S^"
 . set proxClientRegNumber=clientRegNumber+1
 . set ^FTCLIprox(0)=proxClientRegNumber
 if clientTypeSelect="F" do
 . set clientCPF=$$getSessionValue^%zewdAPI("clientCPF",sessid) 
 . if clientCPF'=0 If $d(^FTCLIc(clientCPF)) set msg="Erro no Cadastro. CPF já cadastrado" goto sair
 . set clientIE=""
 . set clientIE=$$getSessionValue^%zewdAPI("clientIE",sessid)
 . set ^FTCLI(clientRegNumber)=clientRS_"^"_clientStreet_"^"_clientNeighb_"^"_clientCity_"^"_clientUF_"^"_clientCEP_"^"_clientPhone_"^"_clientCPF_"^"_clientIE_"^"_clientEmail_"^^^"_clientName_"^"_clientFamily_"^"_clientDtFund_"^"_clientDtCad_"^0^^^^^^"_clientIBGE_"^"
 . set ^FTCLIc(clientCPF,clientRegNumber)=""
 . set ^FTCLIa(clientRS,clientRegNumber)=""
 . if payOpt'="" do 
 .. set ^FTNEG(clientRegNumber)=limiteCred_"^"_saleType_"^"
 .. set ^FTNEG(clientRegNumber,payOpt)=payTax_"^S^"
 . set proxClientRegNumber=clientRegNumber+1
 . set ^FTCLIprox(0)=proxClientRegNumber

sair ;
 do deleteFromSession^%zewdAPI("clientRegNumber",sessid)
 do deleteFromSession^%zewdAPI("clientTypeSelect",sessid)
 do deleteFromSession^%zewdAPI("clientRS",sessid)
 do deleteFromSession^%zewdAPI("clientDtFund",sessid)
 do deleteFromSession^%zewdAPI("clientFamily",sessid)
 do deleteFromSession^%zewdAPI("limiteCred",sessid)
 do deleteFromSession^%zewdAPI("saleType",sessid)
 do deleteFromSession^%zewdAPI("clientCEP",sessid)
 do deleteFromSession^%zewdAPI("clientStreet",sessid)
 do deleteFromSession^%zewdAPI("clientNeighb",sessid)
 do deleteFromSession^%zewdAPI("clientCity",sessid)
 do deleteFromSession^%zewdAPI("clientUF",sessid)
 do deleteFromSession^%zewdAPI("clientIBGE",sessid)
 do deleteFromSession^%zewdAPI("clientName",sessid)
 do deleteFromSession^%zewdAPI("clientPhone",sessid)
 do deleteFromSession^%zewdAPI("clientEmail",sessid)
 do deleteFromSession^%zewdAPI("clientCNPJ",sessid)
 do deleteFromSession^%zewdAPI("clientCPF",sessid)
 do deleteFromSession^%zewdAPI("clientIE",sessid)
 do deleteFromSession^%zewdAPI("payOpt",sessid)
 do deleteFromSession^%zewdAPI("payTax",sessid)
 QUIT:$QUIT msg QUIT