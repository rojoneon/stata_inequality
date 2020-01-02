
******************************************************
***Trabajo: Horas dedicadas al trabajo de cuidados
***Elaborado por: Gatitos contra la desigualdad
***Fecha: 31 de Enero de 2019
******************************************************




*Se descarga la base de datos de pobreza_16 de la página de CONEVAL, y la bases de la ENIGH 2016
 
use "pobreza_16.dta", clear
merge 1:1 folioviv foliohog numren using  "pobla16.dta"
drop _merge 

tabstat hor_6

tab pea, nol
tab asis_esc

tab pea asis_esc

destring pea asis_esc edad sexo, replace
gen nini=0
replace nini=1 if pea==0 & asis_esc==2

tabstat nini [w=factor]
gen pob12_30=0
replace  pob12_30 =1 if edad>=12 & edad<=30

tabstat nini [w=factor] if  pob12_30==1
tabstat hor_6 [w=factor] if  pob12_30==1, by(nini) 

tab sexo
tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==2 , by(nini) 
tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==1 , by(nini) 

tabstat nini  [w=factor], by (sexo)
tab nini sexo [w=factor], row nof
save "ninis.dta", replace

use "Concen16.dta", clear
xtile ingcor_decil  [fw=factor] = ing_cor , nquantiles(10)
keep ing_cor folioviv foliohog  ingcor_decil
merge 1:m folioviv foliohog using "ninis.dta"
tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==2 , by(ingcor_decil) 
tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==1 , by(ingcor_decil) 

tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==2 , by(pobreza) 
tabstat hor_6 [w=factor] if  pob12_30==1 & sexo==1 , by(pobreza) 
