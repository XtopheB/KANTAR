*-----------------------------------CoeffVariation.ado---------------------------------------------------
*------------procédure qui calcule le coeff de variation d'une variable----------------------------------
*------------------------------------------29/02/05------------------------------------------------------

program define CoeffVariation,rclass
version 8.2
syntax [varlist] [if]

set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */
set more off
tokenize "`varlist'"  

tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

quietly sum `1' if  `touse'
return local cv = (r(sd)/r(mean))*100  /* coefficient de variation */

end
*--------------------------------------------------------------------------------------------------------

