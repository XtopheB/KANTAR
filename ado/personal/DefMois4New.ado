
/* Programme de calcul de périodes de 4 semaines  (CB le 27 Octobre)  */
/* La première semaine est en 1997 et porte le numéro 365 depuis le 1-01-1991 */

program define DefMois4New
version 8.0

capture drop Mois4
capture label drop typoMois4

/*attention, pr an 2001, saut de sm91=552 à 554 (pas de 553) car pas la semaine du 6/08/01 au 12/08/01...dc le cut 549,puis 554 (et pas 553)*/
egen Mois4 =cut(sm91), at(365,369, 373, 377, 381,385,389,393,397,401,405,409,413,417,421,425,429,433,437,441,445,449,453,457,461,465,469,473,477,481,485,489,493,497,501,505,509,513,517,521,525, 529, 533, 537, 541, 545, 549, 554, 558, 562, 566, 570, 574) icodes
replace Mois4=Mois4 +1
label variable Mois4 "Periode de 4 semaines de 7jours"

capture label define typoMois4 1 "jan" 2 "feb" 3 "mar" 4 "apr" 5 "apr-may" 6 "may-june" 7  "june-july"  8 " july" 9 "aug" 10 "sept" 11 "oct" 12 "nov" 13 "dec"
capture label define typoMois4 14 "jan" 15 "feb" 16 "mar"  17 "mar-apr" 18 "apr-may" 19 "may-june" 20"june-july"  21 " july" 22 "aug" 23 "sept" 24 "oct" 25 "nov" 26 "dec", add
capture label define typoMois4 27 "jan" 28 "feb" 29 "mar"  30 "apr" 31 "may" 32 "june" 33 "july"  34 " july-aug" 35 "aug-sept" 36 "sept-oct" 37 "oct-nov" 38 "nov-dec" 39"end-dec", add
capture label define typoMois4 40 "jan" 41 "feb" 42 "mar" 43 "apr" 44 "apr-may" 45 "may-june" 46  "june-july"  47 " july" 48 "aug" 49 "sept" 50 "oct" 51 "nov" 52 "dec" ,add   

capture label value Mois4 typoMois4
capture  numlabel typoMois4, add 

end
