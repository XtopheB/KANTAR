/* Programme LabelMenageNF (à partir de LabelMenage.do)  */
/* créé le 21/06/2006 V et C  */
/* LABELLISATION des variables des MénagesNF */
/*7/12/06 rajout certaines variables anthropo non mentionnées*/
/*14/05/07 rajout nouvelles variables 2004 et suite (année 2004 transition : des fois une variable, des fois elle est explosée)*/
/*par exemple mord ou ordi/mifi/mipo*/
/*labellisation de ana`i' (pour 2004) au lieu de iana`i'*/
/*27/07/07 correction typoclas pas typofoyer*/
/* version 1.1 : Ajout de etuc et etup  (15/01/2007)*/ 
/* version 1.2 : Synchronisation avec Valérie, Prise en compte specificités pour annee>=2004 (21/01/2008)*/ 
/* version 1.3 : Labellisation ageind`i' + 14 individus possibles (et non 11)*/ 
/*version 1.4 : Labellisation etud`i' (19/07/11 VO) */
/*version 1.5 : correction labels fru`i' et leg`i' avec i=1,2,3 (0 c'est non, 1 oui et pas l'inverse!!!) (3/08/11 VO)*/
/*version 2.0 : version générique et nouvelles variables 2008, 2009 (VO)*/
/*version 3.0 : rajouts nouvelles variables 2010, 2011 (VO)*/

local version "M3.0"

note : Programme de labelisation des ménages : version `version'
/* capture labelise les variables menages */ 

capture label variable spra "Statut de la personne responsable des achats"
capture label variable cspc "Categorie socio-professionnelle de la personne de reference"
capture label variable cspp "Categorie socio-professionnelle de la paneliste"
capture label variable dipc "Niveau de diplome de la personne de reference"
capture label variable dipp "Niveau de diplome de la paneliste"
capture label variable en16 "Nombre d'enfants de moins de 16 ans"
capture label variable en15 "Nombre d'enfants de moins de 15 ans"
capture label variable en3 "Nombre d'enfants de moins de 3 ans"
capture label variable en4 "Nombre d'enfants de moins de 4 ans"
capture label variable habi "Habitat (recensement 1990 de la pop)"
capture label variable naic "Annee de naissance de la personne de reference"
capture label variable nais "Date de naissance du dernier bébé de moins de 4 ans"     /*new*/
capture label variable agec "Age de la personne de reference"
capture label variable naip "Annee de naissance de la paneliste"
capture label variable agep "Age de la paneliste"
capture label variable natc "Nationalite de la personne de reference"
capture label variable natp "Nationalite de la paneliste"
capture label variable nfp "Nombre de personnes au foyer en permanence"
capture label variable nf "Nombre de personnes au foyer"
capture label variable noreg "Departement de residence du menage (numerotation Secodip)"
capture label variable porpnlt "Periode de recrutement du menage"
capture label variable revd "Revenu mensuel du foyer declare par la paneliste"
capture label variable an "Annee de l'observation"
capture label variable nopnltNF "Numero de paneliste (nouvelle formule 2002-2005)" 
capture label variable nopnlt "Numero de paneliste (ancienne formule)" 

      
/*3/05/05 nouvelles variables intégrées*/ 
capture label variable jard "Jardin"
capture label variable auto "Vehicule auto"
capture label variable capa "Capacité congelateur"
capture label variable rs "Residence secondaire"
capture label variable ucfe "Unites de conso Femmes"
capture label variable ucad "Unites de conso Adultes"
capture label variable ucbb "Unites de conso Bebes"
capture label variable refr "refrig-congel. (le plus gros)"
capture label variable telp "téléphone portable"
capture label variable zeatinsee "Zone d'étude et d'aménagement du territoire insee"
capture label variable mord "Micro-Ordinateur"
/*1/09/11*/
capture label variable  fare "famille recomposée"
capture label variable  jenf "age plus jeune enfant"
capture label variable  dog "nb de chiens"
capture label variable  chat "nb de chats"
capture label variable  cace "cave ou cellier"
capture label variable  malt "lave linge indép"
capture label variable  kafe "cafetière électrique - cafetière expresso"
capture label variable  stat "STATUT DU PLUS JEUNE BEBE DE MOINS DE 4 ANS"
 
local jour "lundi mardi mercredi jeudi vendredi samedi dimanche"
local ms "midi soir"
foreach j of local jour {
    foreach r of local ms {
        capture label variable `j'_`r' "Nb moy.de pers.au repas(domicile)du `j' `r'"
    }
} 

  
capture label define typoitai 0 "75 et -" 1 "76 à 79" 2 "80 à 83" 3 "84 à 87" 4 "88 à 91" 5 "92 à 95" 6 "96 à 99" 7 "100 à 103" 8 "104 et plus" 9 "non déclaré"
capture label define typoibas 0 "87 et -" 1 "88 à 90" 2 "91 à 93" 3 "94 à 96" 4 "97 à 99" 5 "100 à 102" 6 "103 à 106" 7 "107 à 112" 8 "113 et plus" 9 "non déclaré"


