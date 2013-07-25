/* =================================       PROGRAMME MENAGEMAKERG            =================================================================================*/
/* 25/08/10 issu de MenageMakerNF567.do pour les donn�es nouvelle formule 2006n, 2007n + 2008 */
/* cree les fichiers  menages'annee'.dta , qui sont les fichiers des m�nages par ann�e */
/*  PAS de LABELLISATION   */
/*25/08/10 jusqu'� 14 individus (et non 11)  --> cr�ation des variables individuelles pour tous les 14 individus! */
/* 30/08/2011 : issu de MenageMakerNF678.do pour les donn�es nouvelle formule 2007n2, 2008n et 2009  */
/*            : On renome les vaiables _panw comme pr�c�demment                                 */
/*            : num�ro de version 2.0*/
/*31/08/2011 : version 2.1 : programme rendu g�n�rique (cas 2009 pris en compte)*/
/*                           importation de Pan_`annee'.act modifi�e car � partir de 2009, 10 caract�res (et non 9) pr variable nopnltNF    */
/*01/08/2012 : version 3.0 adaptation du programme pour les donn�es 2010 (sp�cificit�s sur les noms de fichiers et format .csv (fini les ".pi" et ".act")*/
/*===============================================================================================================================================================*/


clear
capture log close
*set mem 900M
set more off  

local version "3.0"

do CheminSourceG.do   / * new 1/09/11  */


local varlistannee "2007 2008 2009"      /*  <------------------------- !!! ANNEES   */
local varlistannee "2010"      /*  <------------------------- !!! ANNEES   */


/* creation des variables an, agec et agep et maber */ 
/*changement de format pour le numero de paneliste*/ 
/*prise en compte d'annees a 4 chiffres*/
/* tri par rapport au no de paneliste*/

cd ..

