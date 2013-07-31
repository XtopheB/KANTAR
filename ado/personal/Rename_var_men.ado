/*proc�dure qui permet de renommer des variables (m�nages) en fonction de ce qu'on veut (ann�e)*/
/*L'id�e est que dans nos fichiers 2002-2003, certaines variables �voluent sur les 2 ans et il est donc important de les renommer en fonction de l'ann�e*/
/*7/12/06 val�rie */

program define Rename_var_men 
version 9.2
*syntax [varlist]  [if] 
args texte
*tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/ 
*mark `touse' `if'
*tokenize "`varlist'"  

forvalues i = 1/11 {
    ren  ipds`i'  ipds`i'_`texte'  /*poids*/
    ren ista`i' ista`i'_`texte'    /*statut (et donc sexe)*/
    replace ipds`i'_`texte'=. if ipds`i'_`texte'==999
    ren icsp`i' icsp`i'_`texte'    /*csp*/
    ren iage`i' iage`i'_`texte'    /*�ge*/
    ren iana`i' iana`i'_`texte'    /*ann�e naissance*/
    ren ihad`i' ihad`i'_`texte'    /*taille*/
    ren ipoi`i' ipoi`i'_`texte'    /*pointure*/
    ren ibad`i' ibad`i'_`texte'    /*tour de bassin (continue)*/
    ren ibas`i' ibas`i'_`texte'    /*tour de bassin (classes)*/
    ren itpd`i' itpd`i'_`texte'    /*tour de poitrine (continue)*/
    ren itpo`i' itpo`i'_`texte'    /*tour de poitrine (classes)*/
    ren icol`i' icol`i'_`texte'    /*tour de col (homme)*/
    ren itad`i' itad`i'_`texte'    /*tour de taille (continue) (homme)*/
    ren itai`i' itai`i'_`texte'    /*tour de taille (classes) (homme)*/
    ren ihau`i' ihau`i'_`texte'     /*Stature indiv `i' (classes)*/
    ren BMI`i' BMI`i'_`texte'       /*bmi*/
    
} 

ren  nf nf_`texte' 
ren foyer foyer_`texte'
*ren stat stat_`texte'  /*statut du + jeune b�b� de moins de 3 ans (fille ou gar�on)*/

   

end

exit
