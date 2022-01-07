web ;---- [Consulta programa de corte]
 ;
config(sessid) ;---[ prePageScript ]
 do deleteFromSession^%zewdAPI("erro",sessid)
 do deleteFromSession^%zewdAPI("motivo",sessid)
 set eq="",d="",a="",data="",arquivo="",dataCorte="",arquivoCorte=""
 set equip("BAV")="Bavelloni",equip("BYS")="Bystronic"
 for  s eq=$O(equip(eq)) q:eq=""  do
 .s equipCorte=(equip(eq))
 .do appendToList^%zewdAPI("equipCorte",equipCorte,eq,sessid)
 quit ""
 ;
lista(sessid) ;---[ actionScript ]
 set equip=$$getSessionValue^%zewdAPI("equipCorte",sessid)
 if equip="BAV" s equip="Bavelloni"
 if equip="BYS" s equip="Bystronic"
 if equip="" quit ""
 set i="",d="",a="",data="",datas="",arquivo="",arquivos="",dataCorte="",arquivoCorte=""
listaDatas;
 for  s data=$zsearch("/cortes/"_equip_"/*") quit:data=""  do
 .set i=1+i
 .set datas(i)=$P(data,"/cortes/"_equip_"/",2)
 for  s d=$O(datas(d)) q:d=""  do
 .s dataCorte=(datas(d))
 .do appendToList^%zewdAPI("dataCorte",dataCorte,dataCorte,sessid)
 set data=$$getSessionValue^%zewdAPI("dataCorte",sessid)
 if data="" quit ""
listaArquivos;
 set i="" 
 for  s arquivo=$zsearch("/cortes/"_equip_"/"_data_"/*") quit:arquivo=""  do
 .set i=1+i
 .set arquivos(i)=$P(arquivo,"/cortes/"_equip_"/"_data_"/",2)
 for  s a=$O(arquivos(a)) q:a=""  do
 .s arquivoCorte=(arquivos(a))
 .do appendToList^%zewdAPI("arquivoCorte",arquivoCorte,arquivoCorte,sessid)
 quit ""
 ;
consultaCorte(sessid) ;---[ prePageScript ]
 ;
 set equip=$$getSessionValue^%zewdAPI("equipCorte",sessid)
 set prog=$$getSessionValue^%zewdAPI("arquivoCorte",sessid)
 set data=$$getSessionValue^%zewdAPI("dataCorte",sessid)
 if data="" set erro=1,motivo="Selecione uma data" goto erroConsultaCorte
 if prog="" set erro=1,motivo="Selecione um arquivo" goto erroConsultaCorte
 if equip="BAV" s equip="Bavelloni" goto consultaCorteBav
 if equip="BYS" s equip="Bystronic" goto consultaCorteBys
 quit ""
 ;
consultaCorteBys;
 quit ""
 ;
consultaCorteBav;
 set c="",dl="^"
 i $zsearch("/cortes/"_equip_"/"_data_"/"_prog)'=""  do
 .set arquivo="/cortes/"_equip_"/"_data_"/"_prog
 else  set erro=1,motivo="Arquivo nao existe" goto erroConsultaCorte
 o arquivo
 u arquivo
 for i=1:1 quit:$zeof  do
 .r linha 
 .s:linha["L6" coord(i)=linha 
 .s:linha["E30000" chapa=linha,largChapa=$E(chapa,$F(chapa,"E30000="),$F(chapa,"0E30001")-8),altChapa=$E(chapa,$F(chapa,"E30001="),$F(chapa,"E30002")-7)
 for  set c=$O(coord(c)) quit:c=""  do
 .set x0=$E(coord(c),$F(coord(c),"L6="),$F(coord(c),"L7")-3)
 .set y0=$E(coord(c),$F(coord(c),"L7="),$F(coord(c),"L8")-3)
 .set x1=$E(coord(c),$F(coord(c),"L13="),$F(coord(c),"L14")-4)
 .set y1=$E(coord(c),$F(coord(c),"L14="),$F(coord(c),"G")-2)
 .set corte(c)=x0_dl_y0_dl_x1_dl_y1
 ;
carregaCorte;
 do setSessionValue^%zewdAPI("largChapa",largChapa,sessid)
 do setSessionValue^%zewdAPI("altChapa",altChapa,sessid)
 do mergeArrayToSession^%zewdAPI(.corte,"cortes",sessid)
 quit ""
 ;
erroConsultaCorte ;
 do deleteFromSession^%zewdAPI("equipCorte",sessid)
 do deleteFromSession^%zewdAPI("arquivoCorte",sessid)
 do deleteFromSession^%zewdAPI("cortes",sessid)
 do deleteFromSession^%zewdAPI("altChapa",sessid)
 do deleteFromSession^%zewdAPI("largChapa",sessid)
 do setSessionValue^%zewdAPI("erro",erro,sessid)
 do setSessionValue^%zewdAPI("motivo",motivo,sessid)
 quit ""
 ;