capture label define typoista 1 "menagère" 2 "personne de référence (homme)" 3 "autres individus féminins" 4 "autres individus masculins"

capture label define typoSexe 9 "non deduit" 1 "homme" 2"femme"

/*------------------------------tour poitrine !!!!!!!! des diff ho / fe -------------------------------*/
/*label commun ho/fe mais changement des moda initiales (donc +10 hommes, +20 femmes)*/

/************pour les hommes*************/
capture label define typoitpo 10 "83 et - (h)" 11 "84 à 87 (h)" 12 "88 à 91 (h)" 13 "92 à 95 (h)" 14 "96 à 99 (h)" 15 "100 à 103 (h)" 16 "104 à 107 (h)" 17 "108 à 111 (h)" 18 "112 et plus (h)" 19 "non déclaré (h)"
/************pour les femmes (, add) *************/
capture label define typoitpo 20 "82 et - (f)" 1 "83 à 85 (f)" 22 "86 à 88 (f)" 23 "89 à 91 (f)" 24 "92 à 94 (f)" 25 "95 à 97 (f)" 26 "98 à 100 (f)" 27 "101 à 104 (f)" 28 "105 et plus (f)" 29 "non déclaré (f)", add
capture label value itpo typoitpo

/*----------------------------------------stature !!!!!!!! des diff ho / fe----------------------------------------*/
/*label commun ho/fe mais changement des moda initiales (donc +10 hommes, +20 femmes)*/
/************pour les hommes*************/
capture label define typoihau 10 "163 et -" 11 "164 à 166" 12 "167 à 168" 13 "169 à 171" 14 "172 à 173" 15 "174 à 176" 16 "177 à 178" 17 "179 à 182" 18 "183 et plus" 19 "non déclaré"
/************pour les femmes (, add)*************/
capture label define typoihau_f 20 "153 et -" 21 "154 à 156" 22 "157 à 158" 23 "159 à 161" 24 "162 à 163" 25 "164 à 166" 26 "167 à 168" 27 "169 à 171" 28 "172 et plus" 29 "non déclaré", add
capture label value ihau typoihau

capture label define typojard 0 "non dispo jardin" 1 "jardin en rési principale" 2 "jardin en rési secondaire" 3 "jardin rési princi et secon" 4 "jardin ailleurs" 5 "jardin rési prin et ailleurs" 6 "jardin rési secon et ailleurs" 7 "jardin rési prin et secon et ailleurs"
capture label value jard typojard

capture label define typocapa 0 "pas de congelateur" 1 "congel moins de 150L" 2 "congel 150L et plus" 8 "possession non declaree" 9 "capacite non declaree"
capture label value capa typocapa

capture label define typors 0 "pas de residence secondaire" 1 "disposition residence secondaire" 2 "possession residence secondaire"
capture label value  rs typors

