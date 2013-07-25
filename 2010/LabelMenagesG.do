/* Programme LabelMenageNF (� partir de LabelMenage.do)  */
/* cr�� le 21/06/2006 V et C  */
/* LABELLISATION des variables des M�nagesNF */
/*7/12/06 rajout certaines variables anthropo non mentionn�es*/
/*14/05/07 rajout nouvelles variables 2004 et suite (ann�e 2004 transition : des fois une variable, des fois elle est explos�e)*/
/*par exemple mord ou ordi/mifi/mipo*/
/*labellisation de ana`i' (pour 2004) au lieu de iana`i'*/
/*27/07/07 correction typoclas pas typofoyer*/
/* version 1.1 : Ajout de etuc et etup  (15/01/2007)*/ 
/* version 1.2 : Synchronisation avec Val�rie, Prise en compte specificit�s pour annee>=2004 (21/01/2008)*/ 
/* version 1.3 : Labellisation ageind`i' + 14 individus possibles (et non 11)*/ 
/*version 1.4 : Labellisation etud`i' (19/07/11 VO) */
/*version 1.5 : correction labels fru`i' et leg`i' avec i=1,2,3 (0 c'est non, 1 oui et pas l'inverse!!!) (3/08/11 VO)*/
/*version 2.0 : version g�n�rique et nouvelles variables 2008, 2009 (VO)*/

local version "M2.0"

note : Programme de labelisation des m�nages : version `version'
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
capture label variable nais "Date de naissance du dernier b�b� de moins de 4 ans"     /*new*/
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

      
/*3/05/05 nouvelles variables int�gr�es*/ 
capture label variable jard "Jardin"
capture label variable auto "Vehicule auto"
capture label variable capa "Capacit� congelateur"
capture label variable rs "Residence secondaire"
capture label variable ucfe "Unites de conso Femmes"
capture label variable ucad "Unites de conso Adultes"
capture label variable ucbb "Unites de conso Bebes"
capture label variable refr "refrig-congel. (le plus gros)"
capture label variable telp "t�l�phone portable"
capture label variable zeatinsee "Zone d'�tude et d'am�nagement du territoire insee"
capture label variable mord "Micro-Ordinateur"
/*1/09/11*/
capture label variable  fare "famille recompos�e"
capture label variable  jenf "age plus jeune enfant"
capture label variable  dog "nb de chiens"
capture label variable  chat "nb de chats"
capture label variable  cace "cave ou cellier"
capture label variable  malt "lave linge ind�p"
capture label variable  kafe "cafeti�re �lectrique - cafeti�re expresso"
capture label variable  stat "STATUT DU PLUS JEUNE BEBE DE MOINS DE 4 ANS"
 
local jour "lundi mardi mercredi jeudi vendredi samedi dimanche"
local ms "midi soir"
foreach j of local jour {
    foreach r of local ms {
        capture label variable `j'_`r' "Nb moy.de pers.au repas(domicile)du `j' `r'"
    }
} 

  
capture label define typoitai 0 "75 et -" 1 "76 � 79" 2 "80 � 83" 3 "84 � 87" 4 "88 � 91" 5 "92 � 95" 6 "96 � 99" 7 "100 � 103" 8 "104 et plus" 9 "non d�clar�"
capture label define typoibas 0 "87 et -" 1 "88 � 90" 2 "91 � 93" 3 "94 � 96" 4 "97 � 99" 5 "100 � 102" 6 "103 � 106" 7 "107 � 112" 8 "113 et plus" 9 "non d�clar�"


capture label define typoista 1 "menag�re" 2 "personne de r�f�rence (homme)" 3 "autres individus f�minins" 4 "autres individus masculins"

capture label define typoSexe 9 "non deduit" 1 "homme" 2"femme"

/*------------------------------tour poitrine !!!!!!!! des diff ho / fe -------------------------------*/
/*label commun ho/fe mais changement des moda initiales (donc +10 hommes, +20 femmes)*/

