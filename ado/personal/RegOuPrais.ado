*! version beta 24janv2005
/*tests d'égalité des betas intégrés ici (comme ça on ne les fait que pr reg ou prais selon le cas)*/
/*rajout condition si e(N)>20*/

/*10/01/05 : modifiée par Valérie*/

program define RegOuPrais, eclass
version 8.0, missing
syntax [varlist]  [,num(string)]  

di in red "debut des reg"
capture quietly regress lnpuBR4   trim1  trim2  trim3
est2vec regpraisBR4 , vars (lnPdmVolBR1   lnPdmVolBR2  lnPdmVolBR3 PartSeg`ss'BR4 lnPdmVolBR6 lnPdmVolBR7 lnPdmVolBR8 lnPdmVolBR9  trim1  trim2  trim3 _cons) e(r2 r2_a F)
    

di in red "`num'"
capture regress `varlist'   /*car si pas de capture et bug, ça plante*/

if e(N)!=. & e(N)>=20 {     /*  <------   Test si PB dans la regression  */
    di in green "obs ok"
    quietly dwstat
    scalar define dw=`r(dw)'    /*on stocke la stat de durbin watson*/
    quietly estimates table, stats(aic, bic)
    est store regprais`num'      /*rajout `num' (V)*/
    quietly bgodfrey                /*rajout V*/
    matrix tabAuto`num'=r(p)\r(chi2)  /* INiTIALISATION  */
    matrix tabAuto`num'=tabAuto`num'\dw
    matrix define B=r(p)    /*rajout V : p-value du test de Breush-godfrey*/
    local bg = B[1,1]       /*rajout V : on met la p-value ds 1 scalaire*/
   
    if `bg' <=0.05 {      /*cas de rejet de H0 (H0 c'est indép des résidus)*//*rajout moi...DW trop chiant à gérer*/
        di in green "cas de rejet de H0 (H0 c'est indép des résidus), on fait cochrane orcutt"
        scalar define cochrane=1
        prais `varlist' , corc ssesearch                       
        est store regprais`num'                        /*rajout V*/
        est2vec regpraisBR4, addto(regpraisBR4) name(prais`num') nokeep     /*rajout V*/ /*c'est une prais*/
    } 

    else {   /*cas de NON rejet de H0  */
        regress `varlist'  /*A VIRER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
        di in green "cas de non rejet de H0 (H0 c'est indép des résidus)"
        est store regprais`num' 
        est2vec regpraisBR4 , addto(regpraisBR4) name(reg`num')  nokeep  /*c'est une reg*/
        scalar define cochrane=0
    }
      matrix tabAuto`num'=tabAuto`num'\cochrane     
      
    /*cas où on teste l'égalité des betas*/
   if `num'==1 | `num'==2  | `num'==5  | `num'==6 {    /*cas où les var expli sont pdm HD, MDD, PP (avec index ou non)*/
        di in red "tests ega betas"                                             /*cas où on teste l'égalité des betas*/
        quietly test lnPdmVolBR1 =lnPdmVolBR2
        matrix def tabTest`num'=r(p) 
        capture quietly test lnPdmVolBR1 =lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        capture quietly test lnPdmVolBR2 =lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        capture quietly test lnPdmVolBR1=lnPdmVolBR2=lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        matrix tabTest`num'=tabTest`num'\cochrane  /*pr indiquer si tests basés sur reg ou prais*/
    }

}
else {   /* <---------------Si PB, alors regression basique, et remplissage   */
    quietly regress lnpuBR4   trim1  trim2  trim3
    dwstat
    scalar define dw=`r(dw)'    /*on stocke la stat de durbin watson*/
    est store regprais`num'
    bgodfrey
    matrix tabAuto`num'=r(p)\r(chi2)  /* INiTIALISATION  */
    matrix tabAuto`num'=tabAuto`num'\r(dw)
    est2vec regpraisBR4 , addto(regpraisBR4) name(reg`num')  nokeep
    scalar define cochrane=.
    matrix tabAuto`num'=tabAuto`num'\cochrane
    if `num'==1 | `num'==2  | `num'==5  | `num'==6 { 
        matrix def tabTest`num'= .\.\.\.\.
    }
}
end
exit 