web ;---- [ConsultaApontCliente | 27/10/2018 11:45]

inicio(sessid) ;---[ prePageScript ]
 set CLIa="",CODCLIa=""
 do clearList^%zewdAPI("Cliente",sessid)
 ;
 set CLIa=""
listaClientes ;
 for  set CLIa=$O(^FTCLIa(CLIa)) Q:CLIa=""  D
 . set CODCLIa=$O(^FTCLIa(CLIa,""))
 . do appendToList^%zewdAPI("Cliente",CLIa,CODCLIa,sessid)

 quit ""
 ;