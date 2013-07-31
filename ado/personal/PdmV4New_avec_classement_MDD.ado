/*19/09/05 procédure idem à PdmV4New.ado mais avec MDD qui se distingue en MDD éco et MDD haut de gammme*/

program define PdmV4New_avec_classement_MDD,rclass
version 8.0
syntax [varlist] [if] [,poids(string)]
set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */


capture quietly drop PdmVol*
capture quietly drop PdmVal*
capture quietly drop Val*
capture quietly drop Vol* 
 

/* Test sur les Poids */

di" "  /*pour sauter une ligne*/
if `"`poids'"'=="" {        /*debut boucle si prog avec poids*/
    capture gen Wtemp=Wachat
    di in yellow  "NB : Volume et Valeur sont calcules avec les poids (Wachat)"
    di " --"
    }
else{
    capture gen Wtemp=1    /*   on utilise pas de poids */
    di in green "NB : Volume et Valeur sont calcules sans poids "
    di " --"
    }
    

quietly sort Mois4 /*trie la var Mois4*/
*numlabel typosa2, remove     /*  provisoirement   */ 
 
   
 
/* ETAPE N° 1 : Calcul des volumes et valeurs totaux par mois par brand*/
/*-------------------------------------------------------------------- */


quietly levels brand2    /* avant vallist brand prend comme valeur 1-HD 2-MDD 3-PP 4-MN et (mais pas tj) 5-MR */
global valueBR `r(levels)'

foreach x of global valueBR {   /* Calcul du volume et de la valeur pour chaque modalité et par Mois4 */ 
    quietly by Mois4  : gen toto=sum(qu*Wtemp) if brand2==`x' 
    quietly  by Mois4 : egen VolBR`x'=max(toto) 
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp) if brand2==`x' 
    quietly  by Mois4 : egen ValBR`x'=max(toto) 
    quietly drop toto 
    
    /* labelisation des BR */
    quietly vallist brand if brand==`x', label
    label variable VolBR`x' " Vol `r(list)'"
    label variable ValBR`x' " Val `r(list)'"
    
    /* initialisation et labellisation des pdmBR et puBR */
    quietly gen PdmVolBR`x'=.
    quietly gen PdmValBR`x'=.
    quietly gen puBR`x'=.
    label variable PdmVolBR`x' " PdmVol `r(list)'"
    label variable PdmValBR`x' " PdmVal `r(list)'"
    label variable puBR`x' " Pu `r(list)'"
}
quietly compress /*<---------------------pr voir si ça permet d'éviter bug no room(rajout pr lait)...*/ 
     
/* ETAPE N° 1Bis : Calcul des volumes et valeurs totaux par mois par brand  */
/*                 regroupements HD+PP (6) et MDD+HD+PP (7)                         */
/*                 regroupements HD+MDD (8) et MDD+PP (9)                         */
/*------------------------------------------------------------------------- */

     quietly by Mois4  : gen toto=sum(qu*Wtemp) if brand==1| brand==2     /* HD+MDD*/
    quietly  by Mois4 : egen VolBR8=max(toto) 
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp)  if brand==1| brand==2   /* HD+MDD */
    quietly  by Mois4 : egen ValBR8=max(toto) 
    quietly drop toto 
    
    /*========    NEW   Pdm MDD éco, interm et haut de gamme ==========!!!!!!!!!!!!!!*/
    quietly by Mois4  : gen toto=sum(qu*Wtemp) if classement_mdd==1     
    quietly  by Mois4 : egen VolMDDeco=max(toto) 
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp)  if classement_mdd==1  
    quietly  by Mois4 : egen ValMDDeco=max(toto) 
    quietly drop toto 
    
    quietly by Mois4  : gen toto=sum(qu*Wtemp) if classement_mdd==2    
    quietly  by Mois4 : egen VolMDDinterm=max(toto) 
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp)  if classement_mdd==2 
    quietly  by Mois4 : egen ValMDDinterm=max(toto) 
    quietly drop toto 
    
    quietly by Mois4  : gen toto=sum(qu*Wtemp) if classement_mdd==3  
    quietly  by Mois4 : egen VolMDDhautgamme=max(toto) 
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp)  if classement_mdd==3  
    quietly  by Mois4 : egen ValMDDhautgamme=max(toto) 
    quietly drop toto 
    
    
    label variable VolBR8 "HD+MDD"
    label variable ValBR8 "HD+MDD "
    

    
    /* initialisation et labellisation des pdmBR6,7,8 et 9 et puBR6,7,8 et 9 */
   
    quietly gen PdmVolBR8=.   /*  new */
    quietly gen PdmValBR8=.
    quietly gen puBR8=.
    
    quietly gen PdmVolMDDeco=.   /*  new */
    quietly gen PdmValMDDeco=.
    quietly gen puMDDeco=.
    
    quietly gen PdmVolMDDinterm=.   /*  new */
    quietly gen PdmValMDDinterm=.
    quietly gen puMDDinterm=.
    
    quietly gen PdmVolMDDhautgamme=.   /*  new */
    quietly gen PdmValMDDhautgamme=.
    quietly gen puMDDhautgamme=.
    
    label variable PdmVolBR8 "PdmVol MDD+PP"
    label variable PdmValBR8 "PdmVal MDD+PP"
    label variable puBR8 "Pu MDD+PP"
    
    
