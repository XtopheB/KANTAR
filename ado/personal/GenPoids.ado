/*13/04/05 rajout label variables csppi cspci (VO)*/

set output error    /* supprime l'affichage (sauf erreurs) */

/*=====GenPoids.ado : pour obtenir les poids de redressement==========*/

/* ENTREES */
/* an = année choisie  */


/* EN SORTIE :  fichier    */
/* YC le 18 Nov 2002 --CORRECTION CHRIS JUILLET 2003        */ 
/* CALCULE LES EFFECTIFS DU FICHIER DIRECTEMENT     */

version 8.0

program define GenPoids
args an    /*  <------------------------- !!! ANNEES   */

set output proc  /* retablit l'affichage  */  
di" "
di in white "-------------------------------------------"
di in white "      TRAITEMENT DE L'ANNEE : `an'       " 
di in white "-------------------------------------------"

set output error    /* supprime l'affichage (sauf erreurs) */


if `an'==1998 |`an'==1999 {      /*============pour 1998==========*/

/*================CALCUL DES PONDERATIONS A PARTIR DE CSPC et NFP : CAT SOCIO PROF ET NB DE PERS AU FOYER================*/

        /* nelle var foyer : recodage du nombre de personnes au foyer en permanence parallelement a la nomenclature INSEE*/

        capture gen foyer=.
        capture replace foyer=1 if nfp==1
        capture replace foyer=2 if nfp==2
        capture replace foyer=3 if nfp==3
        capture replace foyer=4 if nfp==4
        capture replace foyer=5 if ( nfp==5 | nfp==6 | nfp==7 |nfp==8 | nfp==9) /* 5 et +*/  
    
        capture label define typofoyer 1 "1" 2 "2" 3 "3" 4 "4" 5 "5 et +" 
        capture label value foyer typofoyer        

 /* nelle var cspci : recodage du de la CSP de la personne de reference parallelement a la nomenclature INSEE*/

        capture gen cspci=.
        capture replace cspci=1 if cspc==10      /*agric exploit*/

        capture replace cspci=2 if (cspc==21 | cspc==22 | cspc==23)  /*artisans, commercants et assimiles, chef d'E. de 10 salaries et +  */

        capture replace cspci=3 if (cspc==31 | cspc==35) /*prof lib et de l'info et du spec*/     

        capture replace cspci=4 if (cspc==36 | cspc==39) /*ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques*/  
    
        capture replace cspci=5 if (cspc==41 | cspc==46 | cspc==47 | cspc==48)     /*prof inter*/ 

        capture replace cspci=6 if (cspc==52 |cspc==53 | cspc==54 | cspc==55 | cspc==56  )    /*employes*/

        capture replace cspci=7 if (cspc==60 |cspc==64)   /*ouvriers qualifies, chauffeurs*/

        capture replace cspci=8 if (cspc==66 |cspc==69)   /*ouvriers non qualifies et agricoles*/

        capture replace cspci=9 if (cspc==71 |cspc==72 |cspc==73)   /*anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter*/

        capture replace cspci=10 if cspc==76 /*anciens employes et ouvriers*/

        capture replace cspci=11 if (cspc==81 |cspc==83 |cspc==84 |cspc==87 |cspc==99) /*autre inactifs*/   
     
        capture label define typocspci 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 
        capture label value cspci typocspci   
        label variable cspci "cspc recodifiee via INSEE"  /*rajout VO le 13/04/05*/ 
         
set output proc  /* retablit l'affichage  */  
di" "
di          " ------------------------------------------------------------------"
di in yellow " Descriptif des Nouvelles variables FOYER et CSPCI  (ANNEE `an')    "
di in yellow "     (Crees a partir des variables NFP et CSPC)        "
di          " ------------------------------------------------------------------"
    
        tab foyer
        tab cspci
        tab cspci foyer
set output error  /* affichage restreint  */  

/*variable foyer*/
/*  Effectifs Par Ménages selon l'INSEE sur la variable foyer  */
gen hfoyer=.
for X in num 1/5 \ Z in any 7380512 7414525 3850077 3277099 1887948 : replace hfoyer=(Z/23810161) if foyer==X

/* Effectifs de la Variable Foyer sur le fichier SECODIP  et calcul du poids  NEW !!! */


capture gen weight_foyer=.
foreach X in 1 2 3 4 5{
    count if foyer==`X'
    replace weight_foyer=((hfoyer)/(r(N)/_N)) if foyer==`X'
    }
label variable weight_foyer "Ponderation  foyer"

