// Programme de création des fichiers  de labelisation de CVWP, CTWPENWP et sa3 ou sa2  GENERIQUE
// cree le 30/07/2013 à partir de LabelComNFG.php


<?php
$var=$argv[1];
$an=$argv[2];
$chem=$argv[3];
$fichier=$argv[4];
$fp=fopen("../DonneesOriginales/".$chem."/Achats/".$fichier.".csv", "r");
$fout=fopen("../Data".$an."/Produits/Label".$var.$an.".do", "w");

$entete="/* Programme créé par le prog LabelComNFG11.php à partir des fichiers $fichier.csv  (Christophe et Valerie le 30/07/2013) */ ";
fputs ($fout, $entete."\n");
fputs ($fout,"\n"." /* Labellisation des modalités */ \n");

$separ=";";
while (!feof($fp))
{
    $lu=rtrim(fgets($fp,500));
    $t=explode($separ, $lu);
    $mod=rtrim($t[0]);
    $lab=rtrim($t[1]);

    // Création des labels (on ne prend pas en compte les lignes non pertinentes)
 if(is_numeric($mod))   /*pour ne pas avoir la 1ère ligne du fichier qui correspond aux noms des colonnes*/
 {
            $aecrire="capture label define typo".$var."  ".$mod." \"".$lab." \" , modify \n";
            fputs ($fout, $aecrire);

   }
}   // fin de la lecture du fichier
$aecrire="label value ".$var." typo".$var."\n";
fputs ($fout,$aecrire);
fclose($fp);
fclose($fout);

?>

// Exemple de commande de lancement


// c:\wamp\bin\php\php5.3.8\php.exe  -q LabelComNFG11.php cvwp          2011  brutesNF11/Donnees2011  INRA_Extract_Circuits
// c:\wamp\bin\php\php5.3.8\php.exe  -q LabelComNFG11.php ctwpenwp      2011  brutesNF11/Donnees2011  INRA_Extract_Shops
// c:\wamp\bin\php\php5.3.8\php.exe  -q LabelComNFG11.php sa2           2011  brutesNF11/Donnees2011  INRA_Marques_Detail_Avec_Bl_Distrib
