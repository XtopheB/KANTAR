/*version du 16/01/06 (valérie)*/
/*Procédure utile pour utiliser la surface des magasins (identification des magasins via enseigne, departement et surface grâce aux données LSA)*/
/*ici on essaie de remplacer les surfaces manquantes pour un ménage donné, par la surface du maga de l'enseigne donnée le + souvent fréquenté*/
/*14/02/06 correction et optimisation de la procédure...merci Christophe*/

/*Comment s'en servir ? ...taper : 
Corrige_srwp_manquants  , enseigne(ici mettre "ctwpenwp" ou "enwp" selon le cas, cad selon l'année des données Secodip) missing(ici mettre "-1"  ou "." selon le cas)
-1 pour 2002 et 2003, "." pour 98-2001 
exemple : "Corrige_srwp_manquants  , enseigne(ctwpenwp) missing(-1)" */


set output error
set more off

program define Corrige_srwp_manquants    
version 9.1
syntax [varlist]  [, enseigne(string)  missing(string)] 
tokenize `varlist'


/*==========================================================*/
/*faire attention "." (98-2001) vs  "-1" 2003*/
/*enwp vs ctwpenwp*/
/*==========================================================*/
di in red "NEW"
duplicates tag nopnlt `enseigne' srwp,gen(tag2) /*nb de répétition d'achats ds enseigne de même surface (autrement dit, même magasin)*/
replace tag2 = tag2 + 1
replace tag2 = 0 if srwp==`missing' 
bysort nopnlt `enseigne'  : egen max_tag2 =max(tag2) if srwp!=`missing' /*lieu le + souvent fréquenté*/

replace max_tag=0 if max_tag2==.

capture drop surf_plus_freq
di in red "la variable enseigne est `enseigne' ici, et les missings de la variable surface sont représentés par `missing'"
local enseigne "`enseigne'"
bysort nopnlt `enseigne' : egen surf_plus_freq=max(srwp) if max_tag2==tag2
bysort nopnlt `enseigne' : egen surf_plus_freq2=max(surf_plus_freq) 
capture drop srwp2
gen srwp2 = srwp
replace srwp2=surf_plus_freq2 if srwp==`missing' 
capture drop surf_plus_freq*
capture drop max_tag2
order  nopnlt `enseigne' srwp srwp2 

di in red "Procédure terminée, variable superficie srwp2 créée, elle correspond à la correction de srwp"



end
