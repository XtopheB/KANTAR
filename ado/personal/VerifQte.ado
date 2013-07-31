/*8/02/05 correction (V) quC0 et quC1 et plus qu0 et qu1*/

program define VerifQte,rclass
version 7.0
syntax [varlist] [if] 
tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

quietly count if `touse'
if r(N)>0 { /*debut boucle si nb d'obs > 0*/

quietly LabelReturn1 qu4* `if'
if `"`r(label)'"'=="Quantite en g" {  /*si la variable de qte est qu40*/
       quietly gen nblot=int(qu40/(s142*s158)) `if' /*le nb de lots peut etre obtenu en considerant la partie entiere du ratio (quantite totale / (poids unitaire fois nb d'unites ds le lot))*/
       quietly count if (qu40!=s142*s158*prwa*nblot & `touse')  /*on compte le nb d'obs tq la qte totale != a ...*/
       return scalar NPbQte=r(N)  /*ds la return list on aura le nb en question*/
       if r(N)>0 {  /*si ce nb est >0*/
                  scalar define taux=round(100*(r(N)/_N), .01) /*def d'un scalaire = au tx d'erreur*/
                  di""  /*pour sauter une ligne*/
                  di in yellow "ATTENTION : Pb de qte pour `r(N)' obs, soit un % d'erreur de " taux

                  /*on corrige en missing les qtes a pb : qu40 et qu0*/

                  *quietly CorrectionA qu40 if (qu40!=s142*s158*prwa*nblot & `touse'),code(2) missing(point)
                  replace achaber=2 if (qu40!=s142*s158*prwa*nblot & `touse') 
                  *quietly CorrectionA quC0 if (Zqu40C2!=s142*s158*prwa*nblot & `touse'),code(2) missing(point)  /*correction V quC0 et plus qu0!!!*/
                  replace achaber=2 if (qu40!=s142*s158*prwa*nblot & `touse')
                  di""  /*pour sauter une ligne*/
                  di"Fin de la verif des qtes : qtes a problemes recodees en missing"
                  di""  /*pour sauter une ligne*/
                  } 
       else if r(N)==0 { /*si le nb est nul*/
                  di""  /*pour sauter une ligne*/
                  di in yellow "OK : Aucun probleme de quantite"
                       } 
       quietly drop nblot  
} 
   
/*============les traitement ci-apres sont parfaitement similaires a ce qui precede, excepte le fait que===============*/
/*============l'on s'interesse aux autres variables de qte :  (qu41, qu1) et (qu46,qu6)================================*/


       if `"`r(label)'"'=="Quantite en ml" {
       quietly gen nblot=int(qu41/(s141*s158*s164)) `if' /*le nb de lots peut etre obtenu en considerant la partie entiere du ratio (quantite totale / (poids unitaire fois nb d'unites ds le lot fois nb d'unites dans le pack))*/
       quietly count if (qu41!=s141*s158*prwa*nblot*s164 & `touse')
       /* la qte totale doit etre egale au produit poids unitaire fois nb de lots fois nb d'unites dans le lot fois nb d'unites ds le pack fois coefficient produit en plus*/
       return scalar NPbQte=r(N)
       if r(N)>0 {
                  scalar define taux=round(100*(r(N)/_N), .01)
                  di""  /*pour sauter une ligne*/
                  di in yellow "ATTENTION : Pb de qte pour `r(N)' obs, soit un % d'erreur de " taux
                  *quietly CorrectionA qu41 if (qu41!=s141*s158*prwa*nblot*s164 & `touse'),code(2) missing(point) 
                  replace achaber=2 if (qu41!=s141*s158*prwa*nblot*s164 & `touse')
                  *quietly CorrectionA quC1 if (Zqu41C2!=s141*s158*prwa*nblot*s164 & `touse'),code(2) missing(point)   /*quC1 et plus qu1!!!*/
                  replace achaber=2 if (qu41!=s141*s158*prwa*nblot*s164 & `touse')
                  di""  /*pour sauter une ligne*/
                  di"Fin de la verif des qtes : qtes a problemes recodees en missing"
                  di""  /*pour sauter une ligne*/
                  } 
       else if r(N)==0 { 
                  di""  /*pour sauter une ligne*/ 
                  di in yellow "OK : Aucun probleme de quantite"
                       } 
       quietly drop nblot        
             
   } 

} /*fin boucle si nb d'obs > 0*/

else if r(N)==0 { /*debut boucle si nb d'obs = 0*/

di in green "Aucune observation"

}  /*fin boucle si nb d'obs = 0*/

end    /*fin du prog*/
