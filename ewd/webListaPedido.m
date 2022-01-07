ListaPedido ;---- [ webListaPedido - 25/05/18 16:13]

inicio(sessid) ;---[ prePageScript ]
 do deleteFromSession^%zewdAPI("itemsArray",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 do deleteFromSession^%zewdAPI("lserv",sessid)
 do deleteFromSession^%zewdAPI("numPed",sessid)
 do deleteFromSession^%zewdAPI("codCli",sessid)
 do deleteFromSession^%zewdAPI("valorPedido",sessid)
 do deleteFromSession^%zewdAPI("nomCli",sessid)
 do deleteFromSession^%zewdAPI("nomCont",sessid)
 do deleteFromSession^%zewdAPI("numTel",sessid)
 do deleteFromSession^%zewdAPI("condPgto",sessid)
 do deleteFromSession^%zewdAPI("dtEntrega",sessid)
 do deleteFromSession^%zewdAPI("dtEmissao",sessid)
 do deleteFromSession^%zewdAPI("obsNF",sessid)
 do deleteFromSession^%zewdAPI("obsPed",sessid)
 set pedido=$$getSessionValue^%zewdAPI("pedido",sessid)
 set etiqueta=$$getSessionValue^%zewdAPI("etiqueta",sessid)
 set lserv=$$getSessionValue^%zewdAPI("listaServ",sessid)
 set counter=0,counterServ=0,counterPeca=0,counterQuebra=0
 if etiqueta?1n.n do
    .set pedido=$p($g(^VDETQ(0,etiqueta)),"^",1)
    .if pedido="" do
        ..set x=$o(^VDAPT(0,etiqueta,""))
        ..if x'="" set pedido=$p($g(^VDAPT(0,etiqueta,x)),"^",5)
        ..quit ""
    .quit ""
 if pedido=""&(etiqueta="") h
 if pedido="" H
 if '$D(^PDPAB(1,0,pedido)) set Error="Não existe pedido" Quit ""
 set regPed=^(pedido)
 if '$D(^PDPAB(1,1,pedido)) set Error="Favor solicitar Depto.Venda p/ cadastrar Itens do Pedido" Quit ""
 set pedidoPronto="N"
 if $D(^PDPAB(1,15,pedido)) set pedidoPronto="S"
 
 ;---- PEGAR O CODIGO DO CLIENTE DE ^PDPAB'
 set codCli=$P($G(^PDPAB(1,0,pedido)),"^",1)
 set regCli=$G(^FTCLI(codCli))
 do setSessionValue^%zewdAPI("numPed",pedido,sessid)
 do setSessionValue^%zewdAPI("codCli",codCli,sessid)
 do setSessionValue^%zewdAPI("valorPedido",$$^Moeda($g(^PDPAB(1,10,codCli,pedido))),sessid)
 do setSessionValue^%zewdAPI("nomCli",$P(regCli,"^",1),sessid)
 do setSessionValue^%zewdAPI("nomCont",$P(regCli,"^",13),sessid)
 do setSessionValue^%zewdAPI("numTel",$p(regCli,"^",7),sessid)
 do setSessionValue^%zewdAPI("condPgto",$P($g(^FTCPG($P(regPed,"^",5))),"^",1),sessid)
 do setSessionValue^%zewdAPI("dtEntrega",$$^Data($P(regPed,"^",6)),sessid)
 do setSessionValue^%zewdAPI("dtEmissao",$$^Data($P(regPed,"^",13)),sessid)
 do setSessionValue^%zewdAPI("obsNF",$P(regPed,"^",14),sessid)
 do setSessionValue^%zewdAPI("obsPed",$P(regPed,"^",15),sessid)

;---- LISTA ITENS 
 set item=""
 for  set item=$O(^PDPAB(1,1,pedido,item)) Q:item=""  D
  . set regItem=^(item)
  . set codProd=$P(regItem,"^",1)
  . set qntPed=$P(regItem,"^",3)
  . set qntApont=$G(^VDAPT(1,pedido,item))
  . if qntApont="" set qntApont=0
  . set qntAberto=qntPed-qntApont
  . set altura=$P(regItem,"^",9)
  . set largura=$p(regItem,"^",10)
  . set area=$p(regItem,"^",11)
  . set obsCli=$P(regItem,"^",6)
  . set codProd=$P(^FTPRO(1,codProd),"^",1)
  . set desc=codProd_" - "_obsCli
  . set dimensao=$J(altura,5,3)_" x "_$J(largura,5,3)
  . set qntQuebra=0,x=""
  . for  set x=$O(^VDAPT(1,pedido,item,"Q",x)) Q:x=""  
  .. set qtqb=$G(^(x)) 
  .. set qntQuebra=qntQuebra+qtqb
  . set flagPronto="/img/atrasado.png"
  . if pedidoPronto="S" set flagPronto="/img/pronto.png"
  . if qntAberto=0 set flagPronto="/img/pronto.png"
  . set counter=counter+1
  . set itemsArray(counter)=flagPronto_"^"_desc_"^"_dimensao_"^"_qntPed_"^"_qntApont_"^"_qntQuebra
  . if lserv="true" goto Servicos
 do mergeArrayToSession^%zewdAPI(.itemsArray,"itemsArray",sessid)
 do setSessionValue^%zewdAPI("lserv",lserv,sessid)
 set counter=0
 set counterServ=0
 set counterPeca=0
 set counterQuebra=0
 
 do deleteFromSession^%zewdAPI("pedido",sessid)
 quit ""
 ;

;---- DADOS SINTETICOS e ANALITICOS DAS PECAS
Servicos ;
 new serv,servAux,regServ,tipoServ,obsServ,servico,obspeca,qntApt
 set serv=""
 for  set serv=$O(^PDPAB(1,1,pedido,item,serv)) Q:serv=""  D
 . set servAux=serv
 . set regServ=$G(^(serv))
 . set tipoServ=$P(regServ,"^",2)
 . set obsServ=$p(regServ,"^",3)
 . set servico=$P($G(^VDTTS(tipoServ)),"^",1)_" "_obsServ
 . set obsPeca=$P(regServ,"^",5)
 . if obsPeca'?1"" set obsPeca=$P($G(^VDOBS(obsPeca)),"^",1)
 . set servico=servico_" "_obsPeca
 . set qntApt=$g(^VDAPT(1,pedido,item,serv))
 . if qntApt="" set qntApt=0
 . set counterServ=counterServ+1
 . set itemsArray(counter,counterServ)=servico_"^"_qntApt
 . goto Pecas
 . kill regServ,tipoServ,obsServ,servico,obsPeca,qntApt
 quit

Pecas ;'
 new peca,regpeca,dataApt,hotaApt,hora,operador,qnt,timestamp
 set peca=""
 for  set peca=$O(^VDAPT(1,pedido,item,servAux,peca)) Q:peca=""  D
 . set ^pecaAux(1)=peca
 . set regPeca=$G(^VDAPT(0,peca,servAux))
 . set dataApt=$P(regPeca,"^",1)
 . set hora=$P(regPeca,"^",2)
 . set timestamp=dataApt_","_hora
 . set operador=$P(regPeca,"^",3)
 . if operador'="" D
 .. set operador=$P($G(^VDOPE(operador)),"^",1)
 . set qnt=$P(regPeca,"^",4)
 . set counterPeca=counterPeca+1
 . set itemsArray(counter,counterServ,counterPeca)=$$^Data(dataApt)_"^"_$zd(timestamp,"24:60")_"^"_operador_"^"_qnt_"^"_^pecaAux(1)
 . goto Quebras
 . kill regpeca,dataApt,hotaApt,hora,operador,qnt,timestamp,^pecaAux
 quit

Quebras ;'
 set pecaQ=^pecaAux(1)
 if $D(^VDAPT(1,pedido,item,"Q",pecaQ)) D
 . set regPeca=$G(^VDAPT(0,pecaQ,"Q"))
 . set dataApt=$P(regPeca,"^",1)
 . set horaApt=$P(regPeca,"^",2)
 . set timestamp=dataApt_","_horaApt
 . set operador=$P(regPeca,"^",3)
 . set operador=$P($G(^VDOPE(operador)),"^",1)
 . set quebra="*Quebra*"
 . set counterQuebra=counterQuebra+1
 . set itemsArray(counter,counterServ,counterPeca,counterQuebra)=$$^Data(dataApt)_"^"_$zd(timestamp,"24:60")_"^"_quebra_"^"_operador_"^"_pecaQ





