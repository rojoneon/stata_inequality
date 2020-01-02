
*Titulo: 				Mitos sobre los beneficiarios
*Autor: 				Máximo Ernesto Jaramillo Molina
*Data: 					ENIGH 2016 
*Fecha de elaboración: 	Mayo de 2019

clear all
set more off

gl bases="/Users/maximoernestojaramillomolina/Documents/Encuestas/MMIP2016/Bases"
gl desig="/Users/maximoernestojaramillomolina/Dropbox/EVALUA CDMX/Coord Información y Estadística/Compartido Información y Estadística/Ajuste CN/Desigualdad de ingresos/"

*********************
**Gastos por hogar***
*********************
*Alcohol
use "$bases/gastohogar.dta", clear
keep if ((clave>="A223" & clave<="A238"))
gen double alcohol = gasto_tri if ((tipo_gasto=="G1"))
sum alcohol
collapse alcohol, by(folioviv foliohog)
save "$desig/alcohol", replace

*Autoconsumo
use "$bases/gastohogar.dta", clear
keep if tipo_gasto=="G3"
gen double autoconsumo = gas_nm_tri if ((tipo_gasto=="G3"))
sum autoconsumo
collapse autoconsumo, by(folioviv foliohog)
save "$desig/autoconsumo", replace


*********************
**Ingreso corriente**
*********************


*Abrir concentrado, y de ahi pegar
use "$bases/concentradohogar.dta", clear
tabstat ing_cor ingtrab rentas transfer estim_alqu otros_ing
*keep  folioviv foliohog tam_loc factor tot_integ est_dis upm ubica_geo ing_cor ingtrab rentas transfer estim_alqu otros_ing

*Abrir concentrado, y de ahi pegar
*do "/Users/maximoernestojaramillomolina/Dropbox/EVALUA CDMX/Coord Información y Estadística/Compartido Información y Estadística/Ajuste CN/Desigualdad de ingresos/Cálculo ingreso corriente sin ajuste_16.do"

merge 1:1 folioviv foliohog using "$desig/alcohol"
recode alcohol (.=0), 
drop _merge
merge 1:1 folioviv foliohog using "$desig/autoconsumo"
recode autoconsumo (.=0), 
drop _merge

*I. Crear deciles de hogares ingreso corriente
*Cálculos nacionales con Ing Cor Inegi
rename ing_cor ingcor_trim
gen ing_cor= ingcor_trim/3
gen ing_cor_pp = ing_cor/tot_integ
xtile decil  [fw=factor] = ing_cor_pp , nquantiles(10)
tabstat ing_cor_pp ing_cor ingcor_trim tot_integ , by(decil) f(%12.2gc)
tabstat ing_cor_pp ing_cor ingcor_trim tot_integ [w=factor], by(decil) f(%12.2gc)






*II: Cálculos nivel hogar

*Mito: Se lo gastan todo en vicios/Malgastan su dinero
*tabla 1
tabstat gasto_mon alcohol tabaco [w=factor], by(decil)

*Tabla 2
*Ingreso No monetario:
sum autoconsumo remu_espec transf_hog trans_inst estim_alqu
gen gas_no_mon=autoconsumo + remu_espec + transf_hog + trans_inst
gen ing_mon= ingcor_trim-gas_no_mon
gen gasto_cor= gasto_mon+gas_no_mon
tabstat gasto_mon ing_mon gasto_cor ingcor_trim [w=factor], by(decil)
tabstat alime [w=factor], by(decil) f(%12.2gc)




*III: Cálculos a nivel persona
merge 1:m folioviv foliohog using "$bases/poblacion.dta"


*Mito 1: Tienen muchos hijos
*tabla 3
tabstat hijos_viv 		       		[w=factor], by(decil)
tabstat tot_i if parentesco=="101"	[w=factor], by(decil)

*Mito 2: No trabajan/No se esfuerzan:
*tabla 4
destring hor_1 num_trabaj trabajo_mp, replace
tabstat hor_1 hor_4 hor_6 hor_7 [w=factor] , by(decil)
recode hor_1 hor_4 hor_6 hor_7 (.=0)
tabstat hor_1 hor_4 hor_6 hor_7 [w=factor] , by(decil)
tabstat hor_1 hor_4 hor_6 hor_7 [w=factor]  , by(decil)

*tabla 5
recode trabajo_mp (.=0) (2=0), gen(trabaja)
tabstat num_trabaj [w=factor], by(decil)
gen segundo_t = 0
replace segundo_t=1 if num_t==2
tabstat segundo_t [w=factor] if trabaja==1, by(decil)
tab decil trabajo_mp  [w=factor], row nof




*Mito Viven del Estado:
*Tabla 6
gen vivir_del_Estado= bene_gob/ing_cor 
tabstat vivir_del_Estado [w=factor], by(decil)
tabstat bene_gob [w=factor], by(decil)
gen benef_x_persona=bene_gob/tot_integ
tabstat vivir_del_Estado benef_x_persona [w=factor] if parentesco=="101", by(decil)















