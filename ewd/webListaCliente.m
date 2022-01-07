web ;---- [Lista Cliente | 14/04/2018 10:30]

lista(sessid) ;---[ prePageScript ]
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
