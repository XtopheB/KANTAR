/*--------------------------- PROGRAMME FusionMarques3456 --------------------------*/
/* 18/12/08 Créé à partir de FusionMarques345.ado                                   */
/*          Adapté aux données 2003-2006 et appelé dans DataMaker56.do  */
/*          Regroupement des marques existant sous deux N° differents              */
/*---------------------------------------------------------------------------------*/


program define FusionMarques3456
version 10.1
set output error
set more off

/* Fusion observées sur produit 0063 BRSA  */
                                                /* en commentaire le label de la marque restante  */
replace sa2=52 if sa2==12536                    /* 12536. AUTRES MQ LEADER PR  */




/*... to be continued*/










end