/************pour les hommes*************/
capture label define typoitpo 10 "83 et - (h)" 11 "84 � 87 (h)" 12 "88 � 91 (h)" 13 "92 � 95 (h)" 14 "96 � 99 (h)" 15 "100 � 103 (h)" 16 "104 � 107 (h)" 17 "108 � 111 (h)" 18 "112 et plus (h)" 19 "non d�clar� (h)"
/************pour les femmes (, add) *************/
capture label define typoitpo 20 "82 et - (f)" 1 "83 � 85 (f)" 22 "86 � 88 (f)" 23 "89 � 91 (f)" 24 "92 � 94 (f)" 25 "95 � 97 (f)" 26 "98 � 100 (f)" 27 "101 � 104 (f)" 28 "105 et plus (f)" 29 "non d�clar� (f)", add
capture label value itpo typoitpo

/*----------------------------------------stature !!!!!!!! des diff ho / fe----------------------------------------*/
/*label commun ho/fe mais changement des moda initiales (donc +10 hommes, +20 femmes)*/
/************pour les hommes*************/
capture label define typoihau 10 "163 et -" 11 "164 � 166" 12 "167 � 168" 13 "169 � 171" 14 "172 � 173" 15 "174 � 176" 16 "177 � 178" 17 "179 � 182" 18 "183 et plus" 19 "non d�clar�"
/************pour les femmes (, add)*************/
capture label define typoihau_f 20 "153 et -" 21 "154 � 156" 22 "157 � 158" 23 "159 � 161" 24 "162 � 163" 25 "164 � 166" 26 "167 � 168" 27 "169 � 171" 28 "172 et plus" 29 "non d�clar�", add
capture label value ihau typoihau

capture label define typojard 0 "non dispo jardin" 1 "jardin en r�si principale" 2 "jardin en r�si secondaire" 3 "jardin r�si princi et secon" 4 "jardin ailleurs" 5 "jardin r�si prin et ailleurs" 6 "jardin r�si secon et ailleurs" 7 "jardin r�si prin et secon et ailleurs"
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
    capture label variable Sexe`i' "Sexe indiv `i' (d�duit des mensurations donn�es)"
    capture label variable ageind`i' "age de l'individu `i' du foyer (en mois) (-1 b�b� � naitre)" 
    
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

         capture label define typocspc 10 "agric. exploitants" 21 "artisans" 22 "commercants et assimil�s" /*
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

         capture label define typocspp 10 "agric. exploitants" 21 "artisans" 22 "commercants et assimil�s" /*
*/       23 "chefs d'E. de 10 salaries et +" 31 "prof. liberales" 35 "info et spectacles" /*
*/       36 "cadres d'E. et ingenieurs"  39 "cadres fion pub., professeurs, prof. scientifiques" /*
*/       41 "instits, sante et travail social, clerge, prof. administratives fion pub." /*
*/       46 "prof. adminitratives et commerciales des E." 47 "techniciens" 48 "contremaitres agents de maitrise" /*
*/       52 "employes civils et agents de service fion pub." 53 "policiers et militaires" /*
*/       54 "employes administratifs d'E." 55 "employes de commerce" 56 "personnels des services directs aux particuliers"/*
*/       60 "ouvriers qualifies" 64 "chauffeurs" 66 "ouvriers non qualifies" 69 "ouvriers agricoles" /*
*/       71 "anciens agriculteurs exploitants" 72 "anciens artisans, commer�ants, chefs d'E." /*
*/       73 "anciens cadres et prof. intermediaires" 76 "anciens employes et ouvriers" /*
*/       81 "chomeurs n'ayant jamais travaille" 83 "militaires du contingent" 84 "eleves, etudiants" /*
*/       87 "personnes diverses sans activite professionnelle" 99 "non declare"
          capture label value cspp typocspp

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
     capture label define typotyph  1 "proprio maison indiv" 2 "loca maison indiv" 3 "proprio appart" 4 "loca appart" 5 "proprio ferme" 6 "loca ferme" 7 "maison (statut d'onccupation non declar�)" 8 "appart (statut d'onccupation non declar�)" 9 "non declar�"
     capture label value typh typotyph 
     
     capture label variable ucfo "Unites de conso Foyer"
     
           
     capture label variable reve "Revenu mensuel du foyer (ESTIME SECODIP)"
    capture label define typoreve 1 "< 2KF" 2 "[2KF;3KF[" 3 "[3KF;4KF[" 4 "[4KF;5KF[" 5 "[5KF;6KF[" 6 "[6KF;7KF["/*
*/        7 "[7KF;8KF[" 8 "[8KF;9KF[" 9 "[9KF;10KF[" 10 "[10KF;12.5KF[" 11 "[12.5KF;15KF[" 12 "[15KF;17.5KF[" /*
*/        13 "[17.5KF;20KF[" 14 "[20KF;25KF[" 15 "[25KF;30KF[" 16 "[30KF;35KF[" 17 "[35KF;45KF[" 18 ">= 45KF" 
    capture label value reve typoreve   
    
    
    capture label variable cspci "CSPc correspondance INSEE (cree par GenPoids.ado)"
        capture label define typocspci 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ing�nieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commer�ants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 
        capture label value cspci typocspci   
          
          capture label variable csppi "CSPp correspondance INSEE (cree par GenPoids.ado)"
        capture label define typocsppi 1 "agric exploit" 2 "artisans, commercants et assimiles, chef d'E. de 10 salaries et +"/*
*/      3 "prof lib et de l'info et du spec" 4 "ing�nieurs, cadres d'E., de la fion pub, professeurs, professions scientifiques"/*
*/      5 "prof inter" 6 "employes" 7 "ouvriers qualifies, chauffeurs" 8 "ouvriers non qualifies et agricoles"/*
*/      9 "anciens : agric exploitants, artisans, commer�ants, chefs d'E., cadres et prof inter" 10 "anciens employes et ouvriers" /* 
*/      11 "autre inactifs" 

        capture label value csppi typocsppi   
          