set output proc  /* retablit l'affichage  */ 
di" "
di " ----------------------------------------------------------------"
di in yellow " Ponderations Nbre personnes (variable FOYER cree via NFP )"
di " ----------------------------------------------------------------"

tab foyer, sum(weight_foyer)
set output error  /* affichage restreint  */  
 
/*variable cspci*/
/*  Effectifs Par Ménages selon l'INSEE sur la variable CSPC  */

gen hcspci=.
for X in num 1/11 \ Z in any 381 1191 241 2035 3123 2646 3549 1262 3441 3948 1521 : replace hcspci=Z/23338 if cspci==X

 capture gen weight_cspci=.
foreach X in 1 2 3 4 5 6 7 8 9 10 11 {
    count if cspci==`X'
    replace weight_cspci=((hcspci)/(r(N)/_N)) if cspci==`X'
    }

label variable weight_cspci "Ponderation  cspc"

set output proc  /* retablit l'affichage  */ 
di" "
di " ----------------------------------------------------------------"
di in yellow " Ponderations sur la CSP (variable CSPCI cree via CSPC)"
di " ----------------------------------------------------------------"

tab cspci, sum(weight_cspci)

set output error  /* affichage restreint  */  

/* ================================== CAlcul du poids CROISE CSPCI et Foyer =========================================== */ 

/* calcul des fréquences pour chacune des mod. de cspci et Foyer  sur le fichier Secodip  */

for X in num 1/11 : egen FFFcspciX=mean((cspci==X))
for Z in num 1/5 : egen FFFfoyerZ=mean((foyer==Z))
for X in num 1/11 : for Z in num 1/5 : egen FFFXZ=mean(cspci==X & foyer==Z)   /* frequences croisées */

/* calcul du poids croisé */
capture gen Wmen=.
for X in num 1/11 : for Z in num 1/5 : replace Wmen=((weight_foyer*weight_cspci)*(FFFcspciX*FFFfoyerZ))/FFFXZ if (cspci==X & foyer==Z)

label variable Wmen  "Ponderation croisee cspcI et Foyer" 
drop FFF* hfoyer hcspci

set output proc  /* retablit l'affichage  */ 
di " "
di " ----------------------------------------------------------------"
di in yellow " Ponderations CROISEES  cspcI et FOYER "
di " ----------------------------------------------------------------"
di" "

table cspci foyer , c(mean Wmen freq) 
di " "
sum Wmen
tab cspci, sum(Wmen)
tab foyer, sum(Wmen)

