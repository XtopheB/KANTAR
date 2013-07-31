/* ------------- PROGRAMME DEFLATENEW ------------------------       */
/* Créé le 4/11/04 par valérie    */
/*   deflate les prix à la conso, selon l'insee, base 100 en 1998 */
/*      sur 6 années (1998, 1999, 2000, 2001, 2002 et 2003)                     */
/*      Suppose la variable MOIS4 52 mois(4*13)                 */
/*2002 2003 complété le 12/03/09*/
/* ---------------------------------------------------------- */
 /*ipc, base 100 en 1998*/
/*http://www.insee.fr/fr/indicateur/indic_cons/indic_cons.asp*/   
/*http://www.insee.fr/fr/themes/conjoncture/serie_revalorisation.asp*/
/*Série hors tabac Ensemble des ménages*/


/*année 1998*/
/*99.5    99.8    100     100.2   100.2   100.3   100     100     100     100     99.9    100  */
/*année 1999*/
/*99.6    99.9    100.3   100.6   100.6   100.6   100.3   100.5   100.6   100.7   100.7   101.2  */
/*année 2000*/
/*101.1   101.2   101.7   101.7   101.9   102.2   102     102.2   102.7   102.6   102.8   102.8  */
/*année 2001*/
/*102.3   102.5   103     103.5   104.2   104.2   104     104     104.2   104.3   104     104.1  */         
/*année 2002*/
/*104.4	  104.6	   105	  105.4	  105.6	  105.5	  105.5	  105.8	   106	   106.2  106.2	   106.3*/
/*année 2003*/
/*106.3	 107.1	  107.5	  107.4	  107.2	  107.4  107.3	  107.6 	108	   108.1  107.9	    108*/

pause on   /* pour permettre les pauses */

program define DeflateNew
version 10.1

#delimit ;
local listIPC 
"99.5    99.8    100     100.2   100.2   100.3   100     100     100     100     99.9    100  100 
99.6    99.9    100.3   100.6   100.6   100.6   100.3   100.5   100.6   100.7   100.7   101.2  101.2
101.1   101.2   101.7   101.7   101.9   102.2   102     102.2   102.7   102.6   102.8   102.8  102.8 
102.3   102.5   103     103.5   104.2   104.2   104     104     104.2   104.3   104     104.1  104.1
104.4	  104.6	   105	  105.4	  105.6	  105.5	  105.5	  105.8	   106	   106.2  106.2	   106.3 106.3
106.3	 107.1	  107.5	  107.4	  107.2	  107.4  107.3	  107.6 	108	   108.1  107.9	    108   108" ;                                                                                                         
#delimit cr

capture confirm new variable ipc 
if _rc==0 {    /* la variable ipc n'existe pas déjà */
    set output error
    capture gen ipc=.
    for X in num 1/78 \ Z in any `listIPC' : replace ipc=Z if Mois4==X
    label variable ipc "Indice Prix Conso (INSEE, base 100 en 1998)"
    
    capture confirm new variable ptwa 
    if _rc!=0 {    /* la variable ptwa est ds fichier*/
        quietly replace ptwa=ptwa*100/ipc 
        set output proc    
        display in yellow " - Variable ptwa deflatee -"
    }
    else { 
        display in red "ptwa pas ds fichier !! Déflatez ce que vous voulez !  "
    }
}
else { 
    display in red "Aucune operation effectuee: ptwa deja deflate !!" 
}
end