forvalues i=1/14 {
    *capture label variable ista`i' "Statut indiv `i'"
    capture label variable statut`i' "Statut indiv `i'"         /*chgt 2003-2005! (avant classes)!!!*/
    capture label variable iday`i' "Jour naiss indiv `i'"
    capture label variable imois`i' "Mois naiss indiv `i'"
    capture label variable iana`i' "Annee naiss indiv `i'"
    capture label variable ana`i' "Annee naiss indiv `i'" /*pour 2004*/
    capture label variable icsp`i' "Csp indiv `i'"
    capture label variable itai`i' "Tour taille masculin `i' (cm)"  /*chgt 2003-2005! (avant classes)!!!*/
    *capture label variable itad`i' "Tour taille masculin `i' (en cm)"
    capture label variable ibas`i' "Tour bassin feminin `i' (cm)"   /*chgt 2003-2005! (avant classes)!!!*/
    capture label variable ihad`i' "Stature indiv `i' (cm) "
    capture label variable ipoi `i' "Pointure indiv `i' (+ 15ans)"
    capture label variable icol`i' "Tour col masculin `i' (cm)"
    capture label variable iord`i' "Num ordre indiv `i'"
    *capture label variable itpd`i' "Tour poitrine indiv `i' (cm)"
    capture label variable itpo`i' "Tour de poitrine  indiv `i' (cm) "      /*chgt 2003-2005 (avant classes)!!!!*/
    capture label variable ihau`i' "Stature indiv `i' (cm) "    /*chgt 2003-2005 (avant classes)!!!!*/
    capture label variable Sexe`i' "Sexe indiv `i' (déduit des mensurations données)"
    capture label variable ageind`i' "age de l'individu `i' du foyer (en mois) (-1 bébé à naitre)" 
    /*new 27/08/13*/
    capture label variable ianb`i'  "Année de naissance de l'individu `i' du foyer"
    
    /*-- tour taille (que pour les hommes) --*/
    capture label value itai`i' typoitai
    /*-- tour bassin (que pour les femmes) --*/
    capture label value ibas`i' typoibas
     /*-- statut (renseigne sur le sexe des individus)--*/
    *capture label value ista`i' typoista
    capture label value statut`i' typoista
    /*--tour de poitrine(ATTENTION, difference selon le sexe)*/
    capture label value itpo`i' typoitpo
    /*--stature (ATTENTION, difference selon le sexe)*/
    capture label value ihau`i' typoihau
    /*--sexe deduit de ista`i' ---*/
    capture label value   Sexe`i' typoSexe
    
    capture label variable  BMI`i' "Body Mass Index indiv `i'"
}

