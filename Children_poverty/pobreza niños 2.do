



clear all
* Carpeta trabajo EVALÚA CDMX
cd "/Users/maximoernestojaramillomolina/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases"


use "antes de cuenta y suma.dta", clear
merge 1:1 folioviv foliohog numren using "pobreza_16.dta"
drop if _merge==1

gen ninez=0
replace ninez=1 if (edad>=0 & edad<=11)
tab ninez [w=factor]

tab pobreza ninez [w=factor] ,

gen pobres_vulne=0
replace pobres_vulne=1 if pobreza==1
replace pobres_vulne=1 if vul_car==1
replace pobres_vulne=1 if vul_ing==1
 
tab pobres_vulne ninez [w=factor] ,







