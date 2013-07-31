/*procédure permettant de regarder, par marque, la cohérence d'autres variables 
(notamment, 1 marque est soit MDD soit non)*/
/*2/10/06 on allège la procédure en virant les sorties écran inutiles (CB et VO)*/

program define Distinct_marque,rclass
version 9.0
syntax [varlist]  [if]
set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */
set more off
tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

tokenize "`varlist'"    /*permet d'indexer les var ds l'ordre où elles sont placees en argument*/
quietly levels sa2 if   `touse'
*local marq "`r(list)'" /*je comprends pkoi ça ne marchait pas!!!c'est r(levels)!!!!!*/
local marq "`r(levels)'"
local pb ""


gen pb=0

foreach m of local marq {
    quietly distinct `1' if sa2==`m' &  `touse' ,missing
    if r(ndistinct)>1 {
        *di in red "-----------------------------------------------------------"
        local newpb "`m'"
        di "cette marque" in red  " `m' " in yellow "rencontre un pb pour la variable `1'. En effet :"
        tab `1' if sa2==`m',m
        tab sa2 if sa2==`m',m
        replace pb=1 if sa2==`m' & `touse'
    }
        local pb : list pb | newpb
}

di in green "les marques dont la variable `1' est douteuse sont : `pb'"

return local liste_pb= "`pb'"   

di " "
di "----------"
di in yellow  "procedure finie : les marques ont ete testees concernant la variable `1'."

end    /*fin du prog*/
