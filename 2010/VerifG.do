/* ==========================   PROGRAMME VERIFG   ============================*/
/* Cree sur la base de VerifNew.do   */
/*mais adapt� aux nouvelles donn�es Secodip 2002 et 2003*/
/*16/10/06*/
/*2/05/07 corrections affichage (C et V)*/
/*10/05/07 programme adapt� aux donn�es 2004 (chgts mineurs)*/
/*seule nouveaut� : recodage des variables anthropom�triques � 0 (au lieu de -1 si manquant) */
/* Revu le 22/03/2010 sans modifications (C & V) (sauf num�ro de version) */
/* 16/08/2011 : Version 2.0 D�tection des unit�s multiples    */
/*              Qu transform� (� partir de sp10) ou ==. si unit�s multiples  */
/* 17/08/2011 : Version 2.1 variable s191 retir�e de la liste listcom car elle peut valoir 0 */
/* 30/08/2011 : Version 2.2 Variables pu et qu remplac�es par Pu et Qu   */
/* 23/09/2011 : Version 2.3 Debuggage sur les unit�s  (Chris)   */
/* 29/09/2011 : Version 2.4 correction test unit� (V) (le distinct Unite_via_sp10 n'est pas faire que pr achaber=0)*/
/* 30/07/2012 : Version 2.5 rajout cas o� sp10 indique "NON SUIVI" mais  tuwa==4 (grammes) : tuwa prime et on consid�re des grammes. (V)*/


version 11.0
set output error 
*pause on
note : Cr�� avec la version  2.5 de VerifG.do
        
/*=============ce programme effectue une serie de verifications, et de corrections automatiques si besoin est============*/
set output proc 
di in yellow "programme VerifNF.do : effectue une serie de verifications, et de corrections automatiques si besoin est"
di in yellow "Rmq : si un achat a plusieurs erreurs d'achat, seule la derni�re rep�r�e sera indiqu�e dans la variable achaber"
note achaber: Rmq : si un achat a plusieurs erreurs d'achat, seule la derni�re rep�r�e sera indiqu�e dans la variable achaber

set output error 

/*liste des variables communes a ts les prodts (16.10.06)*/
    
    local var_importantes "ptwa  cvwp prwa gawa ctwpenwp sa2 nopnltNF sm52 pa sm  Pu Qu "  /*variables importantes*/
    local listcom "sa3 ctwp sa1 dtwa sa4 npwa s1a7 pa  srwp"  /*17/08/11 On supprime s191, qui peut �tre � z�ro  */
    local list_cvwp_aberrants "12 14 21 25 26 31 32 780 820 "   /*�ventuellement, � compl�ter*/
    local list_ctwpenwp_aberrants "432 469 507 596 609"    /*liste adapt�e aux donn�es 2002 2003 et 2004 A COMPLETER  �ventuellement */
    
    
    set output error  
    di " "
    di in yellow " --- Traitement pour le produit `produit' et l'annee $annees ----"
    di " "
    
    quietly capture drop Z*  /*pour eviter d'obtenir already defined pour les Z si on relance */
 


/*---------------------------------       PB N� 0   Tests de Doublons     ------------------------------ */  
set output proc
     di""      
     di in yellow "------  PB N� 0 : Tests de Doublons  ------"    
     duplicates drop
set output error

/*---------------------------------       PB N� 1   achat sans m�nage r�pertori� SECODIP     ------------------------------ */     
     quietly replace maber=1 if mergeProduitMenage==1   /*achats de m�nages inconnus*/
     quietly replace maber=2 if  mergeProduitMenage==2     /*achat fictif : m�nage non acheteur */
     capture drop mergeProduitMenage  
set output proc 
     di""      
     di in yellow "------ PB N� 1 : Tag des menages non-acheteurs (maber=2)  ou inconnus  (maber=1) ------"    
     tab maber,m                             
set output error

/*------------------------------------------------- PB N�2 : incoherence sa7 (achaber==1)------------------------------------*/

