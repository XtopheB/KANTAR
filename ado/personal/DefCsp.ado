/*Rajout variable locale pour compléter le label selon la variable utilisée pr Csp  (VO le 13/04/05)*/
/* Programme de Définition de CSP agrregées   (CB le 6 Octobre 2004)  */
/* Basé sur le travail de Gregory Verdugo et Sylvette  */


program define DefCsp
version 8.0

capture drop Csp
capture label drop typoCsp
capture confirm new variable cspc
    if _rc==0 {    /* la variable cspc n'est pas dans le fichier*/
        di in yellow " Attention : Variable cspp utilisee a la place de cspc"
        gen csptemp=cspp
        local cspnom "cspp" /*rajout pour que selon le cas, affichage variable utilisée*/
        }
    else{
        gen csptemp=cspc
        local cspnom "cspc" /*rajout pour que selon le cas, affichage variable utilisée*/
        
        }
        
gen Csp=.
replace Csp=0 if (csptemp==10 | csptemp==69 | csptemp==71)
replace Csp=1 if (csptemp==21 | csptemp==22 | csptemp==72 | csptemp==23 )
replace Csp=2 if (csptemp==31 | csptemp==35 )
replace Csp=3 if (csptemp==36 | csptemp==73)
replace Csp=4 if (csptemp==39 | csptemp==41 )
replace Csp=5 if (csptemp==46 | csptemp==52 | csptemp==54 | csptemp==55 )
replace Csp=6 if (csptemp==47 | csptemp==48 )
replace Csp=7 if (csptemp==53 | csptemp==83 )
replace Csp=8 if (csptemp==60 | csptemp==66 | csptemp==64 | csptemp==76 | csptemp==56 )
replace Csp=9 if (csptemp==81 | csptemp==84 | csptemp==87)
replace Csp=10 if (csptemp==. )
drop csptemp

label define typoCsp 0 "agri" 1 "arti" 2 "proflib" 3 "cadre" 4 "publi" 5 "admi" 6 "techni" 7 "poli" 8 "ouv" 9 "cho" 10 "non det"
label value Csp typoCsp 
label variable Csp "csp recodifiee (avec `cspnom')"   /* <--- à voir comment mettre le nom de la variable là  ! */
di in green " "
di in green "Variable Csp cree avec succes" 
end

