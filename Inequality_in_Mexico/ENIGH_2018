                     

set more off

*CARPETA UBUNTU /home/maxernesth/Escritorio/encuestas/ENIGH Vieja Construccion/2016/bases

*RECUERDA
*Cambiar lineas de pobreza según año
*Modificar el nombre de los siguientes archivos


*Concentrado - 	Concen16 por 	concentradohogar
* Poblacion - 	Pobla16 - 		poblacion
* Ingresos - 	Ingresos16 - 	ingresos
* Trabajos - 	Trabajos16 - 	trabajos


*La primera vez, modificar:
			*
			*
*DespuÈs de correrlo la segunda vez, modificar

*net install sgini , from(http://medim.ceps.lu/stata)

* Carpete de trabajo UBUNTU
*cd "/home/maxernesth/Escritorio/encuestas/ENIGH Vieja Construccion/2016/bases"


* Carpete de trabajo Mac
*cd "/Users/Maxernsth/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases"

* Carpeta trabajo EVALÚA CDMX
cd "~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases/Prof Enrique"

* Carpete de trabajo Oxfam
*cd "\\OMXFILE01\UserFiles$\maximojaramillo\Documents\Encuestas\ENIGH Vieja Construccion\2016\bases"


clear all
use "concentradohogar", clear





clear all
use "poblacion.dta", clear
destring numren, replace

tab atemed
*necesito la suma del numero de afiliados por hogar





**agregados por cuenta**
clear all
use "poblacion.dta", clear
destring numren inst_1 inst_2  inst_3 inst_4  inst_5 servmed_8 servmed_9 segpop segvol_1 segvol_2, replace



gen pob65ymas = .
replace  pob65ymas=1 if edad>65




gen priv_if_imss=.
replace priv_if_imss=1 if servmed_8==8 & inst_1 ==1
gen priv_if_issste=.
replace priv_if_issste=1 if servmed_8==8 & inst_2 ==2
gen priv_if_pemex=.
replace priv_if_pemex=1 if servmed_8==8 & inst_4 ==4
gen priv_if_segpop=.
replace priv_if_segpop=1 if servmed_8==8 & segpop==1

gen simi_if_imss=.
replace simi_if_imss=1 if servmed_9==9 & inst_1 ==1
gen simi_if_issste=.
replace simi_if_issste=1 if servmed_9==9 & inst_2 ==2
gen simi_if_pemex=.
replace simi_if_pemex=1 if servmed_9==9 & inst_4 ==4
gen simi_if_segpop=.
replace simi_if_segpop=1 if servmed_9==9 & segpop==1

collapse (count) numren pob65ymas inst_1 inst_2  inst_3 inst_4  inst_5 servmed_8 servmed_9 priv_if_imss priv_if_issste priv_if_pemex priv_if_segpop simi_if_segpop simi_if_pemex simi_if_issste simi_if_imss ///
 segvol_1 segvol_2, by(folioviv foliohog)
save "agregado poblacion x cuenta.dta", replace

clear all
use "concentradohogar.dta", clear
*gen _merge=.;)
*list tam_hog numren
*gen resta = (tam_hog - numren)
*tab resta
merge 1:1 folioviv foliohog using "agregado poblacion x cuenta.dta"
drop _merge

save "concentradohogar_modificados.dta", replace




*****************************
**agregados por suma**
*****************************

clear all
use "poblacion.dta", clear
destring numren atemed, replace
collapse (sum) atemed, by(folioviv foliohog)
tabstat atemed, stat(sum)


clear all
use "poblacion.dta", clear
destring numren atemed segpop, replace
replace atemed =0 if atemed==2

destring nivelaprob, replace

recode nivelaprob (0=1) (1/9=.), gen (nivelaprob_0)
recode nivelaprob (1=1) (0=.) (2/9=.), gen (nivelaprob_1)
recode nivelaprob (2=1) (0/1=.) (3/9=.), gen (nivelaprob_2)
recode nivelaprob (3=1) (0/2=.) (4/9=.), gen (nivelaprob_3)
recode nivelaprob (4=1) (0/3=.) (5/9=.), gen (nivelaprob_4)
recode nivelaprob (5=1) (0/4=.) (6/9=.), gen (nivelaprob_5)
recode nivelaprob (6=1) (0/5=.) (7/9=.), gen (nivelaprob_6)
recode nivelaprob (7=1) (0/6=.) (8/9=.), gen (nivelaprob_7)
recode nivelaprob (8=1) (0/7=.) (9=.), gen (nivelaprob_8)
recode nivelaprob (9=1) (0/8=.) , gen (nivelaprob_9)

destring asis_esc nivel, replace
gen asist_1=.
replace asist_1=1 if asis_esc==1 & nivel==1
gen asist_2=.
replace asist_2=1 if asis_esc==1 & nivel==2
gen asist_3=.
replace asist_3=1 if asis_esc==1 & nivel==3
gen asist_4=.
replace asist_4=1 if asis_esc==1 & nivel==4
gen asist_5=.
replace asist_5=1 if asis_esc==1 & nivel==5
gen asist_6=.
replace asist_6=1 if asis_esc==1 & nivel==6
gen asist_7=.
replace asist_7=1 if asis_esc==1 & nivel==7
gen asist_8=.
replace asist_8=1 if asis_esc==1 & nivel==8
gen asist_9=.
replace asist_9=1 if asis_esc==1 & nivel==9




collapse (sum) atemed segpop nivelaprob_0 nivelaprob_1 nivelaprob_2 nivelaprob_3 nivelaprob_4 nivelaprob_5 nivelaprob_6 nivelaprob_7 nivelaprob_8 nivelaprob_9 ///
asist_1 asist_2 asist_3 asist_4 asist_5 asist_6 asist_7 asist_8 asist_9, by(folioviv foliohog)
tabstat atemed, stat(sum)
save "agregado poblacion x suma.dta", replace

clear all
use "concentradohogar_modificados.dta", clear

merge 1:1 folioviv foliohog using "agregado poblacion x suma.dta"
drop _merge
*list tam_hog numren
*gen pob_sin_seg_porhogar = (numren - atemed)
*tab pob_sin_seg_porhogar 

save "concentradohogar_modificados.dta", replace










clear all
use "ingresos.dta", clear



gen P032 =.
replace P032=ing_tri if clave=="P032"
tab P032

gen P033 =.
replace P033=ing_tri if clave=="P033"
tab P033


gen P034 =.
replace P034=ing_tri if clave=="P034"
tab P034

gen P035 =.
replace P035=ing_tri if clave=="P035"
tab P035
 
 gen P036 =.
replace P036=ing_tri if clave=="P036"
tab P036
 

gen P037 =.
replace P037=ing_tri if clave=="P037"
tab P037

gen P038 =.
replace P038=ing_tri if clave=="P038"
tab P038

gen P041 =.
replace P041=ing_tri if clave=="P041"
tab P041

gen P042 =.
replace P042=ing_tri if clave=="P042"
tab P042

gen P043 =.
replace P043=ing_tri if clave=="P043"
tab P043

gen P044 =.
replace P044=ing_tri if clave=="P044"
tab P044

gen P045 =.
replace P045=ing_tri if clave=="P045"
tab P045

gen P046 =.
replace P046=ing_tri if clave=="P046"
tab P046

gen P047 =.
replace P047=ing_tri if clave=="P047"
tab P047

gen P048 =.
replace P048=ing_tri if clave=="P048"
tab P048

collapse (sum) P032 P033 P034 P035 P036 P037 P038 P041 P042 P043 P044 P045 P046 P047 P048, by(folioviv foliohog numren)
save "INGRESOS TRANSFERENCIAS.dta", replace


clear all
use "poblacion.dta", clear
merge 1:1 folioviv foliohog numren using "INGRESOS TRANSFERENCIAS.dta"
drop _merge
collapse (sum) P032 P033 P034 P035 P036 P037 P038 P041 P042 P043 P044 P045 P046 P047 P048, by(folioviv foliohog)
save "nuevo agregado poblacion x suma.dta", replace

clear all
use "concentradohogar_modificados.dta", clear

merge 1:1 folioviv foliohog using "nuevo agregado poblacion x suma.dta"
drop _merge
save "concentradohogar_modificados.dta", replace









clear all
use "poblacion.dta", clear
merge 1:1 folioviv foliohog numren using "INGRESOS TRANSFERENCIAS.dta"
drop _merge

replace P032=. if P032==0
replace P033=. if P033==0
replace P034=. if P034==0
replace P035=. if P035==0
replace P036=. if P036==0
replace P037=. if P037==0
replace P038=. if P038==0
replace P041=. if P041==0
replace P042=. if P042==0
replace P043=. if P043==0
replace P044=. if P044==0
replace P045=. if P045==0
replace P046=. if P046==0
replace P047=. if P047==0
replace P048=. if P048==0

*tab P032 inscr_2
*tab P033 inscr_2

destring inst_1 inst_2 inst_3 inst_4 inst_5, replace

gen jub_todas =.
replace jub_todas =1 if P032!=. | P033!=. 

gen jub_IMSS =.
replace jub_IMSS =1 if P032!=. & inst_1==1 | P033!=. & inst_1==1
gen jub_ISSSTE =.
replace jub_ISSSTE =1 if P032!=. & inst_2==2 | P033!=. & inst_2==2
gen jub_ISSSTE_EST =.
replace jub_ISSSTE_EST =1 if P032!=. & inst_3==3 | P033!=. & inst_3==3
gen jub_PEMEX =.
replace jub_PEMEX =1 if P032!=. & inst_4==4 | P033!=. & inst_4==4
gen jub_OTRO =.
replace jub_OTRO =1 if P032!=. & inst_5==5 | P033!=. & inst_5==5

