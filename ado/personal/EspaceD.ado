/*17/12/04 */
/*17/03/05 rajout de "capture drop sa2bis"*/
/*procédure permettant de comparer ou de compléter l'info de la variable sa7 (MDD ou non) grâce au libellé de la marque*/
/*si la marque finit par un D, elle s'apparente à une MDD*/

program define EspaceD
version 8.0
syntax [varlist]  
set textsize 100  /*pour que la taille du texte ds les graphes soit adequate */
set more off

capture drop d_fin
levels sa2
if "`r(levels)'"=="" { /* Si la variable sa2 est tout le temps à missing*/
    gen d_fin=0
    }
    
else {
    capture drop sa2bis
    decode sa2,gen(sa2bis)
    gen l=length(sa2bis)    
    gen l2=l-1               /*indice du dernier caractere de sa2 (si MDD c'est D)(-1 car y a un vide à la fin)*/ 
    gen l3=l-2                /*avant dernier carac : si MDD c'est un espace */
    gen str1 toto = substr(sa2bis,l2,1)     /*recup du dernier carac*/
    gen str1 tata = substr(sa2bis,l3,1)      /*recup avant dernier carac*/
    gen d_fin=0
    replace d_fin=1 if toto=="D" & tata==" "       /*espace + D semble être une marque MDD (d_fin==1)*/

    capture drop l 
    capture drop l2 
    capture drop l3 
    capture drop toto 
    capture drop tata
}
end
