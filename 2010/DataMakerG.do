/*=====================================================================================================*/
/* =============================== PROGRAMME DATAMAKERNFG ==========================================*/
/*=====================================================================================================*/
/* Ce programme NE TRAITE PAS LES FICHIERS MENAGES (voir MenagesMaker567.do)  */
/* DataMakerNF56 créé à partir de DataMakerNF345.do                           */
/* Version 1.1   29/01/08   sa3 = range.appellation et sa2 = range (pour cohérence avec les fichiers ancienne formule) via un rename*/
/* Version 1.2   04/02/08   Initialisation des locales  (NbAnPasObs  AnSansObs) pour test sur les années manquantes (r(N)>0 ) */ 
/* Version 1.3   13/02/2008 Modification du fichier ProduitNF56.dta si produit sans obs.  */ 
/* Version 1.4    7/03/2008 initialisation locale varlistannee_sans_prem   */ 
/* Version 1.41  26/03/2008 drop de an  */ 
/* Version 1.42  22/04/2008 FusionMarques56 intégrée et MN2NF corrigée (moda de Leader Price) */ 
/* Version 2.0   17/12/2008 Nouvel envoi 2005 et 2006                                          */
/* Version 2.1   15/06/2009 2005 2006 et 2007        */ 
/* Version 2.2   8/06/2010  Fichier des caractéristiques produits (Product_Desc_1aN.txt) modifié pour 2005  */
/*                          (avant c'était le fichier 1er envoi 2005, now celui 2ème envoi 2003-2006)  */
/* Version 2.3   25/08/2010 Pour nouvelles données 2006n, 2007n et 2008  */
/*                          correction labellisation fichier*/
/*Version 3.0  27/07/11 ajout condition pr liste des produits : besoin que l'info panel soit renseignée*/
/*ex: ds Produits678.dta , pdt 538 n'a pas d'info panel donc prog plante (je ne sais pas pourquoi il ne plantait pas avant...) (V) */
/* Version 3.1 30/08/11 : Changement de pu en Pu et qu en QU (conforme à notre règle typographique)    */
/*Version 4.0  1/09/11 : version générique; chgt de boucle : 1 produit par année*/
/*                     : liste des produits à partir du fichier ProduitsNFXXX.dta DANS la boucle année*/
/*====================================================================================================*/
local version "4.0"

*set output error    /* supprime l'affichage (sauf erreurs) */
clear
capture log close
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */

/*========================= DEFINITION DES PRODUITS - ANNEES =============================*/
local varlistannee "2007 2008 2009"      /*  <------------------------- !!! ANNEES   */  
*local varlistannee "2010"      /*  <------------------------- !!! ANNEES   */  

local NbAn : list sizeof varlistannee

do CheminSourceG.do   / * new 1/09/11  */