/*------------------------------------*/      

         capture label define typocspc 10 "agric. exploitants" 21 "artisans" 22 "commercants et assimilés" /*
*/       23 "chefs d'E. de 10 salaries et +" 31 "prof. liberales" 35 "info et spectacles" /*
*/       36 "cadres d'E. et ingenieurs"  39 "cadres fion pub., professeurs, prof. scientifiques" /*
*/       41 "instits, sante et travail social, clerge, prof. administratives fion pub." /*
*/       46 "prof. adminitratives et commerciales des E." 47 "techniciens" 48 "contremaitres agents de maitrise" /*
*/       52 "employes civils et agents de service fion pub." 53 "policiers et militaires" /*
*/       54 "employes administratifs d'E." 55 "employes de commerce" 56 "personnels des services directs aux particuliers"/*
*/       60 "ouvriers qualifies" 64 "chauffeurs" 66 "ouvriers non qualifies" 69 "ouvriers agricoles" /*
*/       71 "anciens agriculteurs exploitants" 72 "anciens artisans, commercants, chefs d'E." /*
*/       73 "anciens cadres et prof. intermediaires" 76 "anciens employes et ouvriers" /*
*/       81 "chomeurs n'ayant jamais travaille" 83 "militaires du contingent" 84 "eleves, etudiants" /*
*/       87 "personnes diverses sans activite professionnelle" 99 "non declare"
          capture label value cspc typocspc

         capture label define typocspp 10 "agric. exploitants" 21 "artisans" 22 "commercants et assimilés" /*
*/       23 "chefs d'E. de 10 salaries et +" 31 "prof. liberales" 35 "info et spectacles" /*
*/       36 "cadres d'E. et ingenieurs"  39 "cadres fion pub., professeurs, prof. scientifiques" /*
*/       41 "instits, sante et travail social, clerge, prof. administratives fion pub." /*
*/       46 "prof. adminitratives et commerciales des E." 47 "techniciens" 48 "contremaitres agents de maitrise" /*
*/       52 "employes civils et agents de service fion pub." 53 "policiers et militaires" /*
*/       54 "employes administratifs d'E." 55 "employes de commerce" 56 "personnels des services directs aux particuliers"/*
*/       60 "ouvriers qualifies" 64 "chauffeurs" 66 "ouvriers non qualifies" 69 "ouvriers agricoles" /*
*/       71 "anciens agriculteurs exploitants" 72 "anciens artisans, commerçants, chefs d'E." /*
*/       73 "anciens cadres et prof. intermediaires" 76 "anciens employes et ouvriers" /*
*/       81 "chomeurs n'ayant jamais travaille" 83 "militaires du contingent" 84 "eleves, etudiants" /*
*/       87 "personnes diverses sans activite professionnelle" 99 "non declare"
          capture label value cspp typocspp

        /*27/08/13 labellisation csp pour tous les indiv du ménage*/
        forv i=1/14 {
            capture label value icsp`i' typocspc
        }

          capture label define typodipc 0 "en etudes ou non declare" 1 "> bac +2" 2 "bac +2" /*
*/        3 "bac, brevet technicien, de maitrise" 4 "CAP" 5 "BEP" 6 "BEPC" 7 "certif d'etudes" 8 "aucun diplomes"
          capture label value dipc typodipc

          
          capture label define typodipp 0 "en etudes ou non declare" 1 "> bac +2" 2 "bac +2" /*
*/        3 "bac, brevet technicien, de maitrise" 4 "CAP" 5 "BEP" 6 "BEPC" 7 "certif d'etudes" 8 "aucun diplomes"
          capture label value dipp typodipp
          
          

          capture label define typoen16 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 ">=9"
          capture label value en16 typoen16

          capture label define typoen3 0 "0 bebe de - 3 ans" 1 "1 bebe de 0-2 mois" 2 "1 bebe de 3-5 mois"/*
*/        3 "1 bebe de 6-11 mois" 4 "1 bebe de 12-17 mois" 5 "1 bebe de 18-23 mois" 6 "1 bebe de 24-29 mois"/*
*/        7 "1 bebe de 30-35 mois" 8 ">=2 bebes" 
          capture label value en3 typoen3       

          capture label define typohabi 0 "Communes rurales" 1 "U. urbaines 2000-4999 hab" 2 "U. urbaines 5000-9999 hab" /*
*/        3 "U. urbaines 10000-19999 hab" 4 "U. urbaines 20000-49999 hab" 5 "U. urbaines 50000-99999 hab" /*
*/        6 "U. urbaines 100000-199999 hab" 7 "U. urbaines > 200000 hab, hors Paris et agglo" 8 "Paris et agglo" 
          capture label value habi typohabi

         capture label define typonatc 0 "pas de pers. de ref. homme" 1 "francaise" 2 "autres" 9 "non declare"
          capture label value natc typonatc   

          capture label define typonatp 1 "francaise" 2 "autres" 9 "non declare"
          capture label value natp typonatp   

          capture label define typonfp 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 ">=9"
          capture label value nfp typonfp   

          capture label define typonf 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 ">=9"
          capture label value nf typonf   

          capture label define typonaic 1900 "1900" 
          capture label value naic typonaic   

        
          capture label define typonaip 1900 "1900" 
          capture label value naip typonaip  

          capture label define typoagec 40 "40" 
          capture label value agec typoagec     

          capture label define typoagep 40 "40" 
          capture label value agep typoagep     


          capture label define typorevd 1 "< 2KF" 2 "[2KF;3KF[" 3 "[3KF;4KF[" 4 "[4KF;5KF[" 5 "[5KF;6KF[" 6 "[6KF;7KF["/*
*/        7 "[7KF;8KF[" 8 "[8KF;9KF[" 9 "[9KF;10KF[" 10 "[10KF;12.5KF[" 11 "[12.5KF;15KF[" 12 "[15KF;17.5KF[" /*
*/        13 "[17.5KF;20KF[" 14 "[20KF;25KF[" 15 "[25KF;30KF[" 16 "[30KF;35KF[" 17 "[35KF;45KF[" 18 ">= 45KF" 99 "non declare" 
          capture label value revd typorevd   
            
          
           capture label variable foyer "Nombre de personnes au foyer (recodage de NF)"
           capture label define typofoyer 1 "1" 2 "2" 3 "3" 4 "4" 5 "5 et +" 
           capture label value foyer typofoyer        
          
          
          capture label variable maber " Code d'erreur du menage"
          capture label define typomaber 0  "OK"  1 "Achat de M inconnu SECODIP"  2 "Non Achat"  3 "Achat de M sans Ponderation" /* a completer si besoin est*/
          capture label value maber typomaber 
          
/* Nouvelles variables   */
     
     capture label variable en6 " Nombre d'enfants de moins de 6 ans"  
     capture label variable  bebe "Presence d'enfants de - de 4 ans (- de 48 mois)"
     capture label variable nocom "Numero de commune"
     
     capture label variable typh "Type d'habitation et statut d'occupation "
     capture label define typotyph  1 "proprio maison indiv" 2 "loca maison indiv" 3 "proprio appart" 4 "loca appart" 5 "proprio ferme" 6 "loca ferme" 7 "maison (statut d'onccupation non declaré)" 8 "appart (statut d'onccupation non declaré)" 9 "non declaré"
     capture label value typh typotyph 
     
     capture label variable ucfo "Unites de conso Foyer"
     
           
     capture label variable reve "Revenu mensuel du foyer (ESTIME SECODIP)"
    capture label define typoreve 1 "< 2KF" 2 "[2KF;3KF[" 3 "[3KF;4KF[" 4 "[4KF;5KF[" 5 "[5KF;6KF[" 6 "[6KF;7KF["/*
*/        7 "[7KF;8KF[" 8 "[8KF;9KF[" 9 "[9KF;10KF[" 10 "[10KF;12.5KF[" 11 "[12.5KF;15KF[" 12 "[15KF;17.5KF[" /*
*/        13 "[17.5KF;20KF[" 14 "[20KF;25KF[" 15 "[25KF;30KF[" 16 "[30KF;35KF[" 17 "[35KF;45KF[" 18 ">= 45KF" 
    capture label value reve typoreve   
    
    
    capture label variable cspci "CSPc correspondance INSEE (cree par GenPoids.ado)"
        capture label define typocspci 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 
        capture label value cspci typocspci   
          
          capture label variable csppi "CSPp correspondance INSEE (cree par GenPoids.ado)"
        capture label define typocsppi 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ingénieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commerçants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 

        capture label value csppi typocsppi   
          
/* Ajout 10/05/2006 */


capture label variable clas "Classes Economico-Sociales Secodip"
capture label define typoclas 1 "Aisée" 2 "Moyenne Supérieure" 3 "Moyenne Inférieure" 4 "Modeste" 
capture label value clas typoclas

capture label variable ensc "Enseignement de la personne de réf encore en cours d'étude"
capture label variable ensp "Enseignement de la panéliste encore en cours d'étude"
capture label define typoens 0 "Plus encore en cours d'étude ou non déclaré" 1 "Primaire" 2 "Secondaire général collège" /*
*/ 3 "Secondaire général lycée" 4 "Technique (lycée d'ens prof ou tech)" 5 "Supérieur (<bac+2)" 6 "Supérieur (> ou = bac + 2)" 

capture label value ensc typoens
capture label value ensp typoens

capture label variable fru1 "Possession d'arbres fruitiers en résidence principale"
capture label define typofru1 1 "Oui" 0 "Non" 

capture label value fru1 typofru1

capture label variable fru2 "Possession d'arbres fruitiers en résidence secondaire"
capture label define typofru2 1 "Oui" 0 "Non" 2 "Non déclaré"
capture label value fru2 typofru2

capture label variable fru3 "Possession d'arbres fruitiers ailleurs"
capture label define typofru3 1 "Oui" 0 "Non" 2 "Non déclaré"
capture label value fru3 typofru3

forvalues i=1/14 {
    capture label variable iage`i' "Age indiv `i'"
    capture label variable iana`i' "Annee naiss indiv `i'"
    capture label variable ihad`i' "Stature indiv `i'  (en cm)"
    capture label variable ibad`i' "Tour de bassin indiv `i'  (en cm) (Femmes seulement)"
    capture label variable ipds`i' "Poids indiv `i'  (en kg)"
    capture label variable itpd`i' "Tour de poitrine indiv `i' (en cm)"
}