Distinct_marque sa7 
/*correction si ambiguit� sur les marques (sa7)*/
local listePB `r(liste_pb)'
set output proc
di in yellow "------ Correction si ambiguit� sur les marques (sa7) (achaber==1) ------"
di in yellow "(pour une m�me marque, des modalites differentes de sa7)"
di "liste des marques a pb : `listePB'"
set output error
foreach m of  local listePB {    /*cas o� pr une marque, variable sa7 ambigue*/
    replace achaber=1 if sa2==`m'
    quietly count if sa2==`m' 
    scalar define nb_achats_`m'=`r(N)' 
    quietly count if sa7==1 & sa2==`m' 
    scalar define pour_mdd=`r(N)'/nb_achats_`m' 
    set output proc
    tab sa2 sa7 if achaber==1
    di "marque `m' a un taux de MDD valant" pour_mdd 
    set output error
    replace sa7=1 if (pour_mdd>=0.5 &  sa2==`m')   
    replace sa7=0 if (1-pour_mdd>0.5 &  sa2==`m')   
}

set output proc
tab achaber,m         /*TEST*/

set output error
     
/*--------------------   PB N� 3  recodage des zeros Secodip en missing (achaber=2 uniquement pour la liste des var importantes)   -----*/
/*modif du 7/07/03 par Val�rie*/
set output proc

   di in yellow " ------ PB N� 3 a : Pr les var communes (de listcom): Recodage des Zeros en missing (mais achaber reste egal a 0) ------ " 
      set output error
      foreach X in  `listcom' { 
      set output proc
        di " " 
        di in white" traitement de la  variable `X' "  
        quietly count if `X'==0                                    /*achaber car missing non genant*/   
        if `r(N)'>0 {   /*affichage que si pb*/  
            set output proc
            di in yellow " il y a `r(N)' valeurs a zeros dans `X'" 
            set output error  
        }                 
        quietly CorrectionA `X' if `X'==0 , code(0) missing(point) /*on code les 0 Secodip en missing, mais on ne code pas */
                                                                 
       } /* fin boucle variables */  
       
    di""      
    di in yellow " ------ PB N� 3 b : Pr les var communes IMPORTANTES : recodage des zeros en missing et codage de achaber a 1 ------ " 
    set output error 
    foreach X in  `var_importantes' { 
        set output proc
        di in white" " 
        di in white" traitement de la  variable `X' "  
        quietly count if `X'==0 
        if `r(N)'>0 {   /*affichage que si pb*/
            di in yellow " il y a `r(N)' valeurs a zeros dans `X'"
        }
        quietly CorrectionA `X' if `X'==0 , code(2) missing(point) /*coder achaber � 2 si var importantes missing*/                                                                                          
    } /* fin boucle variables */  
       
        tab achaber,m     /*TEST*/
       
 set output error  
/*-----------------------------      PB N� 3 c :   recodage des poids missing en 0 (achaber reste �gal 0)         -------------------- */
/*rajout du 17/12/04 Christophe et Val�rie*/   
    set output proc  
    di in yellow " ------ PB N� 3c :   recodage des poids missing en 0 (achaber reste �gal 0) ------  "
    *capture replace Wachat = 0 if Wachat==.   /*si y a pas de poids, c'est que le m�n n'�tait pas pr�sent, et dc poids nul*/
    set output error                              
                                                        
/*-----------------------------      PB N� 3 d :   recodage des variables  � . (au lieu de -1 si manquant) (achaber reste �gal 0)         -------------------- */
set output proc  
di in yellow " ------ PB N� 3 d:   recodage des variables � missing au lieu de -1  ------  "
set output error 

mvdecode _all, mv(-1)
 
/*------------------     PB N�4 : cvwp aberrants ou ctwpenwp (enseigne) aberrants pour des produits alimentaires    -----------------*/   
    set output proc 
    di ""
    di in yellow "------ PB N� 4 : Pb des circuits de distribution ou d'enseignes VRAIMENT aberrants  ------" 
    set output error
    foreach c of local list_cvwp_aberrants {
        replace achaber=3 if cvwp==`c'  
    }
    foreach e of local list_ctwpenwp_aberrants {
        replace achaber=3 if ctwpenwp==`e'  
    }


