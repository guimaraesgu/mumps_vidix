webApontaPronto ;---- [Aponta Pedido Pronto WEB | 27/10/2020 13:27]

clientes(sessid) ;---[ prePageScript ]
 do clearList^%zewdAPI("Cliente",sessid)
 set CLIa="",CODCLIa=""

 for  set CLIa=$O(^FTCLIa(CLIa)) Q:CLIa=""  D
 . set CODCLIa=$O(^FTCLIa(CLIa,""))
 . do appendToList^%zewdAPI("cliente",CLIa,CODCLIa,sessid)
 quit ""
 ;


pedidos(sessid) ;---[ prePageScript ]
 set pedido="",counter=1
 Set codCli=$$getSelectValue^%zewdAPI("cliente",sessid)
 for  set pedido=$O(^PDPAB(1,0,pedido)) Q:pedido=""  D
 . set regPed=^(pedido)
 . if $P(regPed,"^",1)=codCli do 
 .. if $D(^PDPAB(1,6,pedido)) Q
 .. if '$D(^PDPAB(1,0,pedido)) Q
 .. if $D(^PDPAB(1,15,pedido)) Q
 .. if $D(^PDPAB(1,16,pedido)) Q
 .. set vlrPed=$$^Moeda($G(^PDPAB(1,10,codCli,pedido)))
 .. set pedidosArray(counter)=pedido_"^"_vlrPed
 . set counter=counter+1
 do mergeArrayToSession^%zewdAPI(.pedidosArray,"Pedidos",sessid)
 quit ""
 ;'

aponta(sessid) ;---[ ACAO PRINCIPAL ]
 ;set usuario=$$getSessionValue^%zewdAPI("Usuario",sessid)
 set codPed=""
 do getCheckboxValues^%zewdAPI("pedidos",.pedidos,sessid)
 do initialiseCheckbox^%zewdAPI("pedidos",sessid)
 for  set codPed=$O(pedidos(codPed)) Q:codPed=""  D
 . set ^PDPAB(1,15,codPed)=""_$H
 . set item=""
 . for  set item=$O(^VDETQ(1,codPed,item)) Q:item=""  do
 .. set peca=""
 .. for  set peca=$O(^VDETQ(1,codPed,item,peca)) Q:peca=""  do 
 ... kill ^(peca)
 ... kill ^VDETQ(0,peca)
 Q ""
 ;
 
;// PEGAR O PEDIDO
;// EM CADA ITEM DO PEDIDO:
;// 		VERIFICAR QNTS PECAS
;// 			EM CADA PECA VERIFICAR OS SERVIÇOS E O ÚLTIMO SERVIÇO APONTADO
;//			APONTAR OS SERVIÇOS RESTANTES
;// ALTERAR PEDIDO PARA PRONTO -> GRAVAR EM ^PDPAB(1,15,PED)=""_$H
;. set qntItems=$ZP(^PDPAB(1,1,codPed,""))
; . for  set item=$O(^PDPAB(1,1,codPed,"")) Q:item=""  D
; .. set regItem=^(item)
; .. set qntPecas=$P(regItem,"^",3)
; .. for  set numEtq=


;^PDPAB(1,1,PED,ITEM)=DL_3_MOSTRA_QNT_DE_PECAS_DO_ITEM
;^VDETQ(1,PED,ITEM,ETQ)=TIMESTAMP
;^VDAPT(1,PED,ITEM)=QNTFINALIZADA
;^VDAPT(1,PED,ITEM,SER)=QNT_APONTADA_NESSE_SERVICO
; S ^VDAPT(0,PECA,SER)=$P($H,",",1)_DL_$P($H,",",2)_DL_OPE_DL_QTE_DL_PED_DL_ITEM
; S ^VDAPT(1,PED,ITEM,SER,PECA)=""
; S ^VDAPT(2,+$H,PECA,SER)=""

;Kill ^PDPAB(1,3,DATE,PED) ;Pedidos p/ entrega
; Kill ^PDPAB(1,4,DTINI,PED) ;Pedidos p/ emissao
; Kill ^PDPAB(1,5,LOC,PED) ;Pedidos p/ estabelecimento
; Kill ^PDPAB(1,7,PED) ;Pedidos p/ industrializacao
; Kill ^PDPAB(1,8,PED) ;Pedidos transf. p/ expedicao
; Kill ^PDPAB(1,10,CLI,PED) ;Pedido p/ clientes
; Kill ^PDPAB(1,15,PED) ;---[pedidos prontos]
; kiLL ^PDPAB(1,16,PED) ;