capture label variable leg1 "Production de légumes pour la consommation en résidence principale"
capture label define typoleg1 1 "Oui" 0 "Non" 2 "Non déclaré"
capture label value leg1 typoleg1

capture label variable leg2 "Production de légumes pour la consommation en résidence secondaire"
capture label define typoleg2 1 "Oui" 0 "Non" 2 "Non déclaré"
capture label value leg2 typoleg2

capture label variable leg3 "Production de légumes pour la consommation ailleurs"
capture label define typoleg3 1 "Oui" 0 "Non" 2 "Non déclaré"
capture label value leg3 typoleg3

capture label variable auto "nb vehicule(s)"
capture label variable tlv "nb tv couleurs"

capture label variable net "Connexion à Internet"
capture label define typonet 0 "Ni disposition, ni utilisation" 1 "Disposition d'une connexion internet à domicile"/*
*/ 2 "Utilisation domicile ou extérieur" 3 "Disposition + utilisation" 9 "Non déclaré"
capture label value net typonet

capture label define typospra 1 "homme (statut 2)" 2 "femme active (statut 1 et csp 10 à 69)" 3 "femme inactive (statut 1 et csp 70 à 89)"
capture label value spra typospra
    
capture label variable agbb "Age plus jeune bébé de moins de 3 ans (moins de 4 ans depuis 2002)"
capture label define typoagbb 1 "0 à 2 mois" 2 "3 à 5 mois" 3 "6 à 11 mois" 4 "12 à 17 mois" 5 "18 à 23 mois" 6 "24 à 29 mois" 7 "30 à 35 mois" /*
*/ 8 "36 à 41 mois (depuis 1ère période 2002)" 9 "42 à 47 mois (depuis 1ère période 2002)" 
capture label value agbb typoagbb
 

   forvalues i=2/52 {
          capture label variable s`i' "Activite de la `i'eme semaine"     
    }
   capture label variable s1 "Activite de la 1ere semaine"     
   capture label variable nbsem "Nombre de semaines d'activite annuelle" 
   capture label variable NbSemAct "Nombre de semaines d'activite annuelle" 
   capture label variable act "Activite lors de l'achat (activité semaine basée sur les s1...s52)" 
   
   
    capture label define typopanel 1 "GC" ,add 
    capture label define typopanel 2 "VP" ,add
    capture label define typopanel 3 "FL" ,add
    capture label value panel typopanel
    capture numlabel typopanel, add  



