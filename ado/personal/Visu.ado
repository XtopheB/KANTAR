/* ------------- PROGRAMME Visu------------         */
/* 24 Novembre    (CB)                              */
/*                                                  */
/* version préliminaire                             */

program define Visu
version 8.0
set more on

pause on   /* pour permettre les pauses */
set output error  /* Supprime l'affichage  */

/* ETAPE 0 : on supprime les variables qui nous polluent la vie  */ 
preserve

local polluant "sm* s1a7 sa2 sa4 sa7 s191 srwp sa2bis "
foreach toto in `polluant' {
    capture drop `toto'
    }

 
/*ETAPE 1 :récupérer la list des variables spécifiques */

quietly ds s*
local listspe `r(varlist)'   /* listspe contient maintenant toutes les var spécifiques */ 
restore 
set output proc /* retablit l'affichage  */
 
 des s*
 
/*ETAPE N° 2 : Tableau  sur ces variables   */ 
foreach varspe of local listspe {
    capture numlabel typo`varspe', add
    tab1 `varspe', missing
    }
    
end 
    
    
