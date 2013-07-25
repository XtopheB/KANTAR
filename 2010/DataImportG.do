/* ====================================================================================================*/
/* ====================================   PROGRAMME DATAIMPORTG   =================================*/
/* ====================================================================================================*/
/* 25/08/10  Importation. Ce fichier est tiré de Dataimport567.do avec les données 2008  (comprend les données 2006 et 2007 nouvel envoi) */
/* 17/08/2011 : Intégration produits 538, 539, 540 dans fichier Produits678.dta  */
/* 30/08/2011 : Ce fichier est tiré de Dataimport678.do avec les données 2007n2, 2008n, et  2009  (PAP Aout 2011) */
/* 01/09/2011 : programme issu de Dataimport678.do mais transformé de telle sorte à être générique quelle que soit l'année*/
/*              importation année par année (C et V)*/
/* 01/08/2012 : Adaptation mineure aux données 2010 (bouche sur fichier produits)*/
/*26/09/2012  : Chemin php automatique (suppose que la racine du chemin du php.exe est "c:\wamp\bin\php") (V)*/
/* Version 2.0 9/01/2013 : correction importation labels ctwpenwp : début caractère moda 39 et pas 40!!!! (à partir de 2006)*/
/*                          et création numéro de version de DataImportG.do*/


set output proc    /* supprime l'affichage (sauf erreurs) */
clear
capture log close
*set mem 900M
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */

local version "2.0"

/*========================= DEFINITION DES PRODUITS - ANNEES =============================*/
/*26/09/12 NEW : Chemin PHP automatique (car version de php peut varier ds le temps et celon les PCs')*/
*global chemphp "! c:\wamp\bin\php\php5.3.5\php.exe -q"              /*NEW 1/09/11 C */
*global chemphp "! c:\wamp\bin\php\php5.3.8\php.exe -q"              /* Valérie 25/09/12*/
ssc install dirlist
dirlist c:\wamp\bin\php\php*         /*dirlist permet de stocker dans une locale. Revient à écrire : dir c:\wamp\bin\php\php* et à stocker ds une locale */
local n : word count `r(fnames)'
local NbVersionsPHP: word `n' of `r(fnames)'
di in red "`n' versions, la dernière : `NbVersionsPHP'"

/*Test qu'on est OK sur le chemin php*/
capture confirm file c:/wamp/bin/php/`NbVersionsPHP'/php.exe


if _rc!=0{ 
	di in red "Pb php : le chemin du php.exe n'est pas c:/wamp/bin/php/`NbVersionsPHP'/php.exe "
	stop
}
else {
    global chemphp "! c:/wamp/bin/php/`NbVersionsPHP'/php.exe -q"       
}
   
   

local varlistannee "2007 2008 2009"      /*  <------------------------- !!! ANNEES   */  
*local varlistannee "2010"      /*  <------------------------- !!! ANNEES   */  

do CheminSourceG.do   / * new 1/09/11  */


/***************************************************************************/
/*Importation des nouvelles données ACHAT 2009  Nouvel envoi ; 2007 et 2008  */
/*   à partir de AchatFormat_2009_2008n_2007n2.xls                          */                      
/****************************************************************** **/

cd "../DonneesOriginales"


