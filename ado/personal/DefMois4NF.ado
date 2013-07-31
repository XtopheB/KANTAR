
/* Programme de calcul de p�riodes de 4 semaines  (23/06/06 V)  */
/*Remplace DefMois4New. Avant, Mois4 �tait cr��e � partir de sm91, maintenant � partir de pa (p�riode d'achat allant de 1 � 13)*/
/*utilisable de 1998 � 2003 sur les donn�es ancienne et nouvelle formules*/
/*utilisable sur 2004 (2/05/07) (V)*/
/*8/08/08 nummois renomm� NumMois et labellis�*/
/*8/08/07 Labellisation Mois4 pour 2005*/
/*29/05/09 Labellisation Mois4 pour 2006 et 2007*/
/*30/11/10 Labellisation Mois4 pour 2008 (V)*/
/*02/09/11 Labellisation Mois4 pour 2009 (V)*/

program define DefMois4NF
version 10

capture drop Mois4
capture drop NumMois
capture label drop typoMois4

tostring pa, gen (pa2)
/*cr�ation num�ro du mois de l'achat*/
gen str2 NumMois = substr(pa2, 5,6)  /*pa c'est 200201, 200202...*/
destring pa2, replace
destring NumMois, replace

gen Mois4=0
replace Mois4 = NumMois + (an - 1998) * 13
*replace Mois4 = NumMois + (an - 1998) * 13 if dtwa<20020128  /*ann�e 1998 de r�f�rence*/
*replace Mois4= int(Week2002/4)+ 54 if dtwa>= 20020128  /* On "calle" notre num�ro de mois sur les anciennes valeurs de Mois4 */ 


/*Labellisation*/
label variable Mois4 "Periode de 4 semaines de 7jours"
capture label define typoMois4 1 "jan" 2 "feb" 3 "mar" 4 "apr" 5 "apr-may" 6 "may-june" 7  "june-july"  8 " july" 9 "aug" 10 "sept" 11 "oct" 12 "nov" 13 "dec"
capture label define typoMois4 14 "jan" 15 "feb" 16 "mar"  17 "mar-apr" 18 "apr-may" 19 "may-june" 20"june-july"  21 " july" 22 "aug" 23 "sept" 24 "oct" 25 "nov" 26 "dec", add
capture label define typoMois4 27 "jan" 28 "feb" 29 "mar"  30 "apr" 31 "may" 32 "june" 33 "july"  34 " july-aug" 35 "aug-sept" 36 "sept-oct" 37 "oct-nov" 38 "nov-dec" 39"end-dec", add
capture label define typoMois4 40 "jan" 41 "feb" 42 "mar" 43 "apr" 44 "apr-may" 45 "may-june" 46  "june-july"  47 " july" 48 "aug" 49 "sept" 50 "oct" 51 "nov" 52 "dec" ,add   
capture label define typoMois4 53 "jan" 54 "feb" 55 "mar" 56 "apr" 57 "apr-may" 58 "may-june" 59  "june-july"  60 " july-aug" 61 "aug" 62 "sept" 63 "oct" 64 "nov" 65 "dec" ,add   
capture label define typoMois4 66 "jan" 67 "feb" 68 "mar" 69 "apr" 70 "apr-may" 71 "may-june" 72  "june-july"  73 " july-aug" 74 "aug" 75 "sept" 76 "oct" 77 "nov" 78 "dec" ,add   
capture label define typoMois4 79 "jan" 80 "feb" 81 "mar" 82 "apr" 83 "apr-may" 84 "may-june" 85  "june-july"  86 " july-aug" 87 "aug" 88 "sept" 89 "oct" 90 "nov" 91 "dec" ,add   
capture label define typoMois4 92 "jan" 93 "feb" 94 "mar" 95 "apr" 96 "apr-may" 97 "may-june" 98  "june-july"  99 " july-aug" 100 "aug-sept" 101 "sept-oct" 102 "oct" 103 "nov" 104 "dec" ,add   
capture label define typoMois4 105 "jan" 106 "feb" 107 "mar" 108 "apr" 109 "apr-may" 110 "may-june" 111  "june-july"  112 " july-aug" 113 "aug-sept" 114 "sept-oct" 115 "oct" 116 "nov" 117 "dec" ,add   
capture label define typoMois4 118 "jan" 119 "feb" 120 "mar" 121 "apr" 122 "apr-may" 123 "may-june" 124  "june-july"  125 " july-aug" 126 "aug-sept" 127 "sept-oct" 128 "oct" 129 "nov" 130 "dec" ,add   
capture label define typoMois4 131 "jan" 132 "feb" 133 "mar" 134 "apr" 135 "apr-may" 136 "may-june" 137  "june-july"  138 " july-aug" 139 "aug-sept" 140 "sept-oct" 141 "oct" 142 "nov" 143 "dec" ,add              
capture label define typoMois4 144 "jan" 145 "feb" 146 "mar" 147 "apr" 148 "apr-may" 149 "may-june" 150  "june-july"  151 " july-aug" 152 "aug-sept" 153 "sept-oct" 154 "oct" 155 "nov" 156 "dec" ,add              

capture label value Mois4 typoMois4
capture  numlabel typoMois4, add 

label variable NumMois "Num�ro du Mois (de 1 � 13)"

capture drop pa2
end
