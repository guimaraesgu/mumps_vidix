web ;---- [Controle Estoque Box | 16/10/2020 19:42]
 ;
reserva(sessid) ;---[ prePageScript ]
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 set codETQ="",codPED="",codProd="",DL="^"
 set codETQ=$$getSessionValue^%zewdAPI("codETQ",sessid)
 set codPED=$P($G(^VDETQ(0,codETQ)),DL,1)
 set itemPED=$P($G(^VDETQ(0,codETQ)),DL,2)
 set R=$G(^PDPAB(1,1,codPED,itemPED))
 set codProd=$P(R,DL,1)
 IF $D(^ESTOQUEBOX(0,codProd)) D
 . IF $D(^ESTOQUEBOX(0,codProd,codPED)) D
 .. set nxtItem=$G(^ESTOQUEBOX(0,codProd,codPED))+1
 .. set ^ESTOQUEBOX(0,codProd,codPED,nxtItem)=codETQ
 .. set ^ESTOQUEBOX(0,codProd,codPED)=nxtItem
 . IF '$D(^ESTOQUEBOX(0,codProd,codPED)) D
 .. S ^ESTOQUEBOX(0,codProd,codPED)=1
 .. S ^ESTOQUEBOX(0,codProd,codPED,1)=codETQ

 quit ""
 ;

removeReserva(sessid) ;---[prePageScript]
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 set DL="^"
 set codETQ=$$getSessionValue^%zewdAPI("codETQ",sessid)
 set codPED=$$getSessionValue^%zewdAPI("codPED",sessid)
 set codProd=$$getSessionValue^%zewdAPI("codProd",sessid)
 if $D(^ESTOQUEBOX(0,codProd,codPED)) D
 . set qntItens=$G(^ESTOQUEBOX(0,codProd,codPED))
 . for  Q:qntItens=0  D
 .. if $G(^ESTOQUEBOX(0,codProd,codPED,qntItens))=codETQ D
 ... K ^ESTOQUEBOX(0,codProd,codPED,qntItens)
 .. set qntItens=qntItens-1
 . K ^ESTOQUEBOX(0,codProd,codPED)

 quit ""
 ;

ajustaEstoqueBox(sessid) ;---[prePageScript]
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 set codBox="",qntBox=""
 set codBox=$$getSessionValue^%zewdAPI("codBox",sessid)
 set qntBox=$$getSessionValue^%zewdAPI("qntBox",sessid)
 IF $D(^ESTOQUEBOX(0,codProd)) S ^ESTOQUEBOX(0,codProd)=qntBox

 quit ""
 ;