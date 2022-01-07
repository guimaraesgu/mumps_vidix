webAlteraCondPag ;----[ Altera condicao de pagamento Interface WEB ]
 ;
alteraCondPag(sessid) ;---[prePageScript]
 new CLIa,CODCLIa,CODCLI,DL,R,CLI,PED
 set CLIa="",CODCLIa="",CODCLI="",CLI="",DL="^",PED=""
 do clearList^%zewdAPI("cliente",sessid)
 ;
listaClientes ;
 Set CLIa=$O(^FTCLIa(CLIa)) If CLIa="" quit ""
 Set CODCLIa=$O(^FTCLIa(CLIa,"")),CODCLI=$O(^PDPAB(1,10,CODCLIa-1)) 
 If CODCLI'=CODCLIa goto listaClientes
 ;
verificaPedidos ;
 Set PED=$O(^PDPAB(1,10,CODCLI,PED)) If PED="" goto listaClientes
 if '$D(^PDPAB(1,0,PED)) goto verificaPedidos
 ;
carregaClientes ;
 set R=$g(^FTCLI(CODCLI)),CLI=$P(R,DL,1)
 do appendToList^%zewdAPI("cliente",CLI,CODCLI,sessid)
 goto listaClientes
 ;
alteraCondPag1(sessid) ;---[prePageScript]
 new DL,cont,classe,R,CLI,CODCLI,VALOR,PEDCLI,condPag,codCondPag,CONDPAGPED,SITPED,vetor
 set DL="^",cont=0,dl="^",PEDCLI="",condPag="",codCondPag="",CODCLI=""
 Set CODCLI=$$getSelectValue^%zewdAPI("cliente",sessid)
 If CODCLI="" quit "Selecione um cliente para alterar pedidos"
 Set CLI=$G(^FTCLI(CODCLI)),CLI=$P(CLI,DL,1)
 do clearList^%zewdAPI("condPagCli",sessid)
 do clearList^%zewdAPI("cliente",sessid)
 do deleteFromSession^%zewdAPI("ResultSet",sessid)
 do initialiseCheckbox^%zewdAPI("pedidos",sessid)
 do setSessionValue^%zewdAPI("codCliente",CODCLI,sessid)
 ;
carregaCondPagCli ;
 Set codCondPag=$O(^FTNEG(CODCLI,codCondPag)) If codCondPag="" goto carregaPed
 Set condPag=$G(^FTCPG(codCondPag)),condPag=$P(condPag,DL,1)
 do appendToList^%zewdAPI("condPagCli",condPag,codCondPag,sessid) goto carregaCondPagCli
 ;
carregaPed ;
 Set SITPED="atrasado.png"
 Set PEDCLI=$O(^PDPAB(1,10,CODCLI,PEDCLI)) If PEDCLI="" goto carrega
 If '$D(^PDPAB(1,0,PEDCLI)) goto carregaPed
 set VALOR=$G(^PDPAB(1,10,CODCLI,PEDCLI))
 Set CODCONDPAGPED=$P(^PDPAB(1,0,PEDCLI),DL,5),CONDPAGPED=$P(^FTCPG(CODCONDPAGPED),DL,1)
 Set:$P(^PDPAB(1,0,PEDCLI),DL,6)>$P($H,",",1) SITPED="produzindo.png"
 Set:$D(^PDPAB(1,15,PEDCLI)) SITPED="pronto.png"
 Set:$D(^PDPAB(1,6,PEDCLI)) SITPED="bloqueado.png"
 ;
selecionaPed ;
 if '$D(^PDPAB(1,16,PEDCLI)) goto monta
 else  set SITPED="expedido.png"
 ;
monta ;
 set cont=cont+1
 Set classe="normal"
 If cont#2 Set classe="negrito"
 set vetor(cont)=classe_dl_SITPED_dl_PEDCLI_dl_CODCLI_dl_CLI_dl_$$^Moeda(VALOR)_dl_CONDPAGPED_dl_CODCONDPAGPED
 goto carregaPed
 ;
carrega ;
 do mergeArrayToSession^%zewdAPI(.vetor,"ResultSet",sessid)
 quit ""
 ;
altera(sessid) ;---[actionScript]
 new dl,n,ped,pedidos,VALOR,pedOE,aviso,avisoTrava,pedConInv
 set dl="^",ped="",pedidos="",pedOE="",aviso="",avisoTrava="",pedCondInv=""
 set USERX=$$getSessionValue^%zewdAPI("Usuario",sessid)
 set codCliente=$$getSessionValue^%zewdAPI("codCliente",sessid)
 set novoCondPag=$$getSelectValue^%zewdAPI("condPagCli",sessid)
 set novoTxCondPag=$P(^FTNEG(codCliente,novoCondPag),dl,1),novoTxCondPag=(1+(novoTxCondPag/100))
 do getCheckboxValues^%zewdAPI("pedidos",.pedidos,sessid)
 do initialiseCheckbox^%zewdAPI("pedidos",sessid)
 if '$d(pedidos) quit "Selecione um pedido para alterar"
 ;
