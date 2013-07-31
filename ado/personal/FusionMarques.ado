/*20/09/05*/
/*16/02/05*/
/* 7/11/04 version mise à jour avec emmental (118 et 5188) et petits suisses (Valérie)*/

*prog créé à partir camembert 0085, yaourt 172, beurre 0032, fromage blanc 0093, lait 0103, 
*fondus 0091,EMMENTAL 118+5188 ,  petits suisses 0092, 0074 DESSERTS FRAIS, 0072 CREME FRAICHE, 0083 FROMAGE DE CHEVRE ( AVEC EAN ), 
*0010 EAUX NATURE , 0272 PATES,  0188 BISCUITS A GRIGNOTER POUR L'APERITIF 
*0100  JAMBON BLANC PREEMBALLE ( AVEC EAN ) , 0211 CHOCOLAT EN TABLETTE  ,  0014 JUS DE FRUITS ET DE LEGUMES AVEC EAN 
*0197 BONBONS CONDITIONNES (AVEC EAN)  

/* ------------- PROGRAMME FusionMarques ------------------------       */
/* Créé le 29/01/2004 par christophe                             */
/* Regroupement des marques existant sous deux N° differents */
/* ---------------------------------------------------------- */


program define FusionMarques
version 9.2
set output error
set more off

/* Fusion observées sur produit 0172 YAOURT  */
                                    /* en commentaire le label de la marque restante  */
replace sa2=15195 if sa2==10998    /*  Melivie ! antartic D*/
replace sa2=28260 if sa2==2123     /* Cora ! cora D */
replace sa2=25200 if sa2==11070    /* Milbona ! etranger non identifie*/
replace sa2=23719 if sa2==12651   /* sans marque lactel  */
replace sa2=14254 if sa2==23722    /* sans marque senoble  */
replace sa2=12593 if sa2==24500    /* sans marque soranor  */
replace sa2=22475 if sa2==24316    /* match ! match nord D  */


/* Fusion observées sur produit 0032 BEURRE  */
                                    /* en commentaire le label de la marque restante  */
replace sa2=13840 if sa2==13300    /* 13840. SAINT PERE ! INTERMARCHE D    */
replace sa2=30462 if sa2==15814    /*  30462. PATURAGES ! INTERMARCHE D    */ 
replace sa2=3008 if sa2==16641    /*    3008. ELLE & VIRE  */
replace sa2=36596 if sa2==9869    /*    36596. CHAMPION ! PROMODES PRODIM D  | */
replace sa2=11594 if sa2==3803    /*   Gault et Millau */
replace sa2=13201 if sa2==12549    /*   13201. SANS MARQUE DEVIENNE   */


/* Fusion observées sur produit 0091 FROMAGES FONDUS  */
                                    /* en commentaire le label de la marque restante  */
replace sa2=11263 if sa2==9025    /* 11263. La vache qui rit   */


/* Fusion observées sur produit 118+5188 EMMENTAL (AVEC ET SANS EAN REGROUPES)  */
                                    /* en commentaire le label de la marque restante  */
replace sa2=15525 if sa2==27850    /* 15525. SANS MARQUE DAVRAIN    */
replace sa2=21607 if sa2==12587    /* 21607. SANS MARQUE ENTREMONT  */ 
replace sa2=30462 if sa2==15814    /* 30462. PATURAGES ! INTERMARCHE D */
replace sa2=5384  if sa2==5242      /* 5384. LYS D'OR  */
replace sa2=22108 if sa2==12535    /* 22108. SANS MARQUE SCHNEITER FROMAGERIE   */
replace sa2=10936 if sa2==34422    /* 10936. SANS MARQUE SCHOEPFER    */
replace sa2=18497 if sa2==32562    /*18497.SANS MARQUE PRESIDENT */
replace sa2=11247 if sa2==20418    /* 11247. LE FROMAGER*/


/* Fusion observées sur produit 0092 petits suisses avec ean  */
                                    /* en commentaire le label de la marque restante  */
replace sa2=14253 if sa2==12758   /*14253. SANS MARQUE NOVA*/
replace sa2=14007 if sa2==23793    /*14007. SANS MARQUE SOPAD NESTLE*/ 
 
 
/* Fusion observées sur produit 0074 DESSERTS FRAIS  */
                                    /* en commentaire le label de la marque restante  */                               
replace sa2=29363 if sa2==12652     /*29363. DELIMETS*/
replace sa2=11256 if sa2==22763    /*11256. MONOPRIX GOURMET D*/


