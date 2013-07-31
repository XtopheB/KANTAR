/* ------------- PROGRAMME DefWachat------------      
/*16/12/04 modif initialisation Wachat � 0*/                 */
/* Cr�� le 5/11/04 par Val�rie (anciennement DefWachat, ms ici aussi pr 2001)  */
/*   g�n�re la variable Wachat= poids de l'achat par pan�liste pour la p�riode */
/*   pour chacun des 52 mois(4*13)                                           */
/*proc�dure DefWachatNewNF cr��e � partir de DefWachatNew pour les nouvelles donn�es 2002 et 2003 (8/08/06 val�rie)*/
/*19/07/07 �a marche aussi sur 2004 (val�rie)*/
/*30//07/07 g�re selon l'ann�e (en regardant le min et max de Mois4)*/
/*18/07/07 : cr�ation variable WFrance qui est juste nb de m�nages repr�sent�s (Wachat * nb m�nages / somme pond)*/
/*26/09/07 : annee remplac�e par an car sinon, pb 2003 2003              */
/* 29/09/2008 : La variable an n'est plus utilis�e (cf datamaker) C& V    */
/*18/12/08 : an remplac�e par annee         */
/* 11/06/2009 : Initialisation de Wachat et WFrance � . et non � 0   */
/*25/09/09 num�ro de version en locale + notes des variables Wachat et WFrance*/
/*1/09/11 DefWachatG.ado : plus besoin de pr�ciser le panel puisque dans DataMakerG.do
          seules les variables pond du panbel du produit en cours sont conserv�es*/
/*28/10/11 boulette corrig�e :  k*per`i' n'est pas compris, il faut �crire  k`p'per`i' et rajouter le levels panel pour connaitre p*/
/* ----------------------------------------------------------------- */


pause on   /* pour permettre les pauses */


program define DefWachatG
version 11.0

local numversion "3.0"

capture confirm new variable   ctwpenwp        /*n'importe, juste pour tester si on est bien sur nos nouveaux fichiers 2002 2003*/ 
if _rc==0 {    /* la variable ctwpenwp n'est pas dans le fichier--> fichier ancienne formule*/ 
    di in red "Proc�dure DefWachatNF n' est pas appropri�e pour ce fichier ancienne formule."
    di in red "Utiliser DefWachatNew.ado."
}
else {
    capture confirm new variable Wachat 
    if _rc==0 {    /* la variable Wachat n'existe pas d�j� */
    
        gen Wachat=.   /* Pour �viter des poids nuls...  */
        gen WFrance=. 
        
        qui levels annee
        local AnneeEnCours "`r(levels)'"        
        /*28/10/11 rajout� ici (V)*/
        quietly levels panel
        if `r(levels)'==1 {
            local p "gc"
        }
        if `r(levels)'==2 {
            local p "vp"
        }
        if `r(levels)'==3 {
            local p "fl"
        }
        /*1/09/11 A partir de 2009 seulement 2 panels!!! (GC, et PF)*/

        if `AnneeEnCours' >=2009 {
            if `r(levels)'==2 | `r(levels)'==3 {
                local p "pf"
            }
        }
        
        quietly sum Mois4        /*NEW 30/07/07*/
        forvalues i= `r(min)'/`r(max)' {         /*78/91 */   /*pour 2002 et 2003 (que jusqu'� 78) et 2004 (de 79 � 91)*/
            capture quietly replace Wachat=k`p'per`i'  if Mois4==`i'  &  k`p'per`i'!=.   /*pr �viter que Wachat soit � missing*/    /*k*per`i' incompris!!!! (V) 28/10/11*/
            capture quietly replace WFrance = k`p'per`i'/${SumPondper`i'} if Mois4==`i'
        }
        
        /*28/10/11 http://www.insee.fr/fr/themes/tableau.asp?reg_id=0&ref_id=AMFd2*/
        /*1990:21 952 292 ; 1999:24 344 951 (23 776 ); 2008:24 344 951 */
        
        quietly replace WFrance = WFrance * 23810161 if annee<2004      /*bas� sur enqu�te insee 1999*/ 
        quietly replace WFrance = WFrance * 25732000 if annee>=2004     /*enqu�te 2004*/
                                                                                /*... to be completed plus tard*/
        label variable Wachat "Pond�ration p�riode (mensuelle) de l'achat"
        label variable WFrance "Nb de m�nages France repr�sent�s p�riode (mensuelle) de l'achat"

        di in yellow " Variable Wachat et WFrance creees " 
        note Wachat : Wachat cr�� avec la version `numversion' de DefWachatNF.do
        note WFrance : WFrance cr�� avec la version `numversion' de DefWachatNF.do
    }
    else { 
        display in red "Aucune operation effectuee: Wachat existe deja "
    }
}

end
