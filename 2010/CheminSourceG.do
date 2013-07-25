/******************************************************************************************************/
/*1/09/11 Programme listant les chemins des donn�es sources*/
/*        Il permet d'avoir des programmes g�n�riques (DataMakerG.do...)*/
/*        Suppose que les donn�es brutes sont dans le dossier "DonneesOriginales"*/
/*         A compl�ter pour les ann�es ant�rieures � 2007 et ensuite apr�s 2009*/
/*         PetitNomAAAA est le dossier de stockage des donn�es brutes (678, 789...)*/
/******************************************************************************************************/

/*to be completed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/* 01/08/2012 :  compl�t� 2010  */


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
