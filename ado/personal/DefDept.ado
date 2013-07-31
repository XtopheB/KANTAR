
/* Programme de Définition des Régions  (Secodip) et de Départements INSEE  (CB le 6 Octobre 2004)  */
/* La variable NOREG doit être présente  */
/* en sortie : création des variables Dept et Region     */
/* CORRIGEE le 7/02/2005 ERREURSUR REGION !! */
/* labellisation de Dept le 7/09/05*/
/*Variable Code_Commune créée (13/10/05) (VO)*/
/*27/01/06 correction des codes communes Corses (via "c:/lsa/codeinsee.dta") (VO)*/
/*2/05/07 on vire ce qu'on croyait être la Corse (il n'y a pas de 20 pr Dept)*/
/*6/11/08 on met safedrop au lieu de drop : car avant "drop l" et "drop nul" avant création et si la variables l n'est pas ds fichier ms lib oui, ça vire lib (VO)*/

program define DefDept
version 11.0

set more off
capture drop Dept   /* <<<---- reinitialisation */
capture label drop typoDept

capture confirm new variable noreg
if _rc!=0 {    /* la variable noreg est dans le fichier*/  
    set output error
    
    /*****************    création variable Dept (départements INSEE)  *****************/ 
    /*      on la crée à partir de noreg qui est dispo ds les fichiers secodip          */
    
    gen Dept=.
    
    for X in num  1/10 \ Z in any 69 25 58 76 75 77 73 19 87 17 : quietly replace Dept=X  if noreg==Z
    for X in num 11/19 \ Z in any 85 90 80 29 55 43 42 50 54  : quietly replace Dept=X  if noreg==Z
    quietly replace Dept=13  if noreg==81   /* Double entrée  */
    for X in num 21/30 \ Z in any 61 33 52 98 65 74 28 48 34 83 : quietly replace Dept=X  if noreg==Z
    quietly replace Dept=29  if noreg==35   /* Double entrée  */
    for X in num 31/40 \ Z in any 88 93 97 84 32 51 46 72 63 96 : quietly replace Dept=X  if noreg==Z
    for X in num 41/50 \ Z in any 47 67 56 37 49 91 99 82 40 31 : quietly replace Dept=X  if noreg==Z
    for X in num 51/60 \ Z in any 18 16 38 14 15 36 12 59 20 26 : quietly replace Dept=X  if noreg==Z
    quietly replace Dept=59  if noreg==21   /* Double entrée  */
    for X in num 61/70 \ Z in any 30 22 57 95 94 86 11 10 68 64 : quietly replace Dept=X  if noreg==Z
    quietly replace Dept=62  if noreg==23   /* Double entrée  */
    for X in num 71/80 \ Z in any 62 39 71 70 00 27 09 06 44 24 : quietly replace Dept=X  if noreg==Z
    quietly replace Dept=75  if noreg==01 | noreg==02   /* Triple entrée  */
    for X in num 81/90 \ Z in any 89 92 78 79 41 45 53 13 60 66 : quietly replace Dept=X  if noreg==Z
    for X in num 91/95 \ Z in any  07 03 04 05 08 : quietly replace Dept=X  if noreg==Z
    
    label define typoDept 1 "Ain"
    label define typoDept 2 "Aisne", add
    label define typoDept 3 "Allier", add
    label define typoDept 4 "Basses-Alpes", add
    label define typoDept 5 "Hautes-Alpes", add
    label define typoDept 6 "Alpes-Maritimes", add
    label define typoDept 7 "Ardèche", add
    label define typoDept 8 "Ardennes", add
    label define typoDept 9 "Ariège", add
    label define typoDept 10 "Aube", add
    label define typoDept 11 "Aude", add
    label define typoDept 12 "Aveyron", add
    label define typoDept 13 "Bouches-du-Rhône", add
    label define typoDept 14 "Calvados", add
    label define typoDept 15 "Cantal", add
    label define typoDept 16 "Charente", add
    label define typoDept 17 "Charente-Maritime", add
    label define typoDept 18 "Cher", add
    label define typoDept 19 "Corrèze", add
    label define typoDept 20 "Corse", add
    label define typoDept 21 "Côte-d'Or", add
    label define typoDept 22 "Côtes-d'Armor", add
    label define typoDept 23 "Creuse", add
    label define typoDept 24 "Dordogne", add
    label define typoDept 25 "Doubs", add
    label define typoDept 26 "Drôme", add
    label define typoDept 27 "Eure", add
    label define typoDept 28 "Eure-et-Loir", add
    label define typoDept 29 "Finistère", add
    label define typoDept 30 "Gard", add
    label define typoDept 31 "Haute-Garonne", add
    label define typoDept 32 "Gers", add
    label define typoDept 33 "Gironde", add
    label define typoDept 34 "Hérault", add
    label define typoDept 35 "Ille-et-Vilaine", add
    label define typoDept 36 "Indre", add
    label define typoDept 37 "Indre-et-Loire", add
    label define typoDept 38 "Isère", add
    label define typoDept 39 "Jura", add
    label define typoDept 40 "Landes", add
    label define typoDept 41 "Loir-et-Cher", add
    label define typoDept 42 "Loire", add
    label define typoDept 43 "Haute-Loire", add
    label define typoDept 44 "Loire-Atlantique", add
    label define typoDept 45 "Loiret", add
    label define typoDept 46 "Lot", add
    label define typoDept 47 "Lot-et-Garonne", add
    label define typoDept 48 "Lozère", add
    label define typoDept 49 "Maine-et-Loire", add
    label define typoDept 50 "Manche", add
    label define typoDept 51 "Marne", add
    label define typoDept 52 "Haute-Marne", add
    label define typoDept 53 "Mayenne", add
    label define typoDept 54 "Meurthe-et-Moselle", add
    label define typoDept 55 "Meuse", add
    label define typoDept 56 "Morbihan", add
    label define typoDept 57 "Moselle", add
    label define typoDept 58 "Nièvre", add
    label define typoDept 59 "Nord", add
    label define typoDept 60 "Oise", add
    label define typoDept 61 "Orne", add
    label define typoDept 62 "Pas-de-Calais", add
    label define typoDept 63 "Puy-de-Dôme", add
    label define typoDept 64 "Pyrénées-Atlantiques", add
    label define typoDept 65 "Hautes-Pyrénées", add
    label define typoDept 66 "Pyrénées-Orientales", add
    label define typoDept 67 "Bas-Rhin", add
    label define typoDept 68 "Haut-Rhin", add
    label define typoDept 69 "Rhône", add
    label define typoDept 70 "Haute-Saône", add
    label define typoDept 71 "Saône-et-Loire", add
    label define typoDept 72 "Sarthe", add
    label define typoDept 73 "Savoie", add
    label define typoDept 74 "Haute-Savoie", add
    label define typoDept 75 "Paris", add
    label define typoDept 76 "Seine-Maritime", add
    label define typoDept 77 "Seine-et-Marne", add
    label define typoDept 78 "Yvelines", add
    label define typoDept 79 "Deux-Sèvres", add
    label define typoDept 80 "Somme", add
    label define typoDept 81 "Tarn", add
    label define typoDept 82 "Tarn-et-Garonne", add
    label define typoDept 83 "Var", add
    label define typoDept 84 "Vaucluse", add
    label define typoDept 85 "Vendée", add
    label define typoDept 86 "Vienne", add
    label define typoDept 87 "Haute-Vienne", add
    label define typoDept 88 "Vosges", add
    label define typoDept 89 "Yonne", add
    label define typoDept 90 "Territoire de Belfort", add
    label define typoDept 91 "Essonne", add
    label define typoDept 92 "Hauts-de-Seine", add
    label define typoDept 93 "Seine-Saint-Denis", add
    label define typoDept 94 "Val-de-Marne", add
    label define typoDept 95 "Val-d'Oise", add
    label value Dept typoDept

    label variable Dept "Departement (INSEE)"
    set output proc 
    di " "
    di in green "Variable Dept cree avec succes" 
    
    set output error
    
    /*****************    création variable Region (selon Secodip, différente des régions selon INSEE)   *****************/
    capture drop Region
    capture label drop typoRegion
    gen Region=1 if noreg<10  
    replace Region=2 if noreg>=10 &noreg <20  
    replace Region=3 if noreg>=20 &noreg <27
    replace Region=4 if noreg>=27 &noreg <46     
    replace Region=5 if noreg>=46 &noreg <59
    replace Region=6 if noreg>=59 &noreg <75
    replace Region=7 if noreg>=75 &noreg <87
    replace Region=8 if noreg>=87  
     
   label define typoRegion 1 "Paris"
   label define typoRegion 2 "Est", add
   label define typoRegion 3 "Nord", add
   label define typoRegion 4 "Ouest", add    
   label define typoRegion 5 "Centre-Ouest", add
   label define typoRegion 6 "Centre-Est", add
   label define typoRegion 7 "Sud-Est", add   
   label define typoRegion 8 "Sud-Ouest", add   
   label value Region typoRegion    
   label variable Region "Region (Secodip)"     /*rajout le 13/04/05 */
   set output proc
   di in green "Variable Region (Secodip) cree avec succes"    
   set output error
   
   /*****************    création variable Region_insee   *****************/
    capture drop Region_insee
    capture label drop typoRegion_insee

    gen Region_insee=1 if Dept==67 | Dept==68
    label define typoRegion_insee 1 "Alsace"
    
    replace Region_insee=2 if Dept==24 | Dept==33 | Dept==40 | Dept==47 | Dept==64
    label define typoRegion_insee 2 "Aquitaine", add

    replace Region_insee=3 if Dept==03 | Dept==15 | Dept==43 | Dept==63
    label define typoRegion_insee 3 "Auvergne", add

    replace Region_insee=4 if Dept==14 | Dept==50 | Dept==61
    label define typoRegion_insee 4 "Basse-Normandie", add

     replace Region_insee=5 if Dept==21 | Dept==58 | Dept==71 | Dept==89
     label define typoRegion_insee 5 "Bourgogne", add

     replace Region_insee=6 if Dept==22 | Dept==29 | Dept==35 | Dept==56
     label define typoRegion_insee 6 "Bretagne", add

     replace Region_insee=7 if Dept==18 | Dept==28 | Dept==36 | Dept==37 | Dept==41 | Dept==45
     label define typoRegion_insee 7 "Centre", add

     replace Region_insee=8 if Dept==08 | Dept==10 | Dept==51 | Dept==52
     label define typoRegion_insee 8 "Champagne-Ardenne", add

     replace Region_insee=9 if Dept== 25 | Dept==39 | Dept==70 | Dept==90
     label define typoRegion_insee 9 "Franche-Comté", add

     replace Region_insee=10 if Dept==27 | Dept==76
     label define typoRegion_insee 10 "Haute-Normandie", add

     replace Region_insee=11 if Dept==75 | Dept==77 | Dept==78 | Dept==91 | Dept==92 | Dept==93 | Dept==94 | Dept==95
     label define typoRegion_insee 11 "Ile-de-France", add

     replace Region_insee=12 if Dept==11 | Dept==30 | Dept==34 | Dept==48 | Dept==66
     label define typoRegion_insee 12 "Languedoc-Roussillon", add

     replace Region_insee=13 if Dept==19 | Dept==23 | Dept==87
     label define typoRegion_insee 13 "Limousin", add

     replace Region_insee=14 if Dept==54 | Dept==55 | Dept==57 | Dept==88
     label define typoRegion_insee 14 "Lorraine", add

     replace Region_insee=15 if Dept==09 | Dept==12 | Dept==31 | Dept==32 | Dept==46 | Dept==65 | Dept==81 | Dept==82
     label define typoRegion_insee 15 "Midi-Pyrénées", add

     replace Region_insee=16 if Dept==59  | Dept==62
     label define typoRegion_insee 16 "Nord-Pas-de-Calais", add

     replace Region_insee=17 if Dept== 44 | Dept==49 | Dept==53 | Dept==72 | Dept==85
     label define typoRegion_insee 17 "Pays de la Loire", add

     replace Region_insee=18 if Dept== 02 | Dept==60 | Dept==80
     label define typoRegion_insee 18 "Picardie", add

     replace Region_insee=19 if Dept==16 | Dept==17 | Dept==79 | Dept==86
     label define typoRegion_insee 19 "Poitou-Charentes", add

     replace Region_insee=20 if Dept==04 | Dept==05 | Dept==06 | Dept==13 | Dept==83 | Dept==84
     label define typoRegion_insee 20 "Provence-Alpes-Côte-d'Azur", add

     replace Region_insee=21 if Dept==01 | Dept==07 | Dept==26 | Dept==38 | Dept==42 | Dept==69 | Dept==73 | Dept==74
     label define typoRegion_insee 21 "Rhône-Alpes", add

     replace Region_insee=22 if Dept==20
     label define typoRegion_insee 22 "Corse", add

    label value Region_insee typoRegion_insee
    label variable Region_insee  "Region_insee(INSEE)"     /*rajout le 4/09/05 */
    set output proc
    di in green "Variable Region_insee(INSEE) cree avec succes"    
    
    /* *************   petite partie pour générer les codes communes à partir de Dept et nocom   **************/
    capture safedrop Code_Commune
    capture safedrop nocomstring
    capture safedrop toto
    capture safedrop l
    capture safedrop nul
    
    tostring nocom, gen(nocomstring)    /*transformer nocom en string pr pouvoir jouer avec nb de caractères*/
    tostring Dept, gen(Deptstring)
    
    gen m=length(Deptstring)
    gen l=length(nocomstring) /*regarder nb de caractères*/
    
    gen nul=0
    /*nocom doit avoir 3 caractères, Dept doit en avoir 2*/
    egen toto = concat(nul nocom) if l==2   /*on rajoute un 0 pr avoir 3 caractères*/
    egen tata = concat(nul nul nocom) if l==1 /*on rajoute deux 0 pr avoir 3 caractères*/
    replace toto = tata if l==1
    replace toto = nocomstring if l==3  /*toto a 3 chiffres*/
    drop tata
   
    
    egen Deptbis = concat(nul Dept) if m==1
    replace Deptbis=Deptstring if m==2
    egen Code_Commune = concat(Deptbis toto)
    drop nocomstring  Deptstring m l toto Deptbis nul
    di in green " Variable Code_Commune cree avec succes"
    di " "
    }