/* Ajout 10/05/2006 */


capture label variable clas "Classes Economico-Sociales Secodip"
capture label define typoclas 1 "Ais�e" 2 "Moyenne Sup�rieure" 3 "Moyenne Inf�rieure" 4 "Modeste" 
capture label value clas typoclas

capture label variable ensc "Enseignement de la personne de r�f encore en cours d'�tude"
capture label variable ensp "Enseignement de la pan�liste encore en cours d'�tude"
capture label define typoens 0 "Plus encore en cours d'�tude ou non d�clar�" 1 "Primaire" 2 "Secondaire g�n�ral coll�ge" /*
*/ 3 "Secondaire g�n�ral lyc�e" 4 "Technique (lyc�e d'ens prof ou tech)" 5 "Sup�rieur (<bac+2)" 6 "Sup�rieur (> ou = bac + 2)" 

capture label value ensc typoens
capture label value ensp typoens

capture label variable fru1 "Possession d'arbres fruitiers en r�sidence principale"
capture label define typofru1 1 "Oui" 0 "Non" 

capture label value fru1 typofru1

capture label variable fru2 "Possession d'arbres fruitiers en r�sidence secondaire"
capture label define typofru2 1 "Oui" 0 "Non" 2 "Non d�clar�"
capture label value fru2 typofru2

capture label variable fru3 "Possession d'arbres fruitiers ailleurs"
capture label define typofru3 1 "Oui" 0 "Non" 2 "Non d�clar�"
capture label value fru3 typofru3

forvalues i=1/11 {
    capture label variable iage`i' "Age indiv `i'"
    capture label variable ageind`i' "Age indiv `i'"    /*new 2005*/
    capture label variable iana`i' "Annee naiss indiv `i'"
    capture label variable ihad`i' "Stature indiv `i'  (en cm)"
    capture label variable ibad`i' "Tour de bassin indiv `i'  (en cm) (Femmes seulement)"
    capture label variable ipds`i' "Poids indiv `i'  (en kg)"
    capture label variable itpd`i' "Tour de poitrine indiv `i' (en cm)"
}

capture label variable leg1 "Production de l�gumes pour la consommation en r�sidence principale"
capture label define typoleg1 1 "Oui" 0 "Non" 2 "Non d�clar�"
capture label value leg1 typoleg1

capture label variable leg2 "Production de l�gumes pour la consommation en r�sidence secondaire"
capture label define typoleg2 1 "Oui" 0 "Non" 2 "Non d�clar�"
capture label value leg2 typoleg2

capture label variable leg3 "Production de l�gumes pour la consommation ailleurs"
capture label define typoleg3 1 "Oui" 0 "Non" 2 "Non d�clar�"
capture label value leg3 typoleg3

capture label variable auto "nb vehicule(s)"
capture label variable tlv "nb tv couleurs"

capture label variable net "Connexion � Internet"
capture label define typonet 0 "Ni disposition, ni utilisation" 1 "Disposition d'une connexion internet � domicile"/*
*/ 2 "Utilisation domicile ou ext�rieur" 3 "Disposition + utilisation" 9 "Non d�clar�"
capture label value net typonet

