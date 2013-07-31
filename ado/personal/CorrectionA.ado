/*version du 9/07/03 : modif du recodage de achaber(on ne le recode plus si il était déjà !=0*/
/* enregistrer sous c:\ado\personnal\filename.ado */
/*cette procedure permet de corriger les observations aberrantes*/

/* ENTREES */
/* varlist= variable(s) à corriger */
/* val = nouvelle valeur à imputer (option) */
/* code =  code d'erreur pour achaber (option)*/
/* missing= pour imputer une valeur non numérique (. par exemple) (option) */

/* EN SORTIE :  AFFICHAGE ECRAN    */
/* YC le 18 Nov 2002 CORRECTION CHRIS JUIN 2003   */ 


version 8.0
program define CorrectionA 
syntax [varlist] [if] [in] [,val(real 1) code(real 1) missing(string)] 
tokenize `varlist'
tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

quietly count if `touse'
if r(N)>0 { /*debut boucle si nb d'obs > 0*/

while "`1'"!=""{
    capture gen Z`1'C`code'=`1'     /*  on garde l'ancienne valeur */
    di in white " creation de la variable de sauvegarde Z`1'C`code'"
    quietly replace achaber=`code' if `touse'& achaber==0 `in'  /* on donne un code d'erreur dans la variable achaber */

    if "`missing'" !="" {           /* Cas d'un nouveau codage en missing */ 
        replace `1'=. if `touse' `in'
        di in white " Remplacement par la valeur missing dans la variable `1'"
        }
    else    {
        replace `1'=`val' if `touse' `in'  /* Cas d'un recodage avec la nouvelle valeur  */
        di in white " Remplacement par la valeur `val' dans la variable `1'"
        }
    mac shift /* on passe à la variable suivante */
    }
} /*fin boucle si nb d'obs > 0*/

else if r(N)==0 { /*debut boucle si nb d'obs = 0*/

di in green "Aucune observation"

}  /*fin boucle si nb d'obs = 0*/


end