else{
    di in red " Attention :  la variable noreg n'est pas dans le fichier. FIN de la procedure "
    }

/*=================================================================================*/
/*27/01/06 correction des codes communes Corses (via "c:/lsa/codeinsee.dta")*/
/*=================================================================================*/

local CorseA "20001 20004 20006 20008 20011 20014 20017 20018 20019 20021 20022 20024 20026 20027 20028 20031 20032 20035 20038 20040 20041 20048 20056 20060 20061 20062 20064 20065 20066 20070 20071 20085 20089 20090 20091 20092 20094 20098 20099 20100 20103 20104 20108 20114 20115 20117 20118 20119 20127 20128 20129 20130 20131 20132 20133 20139 20141 20142 20144 20146 20154 20158 20160 20163 20174 20181 20186 20189 20191 20196 20197 20198 20200 20203 20204 20209 20211 20212 20215 20228 20232 20240 20247 20249 20253 20254 20258 20259 20262 20266 20268 20269 20270 20271 20272 20276 20278 20279 20282 20284 20285 20288 20295 20300 20308 20310 20312 20322 20323 20324 20326 20330 20331 20336 20345 20348 20349 20351 20357 20358 20359 20360 20362 20363"

local CorseB "20002 20003 20005 20007 20009 20010 20012 20013 20015 20016 20020 20023 20025 20029 20030 20033 20034 20036 20037 20039 20042 20043 20045 20046 20047 20049 20050 20051 20052 20053 20054 20055 20057 20058 20059 20063 20067 20068 20069 20072 20073 20074 20075 20077 20078 20079 20080 20081 20082 20083 20084 20086 20087 20088 20093 20095 20096 20097 20101 20102 20105 20106 20107 20109 20110 20111 2011220113 20116 20120 20121 20122 20123 20124 20125 20126 20134 20135 20136 20137 20138 20140 20143 20145 20147 20148 20149 20150 20152 2015320155 20156 20157 20159 20161 20162 20164 20165 20166 20167 20168 20169 20170 20171 20172 20173 20175 20176 20177 20178 20179 20180 20182 20183 20184 20185 20187 20188 20190 20192 20193 20194 20195 20199 20201 20202 20205 20206 20207 20208 20210 20213 20214 20216 20217 20218 20219 20220 20221 20222 20223 20224 20225 20226 20227 20229 20230 20231 20233 20234 20235 20236 20238 20239 20241 20242 20243 20244 20245 20246 20248 20250 20251 20252 20255 20256 20257 20260 20261 20263 20264 20265 20267 20273 20274 20275 20277 20280 20281 20283 20286 20287 20289 20290 20291 20292 20293 20296 20297 20298 20299 20301 20302 20303 20304 20305 20306 20307 20309 20311 20313 20314 20315 20316 20317 20318 20319 20320 20321 20327 20328 20329 20332 20333 20334 20335 20337 20338 20339 20340 20341 20342 20343 20344 20346 20347 20350 20352 20353 20354 20355 20356 20361 20364 20365 20366" 
capture drop toto 
capture drop deb 
*gen toto = "" 

gen deb = substr(Code_Commune, 1,1)

foreach c of local CorseA {
    quietly replace Code_Commune = subinstr(Code_Commune,"0","A",1) if Code_Commune=="`c'"  & deb=="2"
}

foreach c of local CorseB {
    quietly replace Code_Commune = subinstr(Code_Commune,"0","B",1) if Code_Commune=="`c'" & deb=="2"


}

drop deb

/*La ville de Paris, quand elle est considérée dans son ensemble, a le code INSEE 75056 (en carto, Roland a utilisé ce code)*/
/*sinon, découpage en 20 arrondissements et code INSEE de 75101 à 75120 (dans Secodip, LSA...)*/

end
