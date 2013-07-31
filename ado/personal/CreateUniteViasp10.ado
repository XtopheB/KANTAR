/**********************************************************************************************************/
/*************************************  PROCEDURE CreateUniteViasp10  *************************************/
/**********************************************************************************************************/

/* 19/08/2011 : Création d'une variable unité Unite_via_sp10  qui renseigne sur l'unité du produit        */
set output error

program define CreateUniteViasp10
version 11.1


local NumVersion "1.0"

capture confirm new variable sp10
if _rc!=0 {                          /* la variable sp10 existe ds le fichier*/
    decode sp10, gen(Unite_via_sp10)
    *capture drop sp10
    forv l = 0/9 {
       quietly replace  Unite_via_sp10 = subinstr(Unite_via_sp10, "`l'", "", .)
    }
    quietly replace Unite_via_sp10 = subinstr(Unite_via_sp10, ".", "", .)
    quietly replace Unite_via_sp10 = subinstr(Unite_via_sp10, ",", "", .)
    quietly replace Unite_via_sp10=ltrim(Unite_via_sp10)
    quietly replace Unite_via_sp10=rtrim(Unite_via_sp10)
    quietly replace Unite_via_sp10=upper(Unite_via_sp10)
    quietly replace Unite_via_sp10 = subinstr(Unite_via_sp10, "GR", "G", .)
    quietly replace Unite_via_sp10 ="sp10 manquante" if  Unite_via_sp10==""      /*ex. du produit 158 qui pr la période 2005 a la variable sp10 mais 
    manquante!*/
}
else {
    gen Unite_via_sp10 = "sp10 absente"
}
format Unite_via_sp10 %9s


note : Version `NumVersion' de CreateUniteViasp10.ado
di in yellow " Fin de CreateUniteViasp10.ado : variable Unite_via_sp10 créée avec succès "

end
