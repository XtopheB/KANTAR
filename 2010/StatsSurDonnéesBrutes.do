set output proc    /* supprime l'affichage (sauf erreurs) */
clear
capture log close
pause on
set more off  /* pour que Stata ne stope pas en fin de page  */


*local varlistannee "2007 2008 2009"      /*  <------------------------- !!! ANNEES   */  
local annee "2011"      /*  <------------------------- !!! ANNEES   */  
local PetitNomAnnee "11"

/***************************************************************************/                
/****************************************************************** * */

cd "../DonneesOriginales/brutesNF`PetitNomAnnee'/Donnees`annee'"
  
	
clear

/****   Chargement des fichiers achats ****/
local list_per "01 02 03 04 05 06 07 08 09 10 11 12 13"  

foreach per of local list_per {
     /* Données USI  */
     set output proc
     di in white "Data_ET`annee'`per'.dta en cours"
     count
     append using "Data_ET`annee'`per'.dta"           
}

merge n:1 ref using Achats/Product_Desc_1aN`annee'.dta, update replace      /*pr 2011 on récupère sa1*/
drop if _merge==2
drop _merge
  
save ../dataAll`annee'.dta, replace
count
*bysort sa1 : egen NbObs = count(year)
bysort sa1 : gen NbObs = _N

bysort sa1 : keep if _n==1

*merge 1:1 ref using ../Produits`PetitNomAnnee'.dta     /*avant 2011*/

gsort  -NbObs
listtex sa1 libellesa1 NbObs using TableProduits`PetitNomAnnee'.csv, type delimiter(" ; ") replace


