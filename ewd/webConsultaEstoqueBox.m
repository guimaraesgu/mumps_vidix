web ;---- [Pesquisa Estoque Box | 24/09/2020 21:11]
 ;
init(sessid) ;---[ prePageScript ]
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 do deleteFromSession^%zewdAPI("portaIncArray",sessid)
 do deleteFromSession^%zewdAPI("fixoIncArray",sessid)
 do deleteFromSession^%zewdAPI("portaCinzaArray",sessid)
 do deleteFromSession^%zewdAPI("fixoCinzaArray",sessid)
 do deleteFromSession^%zewdAPI("portaVerdeArray",sessid)
 do deleteFromSession^%zewdAPI("fixoVerdeArray",sessid)
 do deleteFromSession^%zewdAPI("nomCli",sessid)

 ;--- INCOLOR PORTA E FIXO
 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=2135:5:2175 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set portaInc=$O(^ESTOQUEBOX(0,i))
 . set portaIncArray(counter)=$E(portaInc,3,4)
 . set portaIncArray(counter,1)=^(portaInc)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,portaInc,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set portaIncArray(counter,2,codPed)=codPed
 .. for  Q:qntEtqRsv=0  D
 ... set numEtq=$G(^ESTOQUEBOX(0,portaInc,codPed,qntEtqRsv))
 ... set portaIncArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=portaInc D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,3)) set qntEmProducao=qntEmProducao+1
 . set portaIncArray(counter,2)=counterEtqRsv
 . set portaIncArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.portaIncArray,"portaIncArray",sessid)
 . set counter=counter+1
 


 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=2235:5:2275 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set fixoInc=$O(^ESTOQUEBOX(0,i))
 . set fixoIncArray(counter)=$E(fixoInc,3,4)
 . set fixoIncArray(counter,1)=^(fixoInc)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,fixoInc,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set fixoIncArray(counter,2,codPed)=codPed
 .. for  D  Q:qntEtqRsv=0
 ... set numEtq=$G(^ESTOQUEBOX(0,fixoInc,codPed,qntEtqRsv))
 ... set fixoIncArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=fixoInc D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,2)) set qntEmProducao=qntEmProducao+1
 . set fixoIncArray(counter,2)=counterEtqRsv
 . set fixoIncArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.fixoIncArray,"fixoIncArray",sessid)
 . set counter=counter+1
 

;--- CINZA PORTA E FIXO
 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=3135:5:3175 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set portaCinza=$O(^ESTOQUEBOX(0,i))
 . set portaCinzaArray(counter)=$E(portaCinza,3,4)
 . set portaCinzaArray(counter,1)=^(portaCinza)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,portaCinza,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set portaCinzaArray(counter,2,codPed)=codPed
 .. for  Q:qntEtqRsv=0  D
 ... set numEtq=$G(^ESTOQUEBOX(0,portaCinza,codPed,qntEtqRsv))
 ... set portaCinzaArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=portaCinza D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,3)) set qntEmProducao=qntEmProducao+1
 . set portaCinzaArray(counter,2)=counterEtqRsv
 . set portaCinzaArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.portaCinzaArray,"portaCinzaArray",sessid)
 . set counter=counter+1

 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=3235:5:3275 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set fixoCinza=$O(^ESTOQUEBOX(0,i))
 . set fixoCinzaArray(counter)=$E(fixoCinza,3,4)
 . set fixoCinzaArray(counter,1)=^(fixoCinza)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,fixoCinza,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set fixoCinzaArray(counter,2,codPed)=codPed
 .. for  D  Q:qntEtqRsv=0
 ... set numEtq=$G(^ESTOQUEBOX(0,fixoCinza,codPed,qntEtqRsv))
 ... set fixoCinzaArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=fixoCinza D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,2)) set qntEmProducao=qntEmProducao+1
 . set fixoCinzaArray(counter,2)=counterEtqRsv
 . set fixoCinzaArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.fixoCinzaArray,"fixoCinzaArray",sessid)
 . set counter=counter+1

 ;--- VERDE PORTA E FIXO
 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=5135:5:5175 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set portaVerde=$O(^ESTOQUEBOX(0,i))
 . set portaVerdeArray(counter)=$E(portaVerde,3,4)
 . set portaVerdeArray(counter,1)=^(portaVerde)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,portaVerde,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set portaVerdeArray(counter,2,codPed)=codPed
 .. for  D  Q:qntEtqRsv=0
 ... set numEtq=$G(^ESTOQUEBOX(0,portaVerde,codPed,qntEtqRsv))
 ... set portaVerdeArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=portaVerde D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,3)) set qntEmProducao=qntEmProducao+1
 . set portaVerdeArray(counter,2)=counterEtqRsv
 . set portaVerdeArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.portaVerdeArray,"portaVerdeArray",sessid)
 . set counter=counter+1
 
 set counter=0,counterEtqRsv=0,qntEmProducao=0
 for i=5235:5:5275 D
 . set counterEtqRsv=0
 . set qntEmProducao=0
 . set fixoVerde=$O(^ESTOQUEBOX(0,i)) 
 . set fixoVerdeArray(counter)=$E(fixoVerde,3,4)
 . set fixoVerdeArray(counter,1)=^(fixoVerde)
 . set codPed=""
 . for  set codPed=$O(^ESTOQUEBOX(0,fixoVerde,codPed)) Q:codPed=""  D
 .. set qntEtqRsv=^(codPed)
 .. set counterEtqRsv=counterEtqRsv+qntEtqRsv
 .. set fixoVerdeArray(counter,2,codPed)=codPed
 .. for  D  Q:qntEtqRsv=0
 ... set numEtq=$G(^ESTOQUEBOX(0,fixoVerde,codPed,qntEtqRsv))
 ... set fixoVerdeArray(counter,2,codPed,qntEtqRsv)=numEtq
 ... set qntEtqRsv=qntEtqRsv-1
 . set ped=""
 . for  set ped=$O(^PDPAB(1,0,ped)) Q:ped=""  D
 .. set numPed=ped
 .. set regPed=^(ped)
 .. set cli=$P(regPed,"^",1)
 .. if cli=820&('$D(^PDPAB(1,15,numPed))) D
 ... set item=""
 ... for  set item=$O(^PDPAB(1,1,numPed,item)) Q:item=""  D
 .... set regItem=^(item)
 .... set codProd=$P(regItem,"^",1)
 .... if codProd=fixoVerde D
 ..... set numEtiqEstoque=""
 ..... for  set numEtiqEstoque=$O(^VDETQ(1,numPed,item,numEtiqEstoque)) Q:numEtiqEstoque=""  D
 ...... if '$D(^VDAPT(0,numEtiqEstoque,2)) set qntEmProducao=qntEmProducao+1
 . set fixoVerdeArray(counter,2)=counterEtqRsv
 . set fixoVerdeArray(counter,3)=qntEmProducao
 . do mergeArrayToSession^%zewdAPI(.fixoVerdeArray,"fixoVerdeArray",sessid)
 . set counter=counter+1

 quit ""
;