foreach annee of local varlistannee {
    capture mkdir Data`annee' 
    cd Data`annee'
    capture mkdir Menages 
    
    set output proc
    log using "Menages/MenageMakerG_$S_DATE.smcl",replace
    set output error
    clear
    set output proc
    di ""
    display "fichier en cours  menages`annee'NF.dta"
    *set output error       /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
    

    /*******************************************************************************/
    /* ETAPE 0 : Importation des donn�es m�nages  */
    /*******************************************************************************/
    /****   Variables m�nages   ****/
    /*A partir des donn�es 2010 les fichiers d�butent par "INRA_". */
    /*On renomme le fichier INRA_CR2010.csv pour �tre coh�rent avec les donn�es pr�c�dentes*/
    cd ../DonneesOriginales/${CheminBrutes`annee'}/Menages/
    if `annee' >=2009 {
        !echo "On renomme le fichier INRA_CR`annee'.csv en CR`annee'.csv(CB et VO)">ReadmeCB_VO.txt
        ! dir *CR`annee'* >> ReadmeCB_VO.txt
        ! ren INRA_CR`annee'.csv cr`annee'.csv
        ! dir cr* >> ReadmeCB_VO.txt
      }  
    insheet using cr`annee'.csv, delimiter(";")  
    capture ren household nopnltNF
    
    /* Renomage des variables en _panw contenue dans 2008 et 2009 pour correspondre � 2007 et ant�rieures   */
    capture    ren csp_panw        cspp
    capture    ren sech_panw       sech
    capture    ren trap_panw       trap
    capture    ren porpnlt_panw    porpnlt
    capture    ren etud_panw       etup
    capture    ren stat_panw       stat
    capture    ren age_panw        agep
    /* Chg 2010 */ 
    for k in num 1/20 : capture  ren istak statutk
    capture ren dpts noreg
    capture ren jar1 japr
    capture ren jar2 jase
    capture ren jar3 jaai
    capture ren rve reve
    capture ren rs1 rsse
    
    sort nopnltNF
    
    save "..\..\..\..\Data2010\Menages\menages`annee'.dta",replace 
    
   
    /*****  Pond�rations mensuelles   *******/
    local panel "fl gc vp"
    
    if `annee' >=2009 {
        local panel "gc pf" /*changement structure des panels � partir de 2009 : gc et pf*/
    }

    /*On Renomme des fichiers bruts pour harmonisation des noms avec pr�c�dents envois*/
    if `annee' ==2009 {
        !echo "On renomme le fichier PAN_2009vp.pi en PAN_2009pf.pi (CB et VO)">ReadmeCB_VO.txt
        ! dir *.pi >> ReadmeCB_VO.txt
        ! ren PAN_2009vp.pi PAN_2009pf.pi
        ! dir *.pi >> ReadmeCB_VO.txt
    }
    
    foreach pan of local panel {
        clear
        if `annee' <=2009  {
            #delimit ;
                infix nopnltNF 1-9 k`pan'per1 11-16 k`pan'per2 17-22 k`pan'per3 23-28 k`pan'per4 29-34 
                k`pan'per5 35-40 k`pan'per6 41-46 k`pan'per7 47-52 k`pan'per8 53-58 k`pan'per9 59-64 
                k`pan'per10 65-70 k`pan'per11 71-76 k`pan'per12 77-82 k`pan'per13 83-88  kor`pan'men 89-94 
                using pan_`annee'`pan'.pi ;  /* <--- (C) Modification du nom du fichier 25/08/2010 */
            #delimit cr
        }
        /**** A partir de 2010 il n'y a plus les fichiers.pi mais des .csv ****/
        else {   
            insheet  using "INRA_POIDS_`pan'_2010.csv", delimiter(";") 
            ren v4 Pond`annee'
            ren  household  nopnltNF
            /*v5 c'est pour p�riode 1 ; v17 p�riode 13 (donc faire nom variable - 4)*/
            forv k = 5/17{
                local Per = `k' - 4
                ren v`k'  k`pan'per`Per'
            } 
        }
        
        sort nopnltNF
        compress
        save "../../../../Data`annee'/Menages/pond`pan'`annee'.dta", replace
    }   /*fin panel*/
    
    clear
    /*****  Activit� hebdomadaire (0,1,V,E)  ******/
    if `annee' <=2009  {
        local varV ""
        forvalues i=1/52 {
            local position = 10 + `i'       /*de 1 � 9 c'est nopnlt, 10 c'est pas tjrs un espace, v1 c'est v11, v2 c'est v12....*/
            local encours "str  s`i'  `position'"           /*str v1 11*//*super utilisation des macros!!!!! */
            local varV `"`varV' `encours'"'   /*concat�nation, pas union (sinon qu'une seule fois "str") on aura ainsi str v1 11 str v2 12...*/
        }
        /*1/09/11 nopnltNF a maintenant 10 caract�res et parfois pas d'espace entre nopnltNF et les s`i'!!! Pensez � v�rifier!!!*/
        infix long nopnltNF 1-10  `varV'  using Pan_`annee'.act     
    }
    /**** A partir de 2010 il n'y a plus les fichiers.pi mais des .csv ****/
    else { 
        insheet  using "INRA_PAN_ACTIVITE_HEBDO_2010.csv", delimiter(";")
        /*v4 c'est pour semaine 1 ; v55 semaine 52 (donc faire nom variable - 3)*/
        ren  household  nopnltNF
        forv k = 4/55{
            local Per = `k' - 3
            ren v`k'  s`Per'
        }
    }
    sort nopnltNF
    save "../../../../Data`annee'/Menages/Act`annee'.dta", replace

    cd ../../../../Data`annee'
    use "Menages/menages`annee'",replace
    foreach pan of local panel {
        merge nopnltNF using "Menages/pond`pan'`annee'.dta"
        di "merge issu du pond`pan'`annee'"
        tab _merge
        capture ren _merge merge`pan'
        sort nopnltNF
    }
    capture drop _merge
    merge nopnltNF using "Menages/Act`annee'.dta"
    tab _merge
    capture ren _merge mergeAct`annee'
    save "Menages/menages`annee'", replace 
    
    set output error
    
    /*******************************************************************************/
    /* ETAPE 1 : On renomme des variables pour plus de conformit� avec 1998-2001-2002-2003  */
    /*******************************************************************************/
    gen an = `annee'    /*pr �tre en conformit� avec les donn�es 1998-2001 ancienne formule*/
    
    /*******************************************************************************/
    /* ETAPE 2 : On cree des variables  */
    /*******************************************************************************/

    forvalues i = 1 / 14 {
        gen Sexe`i'=.       /*par d�faut . = manquant*/
    }
    /*D�termination du sexe via la variable statut`i' (plus via tour de col et tour bassin qui seront dans VerifMenagesNF)*/
    forvalues i = 1 / 14 {
        replace Sexe`i'=1 if  statut`i' == 2 | statut`i' == 4   /*ATTENTION : en 2004 c'est statut`i' au lieu de ista`i'*/
        replace Sexe`i'=2  if statut`i' == 1 | statut`i' == 3 /*femme*/   
    }
    
    /**** cr�ation BMI par individu du foyer (info du poids � partir de 2002!) ****/
    if `annee' > 2001 {
        forvalues i = 1/ 14 {  
            gen BMI`i' =   (ipds`i' / (ihau`i'^2) ) * 10000  if ipds`i'>0 & ipds`i'!=.  & ihau`i'>0 & ihau`i'!=.  /*car taille en cm*/ /*ihau en 2004 avant c'�tait ihad en cm*/
        }
    }
    
    /***** Creation de nouvelles variables ... *****/    
    DefCsp
    DefDept   /*new*/
    
     /*** Cr�ation variable foyer ****/
    capture gen foyer=.
    capture replace foyer=1 if nf==1
    capture replace foyer=2 if nf==2
    capture replace foyer=3 if nf==3
    capture replace foyer=4 if nf==4
    capture replace foyer=5 if ( nf==5 | nf==6 | nf==7 |nf==8 | nf==9) /* 5 et +*/  
  
    capture gen maber=0 
    
    /***** cr�ation variable vacances "vac" qui vaut v`i' selon la semaine d'achat (NEW 23/04/07) *****/
    gen NbSemAct = 0
    forvalues i=1 /52 { 
        quietly replace NbSemAct  = NbSemAct + 1 if s`i'=="1"       /* v`i' vaut 0,1,V, E (3/08/07)  , activit� si v`i'=="1"*/
    }

    
    /*******************************************************************************/
    /* ETAPE 4 : Labellisations   */
    /*******************************************************************************/

    label data "Panelistes (au complet) pour l'annee `annee' (source 2008)" 
    format nopnlt %9.0f /* Affichage convivial */
   
   /* Labellisation */
    quietly do "../progsG/LabelMenagesG.do"                /*   TO MODIFY */
    
    sort nopnlt
    quietly compress
    order  nopnlt-statut1 *1 *2 *3 *4 *5 *6 *7 *8 *9 *10 *11   /* 24/08/10 : la variable spra n'existe plus, la derni�re est ??? */
    note : Cr�� avec la version `version' de MenageMakerG.do
    save "Menages\menages`annee'",replace 
    display "fichier en cours  menagesNF`annee'.dta"
    
    cd ..
    
    di in green " Fin du traitement pour l'annee `annee'"
    di in yellow " Fin  le " in green " `c(current_date)',  "  in yellow " � " in green  " : `c(current_time)'. " 
    log close
} /* FIN du traitement pour les MENAGES   */


cd ..   /* retour niveau secodip  */
set output proc

