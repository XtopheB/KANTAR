/************************ LabelVarProdComNF789.do *************************************/
/*18/12/08 LabelVarProdComNF56.do créé à partir de LabelVarProdComNF345.do */
/* A lancer sur un fichier produit 2005-2006 nouvelle formule*/
/*18/12/08 label de sflag rajouté*/
/*17/08/11 labellisation de tuwa, suppression de LibTuwa (ou ds Epure?), labellisation de Qu et Pu (valérie)*/
/*31/07/13 un petit capture rajouté + labellisation de sa1 (avant dans DataMakerG.do)*/
/*6/08/13 version 2.0 : on renomme var "Spe1" en "Gencode" pour année 2011 (G ou NG : gencodé ou non)*/
/*5/09/13 version 2.1 : Modif label sflag et se smodalités*/
/********************************************************************************/
local Version "2.1"

capture label   variable annee "Année du panel"
capture label   variable cawp "Centrale d'achat (NF)"

capture label   variable ctwpenwp "Catégorie de magasin et Enseigne du magasin (NF)"
capture label   variable cvwp "Circuit de vente"
capture label   variable dtwa "Date de l'achat"
capture label   variable famille "Numéro de famille Secodip"
capture label   variable gawa "Coefficient correcteur si gros achats"

capture label   variable nawa "Numéro d'achat dans le panier"
capture label   variable npwa "Numéro de panier"
capture label   variable pa "Période d'achat  "
capture label   variable panel "Panel d'appartenance (1=GC, 2=VP, 3=FL)"
capture label   variable prwa "Coefficient produit en plus  "
capture label   variable ptwa  "Prix de l'achat (en euros)"       /*"Prix de l'achat en francs (relevé par le ménage)  "*/
capture label   variable qawa "Nombre d'achat d'un même produit lors d'un même acte d'achat  "
capture label   variable qorig "Quantité achetée dans les unités données par Secodip  "
capture label   variable qunitaire "Quantité de base (Secodip)  "
capture label   variable ref "Référence interne Secodip (2001-2006)  "
capture label   variable s191 "Promotions remarquées par le ménage  "
capture label   variable s1a7 "Jour de la semaine  "
capture label   variable sa1 "Numéro du produit  "
capture label   variable sflag "Source de la donnée"      /*Label modifié 5/09/13  "Source flag (2003-2006)"*/
capture label   variable pweight "Purchase weight (2003-2006)"

capture label   variable sm "Numéro de semaine dans la période (reconstitué par l'INRA à partir de 2001) "
capture label   variable sm52 "Numéro de la semaine depuis le début de l'année "
capture label   variable srwp "Surface du magasin "
capture label   variable tuwa "Unités de mesure originale (pour q) "
capture label   variable Pu  "prix unitaire en euros (avec produit en plus)"      /*rajout (7/12/06)*/

/*===============================================================================================================*/
/*=====================================================    A LA MAIN    =========================================*/
/*===============================================================================================================*/

/****************************    Variable panel    ****************************/
 /* Labellisation des modalités */           
capture label define typopanel 1 "GC", modify
capture label define typopanel 2 "VP", modify
capture label define typopanel 3 "FL", modify
capture label value panel typopanel
capture numlabel typopanel, add            

/*NEW 18/12/08*/
/****************************    Variable source flag    ****************************/
 /* Labellisation des modalités */    /*5/09/13 je complète la labellisation des moda (données 2011)*/       
capture label define typosflag 0 "scanette", modify
capture label define typosflag 1 "palm", modify 
capture label define typosflag 2 "scanette", modify
capture label define typosflag 4 "Relevé d'achat", modify      /*avant "hyg beauté (que sa1 35)"*/
capture label define typosflag 6 "Global Park", modify      
capture label define typosflag 7 "Clickers", modify    
capture label define typosflag 8 "H14 Mini scan", modify    
capture label define typosflag 11 "Déclaration des achats de proximité", modify    

capture label value sflag typosflag
capture numlabel typosflag, add  
 
/********  MDD  ***********/          
capture label variable sa7 "Marque : MDD ou non" 
capture label define typosa7  1 "MDD"  0 "Non MDD"
capture label value sa7 typosa7  
        
/***********    Variables quantités  (partie modifiée le 6/08/13)  *************/   
qui levels annee
if `r(levels)' <2011 {     
    capture local toto = LibTuwa[1]
    capture local toto = "(`toto')"
    di "`toto'"
}
capture label variable tuwa "Unité du produit   `toto'"        
capture label variable qorig "Quantité totale    `toto'"
capture label variable Qu "Quantité totale convertie CV   `toto'"
    
/*************      Variable merge       ************/
capture label variable mergeProduitMenage "Variable de jointure"
capture label define typomergeProduitMenage 3  "Achat M connu SECODIP"  2 "Achat fictif : M connu non acheteur" 1 "Achat M inconnu SECODIP"  
capture label value mergeProduitMenage typomergeProduitMenage
        
/**********  Variable achaber d'erreur sur achats  ********/        
capture label variable achaber "Code d'erreur sur achat"
capture label define typoachaber 0  "OK"    
capture label define typoachaber 1 "incoherence sa7", add 
capture label define typoachaber 2 "pb missing var communes importantes", add 
capture label define typoachaber 3 "circuit distri ou enseignes aberrant (cvwp ou ctwpenwp)", add 

/*NEW  31/07/13*/
/*************      Variable sa1       ************/
/*labellisation  de SA1 (pour l'instant un peu artisanal...). */  
quietly vallist libellesa1
local lib "`r(list)'"
/*labellisation variable sa1 num.lib*/
quietly vallist sa1
local nbprod "`r(list)'"
label define typosa1  `nbprod' "`lib'"  
capture label value sa1 typosa1  

/*NEW  6/08/13*/
/*************      Variable sp1   pour année 2011    ************/
qui levels annee
if `r(levels)' >=2011 {
    ren Spe1 Gencode
}
        
        
note : Version `Version' de LabelVarProdComG.do
di in yellow " Fin de LabelVarProdComG "        
