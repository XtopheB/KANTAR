
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

di in red "Proc�dure termin�e, variable EcartAvecMeanMen_`1' cr��e, elle correspond, pour chaque individu d'un m�nage et par ann�e, � l'�cart entre sa valeur et la valeur moyenne (l'ann�e donn�e) du m�nage auquel il appartient."



end
