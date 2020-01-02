*Titulo: 				Datos sobre condiciones laborales de trabajadoras del hogar
*Autor: 				Gatitos contra la desigualdad
*Fuentes:				ENIGH 2918 y CONEVAL


use "~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases/CONEVAL/Base de datos/trabajos.dta", clear

/*
incluir 
9611 Trabajadores domésticos
5222 Cuidadores de niños, personas con discapacidad y ancianos en casas particulares
9643 Lavanderos y planchadores domésticos
8343 Choferes en casas particulares
5113 Cocineros domésticos
*/

gen trab_dom=0
replace trab_dom=1 if sinco=="9611" | sinco=="5222" | sinco=="9643" | sinco=="8343" | sinco=="5113"

gen trabajador=1

gen contratO=0
replace contratO=1 if contrato=="1"

gen incapacidad=0
replace incapacidad=1 if pres_1=="01"

gen aguinaldo=0
replace aguinaldo=1 if pres_2=="02"

gen vacaciones=0
replace vacaciones=1 if pres_3=="03"

gen seg_soc=0
replace seg_soc=1 if medtrab_1=="1" | medtrab_2=="2" | medtrab_3=="3" | medtrab_4=="4"

collapse (max) trabajador trab_dom contratO incapacidad aguinaldo vacaciones seg_soc (mean) htrab, by(folioviv foliohog numren)


merge m:1 folioviv foliohog numren using "~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases/CONEVAL/Base final/pobreza_18.dta"

recode trab_dom contratO incapacidad aguinaldo vacaciones seg_soc (.=0)

tab pobreza trab_dom [w=factor]
tab plb trab_dom [w=factor]


*Hay 98 mil trabajadoras domésticas menores de edad y 312 mil son adultas mayores
tab edad [w=factor] if trabajador==1 & trab_dom==1,


*En promedio, trabajan 30 horas a la semana las trabajadoras domésticas
tabstat htrab [w=factor], by(trab_dom)

*51% de trabajadoras del hogar viven en pobreza de ingresos
tab plb trab_dom [w=factor], col nof
tab plb trab_dom [w=factor],

*15% de trabajadoras del hogar viven en pobreza extrema de ingresos
tab plb_m trab_dom [w=factor], col nof
tab plb_m trab_dom [w=factor], 

*Mientras que 35% de trabajadores tienen contrato, solo 2.6% de trabajadoras dome lo tiene
tab contratO trab_dom [w=factor] if trabajador==1, col nof

*Mientras que 33% de trabajadores tienen incapacidad, solo 3.9% de trabajadoras dome lo tiene
tab incapacidad trab_dom [w=factor] if trabajador==1, col nof

*Mientras que 38% de trabajadores tienen aguinaldo, solo 15% de trabajadoras dome lo tiene
tab aguinaldo trab_dom [w=factor] if trabajador==1, col nof

*Mientras que 34% de trabajadores tienen vacaciones, solo 6% de trabajadoras dome lo tiene
tab vacaciones trab_dom [w=factor] if trabajador==1, col nof

*Mientras que 36% de trabajadores tienen seguridad social, solo 3.7% de trabajadoras dome lo tiene
tab seg_soc trab_dom [w=factor] if trabajador==1, col nof