/*********   nouvelles variables 2004  *************/
/*****   Ces 3 variables remplacent mord*********/
if an==2004 {   /*c'est faux mais c'est juste*/
note an : annee 2004 TRANSITION pour certaines variables ménages (selon période de recrutement, utiliser une variable ou une autre) (Attention : typh, telp, net...))
note ordi : + de précision concernant possession micro-ordi : avt oui/non, now combien de chaque type (mord est remplacé par ordi, mifi, mipo)
}
capture label variable ordi "Nb de micro-ordi"
capture label variable mifi "Nb de PC"
capture label variable mipo "Nb d'ordi. port."


capture label variable hoci "home cinema"
capture label variable cabl "abonnement reseau cable"
capture label variable absa "abonnement satellite"
capture label variable deco "decodeur canal+"
capture label variable ldvd "lecteur dvd"
capture label variable phnu "appareil photo numérique"

/****  Eclatement de la variable typh  *****/
if an>=2004 {   /*c'est faux mais c'est juste*/
    note thab : éclatement de la variable type habitation (typh) (proprio/loca et maison/appart...) en 2 variables (thab et socc)
    note japr: eclatement variable jardin (jard) en 2 variables (japr, jase, jaai)
    note rsse: nouvelle variable rsse (résidence secondaire) qui remplace rs mais pas même moda.
    note en25: nouvelle variable Nb enfants de moins de 25 ans (en25)
}

capture label variable rsse "Residence secondaire (voir ancienne variable rs)"

capture label variable japr "Jardin en résidence principale"
capture label variable jase "Jardin en résidence secondaire"
capture label variable jaai "Jardin ailleurs (hors rési prin et secon)"
capture label define typoj  1 "possesseur"  0 "non possesseur" 9 "non declaré"
capture label value japr typoj 
capture label value jase typoj 
capture label value jaai typoj 

