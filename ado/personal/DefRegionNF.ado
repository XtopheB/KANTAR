/*21/06/06 DefRegionNF créée à partir de DefDept.ado pour les fichiers nouvelle formule*/
/*27/01/06 correction des codes communes Corses (via "c:/lsa/codeinsee.dta") (VO)*/
/*Variable Code_Commune créée (13/10/05) (VO)*/
/* labellisation de Dept le 7/09/05*/
/* CORRIGEE le 7/02/2005 ERREURSUR REGION !! */
/* Programme de Définition des Régions  (Secodip) et de Départements INSEE  (CB le 6 Octobre 2004)  */
/* La variable NOREG doit être présente  */
/* en sortie : création des variables Dept et Region     */

program define DefRegionNF
version 9.2

set more off

capture confirm new variable  depinse 
if _rc==0 {    /* la variable depinse n'est pas dans le fichier--> fichier ancienne formule*/ 
    di in red "Utiliser DefDept.ado. (pas de variable depinse dans le fichier)"
    DefDept
}
else {
    /*variable Dept (départements INSEE) n'a plus besoin d'être créée puisque depinse existe directement*/  
       
    ren depinse Dept    /*pour être en conformité avec les données 1998 - 2001 ancienne formule*/
    
    /*variable Region (selon Secodip, différente des régions selon INSEE) n'a plus besoin d'être créée pour 2001NF et 2002 puisque regseco existe directement*/
     
     capture confirm new variable regseco
     if _rc!=0 {    /* la variable regseco est dans le fichier*/ 
            capture ren regseco Region /*pour être en conformité avec les données 1998 - 2001 ancienne formule*/
     }
     else {   /*variable Region à créer (notamment pour 2003)*/
        di in red "La variable regseco(Region) n'est pas dans le fichier...on construit Region... "
        capture confirm new variable noreg
        if _rc!=0 {    /* la variable noreg est dans le fichier*/  
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
            set output error
            set output proc
            di in green "Variable Region (Secodip) cree avec succes"    
            set output error
        }
        else{
            di in red " Attention :  la variable noreg n'est pas dans le fichier. FIN de la procedure "
        }
     }
    ren  reginse Region_insee   /*pour être en conformité avec les données 1998 - 2001 ancienne formule*/
    
      
    
    /* *************   petite partie pour générer les codes communes à partir de Dept et nocom   **************/
    capture drop Code_Commune
    capture drop nocomstring
    capture drop toto
    capture drop l
    capture drop nul
    
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
    
    capture drop toto 
    /*=================================================================================*/
    /*27/01/06 correction des codes communes Corses (via "c:/lsa/codeinsee.dta")*/
    /*=================================================================================*/
    
    local CorseA "20001 20004 20006 20008 20011 20014 20017 20018 20019 20021 20022 20024 20026 20027 20028 20031 20032 20035 20038 20040 20041 20048 20056 20060 20061 20062 20064 20065 20066 20070 20071 20085 20089 20090 20091 20092 20094 20098 20099 20100 20103 20104 20108 20114 20115 20117 20118 20119 20127 20128 20129 20130 20131 20132 20133 20139 20141 20142 20144 20146 20154 20158 20160 20163 20174 20181 20186 20189 20191 20196 20197 20198 20200 20203 20204 20209 20211 20212 20215 20228 20232 20240 20247 20249 20253 20254 20258 20259 20262 20266 20268 20269 20270 20271 20272 20276 20278 20279 20282 20284 20285 20288 20295 20300 20308 20310 20312 20322 20323 20324 20326 20330 20331 20336 20345 20348 20349 20351 20357 20358 20359 20360 20362 20363"
    local CorseB "20002 20003 20005 20007 20009 20010 20012 20013 20015 20016 20020 20023 20025 20029 20030 20033 20034 20036 20037 20039 20042 20043 20045 20046 20047 20049 20050 20051 20052 20053 20054 20055 20057 20058 20059 20063 20067 20068 20069 20072 20073 20074 20075 20077 20078 20079 20080 20081 20082 20083 20084 20086 20087 20088 20093 20095 20096 20097 20101 20102 20105 20106 20107 20109 20110 20111 2011220113 20116 20120 20121 20122 20123 20124 20125 20126 20134 20135 20136 20137 20138 20140 20143 20145 20147 20148 20149 20150 20152 2015320155 20156 20157 20159 20161 20162 20164 20165 20166 20167 20168 20169 20170 20171 20172 20173 20175 20176 20177 20178 20179 20180 20182 20183 20184 20185 20187 20188 20190 20192 20193 20194 20195 20199 20201 20202 20205 20206 20207 20208 20210 20213 20214 20216 20217 20218 20219 20220 20221 20222 20223 20224 20225 20226 20227 20229 20230 20231 20233 20234 20235 20236 20238 20239 20241 20242 20243 20244 20245 20246 20248 20250 20251 20252 20255 20256 20257 20260 20261 20263 20264 20265 20267 20273 20274 20275 20277 20280 20281 20283 20286 20287 20289 20290 20291 20292 20293 20296 20297 20298 20299 20301 20302 20303 20304 20305 20306 20307 20309 20311 20313 20314 20315 20316 20317 20318 20319 20320 20321 20327 20328 20329 20332 20333 20334 20335 20337 20338 20339 20340 20341 20342 20343 20344 20346 20347 20350 20352 20353 20354 20355 20356 20361 20364 20365 20366" 
    
    capture drop deb 
    gen deb = substr(Code_Commune, 1,1)
    
    foreach c of local CorseA {
        replace Code_Commune = subinstr(Code_Commune,"0","A",1) if Code_Commune=="`c'"  & deb=="2"
    }
    
    foreach c of local CorseB {
        replace Code_Commune = subinstr(Code_Commune,"0","B",1) if Code_Commune=="`c'" & deb=="2"
    }
    drop deb
    
    /*La ville de Paris, quand elle est considérée dans son ensemble, a le code INSEE 75056 (en carto, Roland a utilisé ce code)*/
    /*sinon, découpage en 20 arrondissements et code INSEE de 75101 à 75120 (dans Secodip, LSA...)*/
}  /*fin else*/

end
