*Titulo: #DíaDelPagoIgualitario / Análisis de la brecha salarial
*Autor: Gatitos contra la desigualdad
*Data: ENOE primer trimestre, diferentes años.


clear all
set more off
*A continuación, establecer la carpeta que contenga todas las ENOE's de 2010 a 2018
cd "Encuestas/ENOE/2010-2018"



*****************************
*******Datos de 2018I********
*********Base SDMET**********
*****************************


use "SDEMT/SDEMT118.dta", clear

*Se siguen señalamientos de INEGI sobre que observacione dejar en la base
keep if r_def==0
drop if c_res==2
keep if eda>12 
drop if eda==99

gen pob_ocupada=.
replace pob_ocupada=1 if clase2==1
keep if pob_ocupada==1 

gen recibe_ingresos=.
replace recibe_ingresos=1 if ingocup>0 &  clase2==1
replace recibe_ingresos=0 if ingocup==0 &  clase2==1

gen mujer=0
replace mujer=1 if sex==2

gen n=1

gen coho=.
replace coho=1 if nac_anio<1945
replace coho=2 if nac_anio>=1945 & nac_anio<1964
replace coho=3 if nac_anio>=1965 & nac_anio<1981
replace coho=4 if nac_anio>=1982 & nac_anio<1994
replace coho=5 if nac_anio>1994

sort sex

****Tablas

* Brecha promedio, urbano/rural
bysort sex: tabstat ingocup [w=fac], by(ur)

*Gráfica 2. Brecha por deciles
	*Los deciles se crean solo para trabajadores con ingresos
xtile deciles=ingocup [w=fac] if recibe_ingresos==1, nq(10)
tabstat mujer [w=fac], by(decil)

*Gráfica 3. Brecha promedio características demográficas
bysort sex: tabstat ingocup [w=fac], by(anios_esc) 
tab anios_esc sex 

bysort sex: tabstat ingocup [w=fac], by(coho)

bysort sex: tabstat ingocup [w=fac], by(t_loc) 

bysort sex: tabstat ingocup [w=fac], by(e_con) 


*Mapa 1. Serie de tiempo de brecha regional
bysort sex: tabstat ingocup [w=fac], by(ent)


*Gráfica 5. Horas trabajadas promedio por persona
tabstat hrsocup [w=fac], by(sex)
recode hrsocup (1/12=1) (13/24=2) (25/36=3) (37/48=4) (49/60=5) (61/168=6), gen(hrs_cat) 
label define hrs_cat 1 "1 a 12 hrs" 2 "13 a 24 hrs" 3 "25 a 36 hrs" 4 "37 a 48 hrs" 5 "49 a 60 hrs" 6 "Más de 60 hrs"
label values hrs_cat hrs_cat
tab hrs_cat sex [w=fac], row nof

* % en cargos con alta jerarquía
tab pos_ocu sex [w=fac] , row nof
bysort sex: tabstat ingocup [w=fac], by(pos_ocu)
bysort sex: tabstat n [w=fac], by(pos_ocu) s(sum) format(%18.0gc)

****************************************
*******Datos de 2018I*******************
*******Base SDEMT +  Complemento********
****************************************

use "SDEMT/SDEMT118.dta", clear

merge 1:m cd_a ent con v_sel n_hog h_mud n_ren using "2018trim1_dta/COE1T118.dta"
drop _merge
merge 1:m cd_a ent con v_sel n_hog h_mud n_ren using "2018trim1_dta/COE2T118.dta"
 
gen hrs_cuidado=0
replace hrs_cuidado= p11_h2 if  p11_h2 !=. 
replace hrs_cuidado=0 if p11_h2==98 &  p11_m2==0 
replace hrs_cuidado=0 if p11_h2==99 &  p11_m2==0 
 
gen hrs_trans_fam=0
replace hrs_trans_fam= p11_h4 if  p11_h4 !=. 
replace hrs_trans_fam=0 if p11_h4==98 &  p11_m4==0 
replace hrs_trans_fam=0 if p11_h4==99 &  p11_m4==0  

gen hrs_que_hacer=0
replace hrs_que_hacer= p11_h7 if  p11_h7 !=. 
replace hrs_que_hacer=0 if p11_h7==98 &  p11_m7==0 
replace hrs_que_hacer=0 if p11_h7==99 &  p11_m7==0  

gen hrs_trab_no_remu= hrs_cuidado + hrs_trans_fam + hrs_que_hacer 
gen hrs_trab_remu= hrsocup

gen hrs_trab= hrs_trab_no_remu + hrs_trab_remu

xtile deciles=ingocup [w=fac] if ingocup!=0, nq(10)
xtile quintiles=ingocup [w=fac] if ingocup!=0, nq(5)

sort sex

*Gráfica 6. Horas semanales dedicadas a trabajo remunerado y no remunerado
bysort sex:tabstat hrs_trab hrs_trab_no_remu hrs_trab_remu if (clase2==1) [w=fac], by (quintiles)




*Gráficas 7, 8, 9 y 10. Brecha por tipo de ocupación
gen n=1
destring  p3, replace
gen division=real(substr(string(p3, "%4.0g")),1,1)
gen gpo_princ=real(substr(string(p3, "%4.0f")),1,2)

bysort sex: tabstat ingocup [w=fac], by(division)
bysort sex: tabstat n [w=fac], by(division) s(sum) format(%18.0gc)

tab gpo
bysort sex: tabstat ingocup [w=fac], by(gpo)
bysort sex: tabstat n [w=fac], by(gpo) s(sum) format(%18.0gc)

***La clasficación de ocupaciones está por acá: 
		*https://www.inegi.org.mx/app/biblioteca/ficha.html?upc=702825006564



 
****************************************
*******Datos de Varios años************* 
*****Primer trimestre*******************
*******Base SDEMT +  Complemento********
****************************************


***Para que funcionen los dos siguientes loops,se tienen que colocar las base de SDEMT110, SDEMT111...hasta SDEMT118,
	* en la misma carpeta


*Gráfica 1. Serie de tiempo de brecha salarial promedio
forvalues i= 10 / 18 {
use "SDEMT/SDEMT1`i'.dta", clear

keep if r_def==0
drop if c_res==2
keep if eda>12 
drop if eda==99
keep if clase2==1 

*Serie de tiempo de brecha promedio
bysort sex: tabstat ingocup [w=fac]
}
*


*Gráfica 4. *Horas trabajadas promedio

forvalues i= 10 / 18 {
use "SDEMT/SDEMT1`i'.dta", clear

keep if r_def==0
drop if c_res==2
keep if eda>12 
drop if eda==99
keep if clase2==1 

*Horas trabajadas promedio por persona
tabstat hrsocup [w=fac], by(sex)
}
*