sort nopnlt

} /* fin du cas AN == 1998 ou AN==1999  */

      
if `an'==2000 {


/*=====================================================pour 2000========================================================*/

/*=====nfp est constamment egale a 0 sur le fichier menages2000 : on utlise donc la variable nf (nb de pers au foyer)===*/
/*=================sur 1998 et 1999 : nf presente une distribution quasi identique a celle de nfp=======================*/

          


/*================CALCUL DES PONDERATIONS A PARTIR DE CSPC et NF : CAT SOCIO PROF ET NB DE PERS AU FOYER================*/


        /* nelle var foyer : recodage du nombre de personnes au foyer en permanence parallelement a la nomenclature INSEE*/

        capture gen foyer=.
        capture replace foyer=1 if nf==1
        capture replace foyer=2 if nf==2
        capture replace foyer=3 if nf==3
        capture replace foyer=4 if nf==4
        capture replace foyer=5 if ( nf==5 | nf==6 | nf==7 |nf==8 | nf==9) /* 5 et +*/  
        
        capture label define typofoyer 1 "1" 2 "2" 3 "3" 4 "4" 5 "5 et +" 
        capture label value foyer typofoyer   

   
 /* nelle var csppi : recodage du de la CSP de la personne de reference parallelement a la nomenclature INSEE*/

        capture gen csppi=.
        capture replace csppi=1 if cspp==10      /*agric exploit*/

        capture replace csppi=2 if (cspp==21 | cspp==22 | cspp==23)  /*artisans, commercants et assimiles, chef d'E. de 10 salaries et +  */

        capture replace csppi=3 if (cspp==31 | cspp==35) /*prof lib et de l'info et du spec*/     

        capture replace csppi=4 if (cspp==36 | cspp==39) /*ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques*/  
    
        capture replace csppi=5 if (cspp==41 | cspp==46 | cspp==47 | cspp==48)     /*prof inter*/ 

        capture replace csppi=6 if (cspp==52 |cspp==53 | cspp==54 | cspp==55 | cspp==56  )    /*employes*/

        capture replace csppi=7 if (cspp==60 |cspp==64)   /*ouvriers qualifies, chauffeurs*/

        capture replace csppi=8 if (cspp==66 |cspp==69)   /*ouvriers non qualifies et agricoles*/

        capture replace csppi=9 if (cspp==71 |cspp==72 |cspp==73)   /*anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter*/

        capture replace csppi=10 if cspp==76 /*anciens employes et ouvriers*/

        capture replace csppi=11 if (cspp==81 |cspp==83 |cspp==84 |cspp==87 |cspp==99) /*autre inactifs*/   

        
        
        capture label define typocsppi 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 
        capture label value csppi typocsppi   
        label variable csppi "cspp recodifiee via INSEE"
        
 set output proc  /* retablit l'affichage  */  
di" "
di " ----------------------------------------------------------------"
di in yellow " Descriptif des Nouvelles variables FOYER et CSPPI     "
di in yellow "     (Crees a partir des variables NF et CSPP)          "
di " ----------------------------------------------------------------"

             
        tab foyer
        tab csppi
        tab csppi foyer
set output error  /* affichage restreint  */  

/*variable foyer*/
/*  Effectifs Par Ménages selon l'INSEE sur la variable foyer  */
capture gen hfoyer=.
for X in num 1/5 \ Z in any 7380512 7414525 3850077 3277099 1887948 : replace hfoyer=(Z/23810161) if foyer==X

/* Effectifs de la Variable Foyer sur le fichier SECODIP  et calcul du poids  NEW !!! */


capture gen weight_foyer=.
foreach X in 1 2 3 4 5{
    count if foyer==`X'
    replace weight_foyer=((hfoyer)/(r(N)/_N)) if foyer==`X'
    }
label variable weight_foyer "Ponderation  foyer"

set output proc  /* retablit l'affichage  */ 
di" "
di " ----------------------------------------------------------------"
di in yellow " Ponderations Nbre personnes (variable FOYER cree via NF )"
di " ----------------------------------------------------------------"

    tab foyer, sum(weight_foyer)
set output error  /* affichage restreint  */  
 

/*variable csppi*/
/*  Effectifs Par Ménages selon l'INSEE sur la variable CSPP <--- choix de Céline !! (vs CSPP) */
capture gen hcsppi=.
for X in num 1/11 \ Z in any 381 1191 241 2035 3123 2646 3549 1262 3441 3948 1521 : replace hcsppi=Z/23338 if csppi==X

capture gen weight_csppi=.
foreach X in 1 2 3 4 5 6 7 8 9 10 11{
    count if csppi==`X'
    replace weight_csppi=((hcsppi)/(r(N)/_N)) if csppi==`X'
    }

label variable weight_csppi "Ponderation  cspp"

set output proc  /* retablit l'affichage  */ 
di" "
di " ----------------------------------------------------------------"
di in yellow " Ponderations sur la CSPP (variable CSPPI cree via CSP)"
di " ----------------------------------------------------------------"

tab csppi, sum(weight_csppi)

set output error  /* affichage restreint  */  



/* ================================== CAlcul du poids CROISE csppI et Foyer =========================================== */ 

 /* calcul des fréquences pour chacune des mod. de csppi et Foyer  sur le fichier Secodip  */

for X in num 1/11 : egen FFFcsppiX=mean((csppi==X))
for Z in num 1/5 : egen FFFfoyerZ=mean((foyer==Z))
for X in num 1/11 : for Z in num 1/5 : egen FFFXZ=mean(csppi==X & foyer==Z)   /* frequences croisées */

/* calcul du poids croisé */
capture gen Wmen=.
for X in num 1/11 : for Z in num 1/5 : replace Wmen=((weight_foyer*weight_csppi)*(FFFcsppiX*FFFfoyerZ))/FFFXZ if (csppi==X & foyer==Z)
label variable Wmen  "Ponderation croisee csppI et Foyer" 
drop FFF* hfoyer hcsppi


set output proc  /* retablit l'affichage  */ 
di " "
di " ----------------------------------------------------------------"
di in yellow " Ponderations CROISEES  CSPPI et FOYER)"
di " ----------------------------------------------------------------"
di" "

table csppi foyer , c(mean Wmen freq) 
di " "
sum Wmen
tab csppi, sum(Wmen)
tab foyer, sum(Wmen)

sort nopnlt

}  /*   fin du cas an==2000  */

end
                             
                                      
 

