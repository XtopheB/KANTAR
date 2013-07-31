/**********************************************************************************************************/
/**********************************************  PROCEDURE MN2NF  *****************************************/    
/**********************************************************************************************************/
/*--------------*/
* HISTORIQUE : 
/*--------------*/
/* 24 Novembre    (CB)                              */
/*  Remplacement de pkl et pko par Pu suite � Epure.do */
/* version du 28 octobre 2003 Nouvelle definition des types de marque  */
/*           Version adapt�e du travail de Sebastien Montahuc */
/* version du 1/12/03 (CB) remplacement de distinct (obsolette) par levels  */
/* Version du 17/03/04 (CB) Test sur PP : Installation d'un Warning et d'une "bretelle de secours"  */
/*                          si puPP>puglobal                                */
/*  Version du 29/03/04 (CB) Test sur PP (suite): cas ou il n'y a pas de PP nide MHD */
/*                           le r(mean)=. gestion par une boucle de ce  cas et warning         */  
/*9/11/04 : ds la def des MDD on vire annee 1998 et aussi 2001 (pas de sa7)*/
/*26/11/04 : proc�dure alternative identification des MDD double m�thode (sa7 et libell� marque avec espace + D)*/
/*21/12/04 suppression de la verif sur sa7 car on l'a remont�e ds VerifNew.do*/
/*6/01/05 chgt d'un vallist par un levels car les marques sont sous la forme num.lib*/
/*28/09/06 on adapte MN2 pour que la proc�dure soit valable sur les donn�es 98-01 mais aussi � partir de 2002*/
/*enwp-->cvwpenwp, 
Leader 5135 avant, 104 apr�s
liste des magasins HD qui change*/
/*21/04/08 correction moda de Leader c'est 52 (pas 104 puisqu'il faut prendre moda de sa3 d'origine � cause du rename!!!)*/
/*23/07/08 Netto rajout�e � la liste des HD pour nouveaux fichiers (CDM devient Netto en 2001!)*/
/*Version 2.0   8/06/2010   Variables cr��es seront missing par d�faut (au lieu de 0)*/
/*                          Num�ro de version cr�� (via note)                        */
/*Version 2.1  12/08/10  correction erreur sur HD (hardis erron�) + mhd initialis� � 0 (C et V)*/
/*Version 2.2  24/08/10  marque Leader se retrouve ds plusieurs modalit�s --> liste plut�t que variable locale (V)*/
/*--------------*/
* UTILISATION : 
/*--------------*/

/* 
- MN2NF est une proc�dure permettant de cr�er la variable de classification des marques : "brand2" (MN, MDD, HD, PP, MR)
- elle est bas�e sur des hypoth�ses d�cid�es par un groupe de travail de l'�quipe MAIA
- les hypoth�ses sont d�crites en annexes du document "ToutSurSecodip.pdf"
- MN2NF est une proc�dure � lancer sur un fichier d'achats d'un produit donn� (1 seul produit!) sur une ou plusieurs ann�es
- Les variables suivantes devront �tre pr�sentes dans le fichier : 
    * la variable enseigne devra �tre pr�sente (ctwpenwp ou enwp selon ann�e d'�tude)
    * la variable sa2 devra �tre pr�sente ET labellis�e (attention, sa2 = range, ne pas confondre avec sa3 = range.appellation)
    * la variable sa7 devra �tre pr�sente (et ses modalit�s devront �tre 0 ou 1...attention, pas 1 ou 2...)
    * Remarque : la variable sa7 aura pu �tre v�rifi�e (si fichier v�rifi� via VerifNF.do, via proc�dure Distinct_marque.ado, 
                                                        correction des ambiguit�s sur une marque)
    * la variable pu (prix unitaire) devra �tre pr�sente 
    * la variable noreg devra �tre pr�sente
 ------------------------------------------------------------------------------------------------------*/
set output error
set more off

program define MN2NF
version 10.0


local NumVersion "2.2"

/***********************************************************************************************/
/****   ETAPE POUR AFFECTER LES BONNES VARIABLES ET CODAGES SELON LA FORMULE DES DONNEES  ****/
capture confirm new variable ctwpenwp   /*variable enseigne pour donn�es APRES 2002*/
if _rc==0{  /*ancienne formule (donn�es 1998-2001)*/
    local listhardis "11 80 148 162 176 163 268 282 286 293 339 351 664 667 396 695"        
    local leader "5135"
    local var_ens "enwp"
    local franprix1 "202"
    local franprix2 "203"
    local franprix3 "308"

}
else {  /*nouvelle formule (donn�es 2001NF, 2002, ..., 2007)*/
    local listhardis "11 72 132 143 155 144 229 241  244 251 285 295 570 330 835"   /*835 Netto (anciennement CDM 72) rajout�e 23/07/08*/  
    local leader "52 12536  41632  51886  162715  151751"       /*New 24/08/10 (V) Plusieurs Marque Leader Price*/
    local var_ens "ctwpenwp"
    local franprix1 "174"
    local franprix2 "175"
    local franprix3 "262"
}
/***********************************************************************************************/

