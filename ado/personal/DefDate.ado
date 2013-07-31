/* Programme de calcul de Dates  ( Yacine CB le 27 Octobre)  */
/* Révisé par Christophe le 24/04/07 */
/*7/08/07 Procédure mise à jour pour fonctionner sur les nouvelles données 2003-2005 (avec dtwa explosée en year,day, month dès importation) (V)*/
/*  18/09/2007 Ajout du numéro de semaine depuis  1998   */

program define DefDate
version 10.0

capture drop Date
capture drop Week2002


capture confirm new variable year   /*variable year de l'importation des nouvelles données 2003-2005*/

if _rc==0{  /*ancienne formule : variable dtwa existe au format 20001204*/
    quietly gen year=int(dtwa/10000)  /*astuce pour recuperer l'annee a partir de la date secodip*/
    quietly gen month=int((dtwa-year*10000)/100)
    quietly gen day=dtwa-year*10000-month*100
}

else {  /* dans les nouvelles données 2003-2005 : year, month, day existent déjà (importation de dtwa 31/10/2003--> 31, 10, 2003)*/
    /*partie pour retrouver dtwa ancienne formule (pr être cohérent sur toute la période 98 - 2005)*/
    tostring day,gen(day2)
    tostring month,gen(month2)
    gen ld = length(day2)
    gen lm = length(month2)
    gen nul="0"
    egen dayb=concat(nul day2) if ld==1      /*qd le chiffre du jour c'est 5--> 05*/
    egen monthb=concat(nul month2) if lm==1  /*qd le chiffre du mois c'est 5--> 05*/
    replace day2=dayb if ld==1
    replace month2=monthb if lm==1
    egen dtwa = concat(year month2 day2)  /*on recrée l'ancien dtwa*/
    capture drop  lm ld  nul  day2  month2 dayb monthb
    destring dtwa,replace
}
quietly gen Date=mdy(month,day,year) /*date au format jjmmaaaa : 18feb1998 */
quietly format Date %td
quietly drop  day  year  month
/* Calcul des semaines  */

gen week=wofd(Date)    /* Nombre de semaines depuis 01-01-1960  (convention Stata) */
gen Week2002=week-2187  /* Nombre de semaines depuis le 28janvier2002, date a laquelle on passe à  Mois=54 */

quietly drop week

capture label variable Date " Date (JJMMAAAA)"
capture label define typoDate 01jan2003 "01Jan2003" 
capture label value Date typoDate


end
