program define LabelReturn, rclass
/* version du 25/10/2004 */
             version 8.0
             syntax [varlist] [if]
             tokenize "`varlist'"

             local x : variable label `1'
             return local LabelVariable = "`x'"
             local Fichier : data label 
             return local LabelFichier  `"`Fichier'"'
             
             local short = substr(`"`Fichier'"', 1,33)
             return local NomCourt  `"`short'"'
             
             return local var `"`varlist'"'
             
             
  end