buscaPed ;
 for  set ped=$O(pedidos(ped)) quit:ped=""  do
 .if $D(^PDPAB(1,16,ped)) do
 ..set pedOE=ped_" | "_pedOE
 ..set aviso="Os seguintes pedidos constam em OE e nao foram alterados:\n"_pedOE_"\n"
 ..quit
 .else  do
 ..set condPagPed=$P(^PDPAB(1,0,ped),dl,5)
 ..if $D(^FTNEG(codCliente,condPagPed)) do alteraPed(ped,codCliente)
 ..else  do
 ...set pedCondInv=ped_" | "_pedCondInv
 ...set avisoCond=aviso_"Os seguintes pedidos nao podem ser alterados:\n"_pedCondInv_"\n"
 do setWarning^%zewdAPI(aviso,sessid)
 quit ""
 ;
alteraPed(ped,codCliente) ;
 lock ^PDPAB
 lock +^PedidosLib
 set n="",VALOR=0,VALORITEM=0
 set condPagPed=$P(^PDPAB(1,0,ped),dl,5)
 set:condPagPed>1 txCondPagPed=$P(^FTNEG(codCliente,condPagPed),dl,1),txCondPagPed=(1+(txCondPagPed/100))
 TSTART
 for  set n=$O(^PDPAB(1,1,ped,n)) quit:n=""  do
 .set item=$G(^PDPAB(1,1,ped,n)),quantItem=$P(item,dl,3)
 .set precoM2=($P(item,dl,5))/100,precoM2=precoM2/txCondPagPed
 .set novoPrecoM2=precoM2*novoTxCondPag
 .set M2Item=$P(item,dl,11)
 .set VALORITEM=novoPrecoM2*M2Item*quantItem
 .set VALOR=VALOR+VALORITEM
 .set $P(^PDPAB(1,1,ped,n),dl,5)=$FN(novoPrecoM2,"",2)*100
 set $P(^PDPAB(1,0,ped),dl,20)=USERX
 set $P(^PDPAB(1,0,ped),dl,5)=novoCondPag
 set VALOR=$FN(VALOR,"",2)*100
 set $P(^PDPAB(1,5,1,ped),dl,2)=VALOR
 set ^PDPAB(1,10,codCliente,ped)=VALOR
 set DATA=$P($H,",",1)
 set ^PedidoAlterado(ped)=DATA_dl_USERX
 set:$D(^PDPAB(1,6,ped)) $P(^PDPAB(1,6,ped),dl,2)=VALOR
 set:$D(^PedidosLib(codCliente,ped)) ^PedidosLib(codCliente,ped)=VALOR_dl_USERX_dl_$H
 TCOMMIT
 lock -^PedidosLib
 lock -^PDPAB
 If $D(^PDPAB(1,6,ped)) quit
 goto avaliaTrava
 ;
trava ;
 If Trava="S" do
 .set avisoTrava=aviso_"\n"
 .set ^PDPAB(1,6,ped)=CLI_dl_VALOR
 .kill ^PedidosLib(codCliente,ped)
 quit
 ;
avaliaTrava ;---[Verifica se a nova condiçao de pagamento necessita de aprovaçao do financeiro]
 New total,Trava,CodCli,travaPed
 Set dl="^",total=0,TemObs="N",travaPed=""
 Set CodCli="",LimiteCredito=0,LimCadastro=0
 Set px=ped,VrPedido=VALOR,CLI=codCliente
 Set (TDevedor,TVencido,TPedidos)=0
 Do CNPJ(CLI)
 Set LimiteCredito=0
 set Adiantamento=0
 ;
 For  Set CodCli=$O(TabCod(CodCli)) Quit:CodCli=""  Do
      .Set X=$$Devedor(CodCli)
      .Set Devedor=$p(X,dl,1)
      .Set Vencido=$p(X,dl,2)
      .Set MediaAtraso=$p(X,dl,3)
      .Set MediaPagamento=$$MediaPg(CodCli)
      .Set LimiteCredito=LimiteCredito+$j(MediaPagamento*1.3,0,0)
      .Set Pedidos=$$Pedido(CodCli)
      .Set total=total+Pedidos+Devedor
      .Set TPedidos=TPedidos+Pedidos
      .Set TDevedor=TDevedor+Devedor
      .Set TVencido=TVencido+$p(X,dl,4)
      .NEW COD
      .SET ABATER=0
      .SET COD=CodCli,DL="^"
      .Do ORDEM
      .Set Adiantamento=Adiantamento+TOTORD
 ;---[Formula]
 ; (Se Valor do Pedido + Pedidos Abertos + Saldo Devedor)
 ; Maior que Media Pagamentos dos ultimos 365 dias
 ; O pedido vai para a aprovacao
 ;--------------------------------------------------
 Set LimiteCredito=LimCadastro
 Set Trava="N"
 set total=total-Adiantamento
 Set total=total+VrPedido
 ;
 If total>LimiteCredito Set Trava="S"
 If $p(^FTCLI(CLI),dl,27)'?1"" Set Trava="S",TemObs="S" ;Trava se tem observacao no Campo 27
 If TVencido>0 Set Trava="S"
 goto trava
 ;-----------------------------------------------------
 ;
