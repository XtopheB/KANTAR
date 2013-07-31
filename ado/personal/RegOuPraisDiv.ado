/*RegOuPraisDiv.ado 29/03/05 pour les reg temporelles*/



program define RegOuPraisDiv, eclass
version 8.0, missing
syntax [varlist]  [,num(string) name(string)]  

di in red "`num'"
capture regress `varlist'   /*car si pas de capture et bug, ça plante*/

if e(N)!=. & e(N)>=20 {     /*  <------   Test si PB dans la regression  */
    
    quietly dwstat
    scalar define dw=`r(dw)'    /*on stocke la stat de durbin watson*/
    quietly estimates table, stats(aic, bic)
    est store regpraisdiv`num'     
    quietly bgodfrey                
    matrix tabAuto`name'`num'=r(p)\r(chi2)  /* INiTIALISATION  */
    matrix tabAuto`name'`num'=tabAuto`name'`num'\dw
    matrix define B=r(p)    /*rajout V : p-value du test de Breush-godfrey*/
    local bg = B[1,1]       /*rajout V : on met la p-value ds 1 scalaire*/
   
    if `bg' <=0.05 {      /*cas de rejet de H0 (H0 c'est indép des résidus)*//*rajout moi...DW trop chiant à gérer*/
        di in green "cas de rejet de H0 (H0 c'est indép des résidus), on fait cochrane orcutt"
        scalar define cochrane=1
        prais `varlist' , corc ssesearch                       
        est store regpraisdiv`num'                        /*rajout V*/
        est2vec regpraisdiv`name', addto(regpraisdiv`name') name(prais`num') nokeep     /*rajout V*/ /*c'est une prais*/
    } 

    else {   /*cas de NON rejet de H0  */
        regress `varlist'  /*A VIRER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
        di in green "cas de non rejet de H0 (H0 c'est indép des résidus)"
        est store regpraisdiv`num' 
        est2vec regpraisdiv`name' , addto(regpraisdiv`name') name(reg`num')  nokeep  /*c'est une reg*/
        scalar define cochrane=0
    }
      matrix tabAuto`name'`num'=tabAuto`name'`num'\cochrane     
      
    

}
else {   /* <---------------Si PB, alors regression basique, et remplissage   */
    quietly regress puBR4   trim1  trim2  trim3
    dwstat
    scalar define dw=`r(dw)'    /*on stocke la stat de durbin watson*/
    est store regpraisdiv`num'
    bgodfrey
    matrix tabAuto`num'=r(p)\r(chi2)  /* INiTIALISATION  */
    matrix tabAuto`num'=tabAuto`num'\r(dw)
    est2vec regpraisdiv`name' , addto(regpraisdiv`name') name(reg`num')  nokeep
    scalar define cochrane=.
    matrix tabAuto`name'`num'=tabAuto`name'`num'\cochrane
   
}
end
exit 