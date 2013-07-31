/*====================================================================*/
/*====================================================================*/
/******  Petit programme permettant d'automatiser l'installation  *****/
/******   de MES packages ou procédures (et aussi pour mémoire)  ******/
/******   utile pour nouvel ordi, après formattage...            ******/
/*valérie */
/*Version du 1/04/10*/
/*17/01/13 Rajout copie du profile.do (définissant chemin des ado perso)*/
/*====================================================================*/
/*====================================================================*/


/***************************************/
/********  PROCEDURES FROM SSC  ********/
/***************************************/
#delimit ;
    local ProgramsToBeInstalled  
    "distinct vallist 
    matsave 
    fsum  
    xtivreg2 ivreg2 ranktest overid bpagan bgtest whitetst 
    findval fitstat 
    xtoverid outtex egenmore 
    outreg2 outtable estout sutex listtex tabout xcontract latab corrtex tabletutorial  
    mat2txt estwrite texdoc mktab mkcorr parmest dataout
    spmap shp2dta  
    ranktest safedrop
    surface
    moremata
    margeff 
    adolist  
    dirlist   
    " ;   
#delimit cr


foreach p of local ProgramsToBeInstalled {
    ssc install `p',replace
}

/*<-----------------------------------------------------------------
**** POUR MEMOIRE *****
* overidxt : This routine has been superseded by 
* Schaffer and Stillman's xtoverid (q.v.) for Stata 8 or Stata 9 users; 
* xtoverid has broader capabilities.

* findit xi3

* mata : mata mlib index
----------------------------------------------------------------->*/


/***************************************/
/*********   PACKAGES FROM NET  ********/
/***************************************/
net install est2tex.pkg	     , replace from(http://fmwww.bc.edu/RePEc/bocode/e/)	               /*est2tex est2vec est2one*/
net install wls0.pkg         , replace from(http://www.ats.ucla.edu/stat/stata/ado/analysis)
net install st0026_2.pkg     , replace from(http://www.stata-journal.com/software/sj5-3/)	   /*pscore*/
net install matsave.pkg	     , replace from(http://econ.ucsd.edu/muendler/download/stata)	   /*matload */
net install dm13.pkg	     , replace from(http://www.stata.com/users/wgould)	               /*replstr*/
net install outmat           , replace from (http://www.komkon.org/~tacik/stata/)
net install graph2tex        , replace from(http://www.ats.ucla.edu/stat/stata/ado/analysis)
net install sg73.pkg         , replace from(http://www.stata.com/stb/stb40)                     /*modl, modltbl*/
net install st0111           , replace from(http://www.stata-journal.com/software/sj6-4/)       /*séquences (sqset...)*/
net install matsave          , replace from(http://fmwww.bc.edu/RePEc/bocode/m)
net install bioprobit.pkg    , replace from(http://fmwww.bc.edu/RePEc/bocode/b/)            /*probit classes latentes avec IV ou non*/
net install tabmiss.pkg      , replace from(http://www.ats.ucla.edu/stat/stata/ado/analysis/)   /*compte non missing de variables*/
net install mdesc.pkg        , replace from(http://www.ats.ucla.edu/stat/stata/ado/analysis/)   /*affiche les missings et le pourcentage qu'ils représentent*/
net install dm71.pkg        , replace from(http://www.stata.com/stb/stb51)  /*egen=prod produit des observations*/
update all
adoupdate   /*pour mettre à jour les procédures téléchargées écrites par des utilisateurs*/
adoupdate, update


/************************************************************************************/
/********  Copier mon profile.do ds la nouvelle version de Stata installée  ********/
/************************************************************************************/
/*17/01/13 ici on copie le profil.do de Stata version 11 vers Stata version 12*/
di in red "A changer selon version de Stata!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
! copy  c:\Program Files (x86)\Stata11\profile.do     c:\Program Files (x86)\Stata12\


