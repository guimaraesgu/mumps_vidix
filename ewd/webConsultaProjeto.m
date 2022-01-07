webConsultaProjeto ;---- [Consulta Projeto Interface WEB]
 ;
consultaProjeto(sessid);
 set etiqueta=$$getSessionValue^%zewdAPI("tipoConsulta",sessid)
 if etiqueta="etiqueta" goto etiqueta
 else  goto listaItens
 ;
etiqueta;
 d dadosItemPed^webDadosPed(sessid)
 quit ""
 ;
listaItens;
         do deleteFromSession^%zewdAPI("ResultSet",sessid)
         set pedido=$$getSessionValue^%zewdAPI("codigo",sessid)
         If pedido="" Quit "Favor informar pedido para consulta"
         set PED=pedido,DL="^"
         set flag="",rped=""
         if $D(^PDPAB(1,0,PED)) set rped=^(PED),flag="aberto"
         if $D(^PDPAT(1,0,PED)) set rped=^(PED),flag="atendido"
         if flag="" quit "Pedido nao existe"
         ;
         S CLI=$P(rped,"^",1)
         S cliente=$p($G(^FTCLI(CLI)),DL,1)
         ;
         S ITEM=""
         k row
         set ct=0,DL="^"
        ;
ITEM    ;
        If flag="aberto" set ITEM=$O(^PDPAB(1,1,PED,ITEM)) G ITEMZ:ITEM=""
        If flag="atendido" set ITEM=$O(^PDPAT(1,1,PED,ITEM)) G ITEMZ:ITEM=""
        Set R=^(ITEM)
        Set COD=$P(R,DL,1)
        Set RPRO=$G(^FTPRO(1,COD))
        Set NPRO=$P(RPRO,DL,1)
        Set TIPO=$P(RPRO,DL,10)
        If TIPO'=1 G ITEM
        Set ALT=$p(R,DL,9)
        Set OBITEM=$P(R,DL,6)
        Set LARG=$p(R,DL,10)
        Set MEDIDA=$j(ALT,5,3)_" x "_$j(LARG,5,3)
        set nomeItem=NPRO_" "_MEDIDA
        set descr=NPRO_" "_MEDIDA_" "_OBITEM
        set ct=ct+1
        set arquivo=$$montaArquivo^webDadosPed(PED,ITEM)
        if $zsearch(arquivo)="" set arquivo="/img/semProjeto.png"
	set row(ct)=pedido_DL_ITEM_DL_descr_DL_cliente_DL_arquivo_DL_nomeItem
        goto ITEM
ITEMZ   ;
        Do deleteFromSession^%zewdAPI("ResultSet",sessid)
        Do mergeArrayToSession^%zewdAPI(.row,"ResultSet",sessid)
	quit ""
	;
