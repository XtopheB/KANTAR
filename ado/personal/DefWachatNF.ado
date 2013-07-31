/* ------------- PROGRAMME DefWachat------------      
/*16/12/04 modif initialisation Wachat à 0*/                 */
/* Créé le 5/11/04 par Valérie (anciennement DefWachat, ms ici aussi pr 2001)  */
/*   génère la variable Wachat= poids de l'achat par panéliste pour la période */
/*   pour chacun des 52 mois(4*13)                                           */
/*procédure DefWachatNewNF créée à partir de DefWachatNew pour les nouvelles données 2002 et 2003 (8/08/06 valérie)*/
/*19/07/07 ça marche aussi sur 2004 (valérie)*/
/*30//07/07 gère selon l'année (en regardant le min et max de Mois4)*/
/*18/07/07 : création variable WFrance qui est juste nb de ménages représentés (Wachat * nb ménages / somme pond)*/
/*26/09/07 : annee remplacée par an car sinon, pb 2003 2003              */
/* 29/09/2008 : La variable an n'est plus utilisée (cf datamaker) C& V    */
/*18/12/08 : an remplacée par annee         */
/* 11/06/2009 : Initialisation de Wachat et WFrance à . et non à 0   */
/*25/09/09 numéro de version en locale + notes des variables Wachat et WFrance*/
/* ----------------------------------------------------------------- */


pause on   /* pour permettre les pauses */


program define DefWachatNF
version 10.0

local numversion "2.0"

capture confirm new variable   ctwpenwp        /*n'importe, juste pour tester si on est bien sur nos nouveaux fichiers 2002 2003*/ 
if _rc==0 {    /* la variable ctwpenwp n'est pas dans le fichier--> fichier ancienne formule*/ 
    di in red "Procédure DefWachatNF n' est pas appropriée pour ce fichier ancienne formule."
    di in red "Utiliser DefWachatNew.ado."
}
else {
    capture confirm new variable Wachat 
    if _rc==0 {    /* la variable Wachat n'existe pas déjà */
    
        gen Wachat=.   /* Pour éviter des poids nuls...  */
        gen WFrance=. 
        
        quietly levels panel
        if `r(levels)'==1 {
            local p "gc"
        }
        if `r(levels)'==2 {
            local p "vp"
        }
        if `r(levels)'==3 {
            local p "fl"
        }
        
       

        quietly sum Mois4        /*NEW 30/07/07*/
        forvalues i= `r(min)'/`r(max)' {         /*78/91 */   /*pour 2002 et 2003 (que jusqu'à 78) et 2004 (de 79 à 91)*/
            capture quietly replace Wachat=k`p'per`i'  if Mois4==`i'  &  k`p'per`i'!=.   /*pr éviter que Wachat soit à missing*/
            
            capture quietly replace WFrance = k`p'per`i'/${SumPond`p'per`i'} if Mois4==`i'
        }
        
        quietly replace WFrance = WFrance * 23810161 if annee<2004      /*basé sur enquête insee 1999*/ 
        quietly replace WFrance = WFrance * 25732000 if annee>=2004     /*enquête 2004*/
                                                                                /*... to be completed plus tard*/
        label variable Wachat "Pondération période (mensuelle) de l'achat"
        label variable WFrance "Nb de ménages France représentés période (mensuelle) de l'achat"

        di in yellow " Variable Wachat et WFrance creees " 
        note Wachat : Wachat créé avec la version `numversion' de DefWachatNF.do
        note WFrance : WFrance créé avec la version `numversion' de DefWachatNF.do
    }
    else { 
        display in red "Aucune operation effectuee: Wachat existe deja "
    }
}

end