foreach annee of local varlistannee {    
    /**** Importation fichier produits (sa3,sa4,sa7...) ****/
    cd ${CheminBrutes`annee'}
    log using "DataImport$S_DATE.smcl", replace 
    clear
    set output proc
    di in white "Product_Desc_1aN"  in yellow "`per'" in white ".dta en cours"
    set output error
    #delimit ;
        infix long ref 1-10 sa4 12-21 sa3 23-32 sa2 34-43 sa7 45-45 c06 47-51 v06 53-62 
        c07 64-68 v07   70-79 c08   81-85 v08   87-96 c09   98-102 v09  104-113 c10 115-119 
        v10 121-130 c11 132-136 v11 138-147 c12 149-153 v12 155-164 c13 166-170 v13 172-181 
        c14 183-187 v14 189-198 c15 200-204 v15 206-215 c16 217-221 v16 223-232 c17 234-238 
        v17 240-249 c18 251-255 v18 257-266 c19 268-272 v19 274-283 c20 285-289 v20 291-300 
        c21 302-306 v21 308-317 c22 319-323 v22 325-334 c23 336-340 v23 342-351 using Achats/Product_Desc_1aN.txt;
    #delimit cr
    compress
    sort ref
    save Achats/Product_Desc_1aN`annee'.dta, replace


    /*********************************************************************/
    /*      Création du fichier listing des produits (et leur panel)     */ 
    /*1/09/11 voir un prog spécifique qui créé Produit`annee'.dta ??????????????????????????????????????????*/
    /*********************************************************************/
    /*25/08/10 Comme on n'a pas "Liste VF et taille échantillon.csv" contenant info panel par produit, on utilise ancien fichier Produits567.dta*/
    
    /*  le fichier G est le dernier bon 30/08/2011  (basé sur Produits678.dta) */
    
    use "../../brutesNF678/ProduitsG.dta" , clear  /* On copie le Produit678.dta initialement crée.. */
    
    if `annee' > 2006 & `annee' <2010 {
        notes drop _dta
        replace  libellesa1  ="CHOCOLATS OEUF SURPRISE JOUET" if sa1==538
        replace  libellesa1  ="CHOCOLATS MOULAGE FRITURE" if sa1==539
        replace libellesa1="CHOC BOUCHEE ROCHER ET AUTRES" if sa1==540
        replace panel_ini="GC" if sa1==538 | sa1==539 | sa1==540 
        replace panel=1 if  sa1==538 | sa1==539 | sa1==540        
        replace bonprod ="0538" if sa1==538
        replace bonprod ="0539" if sa1==539
        replace bonprod ="0540" if sa1==540
        }
    save "../../brutesNF${PetitNom`annee'}/Produits${PetitNom`annee'}.dta" , replace 

    /* Niveau brutes  */
    cd "Achats"
    clear
    infix  sa1 2-6 str Libsa1 7-40 tuwa 41-43 str LibTuwa 44-100 using "NominalWeights.txt"
    sort sa1
    save NominalTuwa`annee'.dta,replace
    cd ..
    
    /**********************************************************************/
    /*Importation des nouvelles données ACHAT                             */
    /*à partir  de Data_USI-non1_ET200XPP.txt  et Data_USI_ET200XPP.txt   */
    /*                                                                    */
    /**********************************************************************/
    /* Niveau brutes  */
    
    local list_per "01 02 03 04 05 06 07 08 09 10 11 12 13"  

    cd "DataUSI`annee'"
    
    /****   Importation fichiers achats NON USI ****/
    foreach per of local list_per {
         /* Données USI  */
         clear
         set output proc
         di in white "Fichier Data_USI-1_ET" in green "`annee'" in yellow "`per'" in white ".dta en cours"
         set output error
         #delimit ;
            infix long nopnltNF  1-10  long pa 12-17  float day 19-20 float month 22-23 float year 25-28 int sm52 30-31 int s1a7 33 long nawa 35-44 
            long npwa 46-55 int cvwp 57-61 int cawp 63-67 int ctwpenwp 69-73 int srwp 75-79 int sa1 81-85 
            float ptwa 87-96 float qawa 98-107 float qorig 109-118 float qunitaire 120-129 int tuwa 131-135 
            int s191 137-141 float prwa 143-152 float gawa 154-163 long ref 165-174 float pweight 176-180 
            byte sflag 182 using "Data_USI-1_ET`annee'`per'.txt";         
         #delimit cr
         compress
         sort ref
         save "../Data_USI-1_ET`annee'`per'.dta", replace
        
         /* Données NON- USI  */
        clear
        set output proc
        di in white "Fichier Data_USI-non1_ET" in green "`annee'" in yellow "`per'" in white ".dta en cours"
        set output error
        
         #delimit ;
            infix long nopnltNF  1-10  long pa 12-17  float day 19-20 float month 22-23 float year 25-28 int sm52 30-31 int s1a7 33 long nawa 35-44 
            long npwa 46-55 int cvwp 57-61 int cawp 63-67 int ctwpenwp 69-73 int srwp 75-79 int sa1 81-85 
            float ptwa 87-96 float qawa 98-107 float qorig 109-118 float qunitaire 120-129 int tuwa 131-135 
            int s191 137-141 float prwa 143-152 float gawa 154-163 long ref 165-174 float pweight 176-180 
            byte sflag 182 using "Data_USI-non1_ET`annee'`per'.txt";         /* Choix de NON1 fait le 1/08/07 A CONFIRMER   */
         #delimit cr
        compress
        sort ref
        save "../Data_USI-non1_ET`annee'`per'.dta", replace        
        set output proc
        di in white "Fichier Data_USI-non1_ET" in green "`annee'" in yellow "`per'" in white ".dta en cours"
        set output error     
        append using "../Data_USI-1_ET`annee'`per'.dta"
        compress
        sort ref
        /*9/01/13 création d'une note avec version*/
        note : Créé avec la version `version' de DataImportG.do 
        save "../Data_ET`annee'`per'.dta", replace     
    }
    
    cd ..      /* Niveau brutes */
    set output proc
    di in g " ... Done" 
    set output error 

    capture mkdir ../../../Data`annee'  /*new 1/08/12 car initialement ds MenageMakerG.do*/
    cd ../../../Data`annee'
    ! mkdir Produits
    cd "../DonneesOriginales/${CheminBrutes`annee'}"
    
    /* Verification de la liste des produits avec les fichiers d'achat  */
    use "../Produits${PetitNom`annee'}.dta" , replace 
    capture drop merge*
    gen mergeall=1
    local list_per "02 03 04 05 06 07 08 09 10 11 12 13"  
    
    foreach i of local list_per {
    	merge sa1 using "Data_ET`annee'`i'.dta", keep(sa1) uniqmaster sort _merge(merge`annee'`i')
    	bysort sa1 : keep if _n==1
    	replace mergeall=mergeall*merge`annee'`i'
    }
    
    /* 1er Test  */
    distinct sa1 
    levelsof  sa1 if mergeall==1 
    if "`r(levels)'" !="" {
        set output proc
        di in red " Il y a des produits listés non achetés !"
        di in yellow " Il s'agit des num : `r(levels)'"
        list sa1 libellesa1 panel  if mergeall ==1
        }
        
    /* 2ieme Test   */
    distinct sa1 
    levelsof  sa1 if mod(mergeall,2)==0   /* Il existe un _merge ==2 */ 
    if "`r(levels)'" !="" {
        set output proc
        di in red " Il y a des produits achetés  non répertoriés dans ProduitPanel!"
        di in yellow " Il s'agit des num : `r(levels)'"
        list sa1 libellesa1 panel  if mod(mergeall,2)==0  
    }
    set output error
    save "../Produits${PetitNom`annee'}.dta" , replace 


    /*********************************************************************/
    /*      Création des fichiers  CSV et DO de LABELISATION  par ANNEES  */ 
    /*********************************************************************/
     /* Etape de transformation des fichiers .txt en CSV   */
     
    cd "Achats"
    /* 17/08/11 Automatisation de la longueur max du fichier */
    clear
    hexdump Centrales.txt, analyze
    infix  Modc 41-43 str Lab 44-`r(lmax)' using Centrales.txt
    outsheet  using cawp`annee'.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump Circuits.txt, analyze
    infix  Mod 40-43 str Lab 44-`r(lmax)' using Circuits.txt
    outsheet  using cvwp`annee'.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump Enseignes.txt, analyze
    infix  Mod 39-43 str Lab 44-`r(lmax)' using Enseignes.txt       /*9/01/2013 correction début caractère Mod*/
    outsheet  using ctwpenwp`annee'.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump OffresSpeciales.txt, analyze
    infix  Mod 3-6 str Lab 7-`r(lmax)' using OffresSpeciales.txt
    outsheet  using s191`annee'.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump Att_Desc_5aN.txt, analyze
    infix  Nprod 2-6 str Libprod 7-39 Nvar 40-43 str LibVar 44-74 Nmod 75-81 str ModLib 82-`r(lmax)' using Att_Desc_5aN.txt 
    outsheet  using Att_Desc_5aN.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump "Att_Type par VF.txt", result   /* Pour une raison "étrange" (taille ?), hexdump refuse l'analyse pour ces fichiers (cb 30/08/2011) */
    infix  Nprod 2-6 str Libprod 7-39 Nvar 39-43 str LibVar 44-`r(lmax)'  using "Att_Type par VF.txt"
    outsheet  using Att_Type_par_VF.csv , delimit(";") nonames noquote replace
    
    clear
    hexdump Hier_Desc_3et4.txt,  result 
    infix  Nprod 2-6 str Libprod 7-41 Nvar 42-43 str LibVar 44-74  Nmod 75-81 str ModLib 82-`r(lmax)' using "Hier_Desc_3et4.txt"
    outsheet using sa3sa4`annee'.csv , delimit(";") nonames noquote replace
    
    set output proc
    di in yel " conversion en CSV "
    di in green ".... done "
    set output error
    cd ../../../..
    
    cd ProgsG
           
    /*Création des programmes de labelisation des VARIABLES COMMUNES AUX FICHIERS   (ctwpenwp cvwp cawp s191)  */  
    
    local var_com "ctwpenwp cvwp cawp s191"      /* ACHTUNG tuwa n'est plus traité ici (produit dépendant) */
    foreach v of local var_com {  
      $chemphp LabelComNFG.php `v' `annee' ${CheminBrutes`annee'}       /*1/09/11 new 3 arguments : variable, année, chemin des données brutes*/
      set output proc
      di in green " Programme Label`v'" in y"`annee'" in g".do créé"    
      *set output error  !!!!!!!!!!!!!!!!!!!!!!!!!
    }    

    cd "../DonneesOriginales/${CheminBrutes`annee'}"

    /*  Debut des proc par Produit  */
    
    use "../Produits${PetitNom`annee'}.dta" , replace
    
    cd ../../../Data`annee'/Produits
    quietly levels bonprod if mergeall!=1   /* New : on ne crée que si le produit est bien acheté  */  
    local ListeTousProd "`r(levels)'"  /* <-- LA liste de TOUS les produits pour l'année */

     foreach bonprod of local ListeTousProd { 
        ! mkdir `bonprod' 
         set output proc
         di in gre "An " in yellow "`annee' " in green "Produit " in white"`bonprod'" in gree " en cours de labelisation"
         set output error   
         cd ../../ProgsG   /* secodip */
               
          /* Création des progs de label SPECIFIQUES (1 fichier par produit pour l'année `annee')*/
          $chemphp LabelSPNFG.php `bonprod' `annee'  ${CheminBrutes`annee'}  /*1/09/11 new 3 arguments : variable, année, chemin des données brutes*/
             
          /* Création des progs de label SA2, SA3, SA4 (1 fichier par PRODUIT) pour l'année `annee'*/
          $chemphp LabelSa3Sa4NFG.php `bonprod' `annee'    ${CheminBrutes`annee'}  /*1/09/11 new 3 arguments : variable, année, chemin des données brutes*/
         cd ../Data`annee'/Produits
      }
    cd ../../DonneesOriginales
    set output proc
    di  ""
    di in yellow " Fin du traitement le " in green " `c(current_date)',  "  in yellow " à " in green  " : `c(current_time)'. " 
    log close
}  /* fin de l'année */




