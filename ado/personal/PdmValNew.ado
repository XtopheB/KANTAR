*-----------------------------------PdmValNew.ado---------------------------------------------------
*------------procédure qui calcule ----------------------------------
*------------------------------------------2/03/05------------------------------------------------------

program define PdmValNew,rclass
version 8.2
syntax [varlist] [if]

set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */
set more off
tokenize "`varlist'"  

tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'


gen toto=sum(ptwa*Wachat) if  `touse' 
egen num=max(toto) 

gen tata=sum(ptwa*Wachat)  
egen deno=max(tata) 

capture drop toto
capture drop tata

return local pdmval = (num/deno)*100

capture drop num
capture drop deno

end
*--------------------------------------------------------------------------------------------------------