capture label variable en25 "Nb enfants de moins de 25 ans"


capture label variable thab "Type d'habitation"
capture label define typothab  1 "maison indiv"  2 "appart" 3 "ferme"  9 "non declaré"
capture label value thab typothab 

capture label variable socc "Statut d'occupation du logement principal"     
capture label define typosocc 	1 "proprio. ou co-proprio" 2 " loca ou sous-loca" 3 "logé gratos" 9 "non déclaré"
capture label value socc typosocc 

/*****   telp devient tlpo    *****/
if an==2004 {   /*c'est faux mais c'est juste*/
note tlpo: + de précision concernant possession tel.port : avt oui/non (telp), now combien (tlpo)
}
capture label variable tlpo "nb d'individus du foyer possesseurs tel port."

/*****   Eclatement de net en indo/intr/emdo    *****/
if an>=2004 {   /*c'est faux mais c'est juste*/
note indo: + de précision concernant Internet : net est éclaté en 3 variables indo, net2, emdo
}
capture label variable indo "Connexion Internet à domicile"
capture label variable net2 "Connexion Internet sur lieu de travail"
capture label variable emdo "adresse email domicile"

capture label define typoindo 0 "pas acces internet domicile" 1 "acces internet en ligne tel classique" 2 "acces internet avec ligne haut debit" 3 "acces avec mode connexion non renseigné" 9 "non déclaré"
capture label define typonet2 0 "pas acces internet lieu travail" 1 "acces internet lieu travail"  9 "non déclaré"
capture label define typoemdo 0 "non possesseur" 1 "possesseur" 9 "non déclaré"
capture label value indo typoindo
capture label value net2 typonet2 
capture label value emdo typoemdo



capture label variable sech "Sous-échantillons"
capture label define typosech 01 "WP p  FL" 02 "WP p VP" 81 "WP s FL" 88 "WP s VP"
			
/*****   telp devient tlpo    *****/
if an>=2004 {   /*commence courant 2004*/
     capture note etup :  Diplome panéliste (dipp) devient Niveau études (var etup) (mais moda changent)
    capture note etuc:  Diplome pers. ref. (dipc) devient Niveau études (var etuc) (mais moda changent)

}
capture label define typoetup 0 "en etudes ou non declare" 0 "Pas encore scolarisé, maternelle" 1 "Etudes primaires"/*
*/ 2 "Enseignement second.(6e a 3e)"  3 "Technique court (CAP,BEP)" 4 "2e, niveau bac ou brevet pro" 5 "Technique sup (IUT,BTS)"/*
*/ 6 "Supérieur 1er cycle(DEUG,DEUST...)" 7 "Sup 2e cycle(Licence, Maitrise...)" 8 "Sup 3e cycle(DEA,DESS,Doctotat...)" 9 "Non déclaré"
capture label value etup typoetup
capture label variable etup "Niveau études panéliste (remplace dipp 2004-2005)"

capture label variable etuc "Niveau études de la pers. réf.(remplace dipc 2004-2005)"
capture label value etuc typoetup

forvalues i=1/14 {
     capture label variable itlp`i' "Possession tel. port.indiv.`i'"
     capture label variable etud`i' "Niveau études indiv.`i'"
     capture label value etud`i' typoetup       /*NEW 19/07/11*/
     
     capture label variable itra`i' "Act.professionnelle indiv.`i'"
}

capture label variable trap "Activité professionnelle du panéliste"
capture label define typotrap 0 "Sans activité professionnelle"  1 "Temps complet" 2 "Temps partiel" 9 "Activité niveau non déclaré"
capture label value trap typotrap


capture label variable aiur "Aire urbaine"
capture label define typoaiur 0 "Espace à dominante rurale"  1 "Pôle urbain" 2 "Commune Monopolarisée/Couronne peri urbaine" 3 "Commune Multipolarisée"
capture label value aiur typoaiur

if an>=2005 {   /*commence en sept 2005*/
    note cycle:  Nouvelle variable cycle de vie (cycle)
}
capture label variable cycle "Cycle de vie"


/*********   nouvelles variables 2009 *************/
capture label define typofare 0 "non"  1 "oui"  9 "Non déclaré"
capture label value fare typofare


