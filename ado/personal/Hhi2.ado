/*Hhi2 (27/10/05) permet de calculer un indice de concentration qui peut être basé sur une autre variable que la marque (sa4, enwp...)*/
/*procédure qui calcule et graphe (son évolution ds le temps) l'indice de concentration d'Herfindahl*/ /*1/04/05*/

program define Hhi2, eclass 
version 8.2, missing 
syntax [if]  [, onvar(string)] 
tempvar touse  /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/ 

mark `touse' `if'

quietly count if `touse' 
if r(N)>0 { /*debut boucle si nb d'obs >0*/
    local cond=1
}

set more off 
set output error

local produit "$p"

preserve
    keep if  `touse'        /*par exemple si on ne veut que sur les MN (brand2==4)*/
    levels `onvar'
    local var_con "`r(levels)'"
    gen Val=0
    gen PdmVal=0

    bysort Mois4 : gen titi=sum(ptwa * Wachat)
    bysort Mois4 : egen deno = max(titi)

    foreach m of local var_con {
        bysort Mois4 : gen toto=sum(ptwa * Wachat) if `onvar'==`m'
        bysort Mois4 : egen Val`m' = max(toto)
        bysort Mois4 : replace Val = Val`m' if `onvar'==`m'
        bysort Mois4 : replace PdmVal = (Val / deno) * 100 if `onvar'==`m'
        quietly drop toto  Val`m'
    }
    quietly bysort Mois4 `onvar': keep if _n==1
    gen hhi0=0
    bysort Mois4 : replace hhi0=sum(PdmVal * PdmVal)
    bysort Mois4 : egen hhi = max(hhi0)
    set output proc
    sum hhi
    global hhi = `r(mean)'

    quietly drop titi deno
    twoway (line hhi Mois4)  ,   ytitle(Indice Herfindahl basé sur `onvar') xtitle(Periode de 4 semaines)  note(produit `produit') xlabel( 1 "1998" 7 "july" 14 "1999" 21 "july" 27 "2000" 34 "july" 40 "2001" 47 "july" , angle(forty_five))
    if `cond'==1 {
        capture graph export "../`produit'/01/hhi_`on'_if.eps", as(eps)   replace
     }
     else {
        capture graph export "../`produit'/01/hhi.`on'_eps", as(eps)   replace
     }
    di "graph cond `touse'.eps sauve pr le produit `produit'"
    set output error

restore
gen hhi`onvar' = $hhi

end

exit