/* ----------------------------------------------------*/
/*Calcul des volumes et valeurs totaux par mois par MN*/
/* ----------------------------------------------------*/

/* ETAPE N° 2 : definition des 5 premières  MN et 5 premières MR  */

egen nachMN =count(sa2) if MN==1, by(sa2)  /* sur les nombre d'achats  */
egen nachMR =count(sa2) if MR==1, by(sa2)
capture drop _merge
preserve
bysort sa2 :keep if _n==1
egen rangMN=rank(nachMN) if MN==1, field
egen rangMR=rank(nachMR) if MR==1, field

keep sa2 brand MN nachMN rangMN  MR nachMR rangMR
sort sa2
quietly compress
save "rangMN", replace  
restore

sort sa2
quietly merge sa2 using "rangMN"     /* on a la pour chaque marque son RangMN ou son rangMR  */

/* ETAPE N° 3 : Calcul des volumes et valeurs totaux par mois par MN*/
sort Mois4


quietly vallist rangMN if rangMN<6
global valueMN `r(list)'
foreach x of global valueMN {    /* Calcul du volume et de la valeur pour chaque modalité et par Mois4 */  
    quietly by Mois4  : gen toto=sum(qu*Wtemp) if rangMN==`x' 
    quietly  by Mois4 : egen VolMN`x'=max(toto)  
    quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp) if rangMN==`x' 
    quietly  by Mois4 : egen ValMN`x'=max(toto) 
    quietly drop toto
    
    /* labelisation des marques   */
    quietly vallist sa2 if rangMN==`x', label
    label variable VolMN`x' " Vol `r(list)'"
    label variable ValMN`x' "Val `r(list)'"
    
    /* initialisation et labellisation des pdmMN et puMN */
    quietly gen PdmVolMN`x'=.
    quietly gen PdmValMN`x'=.
    quietly gen puMN`x'=.
    label variable PdmVolMN`x' "PdmVol `r(list)'"
    label variable PdmValMN`x' "PdmVal `r(list)'"
    label variable puMN`x' "Pu `r(list)'"
    quietly compress /*<---------------------pr voir si ça permet d'éviter bug no room...*/ 
    }
/* ----------------------------------------------------*/
/*Calcul des volumes et valeurs totaux par mois par MR*/
/* ----------------------------------------------------*/


