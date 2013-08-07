// Programme de labelisation  des variables SPECIFIQUES (fichiers  SECODIP NF 2011)
// cree le 30/07/2013
// Changement de version de PHP (?php au lieu de ? ) 31/05/2011"
// à partir du fichier LabelSPNFG.php  sur les fichiers 2008-2010
// avant on utilisait 2 fichiers (marques et sp) maintenant on utilise   "INRA_Questions.csv" (Cx) et  "INRA_Reponses.csv" (Vx)


<?php

$an=$argv[1];             //   Année en argument
$chem=$argv[2];


$fp1=fopen("../DonneesOriginales/".$chem."/Achats/INRA_Reponses.csv", "r");

$fout=fopen("../Data".$an."/Produits/LabelSPA".$an.".do", "w");  //chgt de lieu car maintenant non spécifique au produit

$entete="/* Programme créé par le prog. LabelSPNFG11.php à partir de \"INRA_Questions.csv\" */"."\n"."/* Christophe et Valerie le 30/07/2013 */ ";

fputs ($fout, $entete."\n");

$separ=";";



////////////////////////////////////////////////
// FICHIER DES REPONSES (Vx)
////////////////////////////////////////////////
fputs ($fout,"\n"."/********************************************************************************************/");
fputs ($fout,"\n"."/* Labellisation des modalités des variables spécifiques */");
fputs ($fout,"\n"."/* typosp unique (puisque les modalités de toutes les Vx sont mélangées et différentes) */");
fputs ($fout,"\n"."/********************************************************************************************/ \n");

while (!feof($fp1))
{
    $lu=rtrim(fgets($fp1,500));
    $t=explode($separ, $lu);
    $nmod=rtrim($t[0]);
    $labmod=rtrim($t[1]);

    if(is_numeric($nmod))   /*pour ne pas avoir la 1ère ligne du fichier qui correspond aux noms des colonnes*/
    {
        // Labellisation des modalités  pour chacune des variables spécifiques
        $aecrire="capture label define typosp"." ".$nmod." \"".$labmod." \" , modify \n";

        fputs ($fout, $aecrire);
    }
}   // fin de la lecture du fichier

fclose($fp1);


////////////////////////////////////////////////
// FICHIER DES QUESTIONS (Cx)
////////////////////////////////////////////////
$fp2=fopen("../DonneesOriginales/".$chem."/Achats/INRA_Questions.csv", "r");

$milieu="/* Affectation des labels des variables spécifiques */ ";
fputs ($fout,"\n"."/********************************************************************************************/\n");
fputs ($fout, $milieu);
fputs ($fout,"\n"."/********************************************************************************************/ \n");

while (!feof($fp2))
{
    $lu=rtrim(fgets($fp2,500));
    $t=explode($separ, $lu);
    $nspe=rtrim($t[0]);
    $labspe=rtrim($t[1]);
    $idtype=rtrim($t[2]); //a priori pas de labellisation si idtype==1 (par ex. poids unitaire=1000, ne pas aller chercher son label!)

    if(is_numeric($nspe))   /*pour ne pas avoir la 1ère ligne du fichier qui correspond aux noms des colonnes*/
    {
    
        if($idtype==0)
        {
            $aecrire="capture label value sp".$nspe." typosp \n";
            fputs ($fout, $aecrire);
        }
        
        //Affectation des labels aux variables
        $aecrire="capture label variable sp".$nspe." \"".$labspe." \"  \n";
        fputs ($fout, $aecrire);
        

    }

}   // fin de la lecture du fichier

fclose($fp2);


fclose($fout);


?>

// Commande de lancement
// ! c:\wamp\bin\php\php5.3.8\php.exe  -q LabelSPNFG11.php  2011  brutesNF11/Donnees2011