/* Fusion observées sur produit 0072 CREME FRAICHE  */
                                    /* en commentaire le label de la marque restante  */                               
replace sa2=5048 if sa2== 21305     /*5048.  LAITERIE DU FOREZ*/
replace sa2= 11192 if sa2 ==32810   /* 11192. MILSANI D */



/* Fusion observées sur produit 0083 FROMAGE DE CHEVRE ( AVEC EAN )   */
                                    /* en commentaire le label de la marque restante  */                               
replace sa2=11132 if sa2==  3100     /*11132. ETOILE DU VERCORS*/
replace sa2=23274  if sa2 == 3658   /*  23274. FROMAGERIE DE LA DROME   */
replace sa2=11031 if sa2 == 11050   /* 11031. SAINT USTRE */
replace sa2=27768 if sa2 ==29934    /*27768. DELTA FRAIS */
replace sa2=32558 if sa2 == 11124   /*32558. MARQUE INCONNUE ! SCOFF  */
replace sa2= 33687 if sa2 == 25706   /*33687. MARQUE INCONNUE ! CHENE VERT*/

/* Fusion observées sur produit 0010 EAUX NATURE   */
replace sa2=9393  if sa2==9394              /*9393 . VITTELLOISE*/ 
replace sa2=11245 if sa2==15184             /*11245. SANS MARQUE LECLERC D  */
replace sa2=32262 if sa2==12788            /*32262. SAINT AMAND ! ST AMAND THERMAL*/ 
replace sa2=15470 if sa2==2091      /*15470. CONTREX ! GENERALE GRANDES SOURC*/ 
replace sa2=9389 if sa2==9391       /* 9389. VITTEL */
     



/* Fusion observées sur produit 0272 PATES   */
replace sa2=13786 if sa2== 29178            /*13786. BELLE FRANCE ! FRANCAP D*/
replace sa2=11256 if sa2== 22763            /*11256. MONOPRIX GOURMET D*/
replace sa2=11594 if sa2== 3803             /*11594. GAULT ET MILLAU D*/
replace sa2=23830 if sa2== 23969            /*23830. ALPINA ! RICHARD C et CIE*/

/* Fusion observées sur produit 0188 BISCUITS A GRIGNOTER POUR L'APERIT  */
replace sa2=5739 if sa2== 121                          /*5739. MENES ALBERT*/
replace sa2=28578 if sa2== 29147                       /*28578. FUNY LAPIN VERT */
replace sa2=8938   if sa2==  32211 | sa2== 36988        /* 8938. TRUTSY D */
replace sa2=16661  if sa2== 10921                      /* 16661. MARQUE INCONNUE ! PARIS STORE SA*/

/* Fusion observées sur produit 0211 CHOCOLAT EN TABLETTE   */
replace sa2=3803  if sa2== 11594             /*3803. GAULT MILLAU D*/
replace sa2= 36998 if sa2==8587                 /*36998. TABLETTE OR ! LECLERC*/

/* Fusion observées sur produit 0100  JAMBON BLANC PREEMBALLE ( AVEC EAN )   */
replace sa2= 5663 if sa2==21662         /*5663. MATTHEWS BERNARD */
replace sa2=3801 if sa2==25535         /*3801. GAULOIS LE*/
replace sa2=36539 if sa2==14194 | sa2==8585         /* 36539. LA TABLE DU ROY ! PROMODES LOGID   */
replace sa2=35094   if sa2== 37180                      /*35094. MONTORSI*/
replace sa2=20487 if sa2==7347       /* 20487. RANOU MONIQUE ! INTERMARCHE D */

/* Fusion observées sur produit 0014 JUS DE FRUITS ET DE LEGUMES AVEC EAN   */
replace sa2=29178 if sa2==13786      /* 29178. BELLE FRANCE D  */
replace sa2=4590 if sa2==25996       /* 4590. JAFFA GOLD */
replace sa2=13580 if sa2==4593 | sa2==22079 | sa2==41052    /* 13580. JAFADEN D*/
replace sa2=20818 if sa2==33337       /* 20818. FRESH'FRUIT   */

/* Fusion observées sur produit 0197 BONBONS CONDITIONNES (AVEC EAN)    */
replace sa2=44055 if sa2== 4574    /*44055. JACK BENOIT*/
replace sa2=983 if sa2==26526      /*983. BONTE */
replace sa2=21795 if sa2==2068     /* 21795. LE TECH  */
replace sa2=39271 if sa2==2926   /*39271. DUPONT D'ISIGNY ! DUPONT D'ISIGN  */
end