gen simul_70ymas_1salario = P044 
replace simul_70ymas_1salario =6573.6 if P044<=6573.6
*>) o menor que (<).

save "antes de cuenta y suma.dta", replace
collapse (sum) simul_70ymas_1salario , by(folioviv foliohog)
save "suma 3.dta", replace






clear all
use "concentradohogar_modificados.dta", clear

merge 1:1 folioviv foliohog using "suma 3.dta"
drop _merge
save "concentradohogar_modificados.dta", replace






clear all
use "antes de cuenta y suma.dta", clear

collapse (count) P032 P033 P034 P035 P036 P037 P038 P041 P042 P043 P044 P045 P046 P047 P048 jub_todas jub_IMSS jub_ISSSTE jub_ISSSTE_EST jub_PEMEX jub_OTRO, by(folioviv foliohog)

rename P032 P032_cuenta
rename P033 P033_cuenta
rename P034 P034_cuenta
rename P035 P035_cuenta
rename P036 P036_cuenta
rename P037 P037_cuenta
rename P038 P038_cuenta
rename P041 P041_cuenta
rename P042 P042_cuenta
rename P043 P043_cuenta
rename P044 P044_cuenta
rename P045 P045_cuenta
rename P046 P046_cuenta
rename P047 P047_cuenta
rename P048 P048_cuenta

save "nuevo agregado poblacion x count.dta", replace

clear all
use "concentradohogar_modificados.dta", clear

merge 1:1 folioviv foliohog using "nuevo agregado poblacion x count.dta"
drop _merge


save "concentradohogar_modificados.dta", replace





clear all
use "concentradohogar_modificados.dta", clear
gen urbano_rural=.
destring urbano_rural tam_loc, replace
replace urbano_rural = 0 if tam_loc== 1 | tam_loc== 2 | tam_loc== 3
replace urbano_rural = 1 if tam_loc== 4
tab urbano_rural tam_loc
keep urbano_rural folioviv foliohog
label define urbano_rural 0 "Urbano" 1 "Rural"
label values  urbano_rural  urbano_rural 
save "urbano_rural.dta", replace

clear all
use "ingresos.dta", clear
destring mes_1, replace
collapse (mean) mes_1, by(folioviv foliohog numren)
save "mes de inicio ingresos.dta", replace

clear all
use "poblacion.dta", clear
merge 1:1 folioviv foliohog numren using "mes de inicio ingresos.dta"
drop _merge
merge m:1 folioviv foliohog using "urbano_rural.dta"
drop _merge 

gen l_bienestar_min=.
replace l_bienestar_min=   950.00   if  urbano_rural==1 & mes_1==7
replace l_bienestar_min=   945.01   if  urbano_rural==1 & mes_1==8
replace l_bienestar_min=   944.99   if  urbano_rural==1 & mes_1==9
replace l_bienestar_min=   946.27   if  urbano_rural==1 & mes_1==10

replace l_bienestar_min=  1331.90  if  urbano_rural==0 & mes_1==7
replace l_bienestar_min=  1326.52  if  urbano_rural==0 & mes_1==8
replace l_bienestar_min=  1326.61  if  urbano_rural==0 & mes_1==9
replace l_bienestar_min=  1328.49  if  urbano_rural==0 & mes_1==10
tab l_bienestar_min

gen l_bienestar=.
replace l_bienestar=  1733.87  if  urbano_rural==1 & mes_1==7
replace l_bienestar=  1726.83  if  urbano_rural==1 & mes_1==8
replace l_bienestar=  1725.08  if  urbano_rural==1 & mes_1==9
replace l_bienestar=  1727.79  if  urbano_rural==1 & mes_1==10

replace l_bienestar= 2132.2 if  urbano_rural==0 & mes_1==7
replace l_bienestar= 2130.0 if  urbano_rural==0 & mes_1==8
replace l_bienestar= 2124.7 if  urbano_rural==0 & mes_1==9
replace l_bienestar= 2124.5 if  urbano_rural==0 & mes_1==10
tab l_bienestar



 collapse (mean) mes_1 l_bienestar l_bienestar_min , by(folioviv foliohog )
 
 
 
 save "lineas bienestar.dta", replace



*s mayor que (>) o menor que (<).
clear all
use "poblacion.dta", clear
gen fac_ecodeescala=.
destring numren, replace
replace fac_ecodeescala=1 if numren==1
replace fac_ecodeescala=0.70 if numren!=1 & edad<=5
replace fac_ecodeescala=0.74 if numren!=1 & edad<=12 & edad>=6
replace fac_ecodeescala=0.71 if numren!=1 & edad<=18 & edad>=13
replace fac_ecodeescala=0.99 if numren!=1 & edad>=19
tab fac_ecodeescala
merge m:1 folioviv foliohog using "lineas bienestar.dta"
gen linea_bienestar= l_bienestar*fac_ecodeescala
gen linea_bienestar_min= l_bienestar_min*fac_ecodeescala
collapse (sum) linea_bienestar linea_bienestar_min, by(folioviv foliohog )
save "lineas bienestar por hogar.dta", replace



clear all
use "concentradohogar_modificados.dta", clear
merge 1:1 folioviv foliohog using "lineas bienestar por hogar.dta"
drop _merge
save "concentradohogar_modificados.dta", replace



*ademas, meter alfabetismo y 
clear all
use "poblacion.dta", clear
destring alfabe, replace
replace alfabe=. if alfabe==1
tab alfabe

collapse (count) alfabe, by(folioviv foliohog )
save "edu alfabestismo mean.dta", replace
clear all
use "concentradohogar_modificados.dta", clear
merge 1:1 folioviv foliohog using "edu alfabestismo mean.dta"
drop _merge
save "concentradohogar_modificados.dta", replace








*******PAra 2016 esto que sigue la verdad no lo moví, volví a empezar hasta Sseguridad social

clear all
use "poblacion.dta", clear
destring numren atemed segpop, replace
replace atemed =0 if atemed==2
destring nivelaprob, replace

recode nivelaprob (0=1) (1/9=.), gen (nivelaprob_0)
recode nivelaprob (1=1) (0=.) (2/9=.), gen (nivelaprob_1)
recode nivelaprob (2=1) (0/1=.) (3/9=.), gen (nivelaprob_2)
recode nivelaprob (3=1) (0/2=.) (4/9=.), gen (nivelaprob_3)
recode nivelaprob (4=1) (0/3=.) (5/9=.), gen (nivelaprob_4)
recode nivelaprob (5=1) (0/4=.) (6/9=.), gen (nivelaprob_5)
recode nivelaprob (6=1) (0/5=.) (7/9=.), gen (nivelaprob_6)
recode nivelaprob (7=1) (0/6=.) (8/9=.), gen (nivelaprob_7)
recode nivelaprob (8=1) (0/7=.) (9=.), gen (nivelaprob_8)
recode nivelaprob (9=1) (0/8=.) , gen (nivelaprob_9)

destring nivelaprob gradoaprob asis_esc, replace
gen no_secu=0
replace no_secu=1 if nivelaprob<=2
replace no_secu=1 if nivelaprob==3 & gradoaprob<=2
 tab no_secu
 gen no_prim_completa=0
replace no_prim_completa=1 if nivelaprob<=1
replace no_prim_completa=1 if nivelaprob==2 & gradoaprob<=5
tab no_prim_completa
gen aÒo_nacimiento=2010-edad 
																							* MOVER EL A—O SEGUN ENCUESTA

gen edad6a15=0																																	
replace edad6a15=1 if edad >=6 &  edad<=15

gen edad_16omas_antes1981=0																																	
replace edad_16omas_antes1981=1 if edad >=16 & aÒo_nacimiento<=1981 

gen edad_16omas_desp1982=0																																	
replace edad_16omas_desp1982=1 if edad >=16 & aÒo_nacimiento>=1982 

gen edad6ymas=0																						
replace edad6ymas=1 if edad >=6 

gen edad3ymas=0																						
replace edad3ymas=1 if edad >=3
 
gen rezago_edu_before=0
replace rezago_edu_before=1 if edad >=6 &  edad<=15 &  asis_esc==2 
replace rezago_edu_before=0 if edad >=6 &  edad<=15 &  no_secu==0
replace rezago_edu_before=2 if edad >=16 & aÒo_nacimiento>=1982 &  no_secu==1
replace rezago_edu_before=3 if edad >=16 & aÒo_nacimiento<=1981 &  no_prim_completa==1
tab rezago_edu_before

tab edad6a15 rezago_edu_before , nof row
tab edad_16omas_antes1981 rezago_edu_before , nof row
tab edad_16omas_desp1982 rezago_edu_before , nof row


*gen rezago_edu=0
*replace rezago_edu=1 if edad >=6 &  edad<=15 &  no_secu==1
*replace rezago_edu=1 if edad >=6 &  edad<=15 &  asis_esc==2 
*replace rezago_edu=1 if edad >=16 & aÒo_nacimiento>=1982 &  no_secu==1
*replace rezago_edu=1 if edad >=16 & aÒo_nacimiento<=1981 &  no_prim_completa==1
*tab rezago_edu edad6ymas, col nof





