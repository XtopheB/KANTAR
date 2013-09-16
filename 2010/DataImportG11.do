/* ====================================================================================================*/
/* ====================================   PROGRAMME DATAIMPORTG11   =================================*/
/* ====================================================================================================*/
/*26/07/13 : Issu de DataImportG.do (C et V)*/
/*07/08/13 : Version 1.1 : suppression d'une seconde liste list_per pour mergeall (l.174) (C)  */ 
/*05/09/13 : version 1.2 : Nouvelle version  de INRA_Marques_Detail_Avec_Bl_Distrib_V2.1.csv re�ue  */
/*10/09/13 : Version 1.3 : Nouvelle version  de INRAClassq_Codif_Vf_Panel_V2.2.csv re�ue  */

set output proc    /* supprime l'affichage (sauf erreurs) */
clear
capture log close
*set mem 900M
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */

local version "1.3"

/*========================= DEFINITION DES PRODUITS - ANNEES =============================*/
/*26/09/12 NEW : Chemin PHP automatique (car version de php peut varier ds le temps et celon les PCs')*/
*global chemphp "! c:\wamp\bin\php\php5.3.5\php.exe -q"              /*NEW 1/09/11 C */
*global chemphp "! c:\wamp\bin\php\php5.3.8\php.exe -q"              /* Val�rie 25/09/12*/
ssc install dirlist
dirlist c:\wamp\bin\php\php*         /*dirlist permet de stocker dans une locale. Revient � �crire : dir c:\wamp\bin\php\php* et � stocker ds une locale */
local n : word count `r(fnames)'
local NbVersionsPHP: word `n' of `r(fnames)'
di in red "`n' versions, la derni�re : `NbVersionsPHP'"

/*Test qu'on est OK sur le chemin php*/
capture confirm file c:/wamp/bin/php/`NbVersionsPHP'/php.exe

if _rc!=0{ 
	di in red "Pb php : le chemin du php.exe n'est pas c:/wamp/bin/php/`NbVersionsPHP'/php.exe "
	stop
}
else {
    global chemphp "! c:/wamp/bin/php/`NbVersionsPHP'/php.exe -q"       
}
   
/* Pour CB  */ 
global chemphp "! c:/wamp/bin/php/php5.3.5/php.exe -q"          
local varlistannee "2011"      /*  <------------------------- !!! ANNEES   */  

do CheminSourceG.do   
cd "../DonneesOriginales"
/***************************************************************************/
/*Importation des nouvelles donn�es ACHAT 2009  Nouvel envoi ; 2007 et 2008  */
/*   � partir de AchatFormat_2009_2008n_2007n2.xls                          */                      
/****************************************************************** **/

