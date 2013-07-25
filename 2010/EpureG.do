/*EpureG.do créé à partir d'Epure789.do*/

/*16/10/06 CB et VO*/
/*23/04/07 On enlève des variables inutiles aux fichiers pour alléger le taille des fichiers*/
/* 22/03/2010 Revu sans modifications (C & V) (sauf numéro de version et affichage) */
/* 17/08/2011 : version 1.1 Correction variables individuelles jusqu'à 15 */


/* ==========================PROGRAMME EPURENF ============================*/
set output proc
version 11.0 

note : Créé avec la version  1.1 de EpureG.do

/***********************************************************/    
/* ETAPE n°1 : On enlève les achats de MENAGES inconnus */
/***********************************************************/    
di""
di in yellow "On enleve les achats  de menages inconnus (maber==1)"
drop if maber==1
di""


/***********************************************************/    
/* ETAPE n°1bis : On enlève les achats fictifs (ménages connus ms sans achat) */
/***********************************************************/    
di""
di in yellow "On enleve les achats  fictifs (maber==2)"
drop if maber==2
di""
    
    
/***********************************************************/        
/* ETAPE n°3 : CIRCUITS de DISTRIBUTION ou enseignes non alimentaires*/
/***********************************************************/    
di in yellow " On enleve les circuits et enseignes VRAIMENT aberrants !"
drop if achaber==3
capture drop Z* /*on élimine les variables crées qd il y avait des erreurs*/ 
di""

/***********************************************************/    
/* ETAPE n°4 : variables inutiles*/
/***********************************************************/  
di in yellow "On enlève des variables ménages inutiles!"
local inutiles "orig popo psec sec sech tph stat tyrec ucca ucci vais noenq comp coud *cat* *dog* dtin elec fon four fri frq iday* imoi* magn mini malv"
foreach i of local inutiles {
    capture drop `i'
}
di in yellow "Les variables ménages inutiles : `inutiles' "

/*On a décidé de supprimer les variables individuelles (anthropométriques et autres) du ménage (on laisse juste pour le 1er indiv)*/
forvalues j=2/15 {
    capture drop i*`j'  /*vire pour les indiv de 2 à 11 les var :  iage2  ibad2  icol2  iday2  ihau2  iord2  ipoi2  itad2  itpd2 iana2  ibas2  icsp2  ihad2  imoi2  ipds2  ista2  itai2  itpo2*/
    capture drop BMI`j'
}

di in yellow "On supprime les variables individuelles (anthropométriques et autres) du ménage (on laisse juste pour le 1er indiv)" 

*  Fin de l'epuration