capture label define typospra 1 "homme (statut 2)" 2 "femme active (statut 1 et csp 10 � 69)" 3 "femme inactive (statut 1 et csp 70 � 89)"
capture label value spra typospra
    
capture label variable agbb "Age plus jeune b�b� de moins de 3 ans (moins de 4 ans depuis 2002)"
capture label define typoagbb 1 "0 � 2 mois" 2 "3 � 5 mois" 3 "6 � 11 mois" 4 "12 � 17 mois" 5 "18 � 23 mois" 6 "24 � 29 mois" 7 "30 � 35 mois" /*
*/ 8 "36 � 41 mois (depuis 1�re p�riode 2002)" 9 "42 � 47 mois (depuis 1�re p�riode 2002)" 
capture label value agbb typoagbb
 

   forvalues i=2/52 {
          capture label variable s`i' "Activite de la `i'eme semaine"     
    }
   capture label variable s1 "Activite de la 1ere semaine"     
   capture label variable nbsem "Nombre de semaines d'activite annuelle" 
   capture label variable NbSemAct "Nombre de semaines d'activite annuelle" 
   capture label variable act "Activite lors de l'achat (activit� semaine bas�e sur les s1...s52)" 
   
   
    capture label define typopanel 1 "GC" ,add 
    capture label define typopanel 2 "VP" ,add
    capture label define typopanel 3 "FL" ,add
    capture label value panel typopanel
    capture numlabel typopanel, add  



/*********   nouvelles variables 2004  *************/
/*****   Ces 3 variables remplacent mord*********/
if an==2004 {   /*c'est faux mais c'est juste*/
note an : annee 2004 TRANSITION pour certaines variables m�nages (selon p�riode de recrutement, utiliser une variable ou une autre) (Attention : typh, telp, net...))
note ordi : + de pr�cision concernant possession micro-ordi : avt oui/non, now combien de chaque type (mord est remplac� par ordi, mifi, mipo)
}
capture label variable ordi "Nb de micro-ordi"
capture label variable mifi "Nb de PC"
capture label variable mipo "Nb d'ordi. port."


capture label variable hoci "home cinema"
capture label variable cabl "abonnement reseau cable"
capture label variable absa "abonnement satellite"
capture label variable deco "decodeur canal+"
capture label variable ldvd "lecteur dvd"
capture label variable phnu "appareil photo num�rique"

/****  Eclatement de la variable typh  *****/
if an>=2004 {   /*c'est faux mais c'est juste*/
    note thab : �clatement de la variable type habitation (typh) (proprio/loca et maison/appart...) en 2 variables (thab et socc)
    note japr: eclatement variable jardin (jard) en 2 variables (japr, jase, jaai)
    note rsse: nouvelle variable rsse (r�sidence secondaire) qui remplace rs mais pas m�me moda.
    note en25: nouvelle variable Nb enfants de moins de 25 ans (en25)
}

capture label variable rsse "Residence secondaire (voir ancienne variable rs)"

capture label variable japr "Jardin en r�sidence principale"
capture label variable jase "Jardin en r�sidence secondaire"
capture label variable jaai "Jardin ailleurs (hors r�si prin et secon)"
capture label define typoj  1 "possesseur"  0 "non possesseur" 9 "non declar�"
capture label value japr typoj 
capture label value jase typoj 
capture label value jaai typoj 

capture label variable en25 "Nb enfants de moins de 25 ans"


capture label variable thab "Type d'habitation"
capture label define typothab  1 "maison indiv"  2 "appart" 3 "ferme"  9 "non declar�"
capture label value thab typothab 

capture label variable socc "Statut d'occupation du logement principal"     
capture label define typosocc 	1 "proprio. ou co-proprio" 2 " loca ou sous-loca" 3 "log� gratos" 9 "non d�clar�"
capture label value socc typosocc 

/*****   telp devient tlpo    *****/
if an==2004 {   /*c'est faux mais c'est juste*/
note tlpo: + de pr�cision concernant possession tel.port : avt oui/non (telp), now combien (tlpo)
}
capture label variable tlpo "nb d'individus du foyer possesseurs tel port."

