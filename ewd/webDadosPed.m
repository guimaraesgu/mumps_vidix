webDadosPed ;---[ Busca Dados de Pedidos Interface WEB ]
 ;
dadosItemPed(sessid) ;--[ Pega dados do item do pedido ]
 set DL="^"
 set erro="",situacao="",pedido="",item="",qte="",arquivo="",cliente="",nomeItem="",descricao=""
 ;
 set etiqueta=$$getSessionValue^%zewdAPI("codigo",sessid)
 if etiqueta="" s erro=1,situacao="Informe a etiqueta!" goto montaDadosItemPed
 set etiqueta=+etiqueta
 set reg=$g(^VDETQ(0,etiqueta))
 if reg="" s erro=1,situacao="Item nao consta na produçao!" goto montaDadosItemPed
 set pedido=$p(reg,DL,1)
 set item=$p(reg,DL,2)
 set qte=$p(reg,DL,3)
 set arquivo=$$montaArquivo(pedido,item)
 if ($zsearch(arquivo)="")&($zsearch(arquivo)="") set arquivo="/img/semProjeto.png"
 set rped=$get(^PDPAB(1,0,pedido))
 if rped="" set erro=1,situacao="Pedido Invalido" goto montaDadosItemPed
 set cliente=$p(rped,DL,1)
 if cliente="" set erro=1,situacao="Cliente invalido" goto montaDadosItemPed
 set cliente=$p($g(^FTCLI(cliente)),DL,1)
 if cliente="" set erro=1,situacao="Cliente invalido" goto montaDadosItemPed
 set R=$g(^PDPAB(1,1,pedido,item))
 if item="" set erro=1,situacao="Item Invalido" goto montaDadosItemPed
 ;
 S COD=$P(R,DL,1)
 S RPRO=$G(^FTPRO(1,COD))
 S NPRO=$P(RPRO,DL,1)
 S ALT=$p(R,DL,9)
 S OBITEM=$P(R,DL,6)
 S LARG=$p(R,DL,10)
 S MEDIDA=$j(ALT,5,3)_" x "_$j(LARG,5,3)
 S QTE=$P(R,DL,3)
 set nomeItem=NPRO_" "_MEDIDA
 set descricao=nomeItem_" "_OBITEM
 ;
montaDadosItemPed
 do setSessionValue^%zewdAPI("pedido",pedido,sessid)
 do setSessionValue^%zewdAPI("item",item,sessid)
 do setSessionValue^%zewdAPI("qte",qte,sessid)
 do setSessionValue^%zewdAPI("arquivo",arquivo,sessid)
 do setSessionValue^%zewdAPI("cliente",cliente,sessid)
 do setSessionValue^%zewdAPI("nomeItem",nomeItem,sessid)
 do setSessionValue^%zewdAPI("descricao",descricao,sessid)
 do setSessionValue^%zewdAPI("erro",erro,sessid)
 do setSessionValue^%zewdAPI("situacao",situacao,sessid)
 do deleteFromSession^%zewdAPI("ResultSet",sessid)
 quit
 ;*******************************************************************
montaArquivo(pedido,item) ;----[ monta nome de arquivo imagem ]
        new path
        set path=$g(^VDPAR(1))
        set extensao=$p(path,"^",2)
        set path=$p(path,"^",1)
        if path="" quit "Falta parametro path arquivo"
        set arquivo=path_pedido_"-"_item_"."_extensao
        quit arquivo
        ;
