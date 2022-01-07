webDadosProducao ;----[Dados Producao Interface WEB]
	;
dadosProducao(sessid) ;---[prePageScript]
	d appendToList^%zewdAPI("ciclo","Atual","atual",sessid)
	d appendToList^%zewdAPI("ciclo","Anterior","anterior",sessid)
	d appendToList^%zewdAPI("periodo","Dia","dia",sessid)
	d appendToList^%zewdAPI("periodo","Semana","semana",sessid)
	d appendToList^%zewdAPI("periodo","Mes","mes",sessid)
	d appendToList^%zewdAPI("periodo","Trimestre","trimestre",sessid)
	d appendToList^%zewdAPI("periodo","Ano","ano",sessid)
	d appendToList^%zewdAPI("periodicidade","Diario","diario",sessid)
	d appendToList^%zewdAPI("periodicidade","Semanal","semanal",sessid)
	d appendToList^%zewdAPI("periodicidade","Mensal","mensal",sessid)
	d appendToList^%zewdAPI("periodicidade","Trimestral","trimestral",sessid)
	d appendToList^%zewdAPI("periodicidade","Anual","anual",sessid)
	;
	quit ""
	;
dadosProducao1 ;---[prePageScript]
	Set ciclo=$$getSessionValue^%zewdAPI("ciclo",sessid)
	Set periodo=$$getSessionValue^%zewdAPI("periodo",sessid)
	Set periodicidade=$$getSessionValue^%zewdAPI("periodicidade",sessid)
	Set dataInicial=$$getSessionValue^%zewdAPI("dataInicial",sessid)
	Set dataFinal=$$getSessionValue^%zewdAPI("dataFinal",sessid)
	;set M2=$O(^VDAPT(1,
	quit ""
	;
getChartDataMes(sessid);
 n chart,mes,ped,data,dl,cli,valor,valorDia,valorDia,valorMes,valorAno,valorPeriodo,MES,legendaMes
 s ped="",data="",dl="^",cli=""
 s valor="",valorDia="",valorDia="",valorMes=0,valorAno="",valorPeriodo=""
 s MES="",legendaMes="",mes="Janeiro,Fevereiro,Março,Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro"
 s nItem="",nPed="",nDia="",precoMes=""
 s areaItem="",areaPed="",areaDia="",areaMes=""
 d deleteFromSession^%zewdAPI("myChart",sessid)
 ;
 for  set data=$O(^PDPAT(1,2,data)) quit:data=""  do
 .set valorDia="",precoDia="",nPed=0,areaDia=""
 .for  set ped=$O(^PDPAT(1,2,data,ped)),nPed=nPed+1 quit:ped=""  do
 ..if '$D(^PDPAT(1,0,ped)) quit
 ..set cfOp=$P(^PDPAT(1,0,ped),dl,5),natOp=$P(^PDPAT(1,0,ped),dl,16)
 ..if (cfOp=1)!(cfOp=97)!(cfOp=98)!(cfOp=99) quit
 ..if (natOp=0)!(natOp=1)!(natOp=8)!(natOp=16)!(natOp=22)!(natOp=43)!(natOp=200) do
 ...set cli=$P(^PDPAT(1,0,ped),dl,1),valor=$G(^PDPAT(1,10,cli,ped))
 ...set valorDia=valorDia+valor
 ...set item="",nItem=0,precoPed="",areaPed=""
 ...for  set item=$O(^PDPAT(1,1,ped,item)),nItem=nItem+1 quit:item=""  do
 ....set areaItem=$P(^PDPAT(1,1,ped,item),dl,11)
 ....set areaPed=areaPed+areaItem 
 ....set precoItem=$P(^PDPAT(1,1,ped,item),dl,5)
 ....set precoPed=precoPed+precoItem 
 ...set areaDia=areaDia+areaPed
 ...set precoMedioPed=precoPed/nItem
 ...set precoDia=precoDia+precoMedioPed
 .set precoMedioDia=precoDia/nPed
 .set precoMes=precoMes+precoMedioDia,nDia=nDia+1
 .set areaMes=areaMes+areaDia
 .set valorMes=valorMes+valorDia
 .if valorMes=0 quit
 .set proxData=$O(^PDPAT(1,2,data))
 .if ($ZD($O(^PDPAT(1,2,data)),"MM")'=$ZD(data,"MM"))!(proxData="") do
 ..set precoMedioMes=precoMes/nDia
 ..set MES=MES+1,legendaMes=$ZD(data,"MMYY")
 ..set chart("faturamento",MES)=(valorMes/100)/10000,chart("legendaMes",MES)=legendaMes,chart("precoMedioMes",MES)=(precoMedioMes/100),chart("areaMes",MES)=areaMes/100
 ..set valorMes=0,precoMedioMes=0,precoMes=0,nDia=0,areaMes=0
 ..quit
 d mergeArrayToSession^%zewdAPI(.chart,"myChart",sessid)
 quit ""
 ;
getChartDataAno(sessid);
 n chart,mes,ped,data,dl,cli,valor,valorDia,valorDia,valorMes,valorAno,valorPeriodo,MES,legendaMes
 s ped="",data="",dl="^",cli="",valor="",valorDia="",valorMes=0,valorAno=0,valorPeriodo="",ANO="",ano=""
 s mes="Janeiro,Fevereiro,Março,Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro"
 d deleteFromSession^%zewdAPI("myChart",sessid)
 ;
 for  set data=$O(^PDPAT(1,2,data)) quit:data=""  do
 .set valorDia=""
 .for  set ped=$O(^PDPAT(1,2,data,ped)) quit:ped=""  do
 ..if '$D(^PDPAT(1,0,ped)) quit
 ..set cfOp=$P(^PDPAT(1,0,ped),dl,5),natOp=$P(^PDPAT(1,0,ped),dl,16)
 ..if (cfOp=1)!(cfOp=97)!(cfOp=98)!(cfOp=99) quit
 ..if (natOp=0)!(natOp=1)!(natOp=8)!(natOp=16)!(natOp=22)!(natOp=43)!(natOp=200) do
 ...set cli=$P(^PDPAT(1,0,ped),dl,1),valor=$G(^PDPAT(1,10,cli,ped))
 ...set valorDia=valorDia+valor quit
 .set valorAno=valorAno+valorDia
 .if valorAno=0 quit
 .set proxPed=$O(^PDPAT(1,2,data,ped))
 .if (proxPed="")!($ZD($O(^PDPAT(1,2,data)),"YY")'=$ZD(data,"YY")) do
 ..set ANO=ANO+1,legendaAno=$ZD(data,"YYYY")
 ..set chart("faturamento",ANO)=valorAno/100,chart("legendaAno",ANO)=legendaAno
 ..set valorAno=0
 ..quit
 d mergeArrayToSession^%zewdAPI(.chart,"myChart",sessid)
 quit ""
 ;