/*****   Eclatement de net en indo/intr/emdo    *****/
if an>=2004 {   /*c'est faux mais c'est juste*/
note indo: + de pr�cision concernant Internet : net est �clat� en 3 variables indo, net2, emdo
}
capture label variable indo "Connexion Internet � domicile"
capture label variable net2 "Connexion Internet sur lieu de travail"
capture label variable emdo "adresse email domicile"

capture label define typoindo 0 "pas acces internet domicile" 1 "acces internet en ligne tel classique" 2 "acces internet avec ligne haut debit" 3 "acces avec mode connexion non renseign�" 9 "non d�clar�"
capture label define typonet2 0 "pas acces internet lieu travail" 1 "acces internet lieu travail"  9 "non d�clar�"
capture label define typoemdo 0 "non possesseur" 1 "possesseur" 9 "non d�clar�"
capture label value indo typoindo
capture label value net2 typonet2 
capture label value emdo typoemdo



capture label variable sech "Sous-�chantillons"
capture label define typosech 01 "WP p  FL" 02 "WP p VP" 81 "WP s FL" 88 "WP s VP"
			
/*****   telp devient tlpo    *****/
if an>=2004 {   /*commence courant 2004*/
     capture note etup :  Diplome pan�liste (dipp) devient Niveau �tudes (var etup) (mais moda changent)
    capture note etuc:  Diplome pers. ref. (dipc) devient Niveau �tudes (var etuc) (mais moda changent)

}
capture label define typoetup 0 "en etudes ou non declare" 0 "Pas encore scolaris�, maternelle" 1 "Etudes primaires"/*
*/ 2 "Enseignement second.(6e a 3e)"  3 "Technique court (CAP,BEP)" 4 "2e, niveau bac ou brevet pro" 5 "Technique sup (IUT,BTS)"/*
*/ 6 "Sup�rieur 1er cycle(DEUG,DEUST...)" 7 "Sup 2e cycle(Licence, Maitrise...)" 8 "Sup 3e cycle(DEA,DESS,Doctotat...)" 9 "Non d�clar�"
capture label value etup typoetup
capture label variable etup "Niveau �tudes pan�liste (remplace dipp 2004-2005)"

capture label variable etuc "Niveau �tudes de la pers. r�f.(remplace dipc 2004-2005)"
capture label value etuc typoetup

forvalues i=1/14 {
     capture label variable itlp`i' "Possession tel. port.indiv.`i'"
     capture label variable etud`i' "Niveau �tudes indiv.`i'"
     capture label value etud`i' typoetup       /*NEW 19/07/11*/
     
     capture label variable itra`i' "Act.professionnelle indiv.`i'"
}

capture label variable trap "Activit� professionnelle du pan�liste"
capture label define typotrap 0 "Sans activit� professionnelle"  1 "Temps complet" 2 "Temps partiel" 9 "Activit� niveau non d�clar�"
capture label value trap typotrap


capture label variable aiur "Aire urbaine"
capture label define typoaiur 0 "Espace � dominante rurale"  1 "P�le urbain" 2 "Commune Monopolaris�e/Couronne peri urbaine" 3 "Commune Multipolaris�e"
capture label value aiur typoaiur

if an>=2005 {   /*commence en sept 2005*/
    note cycle:  Nouvelle variable cycle de vie (cycle)
}
capture label variable cycle "Cycle de vie"


/*********   nouvelles variables 2009 *************/
capture label define typofare 0 "non"  1 "oui"  9 "Non d�clar�"
capture label value fare typofare


capture label variable cap1 "REFRIGERATEUR COMBINE AVEC CONGELATEUR de moins de 150L"
capture label variable cap2 "REFRIGERATEUR COMBINE AVEC CONGELATEUR de 150L et plus"
capture label variable cgl1 "CONGELATEUR INDEPENDANT de moins de 150L"
capture label variable cgl2 "CONGELATEUR INDEPENDANT de 150L et plus" 
capture label variable ipod "LECTEUR MP3, IPOD"
capture label variable rf1p	"REFRIGERATEUR INDEPENDANT"
capture label variable rf3e "REFRIGERATEUR COMBINE AVEC CONSERVATEUR "

capture label define typoposs 0 "non possesseur"  1 "possesseur" 9 "Non d�clar�"

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

capture label define typostat 0 "PAS DE BEBE" 3 "FILLE" 4 "GAR�ON" 
capture label stat typostat
