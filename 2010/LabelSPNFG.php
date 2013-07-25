// Programme de labelisation  des variables SPECIFIQUES (fichiers  SECODIP NF 2005-2006-2007-2008-2009)
// cree le 11/06/2009
// à partir du fichier labelSPNF56.php  sur les fichiers 2005-2006
// Adaptée aux Fichiers nouvel envoi2005 et 2006 et 2007
// Adapté aux fichiers nouvel envoi 2007n2, 2008n et 2009 (30/08/2011)
// Adapté au fichiers 2010 (01/08/2012 )

// PRÉALABLE : ON A TRANSFORME LES FICHIERS .TXT en .CSV (via STATA)
// Utilise les fichiers  "Att_Desc_5aN.csv" et "Att_Type par VF.csv"
// Changement de version de PHP (?php au lieu de ? ) 31/05/2011"

<?php
$numprod=$argv[1];
$an=$argv[2];             //   Année en argument
$chem=$argv[3];
$numcsv=$numprod%1000;   // Numéro raccourci

$fp=fopen("../DonneesOriginales/".$chem."/Achats/Att_Desc_5aN.csv", "r");
$fout=fopen("../Data".$an."/Produits/$numprod/LabelSP".$numprod."A".$an.".do", "w");



$entete="/* Programme créé par le prog. LabelSPNFG.php à partir de \"Att_Desc_5aN.csv\" et \"Att_Type par VF.csv\"  */"."\n"."/* Christophe et Valerie le 01/08/2012 */ ";

fputs ($fout, $entete."\n");
fputs ($fout,"\n"."/* Labellisation des modalités */ \n");


$separ=";";
while (!feof($fp))
{
    $lu=rtrim(fgets($fp,500));
    $t=explode($separ, $lu);
    $nprod=rtrim($t[0]);
    $labprod=rtrim($t[1]);
    $nspe=rtrim($t[2]);
    $labspe=rtrim($t[3]);
    $nmod=rtrim($t[4]);
    $labmod=rtrim($t[5]);

    // Labellisation des modalités  pour chacune des variables spécifiques
     if($numcsv==$nprod)
     {
            if($nspe ==5)
            {
            // Définition des modalités de sa2
            $aecrire="capture label define typosa2"." ".$nmod." \"".$labmod." \" , modify \n";
            fputs ($fout, $aecrire);
            }
            if($nspe <>5)
            {
            // Définition des modalités des autres variables
            $aecrire="capture label define typosp".$nspe." ".$nmod." \"".$labmod." \" , modify \n";
            fputs ($fout, $aecrire);
            }


     } // fin du if numprod ...
}   // fin de la lecture du fichier

fclose($fp);

$milieu="\n/* Affectation des labels pour les  variables spécifiques */\n ";
fputs ($fout, $milieu."\n");

$fp2=fopen("../DonneesOriginales/".$chem."/Achats/Att_Type_par_VF.csv", "r");


while (!feof($fp2))
{
    $lulu=rtrim(fgets($fp2,500));
    $tt=explode($separ, $lulu);
    $nprod=rtrim($tt[0]);
    $labprod=rtrim($tt[1]);
    $nspe=rtrim($tt[2]);
    $labspe=rtrim($tt[3]);

    // Labelisation de la variable
     if($numcsv==$nprod)
     {
            if($nspe ==5)  //Affectation des labels pour  sa2
            {

            $aecrire="capture label variable sa2"." \"".$labspe." \"  \n";
            fputs ($fout, $aecrire);
            $aecrire="capture label value sa2 typosa2 \n";
            fputs ($fout, $aecrire);
            }
            if($nspe <>5) // Affectation des labels pour les  variables spécifiques
            {
            $aecrire="capture label variable sp".$nspe." \"".$labspe." \"  \n";
            fputs ($fout, $aecrire);
            $aecrire="capture label value sp".$nspe." typosp".$nspe."\n";
            fputs ($fout, $aecrire);
            }
     } // fin du if numprod ...
}   // fin de la lecture du fichier



fclose($fout);


?>

// Commande de lancement
// c:\wamp\php\php.exe -q LabelSP789.php 0172 2006
