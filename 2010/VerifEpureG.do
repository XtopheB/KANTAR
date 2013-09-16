/*25/08/09 Programme VerifEpure678.do créé à partir de VerifEpureNF56.do*/
/* 3/09/2010 version incorporant les fichiers 2008  */
/*26/07/11 condition pr liste des produits change (V)*/
/*02/09/11 programme générique basé sur VerifEpure678.do, maintenant boucle sur année en + de la boucle sur les produits*/
/*29/09/11 rajout test existence du fichier (car par ex. ça plantait pr produit 80 année 2007 car pas d'obs et dc pas de fichier p0080NF.dta créé!)*/
/*30/07/12 Le label du fichier était sur 3 années; Il est changé et n'est  que sur l'année ( puisque un fichier par année) */
/*17/01/13 correction test existence fichier produit (ex. produit 80 inexistant en 2007)*/
/*8/08/13 compatible 2011*/
/*23/08/13 : Correction du bug sur les logs (chaque produit a son log).  (C) */
/* =============PROGRAMME VERIF EPURE================*/
clear
capture log close
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */
local varlistannee "2007 2008 2009 2010"    
local varlistannee " 2011"     
 
 

do CheminSourceG.do   / * new 1/09/11  */


*set output error

foreach annee of local varlistannee {

    di "Produits${PetitNom`annee'}"
    di in red "*************************************"
    di in red " ***** annee `annee' *****"
    di in red "*************************************"

    use "../DonneesOriginales/brutesNF${PetitNom`annee'}\Produits${PetitNom`annee'}.dta" , replace
    if `annee'<2011 {
        quietly levels sa1 if mergeall!=1 & mergeall!=.     & panel!=.      
    }
    else {  /*à partir de 2011 on a des infos (panel, sa1) par ref (donc les tests faits ds DataImportG11.do changent) et la variable panel est string ("GC", "PF")*/
        quietly levels sa1 if   Nsa1!=SumTest1   &   Nsa1!=.  & SumTest1 !=.  &   panel!=""   
    }
    local ListeTousProd "`r(levels)'" 
    /* MANUELLEMENT */
    *local ListeTousProd "0005" 


    
    cd  "../Data`annee'/Produits"
 
    foreach produit of local ListeTousProd {  
        di in red "*******************"
        di in red "produit `produit'"
        di in red "*******************"

        /*ETAPE n°1 bis : création variable locale numéro de produit à 4 chiffres pour sauver*/
        gen toto = `produit'
        replace toto = toto + 100000    /*on ajoute 100 000 au numéro de produit*/
        tostring toto, replace
        gen toto2 = substr(toto,3,6)    /*les 4 derniers chiffres formeront le numéro produit à 4 caractères*/
        quietly vallist toto2
        local bonprod "`r(list)'" 
        drop toto*
        
        cd `bonprod'    /*niveau produit en cours*/
        
        log using "VerifEpureG$S_DATE.smcl", replace   

        /* ---------------------------------*/
        /*         ETAPE N°3                */
        /*  Creation du fichier VERIFIE     */ 
        /* ---------------------------------*/   
        /*New 29/09/11 : test fichier créé (non créé si pas d'obs pr ce produit-année)*/
        capture confirm file `"p`bonprod'NF.dta"'
         
         
        if !_rc {		/*fichier existe : il y avait des obs pr ce produit et cette année*/
            
            use "p`bonprod'NF.dta", replace
            set output proc
            di in yellow "******  VERIFICATION  ******"
            global prod "`produit'"
            quietly do "../../../ProgsG/VerifG.do"    
            capture label data "Panel PONDERE et VERIFIE pour le produit `bonprod' et toutes les annees (`annee') ($S_DATE)"  
            quietly compress
            save "p`bonprod'NF_V.dta",replace 
        
            /* ---------------------------------*/
            /*         ETAPE N°4                */
            /*  Creation du fichier EPURE        */ 
            /* ---------------------------------*/   
            set output proc
            di in yellow "******  EPURATION  ******"
            quietly do "../../../ProgsG/EpureG.do"    /*  nouvelle version avec mergeProduitPanel  */
            
    
            capture vallist lib*sa1        /*correction 1/04/10 (V) parfois lors de l'importation c'est libellesa1 et pas libellssa1*/
            local lib "`r(list)'"
            capture label data "`lib' (`bonprod') EPURE, annees (`annee') ($S_DATE). PRIX EN EUROS"  
            quietly compress
            save "p`bonprod'NF_E.dta",replace 
    
            ! del "p`bonprod'NF_V.dta"   /*ON VIRE le _V SINON PB PLACE SUR ORDI (Modifié CB le 4/03/2008)*/
            
        }
            
        else {
            set output proc
            di in red "Fichier p`bonprod'NF.dta n'existe pas pr `annee' (sûrement pas d'obs) "
            set output error
        }
        
       cd ..       /*niveau Produits*/
                
        log close
                      
    }  /* fin de la boucle sur les produits  */
        
    cd ..  /* niveau Data`annee'  */
     
}       /*fin boucle annee*/

note _dta  
di in yellow "---Fin du traitement----" 

