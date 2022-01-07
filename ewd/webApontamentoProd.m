web

ApontamentoProd ;---[ Apontamento Producao Interface WEB: ATUALIZADO 08/09/2020 - GUSTAVO ]
 ;
operador(sessid) ;
 set erro="",operador="",motivo="",servicoOper="",nomeOperador="",desOper=""
 set DL="^"
 set OPE=$$getSessionValue^%zewdAPI("operador",sessid)
 if OPE?1"" s erro=1,motivo="Informar codigo de operador!" goto erroOperador
 if '$D(^VDOPE(OPE)) s erro=1,motivo="Codigo de operador invalido!" goto erroOperador
 set reg=$g(^(OPE))
 set nomeOperador=$p(reg,DL,1),servicoOper=$p(reg,DL,3)
 if servicoOper="" s erro=1,motivo="Operador nao autorizado!" goto erroOperador
 if servicoOper="*" set desOper="TODOS OS PROCESSOS" goto montaOperador
 else  set desOper=$P($g(^VDTTS(servicoOper)),DL,1)
montaOperador
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 do setSessionValue^%zewdAPI("servicoOper",servicoOper,sessid)
 do setSessionValue^%zewdAPI("nomeOperador",nomeOperador,sessid)
 do setSessionValue^%zewdAPI("desOper",desOper,sessid)
 quit ""
erroOperador
 do setSessionValue^%zewdAPI("erro",erro,sessid)
 do setSessionValue^%zewdAPI("motivo",motivo,sessid)
 quit ""
 ;
apontamento(sessid) ;
 set DL="^"
 set erro="",PED="",ITEM="",ITENS="",PECA="",PECAS="",nomeCliente="",nomeItem="",QTE="",DSER="",descricao="",arquivo="",situacao=""
 set OPE=$$getSessionValue^%zewdAPI("operador",sessid)
 set ETIQ=$$getSessionValue^%zewdAPI("codigo",sessid)
 set servicoOper=$$getSessionValue^%zewdAPI("servicoOper",sessid)
 set ETIQ=+ETIQ
 ;
 I '$D(^VDETQ(0,ETIQ)) s erro=1,situacao="Etiqueta nao existe" goto montaDadosAponta
 ;
 S R=$G(^(ETIQ))
 S PED=$P(R,DL,1)
 S ITEM=$P(R,DL,2)
 S (QTEBKP,QTE,PECAS)=$P(R,DL,3)
 S RETQ=R
 ;
 S EMP=1
 ;
 I $D(^PDPAB(1,6,PED)) s erro=1,situacao="Pedido aguardando liberacao!" goto montaDadosAponta
 ;
 I '$D(^PDPAB(1,0,PED)) s erro=1,situacao="Pedido nao existe!" goto montaDadosAponta
 ;
 I $D(^PDPAB(1,15,PED)) s erro=1,situacao="Pedido pronto!" goto montaDadosAponta
 ;
 I $D(^VDAPT(0,ETIQ,"Q")) s erro=1,situacao="Etiqueta consta apontada como perda!" goto montaDadosAponta
 ;
 I '$D(^PDPAB(1,1,PED,ITEM)) s erro=1,situacao="Item nao existe!" goto montaDadosAponta
 ;
 D IV^PD0104AX
 ;
 S R=^(ITEM)
 S CLI=$P(^PDPAB(1,0,PED),DL,1)
 S COD=$P(R,DL,1)
 S QPED=$P(R,DL,3)
 S RPRO=$G(^FTPRO(1,COD))
 S NPRO=$P(RPRO,DL,1)
 S TIPO=$P(RPRO,DL,10)
 S ALT=$p(R,DL,9)
 S LARG=$p(R,DL,10)
 S OBITEM=$P(R,DL,6)
 S TR="",$P(TR,"*",80)=""
 S PRIMEIRO=$O(^PDPAB(1,1,PED,ITEM,""))
 S ULTIMO=$ZP(^PDPAB(1,1,PED,ITEM,""))
 S ITENS=$O(^PDPAB(1,1,PED,""),-1)
 S MS=""
 D SER(ETIQ)
 I MS'?1"" s erro=1,situacao=MS goto montaDadosAponta
 ;---[Verifica ultimo apontamento e limite 1 minuto]
 S QTE=QTEBKP
 S UTAP=$ZP(^VDAPT(0,ETIQ,"")),HH=$P($H,",",2),DIA=$P($H,",",1)
 I UTAP'="" S UTAP=$G(^(UTAP)),HORA=$P(UTAP,DL,2),DIAAP=$P(UTAP,DL,1) I DIAAP=DIA I HH-HORA<(30) s erro=1,situacao="Etiqueta apontada ha menos de um minuto!" goto montaDadosAponta
 ;
 ;---[ ATUALIZA BASE DE DADOS APONTAMENTO ]
 S ^VDAPT(0,ETIQ,SER)=$P($H,",",1)_DL_$P($H,",",2)_DL_OPE_DL_QTE_DL_PED_DL_ITEM
 S ^VDAPT(1,PED,ITEM,SER,ETIQ)=""
 S ^VDAPT(2,+$H,ETIQ,SER)=""
 IF SER=ULTIMO D
   . set SUBGRUPO=$P(RPRO,DL,12)
   . IF SUBGRUPO="6" DO
   .. IF CLI=820 DO
   ... set estoqueAtual=^ESTOQUEBOX(0,COD)
   ... set estoqueAtual=estoqueAtual+1
   ... set ^ESTOQUEBOX(0,COD)=estoqueAtual
   ... S AREAUNDPROD=1.9*$P(RPRO,DL,21)
   ... S DATALVREG=$ZP(^LVMAT(1,COD,""))
   ... S estoqueAtualMT=$P($G(^LVMAT(1,COD,DATALVREG)),"^",1)+AREAUNDPROD
   ... S ^LVMAT(1,COD,DATALVREG)=""_estoqueAtualMT_"^0"_""
   ... Q
   .. Q
 .Q
 ;---[ Soma Qte produzida por ITEM/Servico ]
 S QT=$G(^VDAPT(1,PED,ITEM,SER)),QT=QT+QTE,^(SER)=QT
 S PRONTO=0
 ;---[ Soma Qte produzida por ITEM ]
 IF SER=ULTIMO DO
 .set QT=$G(^VDAPT(1,PED,ITEM)),QT=QT+QTE,^(ITEM)=QT,PECA=QT
 .Q
 D VER
 I OK="S" D FECHAR(PED)
 set nomeCliente=$P($G(^FTCLI(CLI)),DL,1)
 set MEDIDA=$j(ALT,5,3)_" x "_$j(LARG,5,3)
 set nomeItem=NPRO_" "_MEDIDA
 set descricao=nomeItem_" "_OBITEM
 set arquivo=$$montaArquivo(PED,ITEM)
 if ($zsearch(arquivo)="")&($zsearch(arquivo)="") set arquivo="/img/semProjeto.png"
 ;