/* ETAPE N° 5 : Calcul des volumes et valeurs totaux par mois par MR*/
sort Mois4
capture quietly vallist rangMR if rangMR<6       
capture global valueMR `r(list)'                
capture foreach x of global valueMR {   
    di in red "travail sur MR `x'"         
     /* Calcul du volume et de la valeur pour chaque modalité et par Mois4 */
     quietly by Mois4  : gen toto=sum(qu*Wtemp) if rangMR==`x' 
     quietly  by Mois4 : egen VolMR`x'=max(toto) 
     quietly drop toto

    quietly by Mois4  : gen toto=sum(ptwa*Wtemp) if rangMR==`x' 
    quietly  by Mois4 : egen ValMR`x'=max(toto) 
    quietly drop toto
    
    quietly compress /*<---------------------pr voir si ça permet d'éviter bug no room(lait)...*/
    
    /* labelisation des marques   */I
    quietly vallist sa2 if rangMR==`x', label
    label variable VolMR`x' "Vol `r(list)'"
    label variable ValMR`x' "Val `r(list)'"
    
     /* initialisation et labellisation des pdmMN et puMN */
    quietly gen PdmVolMR`x'=.
    quietly gen PdmValMR`x'=.
    quietly gen puMR`x'=.
    label variable PdmVolMR`x' "PdmVol `r(list)'"
    label variable PdmValMR`x' "PdmVal `r(list)'"
    label variable puMR`x' "Pu `r(list)'"
    quietly compress /*<---------------------pr voir si ça permet d'éviter bug no room...*/
    }
    
/*                                                              /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/* ----------------------------------------------------*/
/*   Calcul de  Variables sur les MARQUES par mois       */
/* ----------------------------------------------------*/

/* scalars   */
quietly count 
return local N_Achats = `"`r(N)'"'

quietly distinct(sa2)
return local N_Marques = `"`r(ndistinct)'"'

quietly distinct(sa2) if MN==1
return local N_MN = `"`r(ndistinct)'"'

quietly distinct(sa2) if mdd==1
return local N_MDD = `"`r(ndistinct)'"'

quietly distinct(sa2) if MR==1
return local N_MR = `"`r(ndistinct)'"'

quietly distinct(sa2) if pp==1
return local N_PP = `"`r(ndistinct)'"'

quietly distinct(sa2) if mhd==1
return local N_HD = `"`r(ndistinct)'"'

/*  variables */
bysort Mois4 : gen NbreAch = _N
label variable NbreAch "Nombre d'achats"
quietly gen NbreMTot=0
label variable NbreMTot "Nombre total de marques"
quietly gen NbreMN = 0
label variable NbreMN "Nombre MN" 
quietly gen NbreMDD = 0
label variable NbreMDD "Nombre MDD" 
quietly gen NbreMR = 0
label variable NbreMR "Nombre MR" 
quietly gen NbrePP = 0
label variable NbreMR "Nombre MR" 
quietly gen NbreHD = 0
label variable NbreMR "Nombre MR" 

sort Mois4 
forvalues m = 1/52 {      
    di "mois4 vaut `m'"      
    quietly compress      /*<---------------------pr voir si ça permet d'éviter bug no room...*/ 
    quietly distinct(sa2) if Mois4==`m'
    quietly replace NbreMTot=`r(ndistinct)' if Mois4==`m'
    quietly distinct(sa2) if MN==1 & Mois4==`m'
    quietly replace NbreMN=`r(ndistinct)' if Mois4==`m'
    quietly distinct(sa2) if mdd==1 & Mois4==`m'
    quietly replace NbreMDD=`r(ndistinct)' if Mois4==`m'
    quietly distinct(sa2) if MR==1 & Mois4==`m'
    quietly replace NbreMR=`r(ndistinct)' if Mois4==`m'
    quietly distinct(sa2) if pp==1 & Mois4==`m'
    quietly replace NbrePP=`r(ndistinct)' if Mois4==`m'
    quietly distinct(sa2) if mhd==1 & Mois4==`m'
    quietly replace NbreHD=`r(ndistinct)' if Mois4==`m' 
  
}

*/


/* ----------------------------------------------------*/
/*     ETAPE N° 6 : Calcul des volumes  totaux         */
/* ----------------------------------------------------*/

quietly by Mois4 : keep if _n==1     /*    <<<<-------- Plus qu'une ligne par Mois4   */


gen Volmois=0
gen Valmois=0

