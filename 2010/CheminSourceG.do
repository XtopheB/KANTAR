/******************************************************************************************************/
/*1/09/11 Programme listant les chemins des données sources*/
/*        Il permet d'avoir des programmes génériques (DataMakerG.do...)*/
/*        Suppose que les données brutes sont dans le dossier "DonneesOriginales"*/
/*         A compléter pour les années antérieures à 2007 et ensuite après 2009*/
/*         PetitNomAAAA est le dossier de stockage des données brutes (678, 789...)*/
/******************************************************************************************************/

/*to be completed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/* 01/08/2012 :  complété 2010  */


/********************************/
/****  2006  *****/
/********************************/
global PetitNom2006 "678"
global CheminBrutes2006 "brutesNF678/Donnees2006"

/********************************/
/****  2007n2, 2008n, 2009  *****/
/********************************/
forv i=2007/2009 {
    global PetitNom`i' "789"
    global CheminBrutes`i' "brutesNF${PetitNom`i'}/Donnees`i'"
}

/********************************/
/****  2010  *****/
/********************************/
global PetitNom2010 "10"
global CheminBrutes2010 "brutesNF10/Donnees2010"
