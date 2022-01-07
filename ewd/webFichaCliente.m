webFichaCliente ;---- [Ficha Cliente | 11/05/2018 09:49]
 ;
montaFicha(sessid) ;---[ prePageScript ]
 set counter=0
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 do deleteFromSession^%zewdAPI("dataCadastro",sessid)
 do deleteFromSession^%zewdAPI("openOrders",sessid)
 do deleteFromSession^%zewdAPI("paymentArray",sessid)
 do deleteFromSession^%zewdAPI("contactsArray",sessid)
 do deleteFromSession^%zewdAPI("openTitles",sessid)
 do deleteFromSession^%zewdAPI("openInvoice",sessid)
 do deleteFromSession^%zewdAPI("nomcli",sessid)
 do deleteFromSession^%zewdAPI("endlogcli",sessid)
 do deleteFromSession^%zewdAPI("endbaicli",sessid)
 do deleteFromSession^%zewdAPI("endcidcli",sessid)
 do deleteFromSession^%zewdAPI("endufcli",sessid)
 do deleteFromSession^%zewdAPI("endcepcli",sessid)
 do deleteFromSession^%zewdAPI("ultimaCompra",sessid)
 do deleteFromSession^%zewdAPI("ultimoValor",sessid)
 do deleteFromSession^%zewdAPI("pedidos",sessid)
 do deleteFromSession^%zewdAPI("total",sessid)
 set codigo=$$getSessionValue^%zewdAPI("Cliente",sessid)
 do deleteFromSession^%zewdAPI("Cliente",sessid)
 set Limite=50
 set codcli=codigo
 set reg=^FTCLI(codigo)
 for i=1:1:27 set P(i)=$P(reg,"^",i)
 set ENDCOB=""
 If +P(18)'?1"" set ENDCOB=P(18)_" "_P(19)_"  "_P(20)_"-"_P(21)_" "_P(22)
 If $L(P(8))=14 set CGC=$E(P(8),1,2)_"."_$E(P(8),3,5)_"."_$E(P(8),6,8)_"/"_$E(P(8),9,12)_"-"_$E(P(8),13,14),TIPO="CNPJ"
 Else  set CGC=P(8),TIPO="CPF"
 set Classe=P(14)
 If Classe'="" set Classe=$P($G(^FTTCC(Classe)),"^",1)
 do setSessionValue^%zewdAPI("codcli",codigo,sessid)
 do setSessionValue^%zewdAPI("nomcli",P(1),sessid)
 do setSessionValue^%zewdAPI("endlogcli",P(2),sessid)
 do setSessionValue^%zewdAPI("endbaicli",P(3),sessid)
 do setSessionValue^%zewdAPI("endcidcli",P(4),sessid)
 do setSessionValue^%zewdAPI("endufcli",P(5),sessid)
 do setSessionValue^%zewdAPI("endcepcli",P(6),sessid)

 If ENDCOB'="" do setSessionValue^%zewdAPI("endcodcli",ENDCOB,sessid)
 do setSessionValue^%zewdAPI("telcli",P(7),sessid)
 do setSessionValue^%zewdAPI("concli",P(13),sessid)
 do setSessionValue^%zewdAPI("cgccli",CGC,sessid)
 do setSessionValue^%zewdAPI("iecli",P(9),sessid)
 do setSessionValue^%zewdAPI("classif",Classe,sessid)

;---- CONTATOS'
contatos ;
 set contatos="",dl="^"
 for  set contatos=$O(^FTCLI(codcli,contatos)) Q:contatos=""  D
  .set counter=counter+1
  .set reg=$G(^FTCLI(codcli,contatos))
  .quit:reg=""
  .set nome=$P(reg,dl,1)
  .set tel=$p(reg,dl,2)
  .set email=$p(reg,dl,3)
  .set contactsArray(counter)=nome_"^"_tel_"^"_email
  .quit
 set counter=0
 do mergeArrayToSession^%zewdAPI(.contactsArray,"contactsArray",sessid)
 ;

;---- FORMA DE PAGAMENTO''
forma ;
 set dadosPagtos=""
 for  set dadosPagtos=$O(^FTNEG(codcli,dadosPagtos)) Q:dadosPagtos=""  D
  .set counter=counter+1
  .set RX=$G(^(dadosPagtos))
  .set taxa=$P(RX,"^",1)
  .set forma=$p($g(^FTCPG(dadosPagtos)),"^",1)
  .set padrao=$P(RX,"^",2)
  .if padrao="S" set forma=forma_"(*)"
  .set paymentArray(counter)=forma_"^"_taxa
 set counter=0
 do mergeArrayToSession^%zewdAPI(.paymentArray,"paymentArray",sessid)
 ;
 
;---- ESTATISTICAS DO CLIENTE
stats ;
 set ultimaCompra=0,ultimoValor=0,pedidos=0,adiant=0
 set reg2=$g(^FTCLI2(codigo))
 set ultimaCompra=$P(reg2,"^",1)
 set ultimoValor=$P(reg2,"^",2)
 
 ;---- CHAMA FUNCAO Pedido DE PD.m, QUE FAZ O SOMATORIO DOS PEDIDOS EM ABERTO
 set pedidos=pedidos+$$Pedido^PD(codigo)
 do setSessionValue^%zewdAPI("dataCadastro",$$^Data(P(16)),sessid)
 do setSessionValue^%zewdAPI("ultimaCompra",$$^Data(ultimaCompra),sessid)
 do setSessionValue^%zewdAPI("ultimoValor",$$^Moeda(ultimoValor),sessid)
 do setSessionValue^%zewdAPI("pedidos",$$^Moeda(pedidos),sessid)
 ; 