recode rezago_edu_before (1/3=1), gen(rezago_edu)
tab rezago_edu
tab rezago_edu_before rezago_edu, cell nof

replace rezago_edu=. if rezago_edu==0
replace edad6ymas=. if edad6ymas==0
replace edad3ymas=. if edad3ymas==0

collapse (count) rezago_edu edad6ymas edad3ymas, by(folioviv foliohog)
save "rezago edu.dta", replace

clear all
use "concentradohogar_modificados", clear
merge 1:1 folioviv foliohog using "rezago edu.dta"
drop _merge
save "concentradohogar_modificados.dta", replace



************************Tomado de CONEVAL PROG y modificado************
*INDICADOR DE CARENCIA POR ACCESO A LOS SERVICIOS DE SALUD
***********************************************************************;
clear all
*Acceso a Servicios de salud por prestaciones laborales;
use "trabajos.dta", clear

*Tipo de trabajador: identifica la poblaciÛn subordinada e independiente;

*Subordinados;
gen tipo_trab=.
replace tipo_trab=1 if subor=="1"

*Independientes que reciben un pago;
replace tipo_trab=2 if subor=="2" & indep=="1" & tiene_suel=="1"
replace tipo_trab=2 if subor=="2" & indep=="2" & pago=="1"

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor=="2" & indep=="1" & tiene_suel=="2"
replace tipo_trab=3 if subor=="2" & indep=="2" & (pago=="2" | pago=="3")

*OcupaciÛn principal o secundaria;
destring id_trabajo, replace
recode id_trabajo (1=1)(2=0), gen (ocupa)

*DistinciÛn de prestaciones en trabajo principal y secundario
keep folioviv foliohog numren id_trabajo tipo_trab  ocupa
reshape wide tipo_trab ocupa, i(folioviv foliohog numren) j(id_trabajo)
label var tipo_trab1 "Tipo de trabajo 1"
label var tipo_trab2 "Tipo de trabajo 2"
label var ocupa1 "OcupaciÛn principal"
recode ocupa2 (0=1)(.=0)
label var ocupa2 "OcupaciÛn secundaria"
label define ocupa   0 "Sin ocupaciÛn secundaria" 1 "Con ocupaciÛn secundaria"
label value ocupa2 ocupa

*IdentificaciÛn de la poblaciÛn trabajadora (toda la que reporta al menos un empleo en la base de trabajos.dta)
gen trab=1
label var trab "PoblaciÛn con al menos un empleo"

keep folioviv foliohog numren trab tipo_trab*  ocupa*
sort folioviv foliohog numren
save "ocupados.dta", replace

use "poblacion.dta", clear

*PoblaciÛn objeto: no se incluye a huÈspedes ni trabajadores domÈsticos
drop if parentesco>="400" & parentesco <"500"
drop if parentesco>="700" & parentesco <"800"

sort folioviv foliohog numren
 
merge folioviv foliohog numren using "ocupados.dta"
tab _merge
drop _merge

*PEA (personas de 16 aÒos o m·s);
gen pea=.
replace pea=1 if trab==1 & (edad>=16 & edad!=.)
replace pea=2 if act_pnea1=="1" & (edad>=16 & edad!=.)
replace pea=0 if (edad>=16 & edad!=.) & act_pnea1!="1" 
label var pea "PoblaciÛn econÛmicamente activa"
label define pea 0 "PNEA"  1 "PEA: ocupada"  2 "PEA: desocupada"
label value pea pea

*Tipo de trabajo;
*OcupaciÛn principal;
replace tipo_trab1=tipo_trab1 if pea==1
replace tipo_trab1=. if (pea==0 | pea==2)
replace tipo_trab1=. if pea==.
label define tipo_trab 1"Depende de un patrÛn, jefe o superior" 2 "No depende de un jefe y tiene asignado un sueldo" 3 "No depende de un jefe y no recibe o tiene asignado un sueldo"
label value tipo_trab1 tipo_trab


*OcupaciÛn secundaria;
replace tipo_trab2=tipo_trab2 if pea==1
replace tipo_trab2=. if (pea==0 | pea==2)
replace tipo_trab2=. if pea==.
label value tipo_trab2 tipo_trab



*Servicios mÈdicos prestaciones laborales ;

*OcupaciÛn principal;
gen smlab1=.
replace smlab1=1 if ocupa1==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" |  inst_3=="3" | inst_4=="4") & (inscr_1=="1")
recode smlab1 (.=0) if ocupa1==1
label var smlab1 "Servicios mÈdicos por prestaciÛn laboral en ocupaciÛn principal"
label define smlab 0 "Sin servicios mÈdicos"  1 "Con servicios mÈdicos"
label value smlab1 smlab
tab smlab1 

*OcupaciÛn secundaria;
gen smlab2=.
replace smlab2=1 if ocupa2==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") & (inscr_1=="1")
recode smlab2 (.=0) if ocupa2==1
label var smlab2 "Servicios mÈdicos por prestaciÛn laboral en ocupaciÛn secundaria"
label value smlab2 smlab
tab smlab2 
tab smlab2 smlab1

*ContrataciÛn voluntaria de servicios mÈdicos;

gen smcv=.
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") & (inscr_6=="6") & (edad>=12 & edad<=97)
recode smcv (.=0) if (edad>=12 & edad<=97)
label var smcv "Servicios mÈdicos por contrataciÛn voluntaria"
label define cuenta 0 "No cuenta"  1 "SÌ cuenta"
label value smcv cuenta

*Acceso directo a servicios de salud;

gen sa_dir=.
*OcupaciÛn principal;
replace sa_dir=1 if tipo_trab1==1 & (smlab1==1)
replace sa_dir=1 if tipo_trab1==2 & (smlab1==1 | smcv==1)
replace sa_dir=1 if tipo_trab1==3 & (smlab1==1 | smcv==1)
*OcupaciÛn secundaria;
replace sa_dir=1 if tipo_trab2==1 & (smlab2==1)
replace sa_dir=1 if tipo_trab2==2 & (smlab2==1 | smcv==1)
replace sa_dir=1 if tipo_trab2==3 & (smlab2==1 | smcv==1)

*N˙cleos familiares;
gen par=.
replace par=1 if (parentesco>="100" & parentesco<"200")
replace par=2 if (parentesco>="200" & parentesco<"300")
replace par=3 if (parentesco>="300" & parentesco<"400")
replace par=4 if parentesco=="601"
replace par=5 if parentesco=="615"
recode par (.=6) if  par==.
label var par "Integrantes que tienen acceso por otros miembros"
label define par       1 "Jefe o jefa del hogar"  ///
                       2 "CÛnyuge del  jefe/a"  ///
                       3 "Hijo del jefe/a"  ///
                       4 "Padre o Madre del jefe/a" ///
                       5 "Suegro del jefe/a" ///
                       6 "Sin parentesco directo"
label value par par
tab par

*Asimismo, se utilizar· la informaciÛn relativa a la asistencia a la escuela;
gen inas_esc=.
replace inas_esc=0 if asis_esc=="1"
replace inas_esc=1 if asis_esc=="2"
label var inas_esc "Inasistencia a la escuela"
label define inas_esc  0 "SÌ asiste"  1 "No asiste"
label value inas_esc inas_esc

*En primer lugar se identifican los principales parentescos respecto a la jefatura del hogar y si ese miembro cuenta con acceso directo;

gen jef=1 if par==1 & sa_dir==1
replace jef=. if par==1 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1=="" & inst_4=="" & inst_5=="") & (inscr_1=="" & inscr_2=="" & inscr_3=="" & inscr_4=="" & inscr_5=="" & inscr_7==""))
gen cony=1 if par==2 & sa_dir==1
replace cony=. if par==2 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1=="" & inst_4=="" & inst_5=="") & (inscr_1=="" & inscr_2=="" & inscr_3=="" & inscr_4=="" & inscr_5=="" & inscr_7==""))
gen hijo=1 if par==3 & sa_dir==1  
replace hijo=. if par==3 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6") & (inst_1=="" & inst_4=="" & inst_5=="") & (inscr_1=="" & inscr_2=="" & inscr_3=="" & inscr_4=="" & inscr_5=="" & inscr_7==""))

egen jef_sa=sum(jef), by(folioviv foliohog)
egen cony_sa=sum(cony), by(folioviv foliohog)
replace cony_sa=1 if cony_sa>=1 & cony_sa!=.
egen hijo_sa=sum(hijo), by(folioviv foliohog)
replace hijo_sa=1 if hijo_sa>=1 & hijo_sa!=.

label var jef_sa "Acceso directo a servicios de salud de la jefatura del hogar"
label value jef_sa cuenta
tab jef_sa 
label var cony_sa "Acceso directo a servicios de salud del conyuge de la jefatura del hogar"
label value cony_sa cuenta
tab cony_sa 
label var hijo_sa "Acceso directo a servicios de salud de hijos(as) de la jefatura del hogar"
label value hijo_sa cuenta
tab hijo_sa 

*Otros n˙cleos familiares: se identifica a la poblaciÛn con acceso a servicios de salud mediante otros n˙cleos familiares a travÈs de la afiliaciÛn o inscripciÛn a servicios de salud por alg˙n familiar dentro o 
*fuera del hogar, muerte del asegurado o por contrataciÛn propia;