Devedor(cli) ;Verifica Saldo Devedor e se tem Titulos em Atraso
 New dup,ven,tot,vr,dl,ch,hoje,atraso,tvencido,dias,nr,MediaAtraso,tdias
 Set hoje=+$h,dl="^",ven="",dup="",tdias=0
 Set (tvencido,tot,nr)=0,ch="",atraso="N",nr=0
 ;
Ven ;
 Set ven=$o(^FTDUPCLI(1,cli,ven)) If ven="" Goto Ch
 ;
Dup ; 
 Set dup=$o(^FTDUPCLI(1,cli,ven,dup)) If dup="" Goto Ven
 If '$d(^FTDUP(1,dup)) Goto Dup
 Set vr=$p(^(dup),dl,5)
 If ven<hoje Set atraso="S",tvencido=tvencido+vr,dias=hoje-ven,nr=nr+1,tdias=tdias+dias
 Set tot=tot+vr
 Goto Dup
 ;
Ch ; 
 Set ch=$o(^CXCHP(1,cli,ch)) If ch="" Goto FimDev
 If '$d(^CXCHP(0,ch)) Goto Ch
 Set r=^(ch)
 Set vr=$p(r,dl,3)
 Set ven=$p(r,dl,4)
 Set tot=tot+vr
 If ven<hoje Set atraso="S",tvencido=tvencido+vr,dias=hoje-ven,nr=nr+1,tdias=tdias+dias
 Goto Ch
 ;
FimDev ;
 Set MediaAtraso=0
 If nr>0 Set MediaAtraso=$j(tdias/nr,0,0)
 Quit tot_"^"_atraso_"^"_MediaAtraso_"^"_tvencido
 ;
MediaPg(cli) ;Calcula Media de Pagamento ultimos 12 meses
 New bai,dup,r,DataDias,dl,cont,atz,tatz
 Set DataDias=(+$h)-365,dl="^"
 Set (bai,dup,tot,cont,tatz,atz,cont)=""
 ;
Bai ;
 Set bai=$zp(^FTBAICLI(1,cli,bai)) If bai="" Goto FimBai
 ;
DupBai ;
 Set dup=$zp(^FTBAICLI(1,cli,bai,dup)) If dup="" Goto Bai
 If $d(^FTBAI(1,dup)) Set r=^(dup) Goto Soma
 If $d(^FTBAIAC(1,dup)) Set r=^(dup) Goto Soma
 Goto DupBai
 ;
Soma ;
 Set pag=$p(r,dl,8)
 Set atz=pag-$p(r,dl,4) Set:atz<0 atz=0
 Set tatz=tatz+atz
 Set cont=cont+1
 If pag<DataDias G DupBai
 Set vr=$p(r,dl,6)
 Set tot=tot+vr
 Goto DupBai
 ;
FimBai ;Calcula Media (12 meses)
 Set tot=$j(tot/12,0,0)
 Set MediaAtzLq=0
 If cont>0 Set MediaAtzLq=tatz\cont
 Quit tot
 ;
Pedido(cli) ;Verifica pedidos em aberto
 New ped,r,tot,dl
 Set ped="",tot=0,dl="^"
 ;
Ped ;
 Set ped=$o(^PDPAB(1,10,cli,ped)) If ped="" Goto PedZ
 Set r=^(ped)
 If '$d(^PDPAB(1,0,ped)) Goto Ped
 Set tot=tot+r
 Goto Ped
 ;
PedZ ;
 Quit tot
 ;
