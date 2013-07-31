/*valérie 3/12/04*/
/*ici, on suppose que mhd, mdd et MR sont créées (à partir du marché global)*/
/*seules les pp et MN vont être créées ds chaque sous-segment*/
/*ce prog est utilisé ds les progs de segmentation*/


pause on   /* pour permettre les pauses */

*set output error
set more off

program define MN2_light
version 8.0



/*ETAPE N° 3 : On cree les PP*/ 

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
    replace pp=1 if prix_moyen_par_marque<borne_pour_pp & mhd==0 & mdd==0 & MR==0       /*condition "& MR==0" rajoutée*/
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

/*ETAPE N° 4 : On cree les MN*/
capture drop MN
gen MN=0
replace MN=1 if mhd==0 & mdd==0 & pp==0 & MR==0     /*   condition "& MR==0" rajoutée*/



replace brand2=3 if pp==1
replace brand2=4 if MN==1


*capture label define typobrand2 1 "HD" 2 "MDD" 3 "PP" 4 "MN" 5 "MR"
*capture label value brand2 typobrand2


/*  Sauvegarde du fichier des marques  */
preserve
    capture drop PdAchats       /*rajouté car existait déjà !!!*/
    scalar def Tot=_N
    bysort sa2 : gen PdAchats=(_N/Tot)*100    /*  Sur le nombre d'achats  */
    bysort sa2 : keep if _n==1
    keep sa2 mhd mdd pp MN MR brand2 PdAchats
    sort sa2
    save "CodeMarque2_light.dta", replace
restore
set output proc
di in yellow " Fin de MN2_light"
end
