/*--------------------------- PROGRAMME FusionMarques345 --------------------------*/
/* 22/04/08 Créé à partir de FusionMarques.ado                                     */
/*          Adapté aux nouvelles données 2003-2005 et appelé dans DataMaker345.do  */
/*          Regroupement des marques existant sous deux N° differents              */
/*---------------------------------------------------------------------------------*/


program define FusionMarques345
version 10.0
set output error
set more off

/* Fusion observées sur produit 0063 BRSA  */
                                                /* en commentaire le label de la marque restante  */
replace sa2=52 if sa2==12536                    /* 12536. AUTRES MQ LEADER PR  */




/*... to be continued*/










end
