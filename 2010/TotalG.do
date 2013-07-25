/* Progamme de création des données Kantar   */
/* Version 1.0 : 01/08/2012                  */

cd "d:\Secodip\ProgsG"
capture do DataImportG.do

cd "d:\Secodip\ProgsG"
*capture do MenageMakerG.do

cd "d:\Secodip\ProgsG"
do DataMakerG.do

cd "d:\Secodip\ProgsG\"
capture do VerifEpureG.do

cd "d:\Secodip\ProgsG\"
capture do ComptePanelMenage.do     /*pr faire nos supers tableaux de comptages des ménages selon année, panel, cumul...*/