montaDadosAponta
 do setSessionValue^%zewdAPI("pedido",PED,sessid)
 do setSessionValue^%zewdAPI("nomeCliente",nomeCliente,sessid)
 do setSessionValue^%zewdAPI("item",ITEM,sessid)
 do setSessionValue^%zewdAPI("itens",ITENS,sessid)
 do setSessionValue^%zewdAPI("nomeItem",nomeItem,sessid)
 do setSessionValue^%zewdAPI("quantidade",QTE,sessid)
 do setSessionValue^%zewdAPI("nomeServico",DSER,sessid)
 do setSessionValue^%zewdAPI("etiqueta",ETIQ,sessid)
 do setSessionValue^%zewdAPI("peca",PECA,sessid)
 do setSessionValue^%zewdAPI("pecas",PECAS,sessid)
 do setSessionValue^%zewdAPI("arquivo",arquivo,sessid)
 do setSessionValue^%zewdAPI("descricao",descricao,sessid)
 do setSessionValue^%zewdAPI("Tpr",$h,sessid)
 do setSessionValue^%zewdAPI("erro",erro,sessid)
 do setSessionValue^%zewdAPI("situacao",situacao,sessid)
 quit ""
 ;
montaArquivo(pedido,item) ;----[ monta nome de arquivo projeto ]
        new path
        set path=$g(^VDPAR(1))
        set extensao=$p(path,"^",2)
        set path=$p(path,"^",1)
        if path="" quit "Falta parametro path arquivo"
        set arquivo=path_pedido_"-"_item_"."_extensao
        quit arquivo
        ;
SER(ETIQ) ;----[ Busca servico ]
        S SER="",MS=""
        S PEDREF=$G(^APONTA)
PES     S SER=$O(^PDPAB(1,1,PED,ITEM,SER))
         ;---[ linha abaixo comentada em 21/07/2010 p/ apontar tudo ]
        ;---I PEDREF'?1"" I PED<(PEDREF+1) S SER=$ZP(^PDPAB(1,1,PED,ITEM,"")) ;---TIRAR SE APONTAR TUDO
        ;-----------------------------------------------------------
        I SER="" S MS="Item nao contém serviços a serem apontados!" Q
         ;
