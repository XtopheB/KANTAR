
program define EcartIndivMenage,rclass
version 9.2
syntax [varlist] [if]

set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */
set more off
tokenize "`varlist'"

tempvar touse   /*creation d'une var temporaire touse pour permettre l'utlisation du if classique*/
mark `touse' `if'

bysort nopnlt annee : egen meanvar = mean(`1')
gen EcartAvecMeanMen_`1' = `1' - meanvar
capture drop meanvar

di in red "Procédure terminée, variable EcartAvecMeanMen_`1' créée, elle correspond, pour chaque individu d'un ménage et par année, à l'écart entre sa valeur et la valeur moyenne (l'année donnée) du ménage auquel il appartient."



end
