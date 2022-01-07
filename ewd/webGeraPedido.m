web ;----[ Interface WEB ]
 ;
populate(sessid) ;---[prePageScript]
 new CLIa,CODCLIa,CODCLI,DL,R,CLI,PED
 set CLIa="",CODCLIa="",CODCLI="",CLI="",DL="^",PED=""
 do clearList^%zewdAPI("cliente",sessid)

 ;merge array de clientes,cfops,formas pagto, itens,

 Q ""