PES1    If $D(^VDAPT(0,ETIQ,SER)) D
           .If SER=ULTIMO D    ;ALTERAR QUANDO APONTAR TUDO
                       .. S MS="Item pronto!"
                     ..Q
           .Quit
        Q:MS'?1""
        S CODSER=$P(^PDPAB(1,1,PED,ITEM,SER),DL,2)
         ;
         ;
        ;---[EDITAR ESTA LINHA ABAIXO TIRANDO O $ZP E G PES1 P/ G PES ]
        ;---[QUANDO FOR APONTAR TODAS AS OPERAÇÕES                    ]
        ;---[ linha abaixo COMENTADA E INCLUIDA duas ABAIXO EM 22/07/2010 para apontar primeira e ultima operacao p/ pedidos anteriores ao apontamento total ]
        ;I $D(^VDAPT(0,ETIQ,SER)) S SER=$ZP(^PDPAB(1,1,PED,ITEM,"")) G PES1
        If PEDREF'?1"" I PED<(PEDREF+1) I $D(^VDAPT(0,ETIQ,SER)) S SER=$ZP(^PDPAB(1,1,PED,ITEM,"")) G PES1
        I $D(^VDAPT(0,ETIQ,SER)) G PES
         ;----[consiste servico com operacao do operador]
        S MS=""
        IF servicoOper'="*" IF CODSER'=servicoOper do
          .S MS="Servico operador:"_servicoOper_" diferente do servico apontado:"_CODSER
         .Quit
       Q:MS'?1""
        ;
       ;
       S DSER=$P($G(^VDTTS(CODSER)),DL,1)
       Q
VER    ;---[Verifica Pedido Pronto]
       S ITX=""
       S OK="S"
ITX    S ITX=$O(^PDPAB(1,1,PED,ITX)) I ITX="" G ITXZ
       S RX=$G(^(ITX))
       S PROD=$P(RX,DL,1)
       S TIPO=$P($G(^FTPRO(1,PROD)),DL,10)
       I TIPO'=1 G ITX ;---[PRODUTO DIFERENTE DE VIDRO]
       S QPED=$P(RX,DL,3)-$P(RX,DL,4)
       ;S SX=""
SX     ;S SX=$O(^PDPAB(1,1,PED,ITX,SX)) I SX="" G ITX
       S QPR=$G(^VDAPT(1,PED,ITX))
       I QPR<QPED S OK="N" G ITXZ
       G ITX
       ;
ITXZ   Q
       ;
FECHAR(PED)   ;---[ FECHA PEDIDO ]
       S ^PDPAB(1,15,PED)=$H
       S ITY=""
ITY    S ITY=$O(^VDETQ(1,PED,ITY)) I ITY="" QUIT
       S PEC=""
PEC    S PEC=$O(^VDETQ(1,PED,ITY,PEC)) I PEC="" G ITY
       K ^(PEC)
       K ^VDETQ(0,PEC)
       G PEC
MAIL   ;
       S email=$p($G(^FTCLI(CLI)),DL,10)
       Set Assunto="Pedido Disponivel"
       I email?1"" quit
        ;---------------------------------------------------------------------------------
       S TR="",$P(TR,"=",67)=""
       set message(1)="Prezado Cliente,"
       set message(2)=""
       set message(3)="Informamos que seu pedido numero: "_PED_" encontra-se a disposicao para retirada."
       set message(4)=TR
       set message(5)=" Qte.  Descricao do produto"
       set message(6)=TR
       S ITX=""
IPX    S ITX=$O(^PDPAB(1,1,PED,ITX)) I ITX="" G IPXZ
       S R=$G(^(ITX))
       S QPED=$P(R,DL,3)
       S COD=$P(R,DL,1)
       S UN=$P(R,DL,2)
       S ALTURA=$P(R,DL,9)
       S LARGURA=$P(R,DL,10)
       S NOME=$P($G(^FTPRO(1,COD)),DL,1)
       S COMPL=""
       I ALTURA>0!(LARGURA>0) S COMPL=" "_$J(ALTURA,5,3)_" x  "_$j(LARGURA,5,3)
       S DESCR=$E(NOME,1,45)_COMPL
       S RESTO=62-$L(DESCR)+1
       W !,$J(QPED,4)
       W "  -  ",DESCR
       ;
       G IPX
IPXZ   ;
       w !,TR
       w !!,"Atenciosamente,"
       w !!,"A Vidrolar Ltda."
       w !!!!!!,"Vidix - Gestao em Vidros"
        set timeout=300
        set gmt="0500"
        s ownd="teste"
        set to=email
        set x=$g(^VDPAR(1))
        set server=$p(x,dl,5)
        set from="<"_$p(x,dl,4)_">"
        set displayFrom=$p(x,dl,3)
        set displayTo=""
        set authType="LOGIN"
        set user=$p(x,dl,6)
        set pass=$p(x,dl,7)
        set error=$$smtpSend^%zewdGTM(server,from,displayFrom,to,displayTo,.ccList,subject,.message,.dialog,authType,user,pass,timeout,gmt,ownd)
        quit
        ;
