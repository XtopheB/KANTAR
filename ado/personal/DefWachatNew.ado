/* ------------- PROGRAMME DefWachat------------      
/*16/12/04 modif initialisation Wachat à 0*/                 */
/* Créé le 5/11/04 par Valérie (anciennement DefWachat, ms ici aussi pr 2001)  */
/*   génère la variable Wachat= poids de l'achat par panéliste pour la période */
/*   pour chacun des 52 mois(4*13)                                           */
/* ---------------------------------------------------------- */


pause on   /* pour permettre les pauses */


program define DefWachatNew
version 8.0

capture confirm new variable Wachat 
if _rc==0 {    /* la variable Wachat n'existe pas déjà */

    gen Wachat=0
    forvalues i=1/52 {
        quietly replace Wachat=W`i' if Mois4==`i'  &  W`i'!=.   /*pr éviter que Wachat soit à missing*/
        }
    di in yellow " Variable Wachat cree " 
    }
else { 
    display in red "Aucune operation effectuee: Wachat existe deja "
}


end
