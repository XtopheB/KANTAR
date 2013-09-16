
// Programme de création des fichiers  de labelisation de CAW, CVWP  GENERIQUE
// cree le 11/06/2009 à partir de LabelComNF789.php


<?php
$var=$argv[1];
$an=$argv[2];
$chem=$argv[3];
$fp=fopen("../DonneesOriginales/".$chem."/Achats/".$var.$an.".csv", "r");
$fout=fopen("../Data".$an."/Produits/Label".$var.$an.".do", "w");


$entete="/* Programme créé par le prog LabelComNF789.php à partir des fichiers $var$an.csv  (Christophe et Valerie le 31/08/2011) */ ";
fputs ($fout, $entete."\n");
fputs ($fout,"\n"." /* Labellisation des modalités */ \n");

$separ=";";
while (!feof($fp))
{

    $lu=rtrim(fgets($fp,500));
    $t=explode($separ, $lu);
    $mod=rtrim($t[0]);
    $lab=rtrim($t[1]);

    // Création des labels (on ne prends pas en compte les lignes non pertinentes)
 if(is_numeric($mod))
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
//c:\wamp\php\php.exe -q LabelComNF789.php cawp 2006