gen s_salud=.
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") & (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" | inscr_7=="7")
recode s_salud (.=0) if segpop!="" & atemed!=""
label var s_salud "Servicios mÈdicos por otros n˙cleos familiares o por contrataciÛn propia"
label value s_salud cuenta
tab s_salud 


*Indicador de carencia por servicios de salud;
*****************************************************************************
*Se considera en situaciÛn de carencia por acceso a servicios de salud
*a la poblaciÛn que:

*1. No se encuentra afiliada o inscrita al Seguro Popular o alguna 
*instituciÛn que proporcione servicios mÈdicos, ya sea por prestaciÛn laboral,
*contrataciÛn voluntaria o afiliaciÛn de un familiar por parentesco directo 

*****************************************************************************;


*Indicador de carencia por acceso a la servicios de salud;
gen ic_asalud=.
*Acceso directo;
replace ic_asalud=0 if sa_dir==1
*Parentesco directo: jefatura;
replace ic_asalud=0 if par==1 & cony_sa==1
replace ic_asalud=0 if par==1 & pea==0 & hijo_sa==1
*Parentesco directo: cÛnyuge;
replace ic_asalud=0 if par==2 & jef_sa==1
replace ic_asalud=0 if par==2 & pea==0 & hijo_sa==1
*Parentesco directo: descendientes;
replace ic_asalud=0 if par==3 & edad<16 & jef_sa==1
replace ic_asalud=0 if par==3 & edad<16 & cony_sa==1
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & jef_sa==1
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & cony_sa==1
*Parentesco directo: ascendientes;
replace ic_asalud=0 if par==4 & pea==0 & jef_sa==1
replace ic_asalud=0 if par==5 & pea==0 & cony_sa==1
*Otros n˙cleos familiares;
replace ic_asalud=0 if s_salud==1
*Acceso reportado;
replace ic_asalud=0 if segpop=="1" | (segpop=="2" & atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" | inst_5=="5" | inst_6=="6")) | segvol_2=="2"
recode ic_asalud .=1



*Instituciones que brindan el servicio de salud;
gen serv_sal=.
replace serv_sal=0 if segpop=="2" & atemed=="2"
replace serv_sal=1 if segpop=="1"
replace serv_sal=2 if atemed=="1" & inst_1=="1"
replace serv_sal=3 if atemed=="1" & inst_2=="2"
replace serv_sal=3 if atemed=="1" & inst_3=="3"
replace serv_sal=4 if atemed=="1" & inst_4=="4"
replace serv_sal=5 if serv_sal==0 & ic_asalud==0
replace serv_sal=6 if segvol_2=="2"
replace serv_sal=7 if atemed=="1" & inst_5=="5"
replace serv_sal=8 if atemed=="1" & inst_6=="6"

label var serv_sal "Servicios de salud"
label define serv_sal       0 "No cuenta con servicios mÈdicos"  ///
									1 "Seguro Popular" ///
									2 "IMSS" ///
									3 "ISSSTE o ISSSTE estatal"  ///
									4 "Pemex, Defensa o Marina"  ///
									5 "Otros servicios mÈdicos por seguridad social"  ///
									6 "Seguro privado de gastos mÈdicos" ///
									7 "IMSS-Prospera" ///
									8 "Otros"

label values 				 serv_sal  serv_sal 
tab serv_sal         


label var ic_asalud "Indicador de carencia por acceso a servicios de salud"
label value serv_sal serv_sal
label define caren  0 "No presenta carencia" 1 "Presenta carencia"
label value ic_asalud caren
tab ic_asalud 
tab serv_sal   ic_asalud  

tab atemed ic_asalud  
tab atemed ic_asalud  , nof cell
destring atemed segpop segvol_2, replace
recode atemed (2=0), gen(atemed_mas_segpop)
tab atemed_mas_segpop
tab atemed segpop
replace atemed_mas_segpop=1 if segpop==1
tab atemed_mas_segpop
gen atemed_mas_segpop_mas_volunt = atemed_mas_segpop
replace atemed_mas_segpop_mas_volunt =1 if segvol_2==2
tab atemed_mas_segpop_mas_volunt 
tab atemed_mas_segpop_mas_volunt  ic_asalud

gen igualtiene=.
label var igualtiene "Cuenta con fam directo asegurado, pero igual no reportÛ atenciÛn mÈdica"
replace igualtiene=1 if (jef_sa==1 | cony_sa==1 | hijo_sa==1 ) & (atemed_mas_segpop_mas_volunt ==0  & ic_asalud==0)
list segpop edad if igualtiene==1
tab igualtiene serv_sal 
tab serv_sal 

tab serv_sal ic_asalud

*No tener seg social;
gen sin_segsocial=1
replace sin_segsocial=0 if atemed==1 & inst_1=="1"
replace sin_segsocial=0 if atemed==1 & inst_2=="2"
replace sin_segsocial=0 if atemed==1 & inst_3=="3"
replace sin_segsocial=0 if atemed==1 & inst_4=="4"
replace sin_segsocial=0 if atemed==1 & inst_6=="6"

label var sin_segsocial "No tener seguro social"
label define sin_segsocial       0 "Cuenta con servicios médicos"  ///
									1 "No Cuenta con servicios médicos" ///
								

label values 				 sin_segsocial sin_segsocial
tab sin_segsocial 

preserve
keep folioviv foliohog numren sin_segsocial serv_sal
save "sinsegsocial.dta", replace
restore


keep folioviv foliohog numren sexo edad serv_sal ic_asalud sa_* *_sa segpop atemed inst_* inscr_* segvol_* sin_segsocial 
sort folioviv foliohog numren
save "ic_asalud.dta", replace



clear all
use "ic_asalud.dta", clear
tab serv_sal ic_asalud

*preparar servicios de salud para colpasarlos
gen a_notiene=1 if serv_sal==0
gen a_segpo=1 if serv_sal==0

*Comprobar seguro Popular
tab segpop atemed
tab segpop
gen segpop_fam =.
replace segpop_fam =1 if segpop==1
tab segpop_fam 
*tab atmed_segpop segpop_fam

gen atmed_notiene=1 			if serv_sal==0
gen atmed_segpop=1 				if serv_sal==1
gen atmed_imss=1    			if serv_sal==2
gen atmed_issste=1  			if serv_sal==3
gen atmed_pemex=1 				if serv_sal==4
gen atmed_otrasegosocial=1 		if serv_sal==5
gen atmed_segvol=1 				if serv_sal==6
gen atmed_IMSS_Prospera=1 				if serv_sal==7
gen atmed_otros=1 				if serv_sal==8
tab serv_sal


*comprobaciÛn de las dos variables que tengo para seguro popular
tab segpop_fam
tab atmed_segpop
tab segpop_fam atmed_segpop
*keep if atmed_segpop==. & segpop_fam ==1
*esta diferencia que me sale, los extras de SEG Pop FAM son los que tienen seguro popular e IMSS u otra seguridad social al mismo tiempo
rename segpop_fam segpop_y_otrasegsocial

gen poblacion_prueba=1

destring inst_*, replace

replace inst_2=1 if inst_2==2
replace inst_3=1 if inst_3==3
replace inst_4=1 if inst_4==4
replace inst_5=1 if inst_5==5
replace inst_6=1 if inst_6==6



collapse (sum) ic_asalud sa_* *_sa  atmed_*  segpop_y_otrasegsocial  poblacion_prueba inst_*, by(folioviv foliohog)


save "nuevo nuevo agregado poblacion x suma.dta", replace

clear all
use "concentradohogar_modificados.dta", clear
merge 1:1 folioviv foliohog using "nuevo nuevo agregado poblacion x suma.dta"
drop _merge
save "concentradohogar_modificados.dta", replace


****************************************
*Cálculo de ciudadanias diferenciadas
*cálculo ciudadania chafa
clear all
use "antes de cuenta y suma.dta", clear

gen inas_esc=.
replace inas_esc=0 if asis_esc=="1"
replace inas_esc=1 if asis_esc=="2"
label var inas_esc "Inasistencia a la escuela"
label define inas_esc  0 "SÌ asiste"  1 "No asiste"
label value inas_esc inas_esc

gen par=.
replace par=1 if (parentesco>="100" & parentesco<"200")
replace par=2 if (parentesco>="200" & parentesco<"300")
replace par=3 if (parentesco>="300" & parentesco<"400")
replace par=4 if parentesco=="601"
replace par=5 if parentesco=="615"
recode par (.=6) if  par==.
label var par "Integrantes que tienen acceso por otros miembros"
label define par       1 "Jefe o jefa del hogar"  ///
                       2 "CÛnyuge del  jefe/a"  ///
                       3 "Hijo del jefe/a"  ///
                       4 "Padre o Madre del jefe/a" ///
                       5 "Suegro del jefe/a" ///
                       6 "Sin parentesco directo"
label value par par
tab par

gen benef_polsoc_residu= .
replace benef_polsoc_residu= 1 if P044!=. &  P044!=0
replace benef_polsoc_residu= 1 if P046!=. &  P046!=0
replace benef_polsoc_residu= 1 if P043!=. &  P043!=0
gen polsocresidu_sinimportarSP= benef_polsoc_residu
destring segpop, replace
tab benef_polsoc_residu segpop
replace benef_polsoc_residu= 1 if segpop==1
tab benef_polsoc_residu polsocresidu_sinimportarSP
tab benef_polsoc_residu  segpop

gen oportunid_receptor=1 if P042!=. &  P042!=0
egen jef_op=sum(oportunid_receptor), by(folioviv foliohog)
gen oportuni_todos=.
destring paren edad inas_esc, replace
replace oportuni_todos=1 if  jef_op>=1 & paren==3 & edad<=18 & inas_esc==0

****
merge 1:1 folioviv foliohog numren using "sinsegsocial.dta"
gen sin_segsocial_sinPSprecaria=0
replace sin_segsocial_sinPSprecaria=1 if sin_segsocial==1
replace sin_segsocial_sinPSprecaria=0 if benef_polsoc_residu==1
tab sin_segsocial_sinPSprecaria
gen tipo_ciudadania=1
replace tipo_ciudadania=1 if sin_segsocial_sinPSprecaria==1
replace tipo_ciudadania=2 if benef_polsoc_residu==1
replace tipo_ciudadania=3 if serv_sal==2 | serv_sal==3 | serv_sal==4 | serv_sal==5
replace tipo_ciudadania=4 if serv_sal==6
tab tipo_ciudadania

gen tipo_ciudadania_1=1 if tipo_ciudadania==1

gen tipo_ciudadania_2=1 if tipo_ciudadania==2
gen tipo_ciudadania_3=1 if tipo_ciudadania==3
gen tipo_ciudadania_4=1 if tipo_ciudadania==4

gen tipo_ciudadania_1_5 = 1 if polsocresidu_sinimportarSP==1

*****

tab tipo_ciudadania_1_5 tipo_ciudadania


 collapse (sum) benef_polsoc_residu sin_segsocial_sinPSprecaria tipo_ciudadania_* polsocresidu_sinimportarSP, by(folioviv foliohog)
 
 save "para ciudadanias diferenciadas.dta", replace





**************************************************************************
*****************************trabajo tablas******************************
**************************************************************************

* Carpete de trabajo UBUNTU
*cd "/home/maxernesth/Escritorio/encuestas/ENIGH Vieja Construccion/2014/bases"

* Carpete de trabajo Oxfam
*cd "\\OMXFILE01\UserFiles$\maximojaramillo\Documents\Encuestas\ENIGH Vieja Construccion\2016\bases"

* Carpete de trabajo Mac
*cd "/Users/Maxernsth/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases"

* Carpeta trabajo EVALÚA CDMX
cd "~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases/Prof Enrique"


clear all
use "concentradohogar_modificados.dta", clear

gen urbano_rural=.
destring tam_loc, replace
replace urbano_rural = 0 if tam_loc== 1 | tam_loc== 2 | tam_loc== 3
replace urbano_rural = 1 if tam_loc== 4
tab urbano_rural tam_loc
label define tam_loc 1 "100k o más" 2 "15k a 99,999" 3 "2.5k a 14,999" 4 "Menos de 2.5k" 
label values tam_loc  tam_loc
tab tam_loc
gen edo=substr(ubica_geo, 1, 2)
***************************crear deciles de hogares ingreso corriente
rename ing_cor ingcor
xtile ingcor_decil  [fw=factor] = ingcor , nquantiles(10)
xtile ingcor_decil_NO   = ingcor , nquantiles(10)
tab ingcor_decil ingcor_decil_NO
xtile ingcor_percentil  [fw=factor] = ingcor , nquantiles(100)
xtile ingcor_quintil  [fw=factor] = ingcor , nquantiles(5)




*svyset upm, strata(est_dis) weight(factor) vce(linearized) singleunit(missing)

tabstat ingcor [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )


/*
xtile ingmon_decil  [fw=factor] = ing_mon , nquantiles(10)
xtile ingmon_percentil  [fw=factor] = ing_mon , nquantiles(100)
*/
*********cifras ya *****************
*pob total
*destring tot_resi, replace 
*tab tot_resi [fw=factor]
*tabstat  tot_resi [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
*tabstat  tot_resi [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )

rename tot_integ tam_hog
																														**************tabla 1
tabstat  mayores [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat mayores [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
																														**************

																														

tabstat p65mas [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat p65mas [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
																														
																														
																														
																														
																														**************tabla 2
tabstat  tam_hog [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat tam_hog [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )


tabstat  poblacion_prueba [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat poblacion_prueba [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat poblacion_prueba [fw=factor], by(tam_loc)  stat(sum )  format( %12.2fc )
		
																												**************
																														
																														**************tabla 3																														
tabstat  tam_hog [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
tabstat tam_hog [fw=factor], by(urbano_rural )  stat(mean)  format( %12.2fc )
																														**************
																														
																														

*tabstat  gasmon [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
*tabstat  salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )



*numero hogares
gen num_hog=1
																														**************tabla 4	
tabstat  num_hog [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )
tabstat  num_hog [fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
																														**************

																														
/*																														**************tabla 5
*ingreso corriente monetario promedio por hogar
tabstat  ing_mon [fw=factor], by(ingmon_decil )  stat(mean) format
tabstat  ing_mon [fw=factor], by(urbano_rural )  stat(mean) format
tabstat  ing_mon [fw=factor], by(ingmon_percentil )  stat(mean) format
*/
																														**************
																														
					
*ingreso corriente total sumado por deciles
tabstat ingcor [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )					
					
					

tab  atemed
sort ingcor


************************************************************************************
*afiliaciones a insrituciones de salud
*****************************************************************************************


																														**************tabla 6
*afiliaciÛn inst salud

*probar diferentes aproximaciones a este indicador
gen atmed_cualquiera= atmed_imss + atmed_issste + atmed_pemex + atmed_otros + atmed_otrasegosocial
tab atmed_cualquiera
tab atemed
	*La diferencia en ambos se debe a los que tienen seguro privado voluntario y al mismo tiempo seguridad social. Usar el de atemed "Normal".

tabstat atemed [fw=factor], by(ingcor_decil )  stat(sum )  format( %12.2fc )
tabstat atemed [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini atemed [fw=factor], sortvar(ingcor) 
																														**************

																														
																														
																														**************tabla 7
*imss
tabstat inst_1 [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat inst_1 [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat inst_1 [fw=factor], by(tam_loc)  stat(sum )  format( %12.2fc )
sgini inst_1 [fw=factor], sortvar(ingcor) 

tab atmed_imss
tab inst_1
tab segvol_2
	*Nuevamente la diferencia tiene que ver con lo se segvol_2, seguro privado. Usar inst_1.
 																														**************

																														
																														**************tabla 8																														
*issste
gen issste_sum = inst_2 + inst_3
tabstat issste_sum [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat issste_sum [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat issste_sum [fw=factor], by(tam_loc)  stat(sum )  format( %12.2fc )
sgini issste_sum  [fw=factor], sortvar(ingcor)

tab atmed_issste
tab issste_sum 
tab segvol_2
	*Nuevamente la diferencia tiene que ver con lo se segvol_2, seguro privado. Usar inst_3 y 4 (issste_sum).
																														**************

																													**************tabla 9
*pemex defensa y marina
tabstat inst_4 [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat inst_4 [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat inst_4 [fw=factor], by(tam_loc )  stat(sum )  format( %12.2fc )
sgini inst_4  [fw=factor], sortvar(ingcor)

tab atmed_pemex
tab inst_4
tab segvol_2
	*Nuevamente la diferencia tiene que ver con lo se segvol_2, seguro privado. Usar inst_4.
																														**************
																														
																														
																														**************tabla 10																														
*otro
tabstat inst_6 [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat inst_6 [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat inst_6 [fw=factor], by(tam_loc )  stat(sum )  format( %12.2fc )
sgini inst_6 [fw=factor], sortvar(ingcor)

tab atmed_otros
tab inst_6
tab segvol_2
	*Nuevamente la diferencia tiene que ver con lo se segvol_2, seguro privado. Usar inst_5.

																																
																														**************tabla 10.A																														
*Pemex  + Otros
gen inst_Otros= inst_6+ inst_4
tabstat inst_Otros [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat inst_Otros [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini inst_Otros [fw=factor], sortvar(ingcor)
	
																														**************tabla 10.B																														
*IMSS-Prospera
tabstat inst_5 [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat inst_5 [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini inst_5 [fw=factor], sortvar(ingcor)

tab atmed_otros
tab inst_5
tab segvol_2
	*Nuevamente la diferencia tiene que ver con lo se segvol_2, seguro privado. Usar inst_5.
																														**************


																														**************tabla 11																														
*segpop

tabstat segpop_y_otrasegsocial [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat segpop_y_otrasegsocial[fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
tabstat segpop_y_otrasegsocial[fw=factor], by(tam_loc )  stat(sum )  format( %12.2fc )
sgini segpop_y_otrasegsocial [fw=factor], sortvar(ingcor)

tab segpop_y_otrasegsocial
tab atmed_segpop
	*Lla diferencia tiene que ver con las que tienen seg pop y alguna otra afiliacion a seguridad social. Usar segpop_y_otrasegsocial, que da el total de afiliados.
																														**************

																														
																														
																														
																														**************tabla 12
*Se atiende en Consultorios privados
tabstat servmed_8 [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat servmed_8  [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini servmed_8  [fw=factor], sortvar(ingcor)
																														**************
/*

																														**************tabla 13																														
*De IMSS que se atiende en privados
tabstat priv_if_imss [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat priv_if_imss  [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini priv_if_imss   [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 14																														
*De SegPop que se atiende en privados
tabstat priv_if_segpop [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat priv_if_segpop [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini priv_if_segpop  [fw=factor], sortvar(ingcor)
																														**************


																														**************tabla 15																														
*De SegPop que se atiende en simi
tabstat simi_if_segpop  [fw=factor], by(ingcor_decil )  stat(sum ) format( %12.2fc )
tabstat simi_if_segpop [fw=factor], by(urbano_rural )  stat(sum )  format( %12.2fc )
sgini simi_if_segpop [fw=factor], sortvar(ingcor)
																														**************
	*/																													
																														
/*
*poblaciÛn en hogares con al menos un asegurado IMSS, y que no tiene IMSS
gen  pobxhogar_sin_imss = tam_hog - inst_1
label var pobxhogar_sin_imss  "PoblaciÛn sin IMSS, x hogar, hogares con al menos 1 asegurado al IMSS "
tab  pobxhogar_sin_imss 
replace  pobxhogar_sin_imss =. if inst_1==0
replace  pobxhogar_sin_imss =. if pobxhogar_sin_imss ==0
tab  pobxhogar_sin_imss  [fw=factor]

tab inst_1 [fw=factor]
tab inst_1 

**************
*gasto en salud
*******************

																														**************tabla 16
*gasto en salud, por hogar
tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
tabstat salud [fw=factor], by(urbano_rural )  stat(mean) format( %12.2fc )
																														**************

																														**************tabla 
*1
gen g_salud_imss = salud/inst_1
list  g_salud_imss  salud inst_1
tabstat g_salud_imss  [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
																														**************


*gasto en salud percapita, total
gen saludpercapita = salud / tam_hog
label var saludpercapita "Gasto en salud per capita"
																														**************tabla 22
tabstat saludpercapita  [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
tabstat saludpercapita  [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************


*gasto salud por habitante con al menos 1 integrante en el IMSS
gen hog_almenos_1hab_IMSS=.
label var hog_almenos_1hab_IMSS "Hogares con al menos 1 integrante asegurado al IMSS"
replace hog_almenos_1hab_IMSS=1 if inst_1>=1
tab hog_almenos_1hab_IMSS

																														**************tabla 23
sort hog_almenos_1hab_IMSS
by hog_almenos_1hab_IMSS: tabstat saludpercapita [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_almenos_1hab_IMSS: tabstat saludpercapita [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************

																														**************tabla 17
by hog_almenos_1hab_IMSS: tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_almenos_1hab_IMSS: tabstat salud [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
																														
																														

*gasto por habitante de hogares con al menos 1 integrante en el ISSSTE
gen hog_almenos_1hab_ISSSTE=.
label var hog_almenos_1hab_ISSSTE "Hogares con al menos 1 integrante asegurado al ISSSTE"
replace hog_almenos_1hab_ISSSTE=1 if inst_2>=1 | inst_3>=1 
tab hog_almenos_1hab_ISSSTE

																														**************tabla 24
	sort hog_almenos_1hab_ISSSTE
	by hog_almenos_1hab_ISSSTE: tabstat saludpercapita [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
	by hog_almenos_1hab_ISSSTE: tabstat saludpercapita [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
																														
																															**************tabla 18
by hog_almenos_1hab_ISSSTE: tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_almenos_1hab_ISSSTE: tabstat salud [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************	
	
*gasto por habitante de hogares con al menos 1 integrante en PEMEX
gen hog_almenos_1hab_PEMEX=.
label var hog_almenos_1hab_PEMEX "Hogares con al menos 1 integrante asegurado al PEMEX"
replace hog_almenos_1hab_PEMEX=1 if inst_4>=1 
tab hog_almenos_1hab_PEMEX

																														**************tabla 25
sort hog_almenos_1hab_PEMEX
by hog_almenos_1hab_PEMEX: tabstat saludpercapita [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_almenos_1hab_PEMEX: tabstat saludpercapita [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************

																														**************tabla 19
by hog_almenos_1hab_PEMEX: tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_almenos_1hab_PEMEX: tabstat salud [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
	
*gasto por habitante de hogares con al menos 1 integrante en seg pop
gen hog_almenos_1hab_SEGPOP=.
label var hog_almenos_1hab_SEGPOP "Hogares con al menos 1 integrante asegurado al SEGPOP"
replace hog_almenos_1hab_SEGPOP=1 if segpop_fam >=1 
tab hog_almenos_1hab_SEGPOP

																														**************tabla 26
	sort hog_almenos_1hab_SEGPOP
	by hog_almenos_1hab_SEGPOP: tabstat saludpercapita [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
	by hog_almenos_1hab_SEGPOP: tabstat saludpercapita [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
																														
																														
																														**************tabla 20	
by hog_almenos_1hab_SEGPOP: tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %18.0fc )
by hog_almenos_1hab_SEGPOP: tabstat salud [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
	
*gasto por habitante de hogares con 0 integrantes asegurados
gen hog_con_cero_asegurados_a_nada=.
label var hog_con_cero_asegurados_a_nada "Hogares con cero asegurados a inst. de seg. social o salud"
replace hog_con_cero_asegurados_a_nada=1 if segpop_fam ==0 & inst_4==0 & inst_3==0 & inst_2==0 & inst_1==0
tab hog_con_cero_asegurados_a_nada 
tab hog_con_cero_asegurados_a_nada [fw=factor]


																														**************tabla 27
	sort hog_con_cero_asegurados_a_nada
	by hog_con_cero_asegurados_a_nada: tabstat saludpercapita [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
	by hog_con_cero_asegurados_a_nada: tabstat saludpercapita [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
	
																														**************tabla 21	
by hog_con_cero_asegurados_a_nada: tabstat salud [fw=factor], by(ingcor_decil )  stat(mean) format( %12.2fc )
by hog_con_cero_asegurados_a_nada: tabstat salud [fw=factor], by(urbano_rural)  stat(mean) format( %12.2fc )
																														**************
*/


*afilaidos a instituciones, total
																														**************tabla 28 tabla 29 tabla 30
																														
   
tabstat atmed_notiene  		[fw=factor],  stat(sum) format( %12.2fc )										
										
tabstat atmed_segpop  		[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat atmed_imss  			[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat atmed_issste   		[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat atmed_pemex 		[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )

tabstat atmed_segvol 		[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )

tabstat atmed_otros			[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )

tabstat atmed_otrasegosocial	[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat poblacion_prueba 	[fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
 

**tabstat tam_hog [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
*tabstat mayores [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
*tabstat hog_con_cero_asegurados_a_nada  [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
																														**************
*****************************************
**********seguridad privada     tabla 31**************
**********************************
tabstat segvol_2 [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat segvol_2 [fw=factor], by(urbano_rural)  stat(sum) format( %12.2fc )
sgini segvol_2 [fw=factor], sortvar(ingcor)

	*Lla diferencia entre segvol_2 y atmed_segvol tiene que ver con los que al mimso tiempo tienen seg. voluntario y se3guridad social. Usar seg_vol2, que da el total de afiliados a seguridad social.

**********************************
**********afores   tabla 32**************
**********************************
tabstat segvol_1 [fw=factor], by(ingcor_decil )  stat(sum) format( %12.2fc )
tabstat segvol_1 [fw=factor], by(urbano_rural)  stat(sum) format( %12.2fc )
sgini segvol_1 [fw=factor], sortvar(ingcor)




*****************************************
**********jubliaciones y pensiones  tabla 33**************
**********************************
replace P033 =0 if P033==.
replace P032 =0 if P032==. 
*gen jubilacion=P032+P033
tabstat jubilacion [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )
tabstat jubilacion [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat jubilacion [fw=factor], by(tam_loc)  stat(sum)  format( %14.2fc )
sgini jubilacion [fw=factor], sortvar(ingcor)


******************************************************
***transferencias jubilaciones
******************************************************
																														**************tabla 34
gen t_jubilacion=P032_cuenta +P033_cuenta
tabstat t_jubilacion[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat t_jubilacion[fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini t_jubilacion [fw=factor], sortvar(ingcor)
																														**************


tabstat P033_cuenta[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P033_cuenta[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini P033_cuenta [fw=factor], sortvar(ingcor)

gen pensiones_todas= P033_cuenta + P032_cuenta
tabstat pensiones_todas[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat pensiones_todas[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini pensiones_todas[fw=factor], sortvar(ingcor)

tabstat jub_todas [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_todas [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini jub_todas [fw=factor], sortvar(ingcor)




*simulaciÛn
*replace P033 =0 if P033==.
*replace P032 =0 if P032==. 
gen jub_monto=P033 + P032	
tabstat jub_monto[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_monto[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini jub_monto[fw=factor], sortvar(ingcor)

																														**************tabla 35
tabstat jub_monto[fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat jub_monto[fw=factor], by(urbano_rural )  stat(mean) format( %14.2fc )
																														**************

																														
																														**************tabla 36
tabstat ingcor [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat ingcor [fw=factor], by(urbano_rural)  stat(mean) format( %14.2fc )
gen ingcor_sinjubs = ingcor-jub_monto
tabstat ingcor_sinjubs [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat ingcor_sinjubs [fw=factor], by(urbano_rural)  stat(mean) format( %14.2fc )
																														**************

																														**************tabla 37
replace jub_monto=0 if jub_monto==.
sgini ingcor [fw=factor], 
*gen ingcor_sinjubs = ingcor-jub_monto

sgini ingcor_sinjubs [fw=factor], 
																														**************
***


																														**************tabla 38
tabstat jub_IMSS [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_IMSS [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini jub_IMSS  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 39																														
gen jub_ISSSTE_Ambos=jub_ISSSTE+jub_ISSSTE_EST
tabstat jub_ISSSTE_Ambos [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_ISSSTE_Ambos [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini jub_ISSSTE_Ambos [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 40																														
tabstat jub_PEMEX [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_PEMEX [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini jub_PEMEX  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 41																														
tabstat jub_OTRO [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat jub_OTRO [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini jub_OTRO [fw=factor], sortvar(ingcor)
																														**************
******************************************************
***indeminzaciones
******************************************************
																														**************tabla 42
tabstat P036_cuenta[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P036_cuenta[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini P036_cuenta[fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 43																														
tabstat P036[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P036[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini P036[fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 43.A																														
replace P036=. if P036 ==0 
tabstat P036[fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat P036[fw=factor], by(urbano_rural )  stat(mean) format( %14.2fc )
																														**************

																														
******************************************************
***becas
******************************************************
																														**************tabla 44
tabstat P038_cuenta[fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P038_cuenta[fw=factor], by(urbano_rural )  stat(sum) format( %14.2fc )
sgini P038_cuenta[fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 45 																														
tabstat P038 [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P038 [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini P038 [fw=factor], sortvar(ingcor)

																														**************tabla 46
replace P038=. if P038 ==0 
tabstat P038 [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat P038 [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
																														**************


******************************************************
***adultos mayores
******************************************************
																														**************tabla 47
tabstat P044_cuenta [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P044_cuenta [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini P044_cuenta  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 49																													
tabstat P044 [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P044  [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat P044  [fw=factor], by(tam_loc )  stat(sum)  format( %14.2fc )
sgini P044  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 48																														
replace P044=. if P044 ==0 
tabstat P044 [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat P044 [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
replace P044 =0 if P044 ==.
																														**************

																														**************tabla 50																														
*simulaciÛn

*replace P044 =0 if P044 ==.
sgini ingcor [fw=factor], 
gen ingcor_sin70ymas = ingcor-P044 
sgini ingcor_sin70ymas [fw=factor], 
gen ingcor_consimilacion70ymas = ingcor-P044+simul_70ymas_1salario
sgini ingcor_consimilacion70ymas [fw=factor], 
																														**************

******************************************************
***Oportunidades
******************************************************
																														**************tabla 51
tabstat P042_cuenta [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P042_cuenta [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini P042_cuenta  [fw=factor], sortvar(ingcor)
tabstat P042_cuenta [fw=factor], by( ingcor_percentil)  stat(mean)  format( %14.2fc )																													

																														**************tabla 52																														
tabstat P042 [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P042  [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat P042  [fw=factor], by(tam_loc)  stat(sum)  format( %14.2fc )
sgini P042  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 53																														
replace P042=. if P042 ==0 
tabstat P042 [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat P042 [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
replace P042 =0 if P042 ==.
																														**************

*simulaciÛn calculo de pobreza sin Oportunidades
*replace P042 =0 if P042 ==.
																														**************tabla 54
sgini ingcor [fw=factor], 
gen ingcor_sinOportunidades = ingcor-P042 
sgini ingcor_sinOportunidades [fw=factor], 
																														**************

																														**************tabla 55
tabstat ingcor [fw=factor], by(ingcor_decil )  stat(mean)  format( %14.2fc )
tabstat ingcor [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
tabstat ingcor_sinOportunidades  [fw=factor], by(ingcor_decil )  stat(mean)  format( %14.2fc )
tabstat ingcor_sinOportunidades  [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
																														**************


																														
gen linea_bienestar_trim=linea_bienestar*3
gen linea_bienestar_min_trim=linea_bienestar_min*3

																														**************tabla 56
gen pobreza=.
replace pobreza=1 if ingcor<=linea_bienestar_trim
replace pobreza=0 if ingcor>=linea_bienestar_trim
tab pobreza [fw=factor]

gen pobreza_sinOport=.
replace pobreza_sinOport=1 if ingcor_sinOportunidades  <=linea_bienestar_trim
replace pobreza_sinOport=0 if ingcor_sinOportunidades  >=linea_bienestar_trim
tab pobreza_sinOport[fw=factor]
																														**************

																														**************tabla 57																														
gen pobreza_Ext=.
replace pobreza_Ext=1 if ingcor<=linea_bienestar_min_trim
replace pobreza_Ext=0 if ingcor>=linea_bienestar_min_trim
tab pobreza_Ext [fw=factor]

gen pobreza_Ext_sinOport=.
replace pobreza_Ext_sinOport=1 if ingcor_sinOportunidades  <=linea_bienestar_min_trim
replace pobreza_Ext_sinOport=0 if ingcor_sinOportunidades  >=linea_bienestar_min_trim
tab pobreza_Ext_sinOport[fw=factor]
																														**************

																														
																														**************tabla 57.A
																														
gen benef_polsoc_residu= P042_cuenta + P044_cuenta + segpop_y_otrasegsocia 
tabstat benef_polsoc_residu [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat benef_polsoc_residu [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
sgini benef_polsoc_residu  [fw=factor], sortvar(ingcor)
												
*drop _merge													
merge 1:1 folioviv foliohog using "para ciudadanias diferenciadas.dta"
replace benef_polsoc_residu=1 if P042_cuenta!=0 &  P042_cuenta!=.

																											**************tabla 57.B c y D

tabstat tipo_ciudadania_1 [fw=factor], by(ingcor_decil )  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_1 [fw=factor], by(urbano_rural)  stat(sum)  format( %16.0fc )
	sgini tipo_ciudadania_1 [fw=factor], sortvar(ingcor)
	

tabstat tipo_ciudadania_2 [fw=factor], by(ingcor_decil )  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_2 [fw=factor], by(urbano_rural)  stat(sum)  format( %16.0fc )
	sgini tipo_ciudadania_2 [fw=factor], sortvar(ingcor)
	
tabstat tipo_ciudadania_3 [fw=factor], by(ingcor_decil )  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_3 [fw=factor], by(urbano_rural)  stat(sum)  format( %16.0fc )
	sgini tipo_ciudadania_3 [fw=factor], sortvar(ingcor)

	
tabstat tipo_ciudadania_4 [fw=factor], by(ingcor_decil )  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_4 [fw=factor], by(urbano_rural)  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_4 [fw=factor], by(tam_loc)  stat(sum)  format( %16.0fc )
	sgini tipo_ciudadania_4 [fw=factor], sortvar(ingcor)

	
tabstat polsocresidu_sinimportarSP [fw=factor], by(ingcor_decil )  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_1_5 [fw=factor], by(urbano_rural)  stat(sum)  format( %16.0fc )
	tabstat tipo_ciudadania_1_5 [fw=factor], by(tam_loc)  stat(sum)  format( %16.0fc )
	sgini tipo_ciudadania_1_5 [fw=factor], sortvar(ingcor)	
	
tab tipo_ciudadania_1_5 P042_cuenta	
	
	
/*gen tipo_ciudadania=.
replace tipo_ciudadania=1 if tipo_ciudadania_1>=1
replace tipo_ciudadania=2 if tipo_ciudadania_2==1
replace tipo_ciudadania=2 if P042_cuenta!=0 &  P042_cuenta!=.
replace tipo_ciudadania=3 if tipo_ciudadania_3==1
replace tipo_ciudadania=4 if tipo_ciudadania_4==1
tab tipo_ciudadania
 */
 
																	
																														

******************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************
********************************************************************************corte de base de datos*******************************************************************************************************
******************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************
save "base completa trabajada II.dta", replace

******************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************
********************************************************************************corte de base de datos*******************************************************************************************************
******************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************

* Carpete de trabajo UBUNTU
*cd "/home/maxernesth/Escritorio/encuestas/ENIGH Vieja Construccion/2014/bases"



* Carpete de trabajo Mac
*cd "/Users/Maxernsth/Documents/Encuestas/ENIGH Vieja Construccion/2014/bases"

clear all
clear all
* Carpeta trabajo EVALÚA CDMX
cd "~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases/Prof Enrique"

use "base completa trabajada II.dta", clear


******************************************************
***Procampo
******************************************************
																														**************tabla 58
tabstat P043_cuenta [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P043_cuenta [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat P043_cuenta [fw=factor], by(tam_loc)  stat(sum)  format( %14.2fc )
sgini P043_cuenta  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 59																														
tabstat P043 [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P043  [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat P043  [fw=factor], by(tam_loc)  stat(sum)  format( %14.2fc )
sgini P043  [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 60																														
replace P043=. if P043 ==0 
tabstat P043 [fw=factor], by(ingcor_decil )  stat(mean) format( %14.2fc )
tabstat P043 [fw=factor], by(urbano_rural )  stat(mean)  format( %14.2fc )
																														**************



																														******************************************************
***PAL
******************************************************
																														**************tabla 60.A
tabstat P046 [fw=factor], by(ingcor_decil )  stat(sum) format( %14.2fc )
tabstat P046  [fw=factor], by(urbano_rural )  stat(sum)  format( %14.2fc )
tabstat P046 [fw=factor], by(tam_loc)  stat(sum)  format( %14.2fc )
sgini P046  [fw=factor], sortvar(ingcor)
																														
																														
********************************************************************************
*alfabetismo
																														**************tabla 61
tabstat alfabe [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat alfabe [fw=factor], by(urbano_rural ) stat(sum)  format( %14.2fc )
sgini alfabe [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 62																														
*3ymas
tabstat edad3ymas [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat edad3ymas [fw=factor], by(urbano_rural ) stat(sum)  format( %14.2fc )
																														**************

******************************************
tabstat nivelaprob_0  [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_0  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_0  [fw=factor], sortvar(ingcor)

tabstat nivelaprob_1 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_1  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_1 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_2 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_2  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_2  [fw=factor], sortvar(ingcor)

tabstat nivelaprob_3 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_3  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_3 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_4 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_4  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_4 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_5 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_5  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_5 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_6 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_6  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_6 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_7 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_7  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_7 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_8 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_8  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_8 [fw=factor], sortvar(ingcor)

tabstat nivelaprob_9 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat nivelaprob_9  [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini nivelaprob_9 [fw=factor], sortvar(ingcor)

******************************************
																														**************tabla 64
tabstat asist_2 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat asist_2 [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini asist_2 [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 65																														
tabstat asist_3 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat asist_3 [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini asist_3 [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 66																														
gen asist_mediasup=asist_4 + asist_7 + asist_5 
tabstat asist_mediasup [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat asist_mediasup [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini asist_mediasup [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 67																														
tabstat asist_8 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat asist_8 [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini asist_8 [fw=factor], sortvar(ingcor)
																														**************

																														**************tabla 68
tabstat asist_9 [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat asist_9 [fw=factor], by(urbano_rural)  stat(sum)  format( %14.2fc )
sgini asist_9 [fw=factor], sortvar(ingcor)
																														**************tabla 68


******************************************


																														**************tabla 69
tab rezago_edu [fw=factor]
tabstat rezago_edu  [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat rezago_edu  [fw=factor], by(urbano_rural ) stat(sum)  format( %14.2fc )
sgini P044  [fw=factor], sortvar(ingcor)
																														**************
																														
																														
																														**************tabla 70																														
tabstat edad6ymas [fw=factor], by(ingcor_decil)  stat(sum)  format( %14.2fc )
tabstat edad6ymas [fw=factor], by(urbano_rural ) stat(sum)  format( %14.2fc )
																														**************
			
			
			
			
************************************************Montos totales			
			
*Remesas			
tabstat P041[fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )

gen polsoc_completo  =P038 + P042 + P043 + P044 + P045 + P046 + P047 + P048

tabstat polsoc_completo  [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )
			
*oportunidades
tabstat P042   [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )			
	
*procampo
tabstat P043[fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )		
	
*70 y mas
tabstat 	P044 [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )		
	
	
*PAL
tabstat 	P046 [fw=factor], by(ingcor_decil )  stat(sum) format( %16.2fc )		
	
	
	
	
	
	
*rename ing_mon ingmon	
*gen ingmon_sinPAL=ingmon - P046
*sgini ingmon_sinPAL  [fw=factor], 

																					
************************************************


replace P038=0 if P038==.
replace P041=0 if P041==.
replace P042=0 if P042==.
replace P043=0 if P043==.
replace P044=0 if P044==.
replace P045=0 if P045==.
replace P046=0 if P046==.
replace P047=0 if P047==.
replace P048=0 if P048==.

gen ingcor_sinremesas=ingcor- P041
gen ingcor_sinBecasGob= ingcor- P038
gen ingcor_sinprocampo= ingcor- P043
gen ingcor_sinpolsoc_completo  =ingcor- P038 - P042 - P043 - P044 -P045 - P046 - P047 - P048
*gen ingcor_sinpolsoc2=ingcor- (P038 + P042 + P043 + P044 + P045 + P046 + P047 + P048)
gen ingcor_sinpolsoc_incompleto = ingcor- P038 - P042 - P043 - P044 -P045 



																														**************tabla 71
sgini ingcor  [fw=factor], 
sgini ingcor_sinjubs  [fw=factor], 
sgini ingcor_sinremesas [fw=factor], 
sgini ingcor_sinBecasGob  [fw=factor], 
sgini ingcor_sin70ymas [fw=factor], 
sgini ingcor_sinOportunidades [fw=factor], 
sgini ingcor_sinprocampo [fw=factor], 
sgini ingcor_sinpolsoc_completo [fw=factor], 
sgini ingcor_sinpolsoc_incompleto [fw=factor], 
																														**************



																														**************tabla 72

gen ingmon_sinjubs = ingmon-jub_monto
gen ingmon_sinremesas=ingmon- P041
gen ingmon_sinBecasGob= ingmon- P038
gen ingmon_sin70ymas = ingmon-P044 
gen ingmon_sinOportunidades = ingmon-P042 
gen ingmon_sinprocampo= ingmon- P043
gen ingmon_sinpolsoc_completo  =ingmon- P038 - P042 - P043 - P044 -P045 - P046 - P047 - P048
*gen ingcor_sinpolsoc2=ingcor- (P038 + P042 + P043 + P044 + P045 + P046 + P047 + P048)
gen ingmon_sinpolsoc_incompleto = ingmon- P038 - P042 - P043 - P044 -P045 
gen ingmon_sinpolsoc_completo_sJUBS  =ingmon- P038 - P042 - P043 - P044 -P045 - P046 - P047 - P048 - jub_monto

																														

sgini ingmon  [fw=factor], 
sgini ingmon_sinjubs  [fw=factor], 
sgini ingmon_sinremesas [fw=factor], 
sgini ingmon_sinBecasGob  [fw=factor], 
sgini ingmon_sin70ymas [fw=factor], 
	ineqdec0 ingmon_sinOportunidades [fw=factor], 
sgini ingmon_sinOportunidades [fw=factor], 
sgini ingmon_sinprocampo [fw=factor], 
sgini ingmon_sinpolsoc_completo [fw=factor], 
sgini ingmon_sinpolsoc_incompleto [fw=factor], 
sgini ingmon_sinpolsoc_completo_sJUBS [fw=factor],
																														**************




																														**************tabla 74
* Ingreso corriente monetario per cápita

gen ingmon_pc = ingmon / tam_hog
xtile decil_monpc = ingmon_pc [w = factor], nq(10)
tabstat ingmon_pc [fw=factor], s(mean) by(decil_monpc) format( %16.2fc )
tabstat ingmon_pc  [fw=factor], by(urbano_rural ) stat(mean)  format( %16.2fc )
sgini ingmon_pc   [fw=factor],




																														**************tabla 77
* Ingreso corriente monetario per cápita

xtile decil_monpc = ingmon_pc [w = factor], nq(10)
tabstat ingmon_pc [fw=factor], s(mean) by(decil_monpc) format( %16.2fc )
tabstat ingmon_pc  [fw=factor], by(urbano_rural ) stat(mean)  format( %16.2fc )
tabstat ingmon_pc  [fw=factor], by(ingmon_percentil)  stat(mean) format( %16.2fc )
sgini ingmon_pc   [fw=factor],





***************************
******trabajo con poblacion para artículo OIT
***************************


* Carpete de trabajo Mac
*cd "/Users/Maxernsth/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases"


clear all
* Carpeta trabajo EVALÚA CDMX
cd "/Users/maximoernestojaramillomolina/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases"


use "antes de cuenta y suma.dta", clear

/*
gen urbano_rural=.
destring tam_loc, replace
replace urbano_rural = 0 if tam_loc== 1 | tam_loc== 2 | tam_loc== 3
replace urbano_rural = 1 if tam_loc== 4
tab urbano_rural tam_loc
label define tam_loc 1 "100k o más" 2 "15k a 99,999" 3 "2.5k a 14,999" 4 "Menos de 2.5k" 
label values tam_loc  tam_loc
tab tam_loc
***************************crear deciles de hogares ingreso corriente
rename ing_cor ingcor
xtile ingcor_decil  [fw=factor] = ingcor , nquantiles(10)
xtile ingcor_decil_NO   = ingcor , nquantiles(10)
tab ingcor_decil ingcor_decil_NO
xtile ingcor_percentil  [fw=factor] = ingcor , nquantiles(100)
drop _merge
*/


merge 1:1 folioviv foliohog numren using "pobreza_16.dta"











*
*
**
*
*
*





*gen pensiones_todas = P033 + P032
gen jubilacion_y_pension= .

*tab P032
replace P032=0 if P032==.
replace P033=0 if P033==.
replace  jubilacion_y_pension= 1 if P032>0.000001

replace  jubilacion_y_pension= 1 if P033>0.000001

replace P044=0 if P044==.
replace  jubilacion_y_pension= 1 if P044>0.000001
gen pension_basica = .
replace pension_basica = 1 if P044>0.000001
replace pension_basica=0 if pension_basica==.

tab   jubilacion_y_pension

gen pob65ymas = .
replace  pob65ymas=1 if edad>65
replace pob65ymas=0 if pob65ymas==.
replace jubilacion_y_pension=0 if  jubilacion_y_pension==. 

tab jubilacion_y_pension   pob65ymas 
tab jubilacion_y_pension   pob65ymas [w = factor], cell nof
tab jubilacion_y_pension   pob65ymas [w = factor]
tab pension_basica    pob65ymas [w = factor]
tab pension_basica    pob65ymas [w = factor], cell nof





replace P042=0 if P042==.
gen oport=.
replace oport=1 if P042>0.000001



gen segpop1=.
replace segpop1=0 if segpop=="2"
replace segpop1=1 if segpop=="1"
tabstat pobreza  if segpop1==1
tabstat pobreza  if segpop1==1









*Día del niño
















