/* ------------- PROGRAMME MN2----------------------------------------------------------------------------*/    
/* 24 Novembre    (CB)                              */
/*  Remplacement de pkl et pko par Pu suite à Epure.do */
/* version du 28 octobre 2003 Nouvelle definition des types de marque  */
/*           Version adaptée du travail de Sebastien Montahuc */
/* version du 1/12/03 (CB) remplacement de distinct (obsolette) par levels  */
/* Version du 17/03/04 (CB) Test sur PP : Installation d'un Warning et d'une "bretelle de secours"  */
/*                          si puPP>puglobal                                */
/*  Version du 29/03/04 (CB) Test sur PP (suite): cas ou il n'y a pas de PP nide MHD */
/*                           le r(mean)=. gestion par une boucle de ce  cas et warning         */  
/*9/11/04 : ds la def des MDD on vire annee 1998 et aussi 2001 (pas de sa7)*/
/*26/11/04 : procédure alternative identification des MDD double méthode (sa7 et libellé marque avec espace + D)*/
/*21/12/04 suppression de la verif sur sa7 car on l'a remontée ds VerifNew.do*/
/*6/01/05 chgt d'un vallist par un levels car les marques sont sous la forme num.lib*/
/* ------------------------------------------------------------------------------------------------------*/


*pause on   /* pour permettre les pauses */

set output error
set more off

program define MN2
version 8.0


capture drop mhd 
capture drop mdd
capture drop  pp
capture drop  MN
capture drop  MR 
capture drop brand2
capture drop sans_marque*
capture drop prix_moy*

/*****   ETAPE 1 : On cree les marques de Hard-Discount MHD   *****/

local listhardis "11 80 148 162 176 163 268 282 286 293 339 351 664 667 396 695"     /*  <---  erreur là   !! */
                                /*Nous nous basons sur la liste Secodip (chemise verte)*/