foreach annee of local varlistannee {    
    cd ${CheminBrutes`annee'}
    log using "DataImportG11$S_DATE.smcl", replace 
       
    /* Niveau brutes  */
    clear
    
    /*Cr�ation manuelle du fichier NominalTuwa2011.dta pr �tre coh�rents avec les ann�es pr�c�dentes*/
    /*A partir de INRA_Questions.csv"*/
    cd "Achats"
    insheet  using INRA_Questions.csv , delimit(";")  
    drop if codequest<100000
    ren codequest tuwa
    ren libquest LibTuwa
    drop idtype
    save NominalTuwa`annee'.dta,replace
    cd ..
    /*il faudra ds DataMakerG11.do faire un merge non plus sur sa1 mais sur tuwa qui est maintenant d�j� ds le fichier des achats*/


    /**********************************************************************/
    /*Importation des nouvelles donn�es ACHAT                             */
    /*� partir  de INRAClassq_Achats_2011p.csv   */
    /**********************************************************************/
    local list_per "01 02 03 04 05 06 07 08 09 10 11 12 13"  
 
    cd "DataUSI`annee'"
    
    /****   Importation fichiers achats NON USI ****/
    foreach per of local list_per {  
         /* Donn�es USI  */
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
        
        note : Cr�� avec la version `version' de DataImportG11.do 
        save "../Data_ET`annee'`per'.dta", replace     
    }
    set output proc
    di in g " ... Done" 
    set output error 

    capture mkdir ../../../../Data`annee'  
    cd ../../../../Data`annee'
    ! mkdir Produits
    cd "../DonneesOriginales/${CheminBrutes`annee'}"
    
    /***** Fichier qui associe sa7 (MDD ou non) � sa2 (sa3) *****/   
    /*Attention, ds le fichier suivant c'est sa3 ms on l'appelle sa2 pr �tre coh�rent avec DataMaker qui va renommer sa2 en sa3*/
    /*5/09/13 Nouveau fichier des appellations*/
    insheet using  Achats/INRA_Marques_Detail_Avec_Bl_Distrib_V2.1.csv , delimit(";")   clear
    ren codemarque sa2
    drop libmarque  
    ren bldistrib  sa7
    save Achats/bldistrib.dta, replace
    
    /***** Cr�ation d'un fichier reliant sa1 et libell� sa1 *****/    
    insheet  using Achats/Equivalence_VF_INRA_Classique_QiRi_Enum.csv , delimit(";")   clear
    keep vf nomcourt
    ren vf sa1
    ren nomcourt libellesa1
    save Achats/tempsa1.dta, replace
    
    
    /*********************************************************************/
    /*      Cr�ation du fichier listing des produits (et leur panel)     */ 
    /*********************************************************************/
    /***** Cr�ation de Produits11.dta � partir  de "INRAClassq_Codif_Vf_Panel_V2.2.csv" avec les var CODIF, ref, sa1 et panel *****/    
    /*Attention Produits11.dta a maintenant 1 L par ref et pas par sa1.*/
    insheet  using Achats/INRAClassq_Codif_Vf_Panel_V2.2.csv , delimit(";")  clear
    ren idanciennevf sa1
    ren product ref
    replace panel="PF" if panel=="indetermine"      /*31/07/13 on d�cide que les 22 produits (ref ou product) jambon � la coupe sont PF*//*10/09/13 plus besoin car ds le nouvel envoi v2.2 pas de produit sans panel!*/
    order ref  sa1 panel 
    
    replace sa1="" if sa1=="indetermine"
    destring sa1, replace
    merge n:1 sa1 using Achats/tempsa1.dta, generate(Merge_sa1_Libellesa1) 
    save "../Produits${PetitNom`annee'}.dta" , replace 

    /***** Cr�ation de Product_Desc_1aN`annee'.dta *****/    
    /*R�cup du nb des var ds le fichier d'origine */
    qui des
    local NbVarOrigine=r(k)
    split codif, p(",") /*on explose la variable codif en couple Cx:Vx*/
    /*R�cup du nb des var ds le fichier d'origine avec les couples Cx:Vx split�s */
    qui des
    local NbC = r(k) - `NbVarOrigine'

    forv i=1/`NbC' {
    	local j=100+`i'+5	/*car dans les pr�c�dentes ann�es de donn�es les Cx et Vx d�marrent � C06 et V06*/
    	qui split codif`i',gen(c) p(":")	/*ici c1 et c2 cr�es (c1 la question , c2 la r�ponse)*/
    	local k=substr("`j'",2,3)	/*ruse. j va de 106 � 126. Donc pr avoir des 06...26*/
    	ren c1 c`k'
    	ren c2 v`k'
        destring c`k', replace
        destring v`k', replace
    	drop codif`i'
    }
    replace c06=0 if c06==-3    /*condition ne sert � rien car c06=-3 pour tous les produits (c'est l'appellation)*/
    save Achats/Product_Desc_1aN`annee'.dta, replace        /*pr �tre en ad�quation avec les donn�es des ann�es pr�c�dentes*/
    

    /* V�rification de la liste des produits avec les fichiers d'achat  */  
    use "../Produits${PetitNom`annee'}.dta" , replace      /*nouveau donn�es 2011 : 1L = 1 ref*/
    drop  codif libelle
    capture drop merge*
    gen mergeall=1
 
    foreach i of local list_per {        /* 07/08/13  list_per d�j� d�fini plus haut  */
    	merge n:n ref using "Data_ET`annee'`i'.dta", keepusing(ref) gen(merge`annee'`i')
    	bysort ref : keep if _n==1     /*5/09/13 correction*/
    	replace mergeall=mergeall*merge`annee'`i'
    }
    
    /******* 1er Test ********/
    distinct sa1 
    levelsof  sa1 if mergeall==1 
    if "`r(levels)'" !="" {
        set output proc
        di in red " Il y a des produits (ref) list�s non achet�s !"
        di in yellow "Il sont ds les sa1 : `r(levels)'"
        sort sa1 ref
        list sa1 ref libellesa1 panel  if mergeall ==1
    }
    
     /******* Test1 bis. Pour les donn�es 2011. On regarde si un sa1 n'est pas du tout achet� (aucune de ses ref) ********/
    gen Test1=(mergeall==1)
    bysort sa1 : egen SumTest1=sum(Test1)
    bysort sa1 : gen Nsa1=_N
    count if Nsa1==SumTest1
    if r(N)>0 {
        di in red "Il y a `r(N)' sa1  non achet� (aucune de ses ref)."
    }

     /*******  2ieme Test  ********/
    distinct sa1 
    levelsof  sa1 if mod(mergeall,2)==0   /* Il existe un _merge ==2 */ 
    if "`r(levels)'" !="" {
        set output proc
        di in red " Il y a des produits (ref) achet�s non r�pertori�s dans ProduitPanel!"
        di in yellow " Il s'agit des num : `r(levels)'"
        list sa1 libellesa1 panel  if mod(mergeall,2)==0  
    }
    
     /*******  Test2 bis********/
    gen Test2=(mod(mergeall,2)==0)
    bysort sa1 : egen SumTest2=sum(Test2)
    count if Nsa1==SumTest2
    if r(N)>0 {
        di in red "Il y a `r(N)' sa1  achet� ms absent du fichier des produits."
    }
    
    set output error
    save "../Produits${PetitNom`annee'}.dta" , replace 



    /*********************************************************************/
    /*      Cr�ation des fichiers  CSV et DO de LABELISATION  par ANNEES  */ 
    /*********************************************************************/
    * N'a plus lieu : Etape de transformation des fichiers .txt en CSV   */
     
    cd ../../../ProgsG
           
    /*Cr�ation des programmes de labelisation des VARIABLES COMMUNES AUX FICHIERS   (ctwpenwp cvwp cawp sa2)  */  
    /*2011 : maintenant 4 arguments au lieu de 3 : variable, ann�e, chemin des donn�es brutes, fichier brut*/
    set output proc
    $chemphp LabelComNFG11.php            cvwp          `annee'     ${CheminBrutes`annee'}      INRA_Extract_Circuits
    $chemphp LabelComNFG11.php            ctwpenwp      `annee'     ${CheminBrutes`annee'}      INRA_Extract_Shops
    $chemphp LabelComNFG11.php            cawp          `annee'     ${CheminBrutes`annee'}      INRA_Extract_CentralesAchats
    /*Attention, ds le fichier suivant c'est sa3 ms on l'appelle sa2 pr �tre coh�rent avec DataMaker qui va renommer sa2 en sa3*/
    $chemphp LabelComNFG11.php            sa2       `annee'     ${CheminBrutes`annee'}      INRA_Marques_Detail_Avec_Bl_Distrib_V2.1 
    di in green " Programmes de Labellisation des variables cvwp, ctwpenwp, cawp et sa2 cr��s."    

    /*Pr les cx vx*/
    /*Attention, maintenant, les programmes de labellisation des variables ne sont plus dans les r�pertoires produits*/
    $chemphp LabelSPNFG11.php   `annee' ${CheminBrutes`annee'}  
    di in green " Programmes de Labellisation des variables sp�cifiques et de leurs modalit�s cr��s."    

    set output proc
    di  ""
    di in yellow " Fin du traitement le " in green " `c(current_date)',  "  in yellow " � " in green  " : `c(current_time)'. " 
    log close
}  /* fin de l'ann�e */