capture label variable cap1 "REFRIGERATEUR COMBINE AVEC CONGELATEUR de moins de 150L"
capture label variable cap2 "REFRIGERATEUR COMBINE AVEC CONGELATEUR de 150L et plus"
capture label variable cgl1 "CONGELATEUR INDEPENDANT de moins de 150L"
capture label variable cgl2 "CONGELATEUR INDEPENDANT de 150L et plus" 
capture label variable ipod "LECTEUR MP3, IPOD"
capture label variable rf1p	"REFRIGERATEUR INDEPENDANT"
capture label variable rf3e "REFRIGERATEUR COMBINE AVEC CONSERVATEUR "

capture label define typoposs 0 "non possesseur"  1 "possesseur" 9 "Non déclaré"

capture label value cap1 typoposs
capture label value cap2 typoposs
capture label value cgl1 typoposs
capture label value cgl2 typoposs
capture label value ipod typoposs
capture label value rf1p typoposs
capture label value rf3e typoposs
capture label value cace typoposs
capture label value malt typoposs

capture label define typojenf 0 "pas d'enfant"  1 "LE PLUS JEUNE A MOINS DE 25 MOIS" 2 "LE PLUS JEUNE A DE 25 MOIS A 5 ANS" 3 "LE PLUS JEUNE A DE 6 A 10 ANS"  4 "LE PLUS JEUNE A DE 11 A 15 ANS "
capture label value jenf typojenf

capture label define typokafe 0 "NON POSSESSEUR" 1 "CAFETIERE ELECTRIQUE" 	2 "CAFETIERE EXPRESSO" 	3 "CAFETIERE ELECTRIQUE + CAFETIERE EXPRESSO" 		9 "NON DECLARE" 
capture label value kafe typokafe

capture label define typostat 0 "PAS DE BEBE" 3 "FILLE" 4 "GARçON" 
capture label stat typostat

/*********   nouvelles variables 2010 , 2011 *************/
capture label variable itra	"activité professionnelle du panéliste" 
capture label define typoitra 1 "Travail à temps complet"  2 "Travail à temps partiel"   0 "sans activité"   9 "non déclaré"
capture label value itra typoitra
forv i=1/14 {
    capture label value itra`i'	 typoitra
}

capture label variable cycle "cycle de vie  (Calcul sur l'âge de la PRA)"
capture label define typocycle 1  "Jeunes célibataires (NF1 - de 35 ans, ss enf)"/*
*/  2 "Célibataires âge moyen (NF1 35-64 ans, ss enf)" /*
*/ 3 "Vieux célibataires (NF1 65 ans et +, ss enf)" /*
*/ 4 "Jeunes couples (NF2 et +, de - de 35 ans, ss enf)" /*
*/5 "Couples âge moyen (NF2 et +, 35-64 ans, ss enf)" /*
*/6 "Vieux couples (NF2 et +, 65 ans et +, ss enf)" /*
*/7 "Famille maternelle (NF2 et +, enf le + vieux a de 0 à 5 ans)" /*
*/8 "Famille école primaire (NF2 et +, enf le + vieux a de 6 à 11ans)" /*
*/9 "Famille collège et lycée (NF2 et +, enf le + vieux a de 12 à 17ans) " /*
*/10 "Famille enfants majeurs (NF2 et +, enf le + vieux a de 18 à 24ans)
capture label value cycle typocycle

capture label variable chip	"Poids du chien le plus petit"
capture label variable chig	"Poids du chien le plus gros"
capture label define typochipchig 1 "MOINS DE 5 KGS" 2 "5 A 10 KGS" 3 "11 A 15 KGS" 4 "16 A 20 KGS" 5 "21 A 25 KGS" 6 "26 A 35 KGS" 7 "36 A 45 KGS" 8 "PLUS DE 45 KGS"
capture label value chip typochipchig
capture label value chig typochipchig


capture label variable  scla "CLASSE SOCIO-ECONOMIQUES OCDE"
capture label define typoscla 	1 "TRES MODESTE" 2 "MODESTE" 3 "MOYENNE INFERIEURE" 4 "MOYENNE SUPERIEURE" 5 "AISEE"
capture label value scla typoscla