/* -------------------------------Pb N� 5 : Unit�s multiples et re-transformations en Kg et en L � partir de sp10---------------- */
/* On replace Qu par  .  si multiples unit�s (et diff�rentes de G, KG, mL, ou L) */
set output proc 
CreateUniteViasp10

drop Qu
drop Pu

/* Transformation en KG ou litre si unit� en Gramme ou ML (sp10 d'abord, puis tuwa) */

/* On a l'info pr�cise par sp10 : et ce sont des G, ML ou G ou ML */
gen Qu = qorig*gawa*pweigh/1000 if Unite_via_sp10=="G" |  Unite_via_sp10 =="G OU ML" | Unite_via_sp10 =="ML"  
/* On a pas l'info par sp10: on sait par tuwa que ce sont des  G, ML ou G ou ML */
replace Qu = qorig*gawa*pweigh/1000 if Unite_via_sp10=="sp10 absente" & (tuwa==4 | tuwa==2 | tuwa==9 | tuwa==15 | tuwa==19)

/*G�n�ration de Qu si unit� en Kilogramme ou Litre (sp10 d'abord, puis tuwa) */
/* On a l'info pr�cise par sp10 : et ce sont des KG, L */
replace Qu = qorig*gawa*pweigh if Unite_via_sp10=="KG" | Unite_via_sp10=="L"

/* On a pas l'info par sp10: on sait par tuwa que ce sont des  KG ou L*/
replace Qu = qorig*gawa*pweigh if Unite_via_sp10=="sp10 absente" & (tuwa==25 | tuwa==27)

/* Calcul des PU (en euros) et QU (avec produit en plus )  */
gen Pu=(ptwa/Qu)    /*Pu (en euros)tenant cpte du coeff produit en plus*/


/*17/08/11 changements ds labellisation de Qu selon sp10 et tuwa (val�rie)*/
/* 23/09/11 Modif avec des else if  (Christophe)  */

quietly distinct Unite_via_sp10 if achaber==0   /*car ici on a les m�nages non acheteurs...pr qui unite_via_sp10 manquante*/


if r(ndistinct)>1 {
    capture label variable Qu "Plusieurs unit�s ds ce fichier (cf tuwa et Unite_via_sp10)" 
    note : Attention, ce produit comporte plusieurs unit�s (cf sp10 ou tuwa)
    set output proc 
    di "Attention, ce produit comporte plusieurs unit�s (cf sp10 ou tuwa)"
    tab Unite_via_sp10
    set output error 
}
else {      /*si une seule unit� ds le fichier, on met le bon label*/
    if Unite_via_sp10=="G" | (Unite_via_sp10=="sp10 absente" &  tuwa==4) | (Unite_via_sp10=="NON SUIVI" &  tuwa==4) {

        capture label variable Qu "Kg (quantit� totale convertie CV)" 
    }
    if Unite_via_sp10 =="G OU ML"   | (Unite_via_sp10=="sp10 absente" &  (tuwa==9 | tuwa==15 | tuwa==19)) | (Unite_via_sp10=="NON SUIVI" &  (tuwa==9 | tuwa==15 | tuwa==19)) {
        capture label variable Qu "Kg ou L (quantit� totale convertie CV)" 
    }
    if Unite_via_sp10=="ML"  | (Unite_via_sp10=="sp10 absente" &  tuwa==2) | (Unite_via_sp10=="NON SUIVI" &  tuwa==2)  {
        capture label variable Qu "L (quantit� totale convertie CV)"  
    } 


}

set output proc  

di in yellow "------ labellisation du fichier en cours ------"
capture label data "Panel VERIFIE pour le produit `produit' et toutes les annees"                        
            
di"" 
di in yellow "tableau bilan des erreurs d'achats"
tab achaber,m         /*TEST*/
di"" 
di in yellow " --- fin du traitement de verification pour le produit $prod --- "     

*  Fin du traitement
