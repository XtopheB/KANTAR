/*RegOuPraisDiv.ado 29/03/05 pour les reg temporelles*/
/*mise à jour le 2/06/05 en créant une matrice egbeta`num' qui indique si les betas sont egaux(1) ou non(0) (test egalite)*/

program define RegOuPraisDiv_eaae, eclass
version 8.0, missing
syntax [varlist]  [,num(string) var(string)]    /*num de regression, var c'est les var qu'on veut en sortie*/

local produit "$p"
capture ereturn clear
capture quietly regress `varlist'  cons, nocons   /*car si pas de capture et bug, ça plante*/

set output proc
if e(N)!=. & e(N)>=20 {     /*  <------   Test si PB dans la regression  */
    quietly bgodfrey                
    matrix define B=r(p)    /*rajout V : p-value du test de Breush-godfrey*/
    local bg = B[1,1]       /*rajout V : on met la p-value ds 1 scalaire*/
   
    if `bg' <=0.05 {      /*cas de rejet de H0 (H0 c'est indép des résidus)*//*rajout moi...DW trop chiant à gérer*/
        di in green "cas de rejet de H0 (H0 c'est indép des résidus), on fait cochrane orcutt"
        mat define cochrane=1
        quietly prais  `varlist' cons  , nocons  corc ssesearch    
        mat define b`num' =e(b)
        mat define tx`num' =b`num'[1,1]/b`num'[1,5] /*tx de croissance*/
        quietly est table,p
        est store a`num'
        est2vec a`num', vars(`var')                  
    } 

    else {   /*cas de NON rejet de H0  */
        quietly regress `varlist' cons  , nocons  
        di in green "cas de non rejet de H0 (H0 c'est indép des résidus)"
        mat define b`num' =e(b)
        mat define tx`num' =b`num'[1,1]/b`num'[1,5]
        est table,p
        est store a`num'
        est2vec a`num', vars(`var')  
    }
    
  
     /*cas où on teste l'égalité des betas*/
   if (`num'==3 | `num'==4) &  $test_beta==1   {    /*cas où les var expli sont pdm HD, MDD, PP (avec index ou non)*/
        di in red "tests ega betas"                                             /*cas où on teste l'égalité des betas*/
        quietly test lnPdmVolBR1 =lnPdmVolBR2
        matrix def tabTest`num'=r(p) 
        capture quietly test lnPdmVolBR1 =lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        capture quietly test lnPdmVolBR2 =lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        capture quietly test lnPdmVolBR1=lnPdmVolBR2=lnPdmVolBR3
        matrix tabTest`num'=tabTest`num'\r(p) 
        matrix tabTest`num'=tabTest`num'  /*pr indiquer si tests basés sur reg ou prais*/
        
        /*création matrice de significativité des différences entre les betas*/
        /*Ho c'est b1 = b2*/
        /*rejet de Ho (les coeffs sont significativement différents) si p-value du test inférieure à 5%*/
        local nbcoltt = colsof(tabTest`num')  
        local nbrowtt = rowsof(tabTest`num')     /*-1 car la dernière ligne indique reg ou prais*/ 
        matrix egbeta`num' = J(`nbrowtt',`nbcoltt',1)   /*initialisation avec que des 1*/
        forvalues i = 1/`nbrowtt' {
            forvalues j = 1/`nbcoltt' {
                if tabTest`num'[`i',`j'] < 0.05 {
                    mat  egbeta`num'[`i',`j']  = 0  
                }
        
            }
        }
        mat list egbeta`num'
    }
   
            
}
else {   /* <---------------Si PB, alors regression basique, et remplissage   */
    di in red "comme pb reg basique"
    
    capture confirm new variable puBR4 
    if _rc==0 {    /* la variable puBR4 n'existe pas déjà */
        capture confirm new variable puBR2 
        if _rc==0 { /* la variable puBR2 n'existe pas déjà */
            quietly regress  trim1  trim2  trim3 cons, nocons
        }
        else { /* la variable puBR2 existe  déjà */
            capture quietly regress puBR2   trim1  trim2  trim3 cons, nocons   
            if e(N)==. | e(N)<20 { 
                quietly regress  trim1  trim2  trim3 cons, nocons
            }
        }
    }
    else {  /* la variable puBR4 existe  déjà */
         capture quietly regress puBR4   trim1  trim2  trim3 cons, nocons
         if e(N)==. | e(N)<20 { 
                quietly regress  trim1  trim2  trim3 cons, nocons
            }
    }
    
        matrix egbeta`num' = J(4,1,0)   /*matrice de 0 de taille 4 lignes et 1 colonne*/
        mat define b`num' =e(b)
        mat define tx`num' =b`num'[1,1]/b`num'[1,5]
        est table,p
        est store a`num'
        est2vec a`num', vars(`var')  
        
        if `num'==1 | `num'==2  | `num'==5  | `num'==6 { 
            matrix def tabTest`num'= .\.\.\.\.
        }
   
}


estimates table , stats(aic, bic) star
mat stats`num' = r(stats)    /*concaténation horizontale entre ce vecteur et la matrice à 2 lignes et 10 colonnes*/
mat list stats`num'
 
end
exit 