foreach annee of local varlistannee {
        
    use "../DonneesOriginales/brutesNF${PetitNom`annee'}\Produits${PetitNom`annee'}.dta" , replace
    quietly levels sa1 if mergeall!=1 & mergeall!=.     & panel!=.    
    local ListeTousProd "`r(levels)'"  
    /* MANUELLEMENT */
    *local ListeTousProd "0002 0080 0007" 
    log using "../Data`annee'/Produits/DataMakerG_$S_DATE.smcl", replace
    di in red "Début du prog le `c(current_date)' à `c(current_time)'."

    foreach produit of local ListeTousProd { 
        set output proc
        di in white "--- Année `annee' en cours (produit `produit') ==="
        set output error
        
        /***********************************/
        /* ETAPE N°1  : IMPORTATION        */
        /***********************************/
        clear
        cd ../DonneesOriginales/${CheminBrutes`annee'}   
        
        use "Data_ET`annee'01.dta", replace
        keep if sa1==`produit'
        local list_per "02 03 04 05 06 07 08 09 10 11 12 13"  

        foreach j of local list_per {
            append using "Data_ET`annee'`j'.dta"
            keep if sa1==`produit'
        }

        sort ref
        /*NEW 18/12/08 1 fichier  Product_Desc_1aN par année donc chemin change*/
        merge ref using Achats/Product_Desc_1aN`annee'.dta      /*fichier produit (sa3, sa2, sa7, sa4....)*/
        drop if _merge==2
        capture drop _merge
        set output proc
        di "append des 13 périodes et des infos produits fini pour l'année `annee' (produit `produit')"
        set output error

        sort sa1
        merge sa1 using  "../Produits${PetitNom`annee'}.dta" , keep(panel libellesa1)      /*Récup du panel du produit en cours*/
        drop if _merge==2
        capture drop _merge

        sort sa1
        merge sa1 using  "Achats\NominalTuwa`annee'.dta" , keep(tuwa LibTuwa)      /*Récup de l'unité (tuwa) du produit en cours*/
        drop if _merge==2
        capture drop _merge
        set output proc
        count
        set output error
        
        if r(N)>0 {     /*test car par exemple produit 152 présent ds Produits2004.dta ms 0 obs!!! (pas d'achat!!!)*/
            cd ../../../ProgsG
            set output proc
            di in yellow "Importation OK"
            set output error
            sort nopnlt
            
            /*ETAPE n°1 bis : création variable locale numéro de produit à 4 chiffres pour sauver*/
    
            gen toto = `produit'
            replace toto = toto + 100000    /*on ajoute 100 000 au numéro de produit*/
            tostring toto, replace
            gen toto2 = substr(toto,3,6)    /*les 4 derniers chiffres formeront le numéro produit à 4 caractères*/
            quietly vallist toto2
            
            local bonprod "`r(list)'" 
            drop toto*
            
            /*****************************************/
            /* ETAPE N°2  : CREATION DE VARIABLES  */
            /*****************************************/
            gen annee = `annee'           /*pr être en conformité avec les données 1998-2001 ancienne formule*/ 
            capture drop i
            capture drop I
            
            set output proc
            format ptwa %9.2f   /*rajout pr format convivial 2 chiffres ap virgule*/ 
            
            /******* UNITES ********/ 
            * replace ptwa=ptwa/6.55957  /* Conversion des francs aux euros (plus depuis 2003)*/
            
            /*1/09/11 Qu et Pu seront recalculées dans VerifG.do à partir de Unite_via_sp10*/
            /* Conversion en Kg et litre */
            
            gen Qu = qorig*gawa*pweight          /*  Modif du 10/12/2007 suite explications C. Boizot (C)  */
            replace ptwa = ptwa*gawa*pweight      /*  ----------- idem -------------------------*/  
            
            capture replace Qu = Qu / 1000  if tuwa==4 | tuwa==2 | tuwa==9 | tuwa==15 | tuwa==19   /*on ne divise pas les qtes style nb de parts, ni KG...*/ /*A FAIRE AVEC NominalTUWA!!!!!!*/
             
            /* Calcul des PU (en euros) et QU (avec produit en plus )  */
            capture gen Pu=(ptwa/Qu)    /*Pu (en euros)tenant cpte du coeff produit en plus*/
            
            note : Qu= qorig*gawa*pweigh ; ptwa=ptwa*gawa*pweight (donc Pu=ptwa_orig/quorig)
            
            /*Recodage modalité sa7 (0,1) vs (2,1)*/
            replace sa7=0 if sa7==2 /*non mdd*/
    
            /*  On decide de ne plus calculer les prix par panier et les quantité par panier (le 23/04/07) partie détruite !! */        
    
            /* Creation de variables dates au format Stata*/
            di in green "DefDate" 
            quietly DefDate
            
            /*Création variable Mois4 (période de 4 semaines) */
            di in green "DefMois4" 
            quietly DefMois4NF          /*avant à partir de sm91 qui n'existe plus, maintenant à partir de pa*/
          
            /* variable d'erreur sur l'achat */
            gen achaber=0
            set output proc
            di in green "Création de variables (Qu, Pu, Mois4)" in yellow "   OK"
            di ""
            set output error
    
            /***********************************/
            /* ETAPE N°3  : MERGE DES MENAGES  */
            /***********************************/
            /*partie pour calculer la somme des pondérations (tous les ménages du panel du produit par année et période) (NEW 18/09/07 V)*/
            /*1/09/11 déplacée ici pr ne récupérer que les var pondérations du panel du produit en cours*/
            quietly levels panel
            if `r(levels)'==1 {
                local p "gc"
            }
            if `r(levels)'==2 {
                local p "vp"
            }
            if `r(levels)'==3 {
                local p "fl"
            }
            /*1/09/11 A partir de 2009 seulement 2 panels!!! (GC, et PF)*/
            if `annee' >=2009 {
                if `r(levels)'==2 | `r(levels)'==3 {
                    local p "pf"
                }
            }
            
            cd ../Data`annee'/Produits  
            capture drop _merge
            sort nopnltNF
            merge n:1 nopnltNF using "../Menages/menages`annee'"
            ren _merge mergeProduitMenage
            /*1/09/11 on ne garde que les var pondérations du panel du produit en cours*/
            quietly ds k*per*
            local AllVarPond "`r(varlist)'"
            quietly ds k`p'per*
            local VarPond "`r(varlist)'"
            local AVirer : list AllVarPond - VarPond
            drop `AVirer'
            
            /***** création variable activité  "act" (0,1,V,E) qui vaut v`i' selon la semaine d'achat (NEW 3/08/07) *****/
            set output proc     /*à virer*/

            gen act= "."
            forvalues i=1 /52 { 
                capture quietly replace act=s`i' if sm52==`i' & annee==`annee'     /*reflechir comment gérer les missings (on laisse ou , comme Wachat, 0)*/
            }
    
            set output proc
            di in yellow "Merge des ménages" 
            tab  mergeProduitMenage
            *set output error
           
            drop annee 
            clonevar annee=an  /* on récupère la note de "an" (venue de MenageMaker où c'est toujours "an") */
            drop an   /* On supprime la variable an (C etV le 10/12/2008) */ 
            
            /***********************************/
            /* ETAPE N° 4 PONDERATIONS      */ 
            /***********************************/
            forvalues i = 1/13 {   
                local j = `i' + (`annee' - 1998) * 13
                ren k`p'per`i' k`p'per`j'
             }
             
            preserve
                bysort nopnlt : keep if _n==1   /*tous les ménages présents l'année en cours (acheteurs ou non)*/
                quietly sum Mois4        /*pr connaitre début et fin Mois4*/
                forvalues i= `r(min)'/`r(max)' {   
                    quietly sum k`p'per`i'
                    global SumPondper`i' "`r(sum)'"
                }
            restore
             
            DefWachatG    /*création variable Wachat et WFrance (NEw 1/09/11) selon panel et Mois4*/          
            set output proc
            di in green  "Création de Wachat (et WFrance)" in yellow "  OK"
            set output error   
                                     
            capture drop k*per*        /*on vire les autres poids inutiles */
             
            forvalues i=1/52 {
                capture drop s`i'
            }
    
            /*****************************************/
            /* ETAPE N°5  : VARIABLES SPECIFIQUES  */
            /****************************************/
            local list_var "06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"     /*numéros des variables Cx et Vx : Etendu à 23 le 1/09/2009 */
            local list_var_c ""
            foreach j of local list_var {
                quietly tab c`j'        /*on regarde le contenu de chaque Cx*/   
                sort  c`j'      /*20/08/07 astuce pour éviter que la 1ère ligne soit un ménage non acheteur (sinon c`j'[1] = .!) (V)*/
                if `r(r)'==1 {          /*le tab indique qqch--> variable nonmissing*/
                    di "le tab indique qqch--> variable nonmissing"
                    local nbsp = c`j'[1]    /*récupère la moda de c`j' pr créer sp qui va bien*/
                    ren v`j'  sp`nbsp'    /*On renomme Vx  en  sp`v' avec "v" la valeur(indiquant le sens de la variable) de Cx afin de labelliser */
                    drop c`j' 
                }
                else {
                    drop c`j'           /*on vire Cx qui ne sert à rien pour ce produit*/
                    drop v`j'           /*idem pour Vx*/
                }
            }
        
            compress
            set output proc
            save "`bonprod'/panel`bonprod'NF`annee'",replace     /*   <----   fichier PRODUIT pour une année    */ 
            set output error
             
            /***********************************/
            /*  ETAPE N°7  :  LABELLISATION  */  
            /***********************************/
            /*labellisation  des variables produit COMMUNES (Fichier fait manuellement)*/
            do "../../ProgsG/LabelVarProdComG.do"                  /*A VERIFIER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
    
            /*labellisation  des variables produit COMMUNES (1 fichier pr tous les produits) pour l'année `annee'*/ 
            local var_com "ctwpenwp cvwp cawp s191"    
            foreach v of local var_com {  
                do "Label`v'`annee'.do"
            }
    
            /*Labelisation des variables produit SPECIFIQUES */
            do "`bonprod'/LabelSP`bonprod'A`annee'.do"  
            
            /*labellisation  des variables SA2, SA3, SA4 */  
            do "`bonprod'/labelSA3SA4`bonprod'A`annee'.do"   /* Attention : changement de nom avec  2003 */
                          
            /*labellisation  de SA1 (pour l'instant un peu artisanal...). */  
            quietly vallist libellesa1
            local lib "`r(list)'"
            /*labellisation variable sa1 num.lib*/
            quietly vallist sa1
            local nbprod "`r(list)'"
            label define typosa1  `nbprod' "`lib'"  
    
            /*  <===========  LABELISATION DES MODALITES de TOUTES LES VARIABLES ===============*/
            quietly ds
            local liste_variables `r(varlist)'
            foreach vari of local liste_variables {
                capture numlabel typo`vari' , add        /* affiche les modalites avec le nombre */
            } 
            
            /*********  on renomme sa2 sa3 et réciproquement (29/01/08 C et V) ************/
            * 29/01/08 sa3 = range.appellation et sa2 = range (pour cohérence avec les fichiers ancienne formule, notamment pour MN2G.ado)
            ren sa2 bonsa3
            ren sa3 sa2
            ren bonsa3 sa3
            
            di " "
            set output proc
            di in green "Création de brand2"  
            set output error
            
            /*  ETAPE N°8 : Création brand2 (ici car besoin du label de sa2 issu du php)*/
            quietly FusionMarques3456    /*NEW 18/12/08*/
            quietly MN2G 
            
            di " "
            compress
            /*CHANGER LISTE VAR A ORDONNER 3/08/07!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
            * capture order nopnlt*  c06- unite sp*  noreg- rs  sec- fru1 fru2 leg1  Sexe* BMI*  iage1- itpo1  acha- kafe  legu - ucfo vais- nbpers dogs- vcat Code_Commune foyer maber merge* s* nbsem v* nbvac  
            
            capture drop toto
            
            /* Tests sur l'unité (tuwa) du produit (si différent selon l'année) */
            quietly distinct tuwa
            if `r(ndistinct)'>1 {
                note: ATTENTION : `r(ndistinct)' unités (tuwa) coexistent sur ce produit !!!!!!
            }
            note : Créé avec la version `version' de DataMakerG.do
            capture numlabel, add force  /*pr avoir "num modalité" . "label modalité"*/
            label data "Produit `produit' (`lib') , annee `annee' ($S_DATE)" 
            save "`bonprod'/p`bonprod'NF",replace  
     
            /* ON FLINGUE    !!! */
            cd `bonprod'
            ! del panel*.dta    
            
            cd ../../../ProgsG
        
 
        }   /*fin boucle if r(N)>0*/
               
        else {      /*r(N)==0 pas d'obs pr ce produit pourtant ds ProduitsXXX.dta*/
            di in red "Pas d'obs. pour ce produit `produit' pour l'année `annee'."
            cd ../../../ProgsG
        }
        
        
    }   /* fin de la boucle produit  */  
                               
    clear
    set output proc 
    di in red "----------------------------------------------------------------------"
    di ""
    set output error

    set output proc
    di in yellow "---Affichage des notes du fichier----" 
    note
    di in yellow "---Fin du traitement----" 
    di in yellow " Fin du traitement le " in green " `c(current_date)',  "  in yellow " à " in green  " : `c(current_time)'. " 
    
    log close 

}   /*fin boucle annee*/