foreach x of global valueBR {  /* <-- il se peut que brand n'ai que 4 valeurs (pas de MR)  */
    /*  Problemes de valeurs manquantes sur certains mois - modalités   */
    quietly replace VolBR`x'=0 if VolBR`x'>=.
    quietly replace ValBR`x'=0 if ValBR`x'>=.
    /* calcul du total par mois */
    quietly replace Volmois=Volmois +VolBR`x' 
    quietly replace Valmois=Valmois +ValBR`x' 
    }
/* Calcul du prix par mois global */

quietly gen pumois=Valmois/Volmois
    
/* ETAPE N° 7 :calcul des pdm pour chaque modalite et par Mois4*/

foreach x of global valueBR { /* valueBR contient : 1-HD 2-MDD 3-PP 4-MN et (mais pas tj) 5-MR */
    di " `valueBR' "           
    quietly replace PdmVolBR`x'=VolBR`x'/Volmois 
    quietly replace PdmValBR`x'=ValBR`x'/Valmois
    capture replace puBR`x'=ValBR`x'/VolBR`x' if VolBR`x'!=0
    }
    
/* Bis  :calcul des pdm pour pour les regroupements et par Mois4*/  

foreach x in  8  {            
    quietly replace PdmVolBR`x'=VolBR`x'/Volmois 
    quietly replace PdmValBR`x'=ValBR`x'/Valmois
    capture replace puBR`x'=ValBR`x'/VolBR`x' if VolBR`x'!=0     
    }
    
    quietly replace PdmVolMDDeco=VolMDDeco/Volmois 
    quietly replace PdmValMDDeco=ValMDDeco/Valmois
    capture replace puMDDeco=ValMDDeco/VolMDDeco if VolMDDeco!=0    
    
    quietly replace PdmVolMDDinterm=VolMDDinterm/Volmois 
    quietly replace PdmValMDDinterm=ValMDDinterm/Valmois
    capture replace puMDDinterm=ValMDDinterm/VolMDDinterm if VolMDDinterm!=0    
    
    quietly replace PdmVolMDDhautgamme=VolMDDhautgamme/Volmois 
    quietly replace PdmValMDDhautgamme=ValMDDhautgamme/Valmois
    capture replace puMDDhautgamme=ValMDDhautgamme/VolMDDhautgamme if VolMDDhautgamme!=0    

foreach x of global valueMN {
    quietly replace PdmVolMN`x'=VolMN`x'/Volmois 
    quietly replace PdmValMN`x'=ValMN`x'/Valmois 
    quietly replace puMN`x'=ValMN`x'/VolMN`x'
    }

capture foreach x of global valueMR {                
    quietly replace PdmVolMR`x'=VolMR`x'/Volmois 
    quietly replace PdmValMR`x'=ValMR`x'/Valmois 
    quietly replace puMR`x'=ValMR`x'/VolMR`x'
    }

/* ETAPE N° 8 :création des variables muettes(les 4 trimestres) */      
gen trim1=0
gen trim2=0
gen trim3=0
gen trim4=0
    
replace trim1=1 if            Mois4<=3   | (Mois4>13 & Mois4<=16) | (Mois4>26 & Mois4<=29)   | (Mois4>39 & Mois4<=42)
replace trim2=1 if (Mois4>3 & Mois4<=7)  | (Mois4>16 & Mois4<=20) | (Mois4>29 & Mois4<=32)   | (Mois4>42 & Mois4<=45)     
replace trim3=1 if (Mois4>7 & Mois4<=10) | (Mois4>20 & Mois4<=23) | (Mois4>32 & Mois4<=35)   | (Mois4>45 & Mois4<=48) 
replace trim4=1 if (Mois4>10 & Mois4<=13)| (Mois4>23 & Mois4<=26) | (Mois4>35 & Mois4<=39)   | (Mois4>48 & Mois4<=52)

/* On ne garde que les Volumes, Valeurs, Pdm et Prix unitaires   */

drop pu 
*keep pu* Pdm* Vol* Val* Mois4 trim*  ipc Nbre*

keep pu* Pdm* Vol* Val* Mois4 trim*  ipc        /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

di in yellow "--- fin du traitement--- "
end    /*fin du prog*/
