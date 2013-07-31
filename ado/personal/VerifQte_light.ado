/*14/02/05 juste erreur qte si qte unitaire > qte totale (on fait ce chgt car par ex. cas actimel virait des obs à tort (car pb approximation)*/

program define VerifQte_light,rclass
version 7.0
syntax [varlist] [if] 
tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

quietly count if `touse'

if r(N)>0 { /*debut boucle si nb d'obs > 0*/

        
        capture quietly LabelReturn qu4* `if'
        local var_poids "`r(var)'"
        local label_poids "`r(LabelVariable)'"
        
        
        if "`label_poids'"=="Quantite en g" {  /*si la variable de qte est qu40*/
            di "qte en g"
            capture confirm new variable s142
            if _rc!=0  { /*la variable s142 est ds le fichier*/  
                di "la variable s142 est ds le fichier" 
                replace achaber=2 if (s142> `var_poids' & s142!=. & `touse')
                tab achaber
            }
            else {
                di in red "pas de variable s142 ds ce fichier, donc pas de verif sur les qtes"
            }
        }   /*fin qte en g*/
        
    
        if "`label_poids'"=="Quantite en ml" {   
            di "qte en mL"
            capture confirm new variable s141
            if _rc!=0  { /*la variable s141 est ds le fichier*/   
                 replace achaber=2 if (s141> `var_poids' & s141!=. & `touse')
                 tab achaber
            }
            else {
                di in red "pas de variable s141 ds ce fichier, donc pas de verif sur les qtes"
            }
        }   /*fin qte en mL*/
    
        else if "`label_poids'"==""    {
            di in red "ATTENTION : pas de variable qu4*"
        }
        
        else if "`label_poids'"!="Quantite en g"  &  "`label_poids'" !="Quantite en ml" & "`label_poids'"!=""  {
            di in red "ATTENTION : label non courant (c'est : `label_poids') donc pas g,  ni mL"
        }
    
} /*fin boucle si nb d'obs > 0*/
    

else if r(N)==0 { /*debut boucle si nb d'obs = 0*/
    di in green "Aucune observation"
}  /*fin boucle si nb d'obs = 0*/


end    /*fin du prog*/