capture drop hardis                                
gen hardis=0 
foreach x of local listhardis {
    replace hardis=1 if enwp==`x' 
}

capture drop mhd
gen mhd=0 
bysort sa2 : egen test_hardis=mean(hardis) 
replace mhd=1 if test_hardis>0.90  /*Les marques vendues a plus de 90% par des hard-discounters sont considerees comme marques de hard-discount*/
drop test_hardis 
replace mhd=1 if sa2==5135  /*La marque Leader Price est toujours consideree comme hard-discount meme si elle est aussi vendue par Franprix*/
drop if mhd==1 & hardis==0 & sa2!=5135  /*Les marques de hard-discounts vendues dans des circuits non-hard-discounts sont considerees comme des erreurs et eliminees a l'exception de la marque Leader Price qui est aussi vendue par Franprix*/
drop if sa2==5135 & hardis==0 & enwp!=202 & enwp!=203 & enwp!=308  /*Les observations de marque Leader Price vendue hors circuit Hard-discount et hors Franprix sont eliminees*/

levels sa2 if mhd==1


/*****   ETAPE N° 2 : On cree les marques de distributeur MDD   *****/
capture drop mdd
preserve
    set more off
    gen mdd=0 
    *drop if an==1998  | an==2001
    replace mdd=1 if (sa7==1 & mhd==0)  /*On fait confiance a la variable sa7*/
    
    /*<------------------------------------------------------------------on l'a remonté ds VerifNew.do
    /*2.1 : AMBIGUITE SUR SA7!!! a terme remonter ds VERIF*/
    Distinct_marque sa7
    local listePB `r(liste_pb)'
    
    foreach m of  local listePB {    /*cas où pr une marque, variable sa7 ambigue*/
        quietly count if sa2==`m'
        scalar define nb_achats_`m'=`r(N)'
        quietly count if sa7==1 & sa2==`m'
        scalar define pour_mdd=`r(N)'/nb_achats_`m'
        replace mdd=1 if (pour_mdd>=0.5 & mhd==0 & sa2==`m')
        replace mdd=0 if (pour_mdd<0.5 & mhd==0 & sa2==`m')  
    }
    ------------------------------------------------------------------------------------>*/
    
    /*  Sauvegarde et merge  */
    bysort sa2 : keep if _n==1
    keep sa2 mdd sa7
    sort sa2
    compress
    save "CodeMDD2.dta", replace
    *more
restore

sort sa2
capture drop _merge
merge sa2 using "CodeMDD2.dta"
tab _merge
replace mdd=0 if mdd==.

/*<------------------------------------------------------------------on l'a remonté ds VerifNew.do
/*2.2 : AMELIORATION DEF MDD VIA LIBELLE MARQUE (espace + D)*/
EspaceD

tab mdd d_fin,m

/* on tranche !!!*/
replace mdd=1 if mdd==0 & d_fin==1 & mhd==0
------------------------------------------------------------------------------------>*/

levels sa2 if mdd==1

/*****   ETAPE N° 3 : On cree les PP   *****/
/*On isole les produits sans marque*/

capture drop pp
gen pp=0 
capture drop sa2bis
decode sa2, gen (sa2bis)  /*déjà fait ds EspaceD.ado*/
gen sans_marque=(index(sa2bis, "SANS")>0) 
replace sans_marque=0 if mhd==1 | mdd==1  /*  les "sans_marques ne sont pas MDD ni MHD  */
di in yellow "bysort sans_marque : sum pu"
bysort sans_marque : sum pu
drop sa2bis 


/* on trie les marques au prix moyen faible -> PP  */
di in green "sum pu if mhd==1 "
sum pu if mhd==1 
gen borne_pour_sans_marques=r(mean)+2*r(sd) 
bysort sa2 : egen prix_moyen_par_marque=mean(pu)    /*   A changer si Solide   */
replace pp=1 if sans_marque==1 & prix_moyen_par_marque<=borne_pour_sans_marques  /*Les marques "sans marque" sont classsees pp si leur prix moyen est inférieur ou egal au prix moyen des marques de hard-discount plus deux fois l'écart type.*/
bysort pp : sum pu

/* on ajoute a cette liste les marques au prix moyen < prixmoyen (prix HD& sansmarque)*/ 
di in yellow "sum pu if mhd==1 | pp==1"
sum pu if mhd==1 | pp==1  /*On considere comme premier prix les marques dont le prix moyen est inferieur au prix moyen des marques de hard-discount et des "sans marque pp"*/
gen borne_pour_pp=r(mean) 
if r(mean)!=. {
    replace pp=1 if prix_moyen_par_marque<borne_pour_pp & mhd==0 & mdd==0 
    }
else {
    di in red "Attention pas de HD ni PP ici :  `r(mean)'"
    }
/* Test des Vrais PP */
di in green " sum pu if pp==1"
sum pu if pp==1
scalar define moypuPP=r(mean)
di in yellow "sum pu"
sum pu
scalar define moypu=r(mean)

set output proc 
if moypuPP>moypu & moypuPP!=.{   
    di in red " Attention puPP>puGlobal...."
    levels sa2 if pp==1
    foreach mm in  `r(levels)' {  /* BRETELLE DE SECOURS SI LE CAS APPARAIT !!*/
        quietly sum pu if sa2==`mm'
        replace pp=0 if r(mean)> 0.8*moypu
    }
}
else{
    di in green  " Ok sur prix PP Vs prix Global...."
    di " "
}

set output error

levels sa2 if pp==1
drop borne_pour*
drop prix_moyen*
drop sans_marque

/*****   ETAPE N° 4 : On cree les MN   *****/
capture drop MN
gen MN=0 
replace MN=1 if mhd==0 & mdd==0 & pp==0 



/*****   ETAPE N° 5 : On cree les MR   *****/
capture drop MR
capture drop region

set output proc
gen MR=0
gen region=.
levels sa2  if MN==1   /*AVANT    vallist sa2 if MN==1*/
foreach X in `r(levels)'{       /*avant r(list) ms x.y  avec x num de marq et y lib marq x, ça prenait 2 marq diff*/
    quietly  distinct noreg if sa2==`X' 
    replace region= r(ndistinct) if sa2==`X'
}
replace MR=1 if region <50
drop region
replace MN=0 if MR==1

levels sa2 if MR==1


capture drop brand2
gen brand2=0
replace brand2=1 if mhd==1
replace brand2=2 if mdd==1
replace brand2=3 if pp==1
replace brand2=4 if MN==1
replace brand2=5 if MR==1

capture label define typobrand2 1 "HD" 2 "MDD" 3 "PP" 4 "MN" 5 "MR" 
capture label value brand2 typobrand2


/*  Sauvegarde du fichier des marques  */
preserve
    set more off
    scalar def Tot=_N
    bysort sa2 : gen PdAchats=(_N/Tot)*100    /*  Sur le nombre d'achats  */
    bysort sa2 : keep if _n==1
    keep sa2 mhd mdd pp MN MR brand2 PdAchats
    sort sa2
    save "CodeMarque2.dta", replace
restore
set output proc
di in yellow " Fin de MN2 "

end