capture drop mhd 
capture drop mdd
capture drop  pp
capture drop  MN
capture drop  MR 
capture drop brand2
capture drop sans_marque*
capture drop prix_moy*

/******************************************************************/
/*****   ETAPE 1 : On cree les marques de Hard-Discount MHD   *****/
/******************************************************************/
capture drop hardis  
gen hardis=0        /*12/08/10 V : boulette d�tect�e avec Fabian car sinon test_hardis bas� uniquement sur les enseignes HD (car moy sur hardis; et "." non pris en cpte) et affecte 1!!! */            
foreach x of local listhardis {
   replace hardis=1 if  `var_ens'==`x' & `var_ens'!=.       
}

bysort sa2 : egen test_hardis=mean(hardis) 
gen mhd=test_hardis>0.90  /*Les marques vendues a plus de 90% par des hard-discounters sont considerees comme marques de hard-discount*/
drop test_hardis 
foreach m of local leader {     /*New 24/08/10 boucle car plusieurs marques Leader*/
    replace mhd=1 if sa2==`m'   /*La marque Leader Price est toujours consideree comme hard-discount meme si elle est aussi vendue par Franprix*/
}

/*24/08/10 �crire la condition que la marque est diff�rente de Leader (via boucle car plusieurs moda pour la marque Leader Price)*/
foreach l of local leader {
	local cond "`cond' & sa2!=`l'"
}
*drop if mhd==1 & hardis==0 & sa2!=`leader'  /*Les marques de hard-discounts vendues dans des circuits non-hard-discounts sont considerees comme des erreurs et eliminees a l'exception de la marque Leader Price qui est aussi vendue par Franprix*/
drop if mhd==1 & hardis==0   `cond' 

foreach m of local leader {     /*New 24/08/10 boucle car plusieurs marques Leader*/
    drop if sa2==`m' & hardis==0 & `var_ens'!=`franprix1' & `var_ens'!=`franprix2' & `var_ens'!=`franprix3'  /*Les observations de marque Leader Price vendue hors circuit Hard-discount et hors Franprix sont eliminees*/
}

levels sa2 if mhd==1

/******************************************************************/
/*****   ETAPE N� 2 : On cree les marques de distributeur MDD   *****/
/******************************************************************/
capture drop mdd
preserve
    set more off
    gen mdd=(sa7==1 & mhd==0) if  (sa7!=. & mhd!=.)  /*On fait confiance a la variable sa7*/ /*New 8/06/10 missing par d�faut*/
    
    /*  Sauvegarde et merge  */
    bysort sa2 : keep if _n==1
    keep sa2 mdd sa7
    sort sa2
    compress
    save "CodeMDD2.dta", replace
restore

sort sa2
capture drop _merge
merge sa2 using "CodeMDD2.dta"
tab _merge
drop _merge
*replace mdd=0 if mdd==.        /*New 8/06/10*/

levels sa2 if mdd==1

/******************************************************************/
/*****   ETAPE N� 3 : On cree les PP   *****/
/******************************************************************/

/*On isole les produits sans marque*/

capture drop pp
capture drop sa2bis
decode sa2, gen (sa2bis)  /*d�j� fait ds EspaceD.ado*/
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
gen pp=(sans_marque==1 & prix_moyen_par_marque<=borne_pour_sans_marques)   /*Les marques "sans marque" sont classsees pp si leur prix moyen est inf�rieur ou egal au prix moyen des marques de hard-discount plus deux fois l'�cart type.*/
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

levels sa2 if pp==1
drop borne_pour*
drop prix_moyen*
drop sans_marque

/******************************************************************/
/*****   ETAPE N� 4 : On cree les MN   *****/
/******************************************************************/
capture drop MN
gen MN=(mhd==0 & mdd==0 & pp==0) if  (mhd!=. & mdd!=. & pp!=.)

/******************************************************************/
/*****   ETAPE N� 5 : On cree les MR   *****/
/******************************************************************/
capture drop MR
capture drop region

gen region=.
levels sa2  if MN==1   /*AVANT    vallist sa2 if MN==1*/
foreach X in `r(levels)'{       /*avant r(list) ms x.y  avec x num de marq et y lib marq x, �a prenait 2 marq diff*/
    quietly  distinct noreg if sa2==`X' 
    replace region= r(ndistinct) if sa2==`X'
}
gen MR=(region <50) & region!=.
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

note : Version `NumVersion' de MN2NF.ado
di in yellow " Fin de MN2NF "

end
