// programme de labelisation automatique des fichiers SECODIP 2005 nouvel envoi et 2006 et 2007
// cree le 11/06/2009
// à partir du fichier labelSa3Sa4NF56.php  sur les fichiers 2005-2006


<?php
$numprod=$argv[1];
$an=$argv[2];
$chem=$argv[3];
$numcsv=$numprod%1000;


$fp=fopen("../DonneesOriginales/".$chem."/Achats/sa3sa4".$an.".csv", "r");
$fout=fopen("../Data".$an."/Produits/$numprod/labelSA3SA4".$numprod."A".$an.".do", "w");


$entete="/* Programme de labelisation du produit $numprod (ou $numcsv au format csv) pour l'année $an */";
fputs ($fout, $entete."\n");
$entete="/* Programme créé par le prog labelSa3Sa4NF345.php à partir de sa3sa3$an.csv  */ ";
fputs ($fout, $entete."\n");
$entete="/* (Christophe et Valerie le 7/01/2008)*/\n ";
fputs ($fout, $entete."\n");

$separ=";";

while (!feof($fp))
{
    $lu=rtrim(fgets($fp,500));
    $t=explode($separ, $lu);
    $prod=rtrim($t[0]);
    $labprod=rtrim($t[1]);
    $SA=rtrim($t[2]);
    $ss=substr($SA, -1, 1);
    $sa=strtolower($SA);
    $lab=rtrim($t[3]);
    $mod=rtrim($t[4]);
    $labmod=rtrim($t[5]);


 if($prod==$numcsv)
    {
    $aecrire="capture label define typosa".$ss." ".$mod." \"".$labmod." \", modify ";
    fputs ($fout, $aecrire."\n");
    }

}  // fin de la lecture du fichier sa3sa42005.csv



   $aecrire="\n"."/*ATTENTION : On INVERSE les  MODALITES DE SA3 et SA4  ( CB le 8/08/07)*/ ";
    fputs ($fout, $aecrire."\n");
    $aecrire="\n"."capture label value sa3 typosa4 ";
    fputs ($fout, $aecrire."\n");
    $aecrire="capture label value sa4 typosa3 ";
    fputs ($fout, $aecrire."\n");
    $aecrire="capture numlabel typosa3, add";
    fputs ($fout, $aecrire."\n");
    $aecrire="capture numlabel typosa4, add ";
    fputs ($fout, $aecrire."\n");
    $aecrire="capture label variable sa1 \"Code produit \"" ;
    fputs ($fout, "\n".$aecrire."\n");
    $aecrire="capture label variable sa4 \" MANUFACTURER !\"  ";
    fputs ($fout, $aecrire."\n");
    $aecrire="capture label variable sa3 \" RANGE ! \"  ";
    fputs ($fout, $aecrire."\n");

fclose($fp);
fclose($fout);

?>

// Commande de lancement (exemple)
// c:\wamp\php\php.exe -q LabelSa3Sa4NF678.php 0001 2006