;---- LISTA PEDIDOS EM ABERTO DO CLIENTE
 set codPed="",total=0,counter=0,regPed="",condPagto="",dtEntrega="",valor=0,numPed=0,cfop="",cr="",flagPronto="",alt=""
 set proxPed=^PDPAB(1)+1
pedidosAbertos ; 
 if numPed>proxPed goto pedidosAbertosMergeArrayToSession
 set numPed=numPed+1 
 if '$d(^PDPAB(1,10,codcli,numPed)) goto pedidosAbertos
 if '$d(^PDPAB(1,0,numPed)) goto pedidosAbertos 
 set counter=counter+1
 set regPed=$g(^PDPAB(1,0,numPed))
 set cfop=$P(regPed,"^",17),cr=$P(regPed,"^",16)
 if cfop'?1"" set cfop=$G(^FTNAT(cfop)),cfop=$p(cfop,"^",1)
 set cfop=cfop_" - "_cr
 set cpg="Excluida "
 set dtEntrega=$$^Data($p(regPed,"^",6))
 set condPagto=$p(regPed,"^",5)
 if condPagto'="" set condPagto=$p($g(^FTCPG(condPagto)),"^",1)
 set flagPronto="/img/atrasado.png",alt="Pedido a fazer"
 if $d(^PDPAB(1,15,numPed)) set flagPronto="/img/pronto.png",alt="Pedido pronto"
 if $d(^PDPAB(1,6,numPed)) set flagPronto="/img/bloqueado.png",alt="Bloqueado - Aguardando liberacao do cadastro"
 set valor=(^PDPAB(1,10,codcli,numPed))
 set valor=$$^Moeda(valor)
 set openOrders(counter)=flagPronto_"^"_numPed_"^"_cfop_"^"_dtEntrega_"^"_condPagto_"^"_valor
 goto pedidosAbertos

pedidosAbertosMergeArrayToSession ;
 do setSessionValue^%zewdAPI("total",$$^Moeda(pedidos),sessid)
 do mergeArrayToSession^%zewdAPI(.openOrders,"openOrders",sessid)
 set counter=0;

;---- LISTA TÍTULOS EM ABERTO'
 set venc="",ImpAber=0,dtVenc="",valor=0,cart="",dup=""
Aber ;
VEN set venc=$O(^FTDUPCLI(1,codcli,venc)) If venc="" goto titulosAbertosMergeArrayToSession
DUP set dup=$O(^FTDUPCLI(1,codcli,venc,dup)) If dup="" Goto VEN
 if '$D(^FTDUP(1,dup)) Goto DUP
 set regTit=$g(^FTDUP(1,dup))
 set valor1=$p(regTit,"^",5)
 set valor2=$p(regTit,"^",11)
 set valorTit=valor1-valor2
 set dtVenc=$$^Data(venc)
 set cartTemp=$P(regTit,"^",6)
 set cartTemp2=(^FTCCB(cartTemp))
 set cartTit=$P(cartTemp2,"^",1)  
 set counter=counter+1
 set openTitles(counter)=dup_"^"_dtVenc_"^"_$$^Moeda(valorTit)_"^"_cartTit
 goto DUP

titulosAbertosMergeArrayToSession ;
 do mergeArrayToSession^%zewdAPI(.openTitles,"openTitles",sessid)
 set counter=0


;---- ULTIMAS COMPRAS'
 set invDate="",invValue=0,nrNNF="",invPaymentAux="",invPayment="",invCode="",invObs="",natFiscal="",regNF="",numNota=0,numSerie=0
Compras ;
DATA  set invDate=$ZP(^FTCLIFAT(codcli,invDate)) if invDate="" goto invoiceMergeArrayToSession
NF  set nrNNF=$O(^FTCLIFAT(codcli,invDate,nrNNF)) if nrNNF="" goto DATA
    set numSerie=$P(nrNNF,"/",1),numNota=+$P(nrNNF,"/",2)
    if '$D(^FTNNF(numSerie,numNota)) goto NF
     set regNF=^(numNota)
     set invValue=$P(regNF,"^",11)
     set invPaymentAux=+$P(regNF,"^",9)
     set natFiscal=+$P(regNF,"^",5)
     set invCode=$E($P(^FTNAT(natFiscal),"^",8),1,35)
     set invPayment=$P(^FTCPG(invPaymentAux),"^",1)
     set invObs="Enviada"
     if $D(^FTCAN(numSerie,numNota)) set invObs="Cancelada"
     if $D(^FTDEV(numSerie,numNota)) set invObs="Devolvida"
     set invNum=$P(regNF,"^",35)
     set counter=counter+1
     set openInvoice(counter)=$$^Data(invDate)_"^"_$$^Moeda(invValue)_"^"_invNum_"^"_invPayment_"^"_invCode_"^"_invObs_"^"_numNota
     if counter>Limite goto invoiceMergeArrayToSession
     goto NF
 

invoiceMergeArrayToSession ;
 do mergeArrayToSession^%zewdAPI(.openInvoice,"openInvoice",sessid) 
 set counter=0
 
 quit ""
 ;