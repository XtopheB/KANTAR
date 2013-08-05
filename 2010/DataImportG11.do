/* ====================================================================================================*/
/* ====================================   PROGRAMME DATAIMPORTG11   =================================*/
/* ====================================================================================================*/
/*26/07/13 Issu de DataImportG.do (C et V)*/

set output proc    /* supprime l'affichage (sauf erreurs) */
clear
capture log close
*set mem 900M
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */

local version "1.0"

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
   
local varlistannee "2011"      /*  <------------------------- !!! ANNEES   */  

do CheminSourceG.do   
cd "../DonneesOriginales"
/***************************************************************************/
/*Importation des nouvelles données ACHAT 2009  Nouvel envoi ; 2007 et 2008  */
/*   à partir de AchatFormat_2009_2008n_2007n2.xls                          */                      
/****************************************************************** **/

foreach annee of local varlistannee {    
    cd ${CheminBrutes`annee'}
    log using "DataImportG11$S_DATE.smcl", replace 
       
    /* Niveau brutes  */
    clear
    
    *N'a plus lieu car tuwa directement ds fichier des achats: Importation fichier des unités (tuwa) : "NominalWeights.txt"

    /**********************************************************************/
    /*Importation des nouvelles données ACHAT                             */
    /*à partir  de INRAClassq_Achats_2011p.csv   */
    /**********************************************************************/
    local list_per "01 02 03 04 05 06 07 08 09 10 11 12 13"  
    *local list_per "01"  

    cd "DataUSI`annee'"
    
    /****   Importation fichiers achats NON USI ****/
    foreach per of local list_per {
         /* Données USI  */
        clear
        set output proc
        di in white "Fichier INRAClassq_Achats_" in green "`annee'" in yellow "`per'" in white ".csv en cours"
        set output error
        insheet  using INRAClassq_Achats_`annee'`per'.csv , delimit(";")  
        /*On renomme les variables achats avec les anciens noms (cf fichier Kantar2011_ListingVariablesParFichierBrut_CB_VO.xlsx)*/
        qui ds
        local VarAchatsOrigine "`r(varlist)'"
        local VarAchatsGremaq "pa s1a7  sm52  nawa npwa nopnltNF dtwa cvwp cawp ctwpenwp srwp gawa pweight ref sflag ptwa qawa qorig qunitaire tuwa"
        local n : word count `VarAchatsOrigine'

        forvalues i = 1/`n' {
            local vo : word `i' of `VarAchatsOrigine'
            local vg : word `i' of `VarAchatsGremaq'
            ren `vo' `vg'
        }
        compress
        sort ref
        
        note : Créé avec la version `version' de DataImportG11.do 
        save "../Data_ET`annee'`per'.dta", replace     
    }
    set output proc
    di in g " ... Done" 
    set output error 

    capture mkdir ../../../../Data`annee'  
    cd ../../../../Data`annee'
    ! mkdir Produits
    cd "../DonneesOriginales/${CheminBrutes`annee'}"
    
    /***** Fichier qui associe sa7 (MDD ou non) à sa2 (sa3) *****/   
    /*Attention, ds le fichier suivant c'est sa3 ms on l'appelle sa2 pr être cohérent avec DataMaker qui va renommer sa2 en sa3*/
    insheet using  Achats/INRA_Marques_Detail_Avec_Bl_Distrib.csv , delimit(";")   clear
    ren codemarque sa2
    drop libmarque  
    ren bldistrib  sa7
    save Achats/bldistrib.dta, replace
    
    /***** Création d'un fichier reliant sa1 et libellé sa1 *****/    
    /*INRAClassq_Codif_Vf_Panel_V2.1.csv créé à la main à partir de INRAClassq_Codif_Vf_Panel_V2.1.xlsx*/
    insheet  using Achats/Equivalence_VF_INRA_Classique_QiRi_Enum.csv , delimit(";")   clear
    keep vf nomcourt
    ren vf sa1
    ren nomcourt libellesa1
    save Achats/tempsa1.dta, replace
    
    
    /*********************************************************************/
    /*      Création du fichier listing des produits (et leur panel)     */ 
    /*********************************************************************/
    /***** Création de Produits11.dta à partir  de "INRAClassq_Codif_Vf_Panel_V2.1.csv" avec les var CODIF, ref, sa1 et panel *****/    
    /*Attention Produits11.dta a maintenant 1 L par ref et pas par sa1.*/
    insheet  using Achats/INRAClassq_Codif_Vf_Panel_V2.1.csv , delimit(";")  clear
    ren idanciennevf sa1
    ren product ref
    replace panel="PF" if panel=="indetermine"      /*31/07/13 on décide que les 22 produits (ref ou product) jambon à la coupe sont PF*/
    order ref  sa1 panel codif libelle
    
    replace sa1="" if sa1=="indetermine"
    destring sa1, replace
    merge n:1 sa1 using Achats/tempsa1.dta, generate(Merge_sa1_Libellesa1) 
    save "../Produits${PetitNom`annee'}.dta" , replace 

    /***** Création de Product_Desc_1aN`annee'.dta *****/    
    /*Récup du nb des var ds le fichier d'origine */
    qui des
    local NbVarOrigine=r(k)
    split codif, p(",") /*on explose la variable codif en couple Cx:Vx*/
    /*Récup du nb des var ds le fichier d'origine avec les couples Cx:Vx splités */
    qui des
    local NbC = r(k) - `NbVarOrigine'

    forv i=1/`NbC' {
    	local j=100+`i'+5	/*car dans les précédentes années de données les Cx et Vx démarrent à C06 et V06*/
    	qui split codif`i',gen(c) p(":")	/*ici c1 et c2 crées (c1 la question , c2 la réponse)*/
    	local k=substr("`j'",2,3)	/*ruse. j va de 106 à 126. Donc pr avoir des 06...26*/
    	ren c1 c`k'
    	ren c2 v`k'
    	drop codif`i'
    }
    replace c06="0" if c06=="-3"    /*condition ne sert à rien car c06=-3 pour tous les produits (c'est l'appellation)*/
    save Achats/Product_Desc_1aN`annee'.dta, replace        /*pr être en adéquation avec les données des années précédentes*/
    
/*<------------------------------------------------------------------------------------------------------------------------------
    /* Verification de la liste des produits avec les fichiers d'achat  */  
    use "Produits${PetitNom`annee'}.dta" , replace 
    capture drop merge*
    gen mergeall=1
    local list_per "02 03 04 05 06 07 08 09 10 11 12 13"    /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! pkoi 02 au départ?*/
    
    foreach i of local list_per {
        /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! merge ne marche pas*/
    	merge 1:n ref using "Data_ET`annee'`i'.dta", keep(sa1) /*uniqmaster*/  gen(merge`annee'`i')
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
    save "Produits${PetitNom`annee'}.dta" , replace 
    -------------------------------------------------------------------------------------------------->*/



    /*********************************************************************/
    /*      Création des fichiers  CSV et DO de LABELISATION  par ANNEES  */ 
    /*********************************************************************/
    * N'a plus lieu : Etape de transformation des fichiers .txt en CSV   */
     
    cd ../../../ProgsG
           
    /*Création des programmes de labelisation des VARIABLES COMMUNES AUX FICHIERS   (ctwpenwp cvwp cawp sa2)  */  
    /*2011 : maintenant 4 arguments au lieu de 3 : variable, année, chemin des données brutes, fichier brut*/
    set output proc
    $chemphp LabelComNFG11.php            cvwp          `annee'     ${CheminBrutes`annee'}      INRA_Extract_Circuits
    $chemphp LabelComNFG11.php            ctwpenwp      `annee'     ${CheminBrutes`annee'}      INRA_Extract_Shops
    $chemphp LabelComNFG11.php            cawp          `annee'     ${CheminBrutes`annee'}      INRA_Extract_CentralesAchats
    /*Attention, ds le fichier suivant c'est sa3 ms on l'appelle sa2 pr être cohérent avec DataMaker qui va renommer sa2 en sa3*/
    $chemphp LabelComNFG11.php            sa2       `annee'     ${CheminBrutes`annee'}      INRA_Marques_Detail_Avec_Bl_Distrib 
    di in green " Programmes de Labellisation des variables cvwp, ctwpenwp, cawp et sa2 créés."    

    /*Pr les cx vx*/
    /*Attention, maintenant, les programmes de labellisation des variables ne sont plus dans les répertoires produits*/
    $chemphp LabelSPNFG11.php   `annee' ${CheminBrutes`annee'}  
    di in green " Programmes de Labellisation des variables spécifiques et de leurs modalités créés."    

    set output proc
    di  ""
    di in yellow " Fin du traitement le " in green " `c(current_date)',  "  in yellow " à " in green  " : `c(current_time)'. " 
    log close
}  /* fin de l'année */




