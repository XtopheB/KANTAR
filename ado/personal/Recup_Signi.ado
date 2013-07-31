program define Recup_Signi, rclass
version 8.0, missing
syntax [varlist] [,num(string)]  


local nbcol = colsof(a`num'_b)  
local nbrow = rowsof(a`num'_b) 

/*création de la matrice de la stat de test par coeff (en divisant coeff / standard error)*/
mat def T = (.)

forvalues i = 1/`nbrow' {
    forvalues j = 1/`nbcol' {
        capture drop mat C
        mat def toto = a`num'_b[`i',`j']/a`num'_se[`i',`j']
        *matrix C[`i',`j']= a`num'_b[`i',`j']/a`num'_se[`i',`j']
        mat T = T\ toto /*stat de test les unes en dessous des autres*/
        
    }
}

matrix T = T[ 2..`nbrow'+1,  .]

/*significativité des coeff : à 10% t=1,645 (à 5% t=1,96)*/
/*Ho c'est b=0*/
/*rejet de Ho (coeff significativement différent de 0) si T>t ou T<-t*/

matrix signi = J(`nbrow',`nbcol',0)
forvalues i = 1/`nbrow' {
    forvalues j = 1/`nbcol' {
        if (T[`i',`j'] > 1.645 |  T[`i',`j'] < -1.645) &  T[`i',`j']!=.  {
            mat  signi[`i',`j']  = 1  
        }
        
    }
}
di in red "matrice de significativite (à 10%) des coeff de la reg ou prais numéro `num':"
mat list signi

 
end
exit 