CNPJ(Cli) ;Seleciona Todos os Clientes com a Mesma Raiz do CNPJ
 New CNPJ,Raiz,Tipo
 Kill TabCod
 Set TabCod=0
 Set CNPJ=$P(^FTCLI(Cli),"^",8)
 Set (LimiteCredito,LimCadastro)=$p(^(Cli),"^",17)
 Set TabCod(Cli)=""
 If +CNPJ=0 Quit
 If $L(CNPJ)=14 Set Raiz=$E(CNPJ,1,8) Set CNPJ=Raiz_"000000",Tipo="CNPJ" ;---[ CNPJ ]
 Else  Set Raiz=CNPJ,CNPJ=$E(CNPJ,1,$l(CNPJ)-1)_"0",Tipo="CPF" ;---[ CPF ]
 ;
CNP1 
 Set CNPJ=$Order(^FTCLICGC(CNPJ))
 If Tipo="CNPJ" If CNPJ=""!($E(CNPJ,1,8)'=Raiz) Goto CNPZ
 If Tipo="CPF" If CNPJ=""!(CNPJ'=Raiz) Goto CNPZ
 Set Cli=""
 ;
CNP2 
 Set Cli=$Order(^FTCLICGC(CNPJ,Cli)) If Cli="" Goto CNP1
 Set LimiteCredito=LimiteCredito+$p(^FTCLI(Cli),"^",17)
 Set TabCod(Cli)=""
 Set TabCod=TabCod+1
 Goto CNP2
 ;
CNPZ ;
 Quit
 ;
HabPag(Cli) ;Habito de Pagamento
 New DATA,NF,EPX,NFX,TOTNF,CPG,NAT,Preferencia,Valor,DL,R
 Set MaiorFatura=0,dtMaiorFatura=""
 Set DL="^"
 Set DATA="",Cont=0
 Kill Forma
 ;
DATA ;
 Set DATA=$ZP(^FTCLIFAT(Cli,DATA)) G DATAZ:DATA=""
 Set NF=""
 ;
NF ;
 Set NF=$O(^PDPAT(1,10,Cli,NF)) G DATAZ:NF=""
 Set TOTNF=$p($G(^(NF)),DL,1)
 If '$D(^PDPAT(1,0,NF)) Goto NF
 Set R=^(NF)
 set NRNF=$P(R,"^",14)
 if +NRNF>0 set TOTNF=$p($G(^FTNNF(1,NRNF)),DL,11)
 If TOTNF>MaiorFatura Set MaiorFatura=TOTNF S dtMaiorFatura=$P(R,"^",15)
 Set CPG=+$P(R,DL,5)
 Set NAT=+$P(R,DL,5)
 ;If $D(^FTCAN(EPX,NFX)) Goto NF
 ;If $D(^FTDEV(EPX,NFX)) Goto NF
 do CPG
 I CPG'=1 I CPG="N" Goto NF 
 Set Cont=Cont+1
 If '$D(Forma(CPG)) Set Forma(CPG)=1 Goto NF
 Set Forma(CPG)=Forma(CPG)+1
 Goto NF
 ;
DATAZ ;
 Set CPG="",per=0,Preferencia=""
 Set Maior=0
 For  Set CPG=$O(Forma(CPG)) Do  If CPG="" Quit
      .If CPG="" Quit
      .Set Valor=Forma(CPG)
      .If Valor>Maior Set Maior=Valor,Preferencia=CPG
      .Quit
 If $D(Forma(1)) Set per=$j(Forma(1)*100/Cont,0,0)
 ;Kill Forma
 Set Texto=""
 ;If Per>60 Set Texto="Compra a Vista"
 If Preferencia="" Quit ""
 Set Texto=$p($G(^FTCPG(Preferencia)),"^",1)_" "_$p($g(^FTNEG(Cli,Preferencia)),"^",1)_"%"
 Quit Texto
 ;
ORDEM   ;---[Verifica Valor de saldo de ordem de pagamento]
 Set X=""
 set %saldoORDEM=0
 Set TOTORD=0
 If '$d(ABATER) set ABATER=0
 For I=1:1 Set X=$Order(^CXORD(COD,X)) Quit:X=""  Set TOTORD=TOTORD+$Piece(^(X),DL,1)
 For I=1:1 Set X=$Order(^CXORDx(COD,X)) Quit:X=""  Set TOTORD=TOTORD-$Piece(^(X),DL,1)
 set %saldoORDEM=TOTORD-ABATER
 If $d(%naoIPR) kill %naoIPR quit
 kill %naoIPR
 Quit
 ;
CPG ;---[Verifica se a prazo nao gera duplicata]
 S X=CPG
 S X=+X
 N Y
 S Y="S"
 If X=97!(X=98)!(X=99)!(X=1)!(X=100) S Y="N"
 Quit Y
 ;
