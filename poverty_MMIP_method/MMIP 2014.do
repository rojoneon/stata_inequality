*Titulo: 				Cálculo del Método de Medición Integrada de la Pobreza 2014
*Autor: 				Dirección de Información y Estadística - EVALÚA CDMX
*Fuentes:				MCS 2014
*Fecha de finalización: Agosto de 2019

********************************************************************************
* Contenido del archivo:
* 0. Directorios de trabajo
* 1. Pegado de bases de datos
* 2. NBI 
* 3. Educación
* 4. Salud y Seguridad Social
* 5. Tiempo
* 6. Ingreso
* 7. Cálculo de indicador de MMIP
********************************************************************************



clear all
set more off

********************************************************************************
* Módulo 0. Directorios de trabajo
********************************************************************************

*Se recomienda crear las siguientes carpetas y colocarlas en la raíz de la unidad C de su equipo.  

*Globals Directorio de bases
gl bases=	"C:\MMIP2014\Bases Ajustadas"
gl ingresos="C:\MMIP2014\Ingresos"
gl tmp=		"C:\MMIP2014\TMP"
gl final=	"C:\MMIP2014\Final"


* En la carpeta "Bases Ajustadas", colocar los siguientes archivos:
* 	gastohogar.dta, ingresos.dta, gastospersona.dta, 
*   trabajos.dta, poblacion.dta, hogares.dta y viviendas.dta
*Nota: Utilizar las bases ajustadas a Cuentas Nacionales, disponibles en la página web de EVALÚA.


********************************************************************************
* Módulo 1. Pegado de bases de datos
*
*Generar las bases hogares+Viv.dta, tamano_hogar.dta, factexp.dta y hogaresmmip.dta 
********************************************************************************

*En este módulo se generan las bases intermedias a partir de las 
*bases originales de la encuesta:
*Hogares, viviendas, población 

***
***Primero se trabaja con las bases de vivienda y hogares
***

*Abrir la base de viviendas
use "$bases/viviendas.dta", clear
*Guardar la base idéntica en la carpeta de archivos temporales para modificarla posteriormente
save "$tmp/viviendas.dta", replace

*Abrir la base hogar y pegar con la temporal de vivienda
use "$bases/hogares.dta", clear
merge m:1 proyecto folioviv  using "$tmp/viviendas.dta"
drop _merge

*Generar un folio único, de los folios de vivienda y hogares juntos
egen folio=concat(proyecto folioviv folioh)

*Generar etiquetas para la variable Tamaño de localidad (tam_loc)
label define tam 1"100 mil habitantes y mas" 2"De 15,000 a 99,999 hab" ///
				 3"De 2,500 a 14,999 hab" 4"Menos de 2,500 hab"
destring tam_loc, replace 
label values tam_loc 

*Generar variable uniendo localidades urbanas y rurales
gen ur_rur_2500=1
replace ur_rur_2500=2 if tam_loc==4
label define ur_rur 1 "Loc. > 2,500 habs" 2 "Loc. < 2,500 habs"
label value  ur_rur_2500 ur_rur

*Se substrae municipio y entidad y se genera una variable para cada una
gen municipio=real(substr(ubica_geo,3,3))
gen entidad=real(substr(ubica_geo,1,2))

*Etiquetar las entidades
label define ent 1	"Aguascalientes" 2 "Baja California" 3 "Baja California Sur" 4 "Campeche" ///
5 "Coahuila" 6 	"Colima" 7 	"Chiapas" 8	"Chihuahua"  9	"Ciudad de México" 10	"Durango" ///
11	"Guanajuato"  12	"Guerrero"  13	"Hidalgo"  14	"Jalisco" 15	"México"  ///
16	"Michoacán"  17	"Morelos" 18	"Nayarit" 19	"Nuevo León" 20	"Oaxaca"  ///
21	"Puebla" 22	"Querétaro" 23	"Quintana Roo" 24	"San Luis Potosí"  25	"Sinaloa"  ///
26	"Sonora"  27	"Tabasco" 28	"Tamaulipas" 29	"Tlaxcala" 30	"Veracruz" 31	"Yucatan"32	"Zacatecas"
label value entidad ent

*Alcaldias de la CDMX
gen alcaldia=.
replace alcaldia=2 if (entidad==9 & municipio==2)
replace alcaldia=3 if (entidad==9 & municipio==3)
replace alcaldia=4 if (entidad==9 & municipio==4)
replace alcaldia=5 if (entidad==9 & municipio==5)
replace alcaldia=6 if (entidad==9 & municipio==6)
replace alcaldia=7 if (entidad==9 & municipio==7)
replace alcaldia=8 if (entidad==9 & municipio==8)
replace alcaldia=9 if (entidad==9 & municipio==9)
replace alcaldia=10 if (entidad==9 & municipio==10)
replace alcaldia=11 if (entidad==9 & municipio==11)
replace alcaldia=12 if (entidad==9 & municipio==12)
replace alcaldia=13 if (entidad==9 & municipio==13)
replace alcaldia=14 if (entidad==9 & municipio==14)
replace alcaldia=15 if (entidad==9 & municipio==15)
replace alcaldia=16 if (entidad==9 & municipio==16)
replace alcaldia=17 if (entidad==9 & municipio==17)

*Etiquetado de las alcaldias de CDMX
label define alcaldia 10 "Álvaro Obregón" 2 "Azcapotzalco" 14 "Benito Juárez" 3 "Coyoacán" 4 "Cuajimalpa de Morelos" ///
15 "Cuauhtémoc" 5 "Gustavo A. Madero" 6 "Iztacalco" 7 "Iztapalapa" 8 "La Magdalena Contreras" ///
16 "Miguel Hidalgo" 9 "Milpa Alta" 11 "Tláhuac" 12 "Tlalpan" 17 "Venustiano Carranza" 13 "Xochimilco"

label value alcaldia alcaldia

*Generar una base que contiene variables de vivienda y hogares y las siguientes variables:
save "$final/hogares+Viv.dta", replace

*Se seleccionan las variables creados y las de diseño muetral y se genera una nueva base
keep proyecto folio folioviv foliohog municipio entidad ur_rur_2500 alcaldia factor_hog upm tam_loc est_dis
save "$final/factexp.dta", replace

**********
* Trabajar la base de población
**********
use "$bases/poblacion.dta", clear

egen folio=concat(proyecto folioviv folioh)
sort folio

*Eliminar los folios de los queno son miembros de la familia en el hogar
destring parentesco, replace
drop if parentesco>=400 & parentesco <500
drop if parentesco>=700 & parentesco <800

*Generar una variable dummy de tamaño de hogar y se hacer un collapse para
*tener el numero correcto de integrantes de hogar excluyendo a los parientes
gen tam_hog=1
collapse (sum) tam_hog, by(proyecto folioviv foliohog folio)
save "$tmp/tamano_hogar.dta", replace


*Abrir la base con variables seleccionadas
use "$final/factexp.dta", clear
merge 1:1 proyecto folioviv foliohog folio using "$tmp/tamano_hogar.dta"
tab _merge
drop _merge

*Generar un nuevo factor de expansión de individuo, pero según numero de integrantes del hogar
gen factorxind = factor * tam_hog

*factexp
save "$final/factexp.dta", replace

*Pegar el nuevo factor de expansión a la base de hogares con variables
use "$final/hogares+Viv.dta", clear
merge 1:1 folio using "$final/factexp.dta"
tab _merge
drop _merge
*Guardar en una nueva base de datos
save "$tmp/hogaresmmip.dta", replace



********************************************************************************
* Módulo 2. NBI, de acuerdo con la metodología del MMIP, la dimensión de las NBI 
* se calcula con los siguientes seis componentes. 
*
*	2.1 Construcción y cálculo del indicador de espacio y calidad de la vivienda
*   2.2 Construcción y cálculo del indicador de bienes durables
*   2.3 Construcción y cálculo del indicador de adecuación sanitaria
*   2.4 Construcción y cálculo del indicador de servicio telefónico
*   2.5 Construcción y cálculo del indicador de adecuación energética
*   2.6 Archivo con los  Indicadores de Adecuación de la Vivienda-NBI
*
* Al final se genera la base "nbi.dta" a partir de hogaresmmip12.dta
********************************************************************************



*Utilizar la base de datos de vivienda, a nivel hogar
use "$tmp/hogaresmmip.dta", clear


********************************************************************************
*2.1 Construcción y cálculo del indicador de espacio y calidad de la vivienda
********************************************************************************

***
***2.1.1 Calidad de la vivienda, se elaboran indicadores parciales que miden la 
***calidad de muros, pisos y techos de las viviendas, de acuerdo con los 
***ponderadores que se especifican abajo, para crear un índice de calidad de la 
***vivienda. En cada componente, se especifica la norma.
***


****
****Pared de la vivienda (Norma: Tabique, ladrillo, block, piedra, cantera, 
****cemento o concreto.)
destring mat_pared, replace
gen 	AMj=.
*Material de desecho y lámina de cartón=0
replace AMj=0 if (mat_pared==1 | mat_pared==2)
*Lámina de asbesto o metálica, carrizo bambú o palma, y embarro o bajareque = 0.25
replace AMj=0.25 if (mat_pared>2 & mat_pared<6)
*Madera o adobe = 0.6
replace AMj=0.6 if (mat_pared==6 | mat_pared==7)
*Tabique, ladrillo, block, piedra, cantera, cemento o concreto = 1  					<- Norma
replace AMj=1 if (mat_pared==8)
label var AMj "Adecuación de muros"


***
***Muros de la vivienda, (Norma Teja o Losa de concreto o viguetas con bovedilla)
destring mat_techos, replace
gen ATj=.
*Material de desecho y lámina de cartón = 0
replace ATj=0   if (mat_techos==1 | mat_techos==2)
*Lámina metálica, de asbesto de fibrocemento ondulada, palma o paja, madera o tejamanil y terrado con viguería = 0.5 
replace ATj=0.5 if (mat_techos> 2 & mat_techos <9)
*Teja o Losa de concreto o viguetas con bovedilla = 1      								<- Norma
replace ATj=1 if (mat_techos==9 | mat_techos==10)
label var ATj "Adecuación de techos"

***
***Material de piso, (Norma: Madera, mosaico o viguetas con bovedilla)
* Respuestas "&" = no especificado. Se corrigen con force
destring mat_pisos, gen(mat_pisos1) force
recode mat_pisos1(.=3)
gen APj=.
*Tierra = 0
replace APj=0    if (mat_pisos1==1)
*Cemento o firme = .5   															
replace APj=0.5  if (mat_pisos1==2)
*Madera, mosaico o viguetas con bovedilla												<- Norma
replace APj=1    if (mat_pisos1==3)
label var APj "Adecuación de pisos"

* Generar Índice compuesto de calidad de la vivienda
* Ponderadores para se obtienen con base en los datos de COPLAMAR VIVIENDA
gen ACVj=(APj*0.15) + (AMj*0.55) + (ATj*0.30)
label var ACVj "Ind compuesto calidad de la vivienda"

***
***2.1.2 Espacio disponible en la vivienda, se refiere al grado de hacinamiento, 
***considerándose como norma dos personas por dormitorio, un cuarto de usos múltiples
***por cada 4 personas y concina exclusiva (que no se utilice como dormitorio).
***

*Variable para identificar  hogares donde la cocina también es dormitorio, 1 es "sí se usa también como dormitorio"
gen KEh=0 if (cocina=="2")
replace KEh=0 if (cocina=="1" & cocina_dor=="1")
replace KEh=1 if (cocina=="1" & cocina_dor=="2")

*Etiquetado de las variables de numero de cuartos y numero de dormitorios
label var num_cuarto "Cuartos totales viv(cuart)"
label var cuart_dorm "Num. dormitorios hogar(dormi)"

*Generar la variable cuartos comparables donde se identifican los cuartos de la vivienda
gen CCj= num_cuarto- KEh
label var CCj "Cuartos comparables"
gen CMj= num_cuarto - (cuart_dorm + KEh)
label var CMj "Cuartos multiusos viv"

*Norma del total de cuartos de la vivienda											<- Norma
gen CTj_N= 1 + (0.75* tot_resid) if (tot_resid >1)
*Si solo reside una persona, la norma es 1
replace CTj_N=1 if (tot_resid ==1)
label var CTj_N "Norma cuartos totales vivienda"

*Generar las variables normas para construir el indicador de carencia de la vivienda
*Norma de dormitorios-> Un cuarto por dos personas									<- Norma
gen Dh_N = tot_resid/2
label var Dh_N "Norma dormitorios hogar"

*Se genera adecuación dormitorios por hogar
gen ADh  = cuart_dorm / Dh_N
label var ADh "Ind Adecuación dormitorios"

*Norma de cuartos multiusos de vivienda -> Un cuarto por cada cuatro personas		<- Norma
gen CMj_N = tot_resid/4
label var CMj_N "Norma cuarto multiuso vivienda"

*Norma de dormitorios equivalentes													<- Norma
gen DEh_N = (0.5) + Dh_N + (CMj_N*1.5)
label var DEh_N "Norma Dormitorios Equivalentes"

*Número de dormitorios equivalentes
gen DEh = (KEh*0.5) + cuart_dorm + (CMj*1.5)
label var DEh "Número de Dormitorios Equivalentes"

*Generar adecuación de la vivienda
gen AEVh = DEh / DEh_N
label var AEVh "Adec espacio de la vivienda"

***
*** Cálculo del indicador de espacio disponible en la vivienda
***

*Reescalación de indicador de adecuación de la vivienda
gen AEVh_P = DEh  if (tot_resid ==1 & AEVh <=1)
replace AEVh_P = 1 + ((AEVh-1)/(2)) if (tot_resid == 1 & AEVh >1)
replace AEVh_P = DEh / DEh_N if (tot_resid != 1 & AEVh <= 1)
replace AEVh_P =  1 + ((AEVh-1)/(2)) if (tot_resid != 1 & AEVh >  1)
label var AEVh_P "Reescal de Adec espacio viv"
replace AEVh_P=2 if AEVh_P>=2

gen HMDh = 1 - AEVh_P
label var HMDh "Hacinamiento multidimensional"

***
***Cálculo del consolidado de cantidad y calidad de la vivienda.
***
*Se toman en cuenta ambos indicadores, de espacio y calidad de la vivienda
gen acevj = ACVj*AEVh_P
label var acevj "Ind de espacio y calidad de la vivienda"
* Generar variable de carencia
gen ccevj= 1-acevj
label var ccevj "Ind carencia de espacio y calidad de la vivienda"


******************************************************************
*2.2 Construcción y cálculo del indicador de bienes durables. Este indicador compara 
*un valor aproximado de los bienes durables en el hogar, frente a una norma del costo
*de una canasta de bienes considerados necesarios para el hogar.
******************************************************************

*Se renombran las variables de bienes durables
gen calgas=1 if (calent_sol  == "1" |calent_gas== "1")
gen bomag=1 if (bomba_agua=="1")
gen auto=num_auto
gen camneta=num_van
gen camcaj=num_pickup                                 
gen moto=num_moto                                     
gen bici=num_bici 
gen estereo=num_ester
gen grabado=num_grab       
gen radio=num_radio
gen tv=num_tva + num_tvd
gen dvd=num_dvd
gen licuad=num_licua
gen refri=num_refri
gen estgas=num_estuf
gen lavado=num_lavad
gen plancha=num_planc
gen mcoser=num_maqui
gen venti=num_venti
gen  aspirado=num_aspir
gen compu=num_compu
gen juegovi=num_juego

*Cambiar los valores de missing a 0 y de -1 a 0 para poder hacer la deflactación y la suma
recode auto camneta camcaj moto bici estereo grabado radio tv dvd licuad  ///
    refri estgas lavado plancha mcoser venti aspirado compu  juegovi ///
    calgas bomag(.=0)(-1=0)

*D1
*Dato externo 1 = Precios de bienes durables, actualizados a 2014. Véase documento metodológico

*Se otorga un valor a los bienes de acuerdo a su precio actualizado
*Valores de artículos de vivienda deflactados al mes de agosto de 2014
gen Nauto   =124514.36     	* auto
gen Ncamnet =139545.90     	* camneta
gen Ncamcaj =139545.90     	* camcaj
gen Nmoto   =28255.95      	* moto
gen Nbici   =1354.53    	* bici
gen Nradio  =605.52     	* radio
gen Ngrabad =605.52     	* grabado
gen Nestereo=1315.25     	* estereo
gen Ntv     =3581.34     	* tv
gen Ndvd    =472.08      	* dvd
gen Njuegov =5640.06     	* juegovi
gen Ncompu  =11524.11     	* compu
gen Nventi  =306.61     	* venti
gen Nmcoser =2622.32     	* mcoser
gen Nestgas =3213.71     	* estgas
gen Nrefri  =5384.45     	* refri
gen Nlicuad =368.05      	* licuad
gen Nbomag  =882.24     	* bomag
gen Nplanch =171.96      	* plancha
gen Nlavado =3667.38     	* lavado
gen Naspira =427.44     	* aspirado
gen Ncalgas =1883.37     	* calgas

***
***Cálculo del indicador de bienes durables
***

*D2
*Dato externo 2 = Canasta de bienes durables
*NORMA es la suma del valor presente de: bicicleta, grabadora, tv, ventilador, 
*estufa de gas, refrigerador, licuadora, plancha y lavadora
*Para obtener la carencia se suma de todos los bienes durables y se dividen entre 
*norma, siendo el denominador en 2014, 18701.42

************************************************.
gen ABDj = (Nauto +  Ncamnet + Ncamcaj +  Nmoto  + Nbici  + Nradio  +  ///
Ngrabad + Nestereo + Ntv + Nventi + Nmcoser + Nestgas + Nrefri  + Nlicuad + ///
Nbomag + Nplanch + Nlavado + Naspira + Ncalgas + Ndvd    + Njuegov + ///
Ncompu ) / (18653.54)
label var ABDj "Adec. Bienes Durables"

*Reescalación de variable de bienes durables
gen ABDj_P = ABDj
replace ABDj_P=1 + ((ABDj-1)/ 9) if (ABDj > 1 ) 
replace ABDj_P=2 if ABDj_P>=2
label var ABDj_P "Adec bienes durables reescalado"

*Generación de variable de carencia
gen CBDj = 1 - ABDj_P
label var CBDj "Carenc Resc Adec bienes durables"

*********************************************************************** 
*2.3 Construcción y cálculo del indicador de adecuación sanitaria
***********************************************************************
*** Este indicador tiene tres componentes parciales, adecuación de disponibilidad 
*** de agua, conexión al drenaje y excusado
***
***2.3.1 Agua, la norma corresponde a la disponibilidad de agua dentro de la vivienda,
***con frecuencia diaria
***

*Se convierten en numéricas las variables relacionadas con agua
destring disp_agua, gen(agua_disp)
destring dotac_agua, gen(agua_dot)

*Se recodifica variable de disponibilidad de agua
*La norma es agua entubada dentro de la vivienda (código 1)							<- Norma
recode agua_disp (7 5 4=0)(3 6=1)(2=2)(1=3), gen(ag_disp)
gen aaa = ag_disp/3
label var aaa "Adecuación forma de abasto hídrica"

*Se recodifica variable de frecuencia de agua
*La norma es frecuencia diaria (código 1)											<- Norma
gen frec_agua = 0
replace frec_agua= 0.4 if (agua_dot == 5)
replace frec_agua= 0.6 if (agua_dot == 4)
replace frec_agua= 1.2 if (agua_dot == 3)
replace frec_agua= 2.0 if (agua_dot == 2)
replace frec_agua= 4 if (agua_dot == 1)
label var frec_agua  "Frecuencia del agua"
gen afa = frec_agua/4
label var afa "Adecuación de frecuencia del agua"

*Se genera índice de adecuación y frecuencia de agua
gen AA = (aaa + afa)/2
label var AA "Adecuación de abasto hídrico"

***
***2.3.2 Drenaje y excusado, Norma: excusado exclusivo conectado a drenaje o fosa séptica
***

*Generar índice de adecuación de drenaje
*Se convierten en numéricas las variables relacionadas con drenaje
destring drenaje, replace
*La norma es drenaje conectado a red pública o fosa séptica							<- Norma
recode drenaje (1 2=1)(3 4 5=0)
gen ADr =drenaje/1
label var ADr "Adecuación del drenaje"

*Generar índice de adecuación de excusado
*La norma es que tengan excusa, no compartido y con descarga directa de agua		<- Norma
gen EX=.
replace EX=0 if (excusado=="2")
replace EX=0 if (sanit_agua=="3")
replace EX=4 if ( uso_compar=="2" & sanit_agua=="1")
replace EX=3 if ( uso_compar=="1" & sanit_agua=="1")
replace EX=3 if ( uso_compar=="2" & sanit_agua=="2")
replace EX=2 if ( uso_compar=="1" & sanit_agua=="2")
gen AEX = EX /4.                             
label var AEX "Adecuación de excusado"   

*Generar indicador consolidado de adecuación sanitaria, con base en adecuación de abasto hídrico, de drenaje y de excusado
gen aaadr=AA * ADr  
gen ASjk_m =aaadr * AEX 
label var ASjk_m "Indicador consolidado de adecuación sanitaria"

*Generar indicador de carencia sanitaria
gen CSj_m = 1 - ASjk_m
label var CSj_m "Ind de carencia de adecuación sanitaria"



******************************************************************* 
*2.4 Construcción y cálculo del indicador de servicio telefónico
*******************************************************************

*Generación de indicador conjunto de telefonía o celular
* La norma es tener al menos uno de los dos										<- Norma	
gen ATlj =0 if (telefono == "2" & celular == "2")
replace ATlj =1 if (telefono == "1" | celular == "1")									
replace ATlj =1.5 if (telefono == "1" & celular == "1")
label var ATlj "Adecuación telefonía"

*Generación de indicador de carencia de servicio telefónico
gen CTELJ = 1 - ATlj
label var CTELJ "Ind carencia del serv. telefónico"

************************************************************************
* 2.5 Construcción y cálculo del indicador de adecuación energética
*************************************************************************

*Generación indicador de disponibilidad de energía eléctrica
gen AElj=0 if (disp_elect == "5")
*La norma es cualquier opción en que sí tengan abasto de energía 						<- Norma
replace AElj=1 if (disp_elect == "1" | disp_elect == "2" | disp_elect == "3" | disp_elect =="4") 
label var AElj "Adecuación energía eléctrica"

*Generación indicador de adecuación de combustible
** 1 Leña, 2 Carbón,  6 Otro combustible; 
**Norma: 3 Gas de tanque, 4 Gas natural o de tubería y 5 Electricidad
gen ck=0
replace ck=3 if (combustible == "3" | combustible == "4" | combustible == "5" )
replace ck=1 if (combustible == "1" | combustible == "2" | combustible == "6" )
gen ACK=(ck/3)
label var ACK "Indicadores de adecuación combustible"

*Generación indicador conjunto de adecuación energética
gen AEN= ACK*(0.30) + AElj*(0.70)
label var AEN "Indicadores de adecuación energética"  

*Generación indicador de carencia energética
gen CENJ=1-AEN
label var CENJ "Indicadores de carencia en energética"

**************************************************************************
*2.6 Archivo con los  Indicadores de Adecuación de la Vivienda-NBI *
*************************************************************************

save "$tmp/NBI.dta", replace

keep folio municipio entidad ur_rur_2500 alcaldia factor_hog  tam_hog factorxind ///
ACVj AEVh AEVh_P acevj ccevj ///
ABDj ABDj_P CBDj ///
AA ADr AEX ASjk_m CSj_m ///
ATlj CTELJ ///
AElj   ACK AEN CENJ

save "$final/nbi.dta", replace

********************************************************************************
* Módulo 3. Educación
*
*  3.1 Años de escolaridad
*  3.2 Condición de analfabetismo
*  3.3 Cálculo del indicador de adecuación y rezago educativo 
*
* Construye "edu.dta" a partir de poblacion16.dta
********************************************************************************

*Abrir la base de población original 
use "$bases/poblacion.dta", clear

*Se crea el identificador "folio"
egen folio= concat(proyecto folioviv foliohog)
sort  folio proyecto folioviv foliohog numren

*Se eliminan los que no son miembros de la familia en el hogar
destring edad parentesco, replace 
drop if parentesco>=400 & parentesco<500
drop if parentesco>=700 & parentesco<800

* Tanto alfabetización (alfabetism) como asistencia escolar (asis_esc)
*	están codificadas de la siguiente manera: 1=si  2 = no
destring nivelaprob gradoaprob antec_esc alfabetism asis_esc, replace

************************
*3.1 Años de escolaridad
************************

***
***Reescalación de años de escolaridad
***

* Generar la variable rescgen, que muestra los años que han estudiado los individuos en conjunto de todos sus niveles escolares
gen rescgen=0

*Paso 1: Si el nivel aprobado es 1, de preescolar, se reemplaza como el grado aprobado que tiene
	*la persona, ya que no tiene antecedentes escolares que sumen años de escolaridad.
	*Si tenían más de tres años de preescolar, solo se les cuenta tres años máximo.
replace rescgen=gradoaprob if nivelaprob==1
replace rescgen=3 if rescgen > 3

*Paso 2: Si el nivel aprobado es primaria, secundaria o bachillerato, se les suma una cantidad de años dada
* de manera que, en suma, se obtenga el número de años que llevan estudiando, tomando en cuenta preescolar.replace rescgen=(nivelaprob + (gradoaprob+1)) if nivelaprob==2
replace rescgen=(2 + (gradoaprob+1)) if nivelaprob==2
replace rescgen=(3 + (gradoaprob+6)) if nivelaprob==3
replace rescgen=(4 + (gradoaprob+8)) if nivelaprob==4

*Paso 3: Al grado "normal" o "carrera técnica",
* se les suma el número de años dependiendo del antecedente escolarreplace rescgen=10 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==1 & antec_esc==1) 
replace rescgen=10 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==1 & antec_esc==1) 
replace rescgen=11 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==2 & antec_esc==1)
replace rescgen=12 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==3 & antec_esc==1)
replace rescgen=13 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==4 & antec_esc==1) 
replace rescgen=14 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==5 & antec_esc==1) 

replace rescgen=13 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==1 & antec_esc==2)
replace rescgen=14 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==2 & antec_esc==2) 
replace rescgen=15 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==3 & antec_esc==2) 
replace rescgen=16 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==4 & antec_esc==2)
replace rescgen=17 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==5 & antec_esc==2)
 
replace rescgen=16 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==1 & antec_esc==3) 
replace rescgen=17 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==2 & antec_esc==3)
replace rescgen=18 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==3 & antec_esc==3)
replace rescgen=19 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==4 & antec_esc==3)
replace rescgen=20 if ((nivelaprob==6 | nivelaprob==5) & gradoaprob==5 & antec_esc==3)
 
*Paso 4: Si el nivel aprobado es profesional, mestría o doctorado, solo se le suman los años que llevan estudiando 
replace rescgen=((7 * 2) + (gradoaprob+1)) if (nivelaprob==7 & (gradoaprob > 0 & gradoaprob < 6)) 
replace rescgen=((8 * 2) + (gradoaprob+4)) if (nivelaprob==8 & (gradoaprob > 0 & gradoaprob < 3))
replace rescgen=((9 * 2) + (gradoaprob+4)) if (nivelaprob==9 )


***
*** Norma educativa de años estudiados, de acuerdo a la edad
***

*Generar variable que identifica el año de nacimiento
gen a_nacimiento= 2014-edad

*Generación variable de norma educativa
gen 	normaedu=0
*9 años  de educación equivalen a primaria
replace normaedu=  	9 if 				a_nacimiento <= 1946
*12 años de educación equivalen a secundaria   				        				 	  
replace normaedu=	12 if 				a_nacimiento >= 1947 & a_nacimiento 	<= 1976  
*15 años de educación equivalen a media superior   				        				 	 
replace normaedu=	15 if 				a_nacimiento >= 1977 & edad>=19					
*Norma específica para los nacidos después de 1977 y menores de 18 años
replace normaedu= 	edad-4 if 			a_nacimiento >= 1977 & edad > 4  & edad<19

label var normaedu "Norma educativa"

************************
*3.2 Condición de analfabetismo
************************

***
***Analfabetismo
***

*Generar una nueva variable para condición de alfabetismo,
	*donde normativamente se asume que mayores de ocho años analfabetas están en carencia				<- Normagen alij=0
gen ali=0
replace ali=1 if alfabetism==1
replace ali=0 if (alfabetism==2 & edad >=8) 
label var ali "Condición de alfabetismo"

***
***Asistencia Escolar
***

*Generación de una variable recodificada de asistencia escolar
recode asis_esc (1=1) (2=0)

*Generar variable de norma de asistencia, donde los mayores de tres años y menores de 17 años 
	*tienen que asistir a la escuela, en términos normativos. En caso contrario, están en carencia.		<- Norma
gen normaasis=0																						
replace normaasis=1 if (edad > 3 & edad <= 17) 

*************************************************
* 3.3 Cálculo del indicador de adecuación y rezago educativo   
*************************************************

***
***Generación de indicador de adecuación de educación
***

gen anei=((rescgen + asis_esc)/ (normaedu + normaasis)) * ali
replace anei=((rescgen + asis_esc)/ (normaedu + normaasis)) if (edad>2 & edad<8)
label var anei "Adecuación de educación"

*Se reescala el indicador de anei (adecuación de educación), solo para los que están por arriba de la norma
*Generar valores de reescalación
recode edad (0/17=1)(18/29=2) (30/59=3)(60/197=4), gen(redad)
tabstat anei, s(mean min max) by (redad)
*Se introducen valores de reescalación
gen     anei_p=anei
replace anei_p = 1 + ((anei - 1) /(1.7333-1)) if ( anei>1 & (edad >= 18 & edad  <= 29) )
replace anei_p = 1 + ((anei - 1) /(2.3333-1)) if ( anei>1 & (edad >= 30 & edad  <= 59) ) 
replace anei_p = 1 + ((anei - 1) /(2.8888-1)) if ( anei>1 & edad > 59)
replace anei_p=2 if anei_p>2
label var anei_p "Adecuación de educación del individuo"

*A los menores de 4 años se les da valor de 0 = satisfacción mínima
replace  anei_p =0 if edad<4

***
***Generación de indicador de carencia de educación
***

*Generar variable que identifique a los mayores a dos años
gen mayores_dos_años=1 if edad>2
label var mayores_dos_años "Mayor de 2 años"

*Generar variable de rezago educativo individual
gen rei =  1 - anei_p 
label var rei "Rezago educativo individual"

keep folio numren rei rescgen anei_p 

save "$final/edu.dta", replace


********************************************************************************
* Módulo 4. Salud y Seguridad Social
*
* 4.1 Generación de indicador de ingresos por pensiones y programas de adultos mayores
* 4.2 Acceso a la salud
* 4.3 Indicadores para cálculo de acceso Seguridad Social
* 4.4 Variable de acceso a seguridad social 
*
* Generar salud_y_ss.dta a partir de Poblacion.dta e ingresos.dta                        
********************************************************************************


**************************************
***4.1 Generación de indicador de ingresos por pensiones y programas de adultos mayores
**************************************

*Abrir la base de datos de ingresos
use "$bases/ingresos.dta", clear


*Se mantienen solo los datos de ingresos por pensiones (P033 y P032) y de Programas de Adultos Mayores (P044 y P045)
keep if clave =="P032"| clave =="P033" | clave =="P044" | clave =="P045" 

*Se mantiene en la base solo algunas variables, y se genera la variable folio
keep proyecto folioviv foliohog numren clave ing_tri
egen folio= concat(proyecto folioviv foliohog)
sort folio numren 

*Identificar cuántos hogares tienen ingresos por pensiones
gen pen032=0
replace pen032=1 if clave=="P032" & ing_tri > 0

gen pen033=0
replace pen033=1 if clave=="P033" & ing_tri > 0

gen pen044=0
replace pen044=1 if clave=="P044" & ing_tri > 0

gen pen045=0
replace pen045=1 if clave=="P045"& ing_tri > 0

label var pen032 "Jubilación dentro del país"
label var pen033 "Jubilación de otros países"
label var pen044 "Beneficio de programa 65 y más"
label var pen045 "Beneficio otros programas adultos mayores"

*Colapsar a nivel población dejando 1 como identificador en cada persona que percibe alguno de estos tipos de ingresos
collapse (max) pen032 pen033 pen044 pen045, by(folio numren)

*Guardar la base de datos de pensiones a nivel persona
save "$tmp/Pensiones14.dta", replace

*Abrir la base de población para unirse a la anterior de pensiones
use "$bases/poblacion.dta", clear

*Generar la variable folio
egen folio= concat(proyecto folioviv foliohog)
sort folio numren 

*Se une a la base de factor
merge m:1 folio using "$final/factexp.dta"
drop _merge

*Se une con la base de pensiones
merge 1:1 folio numren using "$tmp/Pensiones14.dta"
drop _merge



*******************
*4.2 Acceso a la salud*
*******************

*Generar variable de acceso a salud
gen asaludi=0

*Se reemplaza el Acceso a Salud, con los siguientes valores
*0.66 si tiene Seguro Popular o IMSS Prospera
replace asaludi=0.66 if segpop=="1" 
*0.33 si tiene "otro"
replace asaludi=0.33 if inst_5=="5"
*1 si tiene IMSS, ISSSTE, ISSSTE estatal
replace asaludi=1 if inst_1 =="1" | inst_2=="2" | inst_3=="3" 
*1.1 Pemex y seguro privado
replace asaludi=1.1 if inst_4=="4" | segvol_2=="2"

*D3
*Dato externo número 3
*****Obtenido de: Cuotas ANUAL IMSS 2014		
************************************************

*Generar variable de Cuota mensual de IMSS por persona
gen segimmsi=0
replace segimmsi=(1900)/12 if edad>=0 & edad<=19 
replace segimmsi=(2300)/12 if edad>=20 & edad<=39 
replace segimmsi=(2500)/12 if edad>=40 & edad<=59 
replace segimmsi=(5300)/12 if edad>=60 
label var segimmsi "Cuota IMSS régimen voluntario mensual por persona 2014"



**Se establece costo monetario de ser no derechohabiente en salud
*Primero, se genera una  variable que identifica a aquellos que no tienen acceso a Salud
gen nodersali=0
replace nodersali=1 if asaludi==0
*Luego se crea una variable que le identifica el costo del seguro voluntario, solo para aquellos que no tienen acceso a salud
gen cnoderchsali=0
replace cnoderchsali=segimmsi if nodersali==1

**************************************************************************
***4.3 Indicadores para cálculo de acceso Seguridad Social (SS)
**************************************************************************

*Generar el identificador de acceso a SS por alguna de las siguientes instituciones
*Que contenga 1 (inscrito como prestación laboral) o 2 (jubilación o invalidez) como su identificador
gen p1=0
gen p2=0
gen p3=0
gen p4=0
replace p1=1 if inst_1=="1" & inscr_1=="1"
replace p2=1 if inst_2=="2" & inscr_1=="1"
replace p3=1 if inst_3=="3" & inscr_1=="1"
replace p4=1 if inst_4=="4" & inscr_1=="1"

replace p1=1 if inst_1=="1" & inscr_1=="2"
replace p2=1 if inst_2=="2" & inscr_1=="2"
replace p3=1 if inst_3=="3" & inscr_1=="2"
replace p4=1 if inst_4=="4" & inscr_1=="2"

*A fin de determinar la cobertura se la SS, se crean variable para identificar 
*a los familiares directos del jefe de familia (pers1) y se aplican las reglas 
*establecidas en las leyes de SS vigentes:
	*Parejas = pers2, hija(o)s=pers3, padres= pers4 o suegros=pers5
	*Dichas variables pers1 a pers5,  toman valor de 1, e identifican al pariente que existe en el hogar
	*Nota: se incluyen parejas del mismo sexo.
destring parentesco, replace
recode parentesco   /// 
       (101 102=1)  ///
	   (200/204=2)  ///
	   (300/305=3)  ///
	   (601=4)      ///
	   (615=5)      ///
	   (else=0), ///
	   gen (paren1) 

gen pers1=1 if paren1==1
gen pers2=1 if paren1==2
gen pers3=1 if paren1==3
gen pers4=1 if paren1==4
gen pers5=1 if paren1==5

replace pers1=0 if pers1==.
replace pers2=0 if pers2==.
replace pers3=0 if pers3==.
replace pers4=0 if pers4==.
replace pers5=0 if pers5==.

* Generar la variable "persm", que identifica a la persona que tiene SERVICIO MEDICO DIRECTO por prestación laboral*.
gen persm=p1 + p2 + p3 + p4
label var persm "Persona con prestación de SS laboral"

* Generar variable (segsocj) que identifica tipo de institución a la que se tiene acceso, para Jefes de familia
	* 1 = imss, 2 = issste federal y estatal, 3 = pemex
gen segsocj=0
replace segsocj=3 if  persm>0 & paren1==1
replace segsocj=1 if  persm>0 & paren1==1 & inst_1=="1" 
replace segsocj=2 if (persm>0 & paren1==1 & (inst_2=="2" | inst_3=="3"))

* Se genera variable (segsocc) que identifica tipo de institución a la que se tiene acceso, para parejas
	* 1 = imss, 2 = issste federal y estatal, 3 = pemex
gen segsocc=0
replace segsocc=3 if (persm>0 & paren1==2)
replace segsocc=1 if (persm>0 & paren1==2 & inst_1=="1") 
replace segsocc=2 if (persm>0 & paren1==2 & (inst_2=="2" | inst_3=="3")) 

* Generar variable (segsocc) que identifica si los hijos tienen acceso a SS
gen segsoch=0
replace segsoch=1 if (persm>0 & (paren1==3 & edad>=16)) 

* Generar variable que identifica si en el hogar hay personas con seguridad social, según parentesco
egen padre=   max(segsocj), by (folio)
egen conyuge= max(segsocc), by (folio)
egen hijoss=  max(segsoch), by (folio) 
egen per1=    max(pers1),   by (folio)
egen per2=    max(pers2),   by (folio)
egen per3=    max(pers3),   by (folio)
egen per4=    max(pers4),   by (folio)
egen per5=    max(pers5),   by (folio)

*Genera una variable que identifica a los hijos de asegurados que van a la escuela y por lo tanto acceden aa SS
*Para ISSSTE, los que son menores a 16 años, o entre 15 y 25 pero asisten a escuela
gen h_b_issste=0
replace h_b_issste=1 if   (((edad<16) | ((edad>15 & edad<25) & asis_esc=="1")) & (paren1==3))
*Para IMSS,   los que son menores a 18 años, o entre 17 y 25 pero asisten a escuela
gen h_b_imss=0
replace h_b_imss=1   if   (((edad<18) | ((edad>17 & edad<25) & asis_esc=="1")) & (paren1==3)) 

***********************************************
*** 4.4 Variable de acceso a seguridad social 
***********************************************

*Generar una variable de Acceso a seguridad social 
gen asegsoci=0 

*Paso 1: Se asigna valor según si es beneficiario de programa de adultos mayores
*Le asigna 0.25 a los que tienen PAM ("65 y más")
replace asegsoci=0.25 if pen044==1
*También para los programas estatales,
replace asegsoci=0.25 if pen045==1
*Con excepción del prorgrama de la CDMX, que se le asigna 0.5
replace asegsoci=0.5 if pen045== 1 & entidad==9

*Paso 2: Se reemplaza de acuerdo a ser asegurado o recibirlo por medio de la pareja
replace asegsoci=1 if segsocj>0 | segsocc>0 | segsoch==1
replace asegsoci=1 if (padre==1 & h_b_imss==1) 
replace asegsoci=1 if (padre==2 & h_b_issste==1) 
replace asegsoci=1 if (conyuge==1 & h_b_imss==1) 
replace asegsoci=1 if (conyuge==2 & h_b_issste==1) 
replace asegsoci=1 if (padre>0 & paren1==4) 
replace asegsoci=1 if (conyuge>0 & paren1==5) 

*Paso 3: Jefe cubre a cónyuge y viceversa.
replace asegsoci=1 if (padre>0 & (conyuge==0 & paren1==2))
replace asegsoci=1 if (conyuge>0 & (padre==0 & paren1==1)) 

*Paso 4: Hijos con prestaciones cubren a  jefe y cónyuge.
replace asegsoci=1 if (hijoss>=1 & padre==0 & paren1==1) 
replace asegsoci=1 if (hijoss>=1 & conyuge==0 & paren1==2) 
replace asegsoci=1 if (hijoss>=1 & segsoch==1)
replace asegsoci=0 if (hijoss>=1 & segsoch==0 & segsocj==0 & segsocc==0 & (paren1==3 | paren1==0)) 

*Paso 5: Se identifica a las personas que tienen acceso indirecto a SS
	* inscr_2 = 2 jubilacion o invalidez
	* inscr_3 = 3 un familiar en el hogar 
	* inscr_4 = 4 muerte de asegurado
	* incsr_7 = 7 un familiar de otro hogar.
replace asegsoci=1 if ((inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") & (inscr_2=="2" | inscr_3=="3" | inscr_4=="4" | inscr_7=="7"))
replace asegsoci=1 if (pen032==1 | pen033==1)

*Etiquetar variables
label var asaludi "Acceso a servicios de salud, individuo"
label var asegsoci "Acceso a seguridad social, individuo"
label var cnoderchsali "Costo Seguro Voluntario IMSS en salud, individuo"

* Se identifica con 1 a los trabajadores del hogar y los huespedes, y luego se retiran de la base.                  
recode parentesco    /// 
       (400/470=1)   ///
	   (700/720=1)   ///
	   (else=0),  ///
	   gen (paren)
replace paren=0 if paren==.
keep if paren==0

*Generar base a nivel individual
egen cnoderchsalij=   		 sum(cnoderchsali), by (folio)
label var cnoderchsalij "Suma no derechohabientes en salud nivel hogar"

save "$tmp/salud_y_ss.dta", replace


********************************************************************************
* Módulo 5. Tiempo
*
* 5.1 Generación de indicadores de carencia de cobertura de menores
* 5.2 Generación de indicador de requerimiento de trabajo doméstico
* 5.3 Generación de indicadores sobre discapacidad y disponibilidad
* 5.4 Generación de indicadores sobre trabajadores del hogar e integrantes disponibles
* 5.5 Calculo del indicador del tiempo
*
* Generar la base etj.dta a partir de TRABAJOS.dta, Poblacion.dta y hogaresmmip.dta
* Bases intermedias: cascm.dta, ocuph.dta, indocu.dta, htrabyguarde.dta y jorexc.dta
********************************************************************************


************************************************************************
***5.1 Generación de indicadores de carencia de cobertura de menores
************************************************************************

***
***Identificación de prestación de guardería
***

*Abrir base de "Trabajo"
use "$bases/trabajos.dta", clear
*Se crea el identificador "folio"
egen folio = concat(proyecto folioviv foliohog)
sort folio

*Se modifica variable de prestación de guardería (prestación_6)
gen pres_6_mod= pres_6
destring pres_6_mod htrab, replace
replace pres_6_mod=0 if  pres_6_mod==.
replace htrab=0 if  htrab==.

*Colapsar indicador de Guardería como prestación y suma de horas trabajadas en ambos trabajos por persona.
collapse (sum) htrab (max) pres_6_mod, by(folio numren)
rename htrab hstrmesp
label var hstrmesp "Horas trabajadas en ambos empleos"
label var pres_6_mod "Indicador prestación de guardería"
* Guardar base
save "$tmp/htrabyguarde.dta", replace

***
***Variables relacionadas con cuidado de menores
***

*Abrir la base de población
use "$bases/poblacion.dta", clear
*Se crea el identificador "folio"
egen folio = concat(proyecto folioviv foliohog)
sort folio

*Se unen las bases creadas anteriormente
merge 1:1 folio numren using "$tmp/htrabyguarde.dta"
drop _merge

*Quitar missings de hstrmesp
replace hstrmesp=0 if  hstrmesp==.

*Generar variables de parentesco y sexo a modificar
destring parentesco sexo, replace

*Generar variable de guardería
gen guard=0
replace guard=1 if pres_6_mod==6

*Generar variable que identifica menores de 10 años
gen menorh10=0
replace menorh10=1 if edad<=10

*Generar variable que identifica trabajadores del hogar
gen trab_hogar=0
replace trab_hogar=1 if ( parentesco >= 401 &  parentesco <= 412)

*Colapsar indicador de Trabajadores del hogar y agregar a la misma base
egen trab_hogar_h=sum(trab_hogar), by(folio)

*Recodificar variable de parentesco, 1 identifica a los no familiares
recode parentesco      /// 
       (400/470=1)     ///
	   (700/999997=1),  ///
       gen (paren) 
replace paren=0 if paren !=1
keep if paren==0	   
	   
*Generar identificador de madre
gen esmama=0
replace esmama=1 if ((parentesco== 101 | (parentesco>=201 & parentesco<= 204 )) & sexo== 2)

*Generar identificador de hija
gen esmama_hija=0
replace esmama_hija=1 if ((parentesco>=301 & parentesco<= 305 ) & sexo==2)

*Crear y modificar identificador de asistencia a la escuela
destring asis_esc, replace
recode asis_esc (2=0) (missing=0) , gen(asis_esc_modif)
tab asis_esc_modif asis_esc
tab asis_esc_modif

*Identificador de mujeres que tienen prestación de guardería
gen der_guard=0
gen der_guard_hija=0
replace der_guard=1 if (guard== 1 & esmama== 1) 
replace der_guard_hija=1 if (guard== 1 & esmama_hija== 1) 

*Generar variable de derecho a guardería a nivel hogar, aún por madre e hija
egen der_guard_max=max(der_guard), by(folio)
egen der_guard_hija_max=max(der_guard_hija), by(folio)

*Generar identificador de menores de hasta 5 años
gen menorh5=0
replace menorh5=1 if edad <= 5
label var menorh5 "Menor de hasta cinco" 
replace menorh5 =0 if menorh5==.

*Identificador de menores que asisten a escuela o guardería
gen menor_asis_esc=0
replace menor_asis_esc=1 if (asis_esc== 1 & menorh10== 1)
replace menor_asis_esc=1 if (der_guard_max==1 & (parentesco>=301 & parentesco<= 305) &  menorh5== 1)
replace menor_asis_esc=1 if (der_guard_hija_max== 1 & parentesco== 609 &  menorh5== 1)

*Identificar pob de 15 a 69 años
gen n15_69 = 0 
replace n15_69 =1 if (edad>= 15 & edad< 70)

*Identificar pob de 12 a 14 años
gen d_12_14=0
replace d_12_14=6/48 if (edad >= 12 & edad <= 14) 
label var d_12_14 "Disponible 12 a 14 años"

*Identificar pob de 70 a 79 años
gen d_70_79=0
replace d_70_79=16/48 if  (edad >= 70 & edad <= 79) 
label var d_70_79 "Disponible 70 a 79 años"

*Colapsar y renombrar variables
collapse (sum) n15_69 hstrmesp menorh10 menor_asis_esc d_70_79 d_12_14 (max) trab_hogar_h, by(folio)
label var n15_69 "Total personas entre 15 y 69 en hogar"
label var menorh10 "Menores de hasta 10 años en el hogar" 

rename hstrmesp wj
label var wj "Total de horas de trabajo por hogar (ocup princ y sec)"

rename trab_hogar_h JTH
label var  JTH "Trabajadores del hogar"

rename menor_asis_esc asis_esch 
label var asis_esch "Menores de 11 años en hogar que asisten escuela o guardería"  

rename d_70_79 dj70_79
label var dj70_79 "Disponible 70 a 79 años"

rename d_12_14 dj12_14
label var dj12_14 "Disponible 12 a 14 años"

*Crear variable de cobertura de menores (en escuela o guarderías)
gen cobertura_menores=0
replace  cobertura_menores=asis_esch/menorh10 if menorh10 > 0
label var cobertura_menores "Cobertura educativa de menores de 11"
*Generar variable de carencia de cuidado de menores
gen CASCMj= (1-cobertura_menores)*2
label var CASCMj "Carencia cuidado de menores"
*Verificar que no se le esté imputando carencia en el cuidado de menores a hogares que no tienen menores
replace CASCMj=0 if (menorh10==0 & CASCMj==2)

*Guardar base de datos
save "$tmp/cascm.dta", replace

************************************************************************
***5.2 Generación de indicador de requerimiento de trabajo doméstico
************************************************************************

*Trabajar base temporal proveniente del módulo 1 "NBI"
use "$tmp/hogaresmmip.dta", clear

*Disponibilidad del agua 
destring disp_agua, replace
recode disp_agua (1=0) (2=0.66) (3/7=2), gen(AAJ)

*Recodificación de variables de bienes del hogar
	*Nota, algunos indicadores tienen un valor -1, que reporta dato "no especificado". Se mandan a Cero.
recode num_refri num_licua num_lavad num_auto num_van num_pickup num_moto (2/999=1) (0=0) (1=1) (-1=0), 
label var num_refri "¿Tiene refrigerador?"
label var num_licua "¿Tiene licuadora?"
label var num_lavad "¿Tiene lavadora?"
label var num_auto  "Auto"
label var num_van   "Camioneta"
label var num_pickup "Camioneta_caja"
label var num_moto  "Moto"

*Indicador de vehiculo motorizado
gen vehicmot = 0
label var vehicmot "¿Tiene vehiculo motorizado?"
replace vehicmot = 1 if (num_auto==1 | num_van==1 | num_pickup==1 | num_moto==1)  

*Indicador de equipo domestico 
gen equipdom= 0
replace equipdom= num_refri + num_licua + num_lavad
label var equipdom "¿Tiene equipo doméstico?"

*Indicador de carencia de equipo ahorrador de trabajo doméstico 
gen CEATDj=0
label var CEATDj "Carencia de equipo ahorrador de trabajo doméstico"

*Se pondera el indicador de acuerdo a disponibilidad de vehículo motorizado o equipo doméstico
replace CEATDj = 0  if (equipdom == 3 & vehicmot == 1)
replace CEATDj = 0  if (equipdom == 2 & vehicmot == 1)
replace CEATDj = 1  if (equipdom == 1 & vehicmot == 1)
replace CEATDj = 1  if (equipdom == 0 & vehicmot == 1)
replace CEATDj = 0  if (equipdom == 3 & vehicmot == 0)
replace CEATDj = 1  if (equipdom == 2 & vehicmot == 0)
replace CEATDj = 2  if (equipdom == 1 & vehicmot == 0)
replace CEATDj = 2  if (equipdom == 0 & vehicmot == 0)

*Se unen las bases creadas anteriormente
merge 1:1 folio using "$tmp/cascm.dta"

*Indicador de la intensidad del trabajo doméstico
gen ITDj=.
replace ITDj = ((AAJ + CEATDj)/2) if menorh10==0
replace ITDj = ((AAJ + CEATDj + CASCMj)/3)  if menorh10>0

*Indicador de la intensidad del trabajo doméstico por estratos
gen       ITDj_r=.
replace   ITDj_r=0 if ITDj<=0.5
replace   ITDj_r=1 if ITDj>0.5 & ITDj<=1.5
replace   ITDj_r=2 if ITDj>1.5 
label var ITDj_r "Intensidad trab dom por estratos"
drop ITDj
rename ITDj_r ITDj

*Se agrupa tamaño de hogar para un mejor manejo de la variable
recode tam_hog (1 2=1)(3 4=3)(5 6=5)(7/99997=7), gen(rank_nhog)
label var rank_nhog "Recodificación de tamaño de hogar" 

***
***Indicador de requerimiento de jornada de trabajo doméstico
***
gen RTDj=.
replace RTDj = 0.7 if (menorh == 0 & ITDj == 2 & rank_nhog == 1)
replace RTDj = 0.9 if (menorh == 0 & ITDj == 2 & rank_nhog == 3)
replace RTDj = 1.1 if (menorh == 0 & ITDj == 2 & rank_nhog == 5)
replace RTDj = 1.3 if (menorh == 0 & ITDj == 2 & rank_nhog == 7)

replace RTDj = 0.5 if (menorh == 0 & ITDj == 1 & rank_nhog == 1)
replace RTDj = 0.7 if (menorh == 0 & ITDj == 1 & rank_nhog == 3)
replace RTDj = 0.9 if (menorh == 0 & ITDj == 1 & rank_nhog == 5) 
replace RTDj = 1.1 if (menorh == 0 & ITDj == 1 & rank_nhog == 7) 

replace RTDj = 0.3 if (menorh == 0 & ITDj == 0 & rank_nhog == 1) 
replace RTDj = 0.5 if (menorh == 0 & ITDj == 0 & rank_nhog == 3) 
replace RTDj = 0.7 if (menorh == 0 & ITDj == 0 & rank_nhog == 5) 
replace RTDj = 0.9 if (menorh == 0 & ITDj == 0 & rank_nhog == 7) 

replace RTDj = 1.2 if (menorh > 0 & ITDj == 2  & rank_nhog == 1) 
replace RTDj = 1.4 if (menorh > 0 & ITDj == 2  & rank_nhog == 3) 
replace RTDj = 1.6 if (menorh > 0 & ITDj == 2  & rank_nhog == 5) 
replace RTDj = 1.8 if (menorh > 0 & ITDj == 2  & rank_nhog == 7) 

replace RTDj = 1.0 if (menorh > 0 & ITDj == 1  & rank_nhog == 1) 
replace RTDj = 1.2 if (menorh > 0 & ITDj == 1  & rank_nhog == 3) 
replace RTDj = 1.4 if (menorh > 0 & ITDj == 1  & rank_nhog == 5) 
replace RTDj = 1.6 if (menorh > 0 & ITDj == 1  & rank_nhog == 7) 

replace RTDj = 0.8 if (menorh > 0 & ITDj == 0  & rank_nhog == 1) 
replace RTDj = 1.0 if (menorh > 0 & ITDj == 0  & rank_nhog == 3) 
replace RTDj = 1.2 if (menorh > 0 & ITDj == 0  & rank_nhog == 5) 
replace RTDj = 1.4 if (menorh > 0 & ITDj == 0  & rank_nhog == 7) 

label var RTDj "Requerimiento de jornada de trabajo doméstico" 

*Guardar la base de datos
keep folio municipio entidad ur_rur_2500 alcaldia cobertura_menores ITDj ///
n15_69 dj12_14 dj70_79 wj menorh10 JTH RTDj RTDj 
save "$tmp/ocuph.dta", replace

************************************************************************
***5.3 Generación de indicadores sobre discapacidad y disponibilidad
************************************************************************

***
***Identificador de población que tiene trabajo, pero no trabajó mes pasado, estudiantes e incapacitados  
***

use "$bases/poblacion.dta", clear

*Se crea el identificador "folio"
egen folio = concat(proyecto folioviv foliohog)
sort folio

*Indicador ocupados de 12 a 79 años 
keep if edad>=12 & edad<80
label var motivo_aus "Causa no trabajo mes pasado"

*Indicador ONT (Ocupados que No Trabajaron): causa por la que no trabajó el mes pasado 
gen ont=0
* Reemplazar si es 1) huelga o paro laboral, 2) paro técnico, 3) Suspensión temporal de sus finciones, ///
	*4) Asistencia a cursos de capcitación, 5) Vacaciones y 6) Permiso, enfermedad o arreglo de asuntos personales
replace  ont = 1 if (motivo_aus == "01" | motivo_aus == "02" | motivo_aus == "03" | motivo_aus == "04" | motivo_aus == "05" | motivo_aus == "06" )
label var ont "Ocupados que no trabajaron" 

*Indicador de ocupados que no trabajaron de 12 a 79 años
gen 		ONT=0
replace 	ONT=6/48  if  (ont == 1 & (edad >= 12 & edad  <= 14))
replace 	ONT=16/48 if  (ont == 1 & (edad >= 70 & edad  <= 79)) 
replace 	ONT=1     if  (ont == 1 & (edad >= 15 & edad  <= 69))
label var 	ONT "Ocupados que no trabajaron de 12 a 79 años" 

*Indicador de 15 a 79 años que asisten a la escuela 
gen EST=0
replace  EST = 1 if ((edad >= 15 & edad < 80) & asis_esc == "1")
label var EST "Estudiantes"

*Indicador de personas con discapacidad y que por esa razón no trabajan
gen C_Disc_a=0
replace C_Disc=1 if act_pnea1=="5"
label var C_Disc "Personas con discapacidad y que por esa razón no trabajan"

*Indicador de personas con discapacidad  de 12 a 79 años y que por esa razón no trabajan
gen 		C_Disca=0
replace  	C_Disca=6/48  	if  (C_Disc_a==1 & (edad >= 12 & edad  <= 14))
replace  	C_Disca=16/48 	if  (C_Disc_a==1 & (edad >= 70 & edad  <= 79))
replace  	C_Disca=1 		if  (C_Disc_a==1 & (edad >= 15 & edad  <= 69))
label var 	C_Disca "Personas con discapacidad y que por esa razón no trabajan de 12 a 79"

*Se colapsan las variables a nivel hogar
collapse (sum) C_Disca EST ONT, by(folio)

label var C_Disca "Número de personas con discapacidad"
label var EST "Número de estudiantes en el hogar"
label var ONT "Número de ocupados que no trabajó mes pasado"

save "$tmp/jorexc.dta", replace

************************************************************************
***5.4 Generación de indicadores sobre trabajo doméstico
************************************************************************

*Utilizar base creada anteriormente
use "$final/factexp.dta",clear 
merge 1:1 folio using "$tmp/ocuph.dta"
drop _merge

*Generar indicador de trabajo doméstico
gen tieneserv=0
replace tieneser=1 if JTH>1

*Generar indicador de jornadas de trabajadores del hogar
label var JTH "Jornadas desempeñadas por trabajadores del hogar"

*Pegar con la base jorexc
merge 1:1 folio using "$tmp/jorexc.dta"
drop _merge

*Se reemplanzan valores perdidos por cero
replace ONT=0 		if ONT==.
replace EST=0 		if EST==.
replace C_Disca=0 	if C_Disca==.
replace RTDj=0 		if RTDj==.
replace JTH=0 		if JTH==.   

*Generar indicador de jornadas de trabajo que no se suman al total del hogar
gen hj= ONT + (EST*0.5833) +  C_Disca
label var hj "Jornadas de trabajo excluidas en el hogar"
replace hj=0 if hj==. | hj<0

*Generar indicador neto de disponibilidad de jornadas de trabajo doméstico por hogar
gen 	kj= (n15_69 + dj12_14 + dj70_79) - hj
replace kj=0 if kj==. | kj<0
label var kj "Horas disponibles de trabajo por hogar"

**************************************************
* 5.5 Calculo del indicador del tiempo
**************************************************

***
***Generación de indicador final de tiempo
***
gen ett=0

replace ett= ((1 + wj) + ((RTDj - JTH) * 48)) /   (kj * 48) 	if (kj >  0 & RTDj >= JTH) 
replace ett= ((1 + wj)                        /   (kj * 48))  	if (kj >  0 & RTDj <  JTH) 
replace ett= ((1 + wj) + ((RTDj - JTH) * 48)) /(1+(kj * 48)) 	if (kj <= 0 & RTDj >= JTH) 
replace ett= ((1 + wj)                        /(1+(kj * 48)))   if (kj <= 0 & RTDj <  JTH) 

replace ett=0.1 if ett>0 & ett<=0.5
replace ett=2 if ett>2 

*Generación de indicador de trabajo doméstico
gen trab_dom = (RTDj - JTH)*48 

*Guardar una base que contiene todas las variables 
save "${tmp}/indocu.dta", replace 

*Se seleccionan algunas variables y se guarda una base con solo esas variables
keep folio municipio entidad ur_rur_2500 alcaldia ett trab_dom
save "$final/etj.dta", replace 

******************************************************************************
* Módulo 6. Ingresos
*
* 6.0   Mes levantamiento de la encuesta, adultos equivalentes
* 6.1   Ingreso monetario
* 6.2   Ingreso no monetario 
* 6.3   Ingreso Total Mensual del hogar 
* 6.4   Líneas de pobreza
* 6.5   Indicador de ingresos del MMIP
* 6.6   Indicador de carencia de salud y SS 
* 6.7   Indicador de Ingresos-Tiempo
*
* Generar las bases finales cict.dta, CASSi.dta y cyt.dta
*
* Generar las bases intermedias: adultos_equivalentes.dta ing_x_persona.dta
* ing_cor_mon.dta gastohogar_no_mon.dta gastospersona_no_mon.dta ing_cor_no_mon.dta y ing_cor_tot.dta
******************************************************************************


*******************************************************************************
*  6.0  Mes levantamiento de la encuesta, y Adultos equivalentes
*******************************************************************************.

***** Cálculo de los adultos equivalentes del hogar, se obtiene de la base 
***** Poblacion.dta, y factexp (se eliminan a los no parientes) ******.

*Abrir la base datos, y solo dejamos variables de edad sexo y parentesco
use "${bases}/poblacion.dta", clear 
keep proyecto folioviv foliohog edad sexo parentesco
sort proyecto folioviv foliohog 
egen folio=concat (proyecto folioviv foliohog)

merge m:1 folio using "${final}/factexp.dta"
tab _merge
drop _merge

*Se eliminan los que no son miembros de la familia en el hogar
destring parentesco, replace
drop if parentesco>=400 & parentesco <500
drop if parentesco>=700 & parentesco <800

*Se identifican individuos por edades
gen bebe=1 if edad>=0 & edad<=2
gen nino=1 if edad>=3 & edad<=14
gen adulto=1 if edad>=15 & edad<=112

*Adulto Equivalente Urbano
gen AE=.
replace AE=0.40 if bebe==1 & sexo=="1"
replace AE=0.39 if bebe==1 & sexo=="2"
replace AE=0.56 if nino==1 & sexo=="1"
replace AE=0.55 if nino==1 & sexo=="2"
replace AE=1.00 if adulto==1 & sexo=="1"
replace AE=0.81 if adulto==1 & sexo=="2"

*Adulto Equivalente Rural
replace AE=0.47 if bebe==1 & sexo=="1" & tam_loc==4
replace AE=0.45 if bebe==1 & sexo=="2" & tam_loc==4
replace AE=0.65 if nino==1 & sexo=="1" & tam_loc==4
replace AE=0.63 if nino==1 & sexo=="2" & tam_loc==4
replace AE=1.00 if adulto==1 & sexo=="1" & tam_loc==4
replace AE=0.83 if adulto==1 & sexo=="2" & tam_loc==4

*Identificador de individuo
gen N=1

*Se colapsan las variables a nivel hogar
collapse (sum) AE N, by(folio)
rename AE ae_sum
rename N N_BREAK

*Guardar base de datos
save "${tmp}/adultos_equivalentes.dta", replace

*********************************************************
*  6.1   Ingreso monetario
*********************************************************
 
use "${bases}/ingresos.dta", clear 

*Generar variable de decena de levantamiento
gen decena=real(substr(folioviv,8,1))
destring decena, replace
recode decena ///
	(0/1 = 8 "Agosto") ///
	(2/4 = 9 "Septiembre") ///
	(5/7 = 10 "Octubre") ///
	(8/9 = 11 "Noviembre"), ///
	gen (meslevan) label (meslevan)

destring mes_*, replace
	
*Generar folio
egen folio=concat (proyecto folioviv foliohog)

*Gwnerar una variable de ingreso identica para hacer modificaciones
gen ing_11=ing_1
gen ing_21=ing_2
gen ing_31=ing_3
gen ing_41=ing_4
gen ing_51=ing_5
gen ing_61=ing_6

***
***Proceso de deflactación
***

*Se regresa a un mes antes para deflactar conforme el mes de referencia
rename ing_11 ing_ma
rename ing_21 ing_11
rename ing_31 ing_21
rename ing_41 ing_31
rename ing_51 ing_41
rename ing_61 ing_51

*Se generó nueva variable de ingresos para deflactar
*D4
*Dato externo 4:
*Deflactor del INPC tomado de INEGI
scalar par_1 =	0.994287
scalar par_2 =	0.997011
scalar par_3 =	0.995151
scalar par_4 =	0.991969
scalar par_5 =	0.993688
scalar par_6 =	0.996420
scalar par_7 =	1.000000
scalar par_8 =	1.004416
scalar par_9 =	1.009970

*Deflactor 5-> den 5
gen den5=.
replace den5= par_1 if meslevan==8
replace den5= par_2 if meslevan==9
replace den5= par_3 if meslevan==10
replace den5= par_4 if meslevan==11

*Deflactor 4-> den 4
gen den4=.
replace den4= par_2 if meslevan==8
replace den4= par_3 if meslevan==9
replace den4= par_4 if meslevan==10
replace den4= par_5 if meslevan==11

*Deflactor 3-> den 3
gen den3=.
replace den3= par_3 if meslevan==8
replace den3= par_4 if meslevan==9
replace den3= par_5 if meslevan==10
replace den3= par_6 if meslevan==11

*Deflactor 2-> den 2
gen den2=.
replace den2= par_4 if meslevan==8
replace den2= par_5 if meslevan==9
replace den2= par_6 if meslevan==10
replace den2= par_7 if meslevan==11

*Deflactor 1-> den 1
gen den1=.
replace den1= par_5 if meslevan==8
replace den1= par_6 if meslevan==9
replace den1= par_7 if meslevan==10
replace den1= par_8 if meslevan==11

*Deflactor principal -> den ma
gen denma=.
replace denma= par_6 if meslevan==8
replace denma= par_7 if meslevan==9
replace denma= par_8 if meslevan==10
replace denma= par_9 if meslevan==11

*Se deflactan de acuerdo al mes de levantamiento
replace ing_51=ing_6/den5 
replace ing_41=ing_5/den4 
replace ing_31=ing_4/den3 
replace ing_21=ing_3/den2 
replace ing_11=ing_2/den1 
replace ing_ma=ing_1/denma 

*Para poder hacer el loop se genera el valor numerico de la clave
gen clave_sin= substr(clave,-2,2)
destring clave_sin, replace

*Se hace el loop para generar la suma del ingreso deflactado para cada clave de ingreso
forvalues i= 1 / 89 {
gen P_`i'=0
replace P_`i' = ing_51 + ing_41 + ing_31 + ing_21 + ing_11 + ing_ma if clave_sin==`i'
}
*Se reemplazan los valores perdidos por cero.
forvalues i= 1 / 89 {
replace P_`i'=0 if P_`i'==.
}

***
***Generar el ingreso corriente mensual deflactado
***
gen incomod=0
replace incomod= ((P_1  + P_2  + P_3  + P_4  + P_5  + ///
				   P_6  + P_7  + P_11 + P_12 + P_13 + ///
				   P_14 + P_18 + P_19 + P_20 +        ///
				   P_21 + P_22 + P_23 + P_24 + P_25 + ///
				   P_26 + P_27 + P_28 + P_29 + P_30 + ///
				   P_31 + P_32 + P_33 + P_34 + P_35 + ///
				   P_36 + P_37 + P_38 + P_39 + P_40 + ///
				   P_41 + P_42 + P_43 + P_44 + P_45 + ///
				   P_46 + P_47 + P_48 + P_67 + P_68 + ///
				   P_69 + P_70 + P_71 + P_72 + P_73 + ///
				   P_74 + P_75 + P_76 + P_77 + P_78 + ///
				   P_79 + P_80 + P_81)/6)+ ///
				   ((P_8 + P_15 + P_50)/12) 

label var incomod "Ingreso corriente mensual deflactado"				   

***
***Generar el ingreso mensual en cada clave
***
forvalues i=1/7 {
gen P_M`i'=0
replace P_M`i'= P_`i'/6
}

forvalues i=8/9 {
gen P_M`i'=0
replace P_M`i'= P_`i'/12
}

forvalues i=10/14 {
gen P_M`i'=0
replace P_M`i'= P_`i'/6
}

forvalues i=15/16 {
gen P_M`i'=0
replace P_M`i'= P_`i'/12
}

forvalues i=17/49 {
gen P_M`i'=0
replace P_M`i'= P_`i'/6
}

gen P_M50=0
replace P_M50= P_50/12

forvalues i=51/81 {
gen P_M`i'=0
replace P_M`i'= P_`i'/6
}

*


***
***Construir Ingreso Laboral
***

gen inglabt=0
replace inglabt= P_M1  + P_M2  + P_M3  + P_M4  + P_M5  + P_M6  + ///  
				 P_M7  + P_M8  + P_M11 + P_M14 + P_M15 + P_M18 + ///
				 P_M19 + P_M20 + P_M21 + P_M22 +				 ///
				 P_M67 + P_M68 + P_M69 + P_M70 + P_M71 + P_M72 + P_M73 + P_M74 +  ///
				 P_M75 + P_M76 + P_M77 + P_M78 + P_M79 + P_M80  + P_M81 
label var inglabt "Ingreso laboral total mensual"


*Se colpasa la base a nivel individuo
collapse (sum) incomod inglabt P_34 P_35 P_36, by(folio numren)

*Guardar la base de ingresos por persona
save "${ingresos}/ing_x_persona.dta", replace


***
***Calcular ingreso por hogar
***

*Utilizar base de población como plantilla
use "$bases/poblacion.dta",clear
*Generar Folio
egen folio=concat (proyecto folioviv foliohog)
*Se uno con base de ingresos por persona
merge 1:1 folio numren using "$ingresos/ing_x_persona.dta"

*Se eliminan los que no son miembros de la familia en el hogar
destring parentesco, replace
gen parentesco1=0
replace parentesco1=1 if (parentesco>=400 & parentesco<=470) | (parentesco>=700 & parentesco<=720)
drop if parentesco1==1

*Para el momento de collapse generar una variable N del tamaño de hogar eliminando los parentescos no deseados
gen N=1

*Cambiar los valores perdidos a 0
recode incomod inglabt P_34 P_35 P_36 (.=0)

*Se colapsa a nivel hogar
collapse (sum) incomod inglabt P_34 P_35 P_36 N, by(folio)

*Se renombran variables para identificar que son a nivel hogar
rename incomod ing_mon 
rename inglabt inglabth 
rename P_34 YIDj 
rename P_35 YISj 
rename P_36 YISj2 
rename N tam_hog

*Etiquetar variables
label var ing_mon 				"Ingreso Corriente Monetario del Hogar"
label var inglabth 				"Ingreso laboral total mensual"
label var tam_hog 				"Tamaño de hogar, solo miembros familia"
label var YIDj 					"Indemn. por seguros contra riesgos a terceros"
label var YISj 					"Indemn. por accidentes de trabajo"
label var YISj2 				"Indemn. por despido y retiro involuntario"

*Base de ingresos del hogar
save "${ingresos}/ing_cor_mon.dta", replace


**************************************************
*  6.2   Ingreso no monetario
**************************************************

***
***6.2.1 Cálculo del ingreso no monetario por hogar
***

*Abrir la base de Gastos por hogar
use "$bases/gastohogar.dta",clear

*Se borran los gastos monetarios, ya que no serán utilizados
drop if tipo_gasto=="G1" 
drop if tipo_gasto=="G2" 

*Control para la frecuencia de los regalos recibidos por el hogar: se quitan los que no son corrientes, es decir, lo que "solo se dieron una vez" u "otros"
drop if ((frecuencia>="5" & frecuencia<="6") | frecuencia==" ") & ( tipo_gasto=="G5" |  tipo_gasto=="G6")

*Generar folio
egen folio=concat (proyecto folioviv foliohog)
sort folio

*Generar variables de gasto monetario
gen g3_gas_nm_tri=0
gen g5_gas_nm_tri=0
gen g6_gas_nm_tri=0
gen g7_gas_nm_tri=0

*Se reemplaza con  el dato del código correspodiente de Gasto No Monetario
replace g3_gas_nm_tri=gas_nm_tri if tipo_gasto=="G3"
replace g5_gas_nm_tri=gas_nm_tri if tipo_gasto=="G5"
replace g6_gas_nm_tri=gas_nm_tri if tipo_gasto=="G6"
replace g7_gas_nm_tri=gas_nm_tri if tipo_gasto=="G7"

*Se reemplazan los valores perdidos por cero
recode  g3_gas_nm_tri g5_gas_nm_tri g6_gas_nm_tri g7_gas_nm_tri (.=0)

*Se colapsan por hogar
collapse (sum)  g3_gas_nm_tri g5_gas_nm_tri g6_gas_nm_tri g7_gas_nm_tri, by(folio)

*Se reemplaza nombre para señalar que es a nivel hogar
rename g3_gas_nm_tri g3h_gas_nm_tri
rename g5_gas_nm_tri g5h_gas_nm_tri
rename g6_gas_nm_tri g6h_gas_nm_tri
rename g7_gas_nm_tri g7h_gas_nm_tri

*Cuidado: G3, G5 y G6 solo están disponibles para "proyecto=2", esto es, 
	*para ENIGH y no para MCS

*Se agrega descripción de variables
label var g3h_gas_nm_tri "SOLO ENIGH-> Autoconsumo trim"
label var g5h_gas_nm_tri "SOLO ENIGH-> Regalos otros hog. trim"
label var g6h_gas_nm_tri "SOLO ENIGH-> Transferencias de inst. trim"	 
label var g7h_gas_nm_tri "Estimacion imputada del alquiler trim." 

*Guardar la base de datos
save "$ingresos/gastohogar_no_mon.dta", replace 

***
*6.2.2 Calculo del ingreso no monetario por persona
***

*Abrir base de gastos por persona
use "$bases/gastospersona.dta",clear 

*Control para la frecuencia: se quitan los que no son corrientes, es decir, 
	*11 = "lo recibió una sola vez" 
	*12 = "otra frecuencia"
drop if (frecuencia=="11") | (frecuencia=="12") 

*Se elimina gasto monetario-> G1 o G2
drop if (tipo_gasto=="G2" |tipo_gasto=="G1")

*Generar Folio
egen folio=concat (proyecto folioviv foliohog)

*Generar variables para cada tipo de gasto
gen g4p_gas_nm_tri=0
gen g5p_gas_nm_tri=0
gen g6p_gas_nm_tri=0

replace g4p_gas_nm_tri=gas_nm_tri if tipo_gasto=="G4"
replace g5p_gas_nm_tri=gas_nm_tri if tipo_gasto=="G5"
replace g6p_gas_nm_tri=gas_nm_tri if tipo_gasto=="G6"

*Se recodifica para convertir los valores perdidos en cero
recode g4p_gas_nm_tri g5p_gas_nm_tri g6p_gas_nm_tri(.=0)

*Colapsamos la variable a nivel hogar
collapse (sum)  g4p_gas_nm_tri g5p_gas_nm_tri g6p_gas_nm_tri, by(folio)

*Se etiqueta la variable
label var g4p_gas_nm_tri "GNM remuneraciones en especie Trim"
label var g5p_gas_nm_tri "SOLO MCS-> GNM regalos otros hogares Trim"
label var g6p_gas_nm_tri "SOLO MCS-> GNM transf instituciones Trim"

*Guardar la base de datos a nivel persona
save "$ingresos/gastospersona_no_mon.dta", replace 


***
*6.2.3 Calculo del ingreso no monetario total
***

*Abrir la base plantilla por hogar, y se une a las de GNM creadas
use "$final/factexp.dta",clear 
merge 1:1 folio using "$ingresos/gastospersona_no_mon.dta"
drop _merge
merge 1:1 folio using "$ingresos/gastohogar_no_mon.dta"
drop _merge

*Se verifica que no haya datos perdidos, modficando a cero
recode g3h_gas_nm_tri g4p_gas_nm_tri g5h_gas_nm_tri g5p_gas_nm_tri g6h_gas_nm_tri ///
	g6p_gas_nm_tri g7h_gas_nm_tri (.=0)

*Generar decena de levantamiento
gen decena=real(substr(folioviv,8,1))
destring decena, replace
recode decena ///
	(0/1 = 8 "Agosto") ///
	(2/4 = 9 "Septiembre") ///
	(5/7 = 10 "Octubre") ///
	(8/9 = 11 "Noviembre"), ///
	gen (meslevan) label (meslevan)

*Generar el deflactor
*D5
*Dato externo 5 
*Deflactor del INPC tomado de INEGI
gen deflac=0
replace deflac = 1.000000 if meslevan==8
replace deflac = 1.004416 if meslevan==9
replace deflac = 1.009970 if meslevan==10
replace deflac = 1.018115 if meslevan==11
label var deflac "Suma de gastos trimestral NBI sin deflactar excepto regalos"

*Se deflactan gasto no monetarios y se divide en tres paraobtener dato mensual
gen autocons 		= (((g3h_gas_nm_tri) / deflac)/3)
gen remu_esp 		= (((g4p_gas_nm_tri) / deflac)/3)
gen reg_hog_hog 	= (((g5h_gas_nm_tri) / deflac)/3)
gen reg_hog_pers	= (((g5p_gas_nm_tri) / deflac)/3)
gen trans_inst_hog  = (((g6h_gas_nm_tri) / deflac)/3)
gen trans_inst_pers = (((g6p_gas_nm_tri) / deflac)/3)
gen estim_alq   	= (((g7h_gas_nm_tri) / deflac)/3)

*Etiquetar variables
label var autocons		  "SOLO ENIGH-> GNM Autoconsumo mensual deflactado"
label var remu_esp		  "GNM remu en especie mensual deflactado"
label var reg_hog_hog	  "SOLO ENIGH-> GNM Reg otros hog. mensual deflactado"
label var reg_hog_pers 	  "SOLO MCS-> GNM Reg otros hog. mensual deflactado"
label var trans_inst_hog  "SOLO ENIGH-> GNM Transf de inst. mensual deflactado"	 
label var trans_inst_pers "SOLO MCS-> GNM Transf de inst. mensual deflactado"
label var estim_alq		  "GNM Estimacion imput alquiler mensual deflactado" 


***
*** Calculo del ingreso corriente no monetario mensual *
***

*Generar Regalos de otros hogares total
gen reg_hog_tot= reg_hog_hog + reg_hog_pers

*Generar Transferencias de instituciones total
gen trans_inst_tot= trans_inst_hog + trans_inst_pers

*Para el ingreso no monetario mensual, se suma G4 (remu_esp), G5 (regalos recibidos de otros hogares)
	*										   G6 (transf. instituciones) y G7 (estim_alq)  
gen ing_no_mon = (remu_esp + reg_hog_tot + trans_inst_tot + estim_alq) 
label var ing_no_mon "Ing Corr No Mon 8/2014 mensual"

*Se guarda la base
save "${ingresos}/ing_cor_no_mon.dta", replace 


**************************************************************************
* 6.3   Ingreso Total Mensual del hogar 
**************************************************************************

*Abrir la base plantilla por hogar, y se une a las de ingreso monetario y no monetario creadas
use "$final/factexp.dta",clear 
merge 1:1 folio using "$ingresos/ing_cor_mon.dta"
drop _merge
merge 1:1 folio using "$ingresos/ing_cor_no_mon.dta"
drop _merge


*Se recodifica para cambiar valores perdidos por ceros
recode ing_no_mon ing_mon autocons remu_esp reg_hog_hog reg_hog_pers trans_inst_hog trans_inst_pers estim_alq (.=0)

***
*** Se calcula Ingreso Corriente Total
***
gen ict = ing_mon + ing_no_mon 
label var ict "Ingreso Corriente Total Mensual 8/2014"

*Generar el ingreso laboral para verificación con tiempo
gen inglabtot = inglabth + remu_esp
label var inglabtot "Ingreso total laboral"

*Se cambian valores perdidos por ceros
recode YIDj YISj YISj2 (.=0)

*Se redefine el ingreso, quitando las indemizaciones (las cuáles son pagos únicos y no corrientes)
rename ict ict_previo
gen ict = ict_previo - ((YISj + YIDj + YISj2) / 6) 
label var ict "Ing Corr Tot Mensual Hogar Redefinido"

*Se une con la base de Adulto Equivalente
merge 1:1 folio using "$tmp/adultos_equivalentes.dta"
drop _merge

*Generar ingreso corriente mensual por adulto equivalente
gen ict_ae = ict / ae_sum 
label var ict_ae "Ingreso total mensual / adulto equivalente"

*Generar ingreso corriente mensual por persona
gen ict_pc = ict / tam_hog 
label var ict_pc "Ingreso total mensual / por persona"

save "$ingresos/ing_cor_tot.dta", replace 

**************************************************************************
* 6.4  Lineas de pobreza
**************************************************************************

*Abrir la base de ingresos recien guardada
use "$ingresos/ing_cor_tot.dta", replace

*Se reemplaza a los hogares que tengan ingresos negativos por cero 
replace ict=0 if ict<0

***
***Generación de linea de pobreza
***

*D9 
* Lineas de pobreza urbana y rural 
gen LP=0
replace LP = 3336.01 + (698.87 * tam_hog) + (2949.93 * ae_sum) if ur_rur_2500==1
replace LP = 2935.47 + (676.49 * tam_hog) + (2628.62 * ae_sum) if ur_rur_2500==2
								
*Se genera línea de pobreza por adulto equivalente
gen LP_ae = LP / ae_sum 
label var LP_ae "Línea de pobreza mensual por adulto equivalente"
		
*Se genera línea de pobreza promedio por persona
gen LP_pc = LP / tam_hog 
label var LP_ae "Línea de pobreza mensual por persona"
								
**************************************************************************
* 6.5  Indicador de ingresos del MMIP
**************************************************************************

*Generar Adecuación del ingreso corriente total 
gen a_ict = ict / LP

*Reescalación de Adecuación del ingreso corriente total 
gen a_ict_reesc = a_ict
replace a_ict_reesc=1+((a_ict- 1)/9) if a_ict > 1
replace a_ict_reesc=2 if a_ict_reesc> 2
replace a_ict_reesc=0 if a_ict_reesc==.

*Generación de indicador de carencia
gen cict=1-(a_ict_reesc)
replace cict=1 if cict >= 1

save "$final/cict.dta", replace

**************************************************************************
* 6.6  Indicador de carencia de salud y SS
**************************************************************************

*Abrir base de poblaciñón y se genera folio
use "$bases/poblacion.dta", clear
egen folio=concat(proyecto folioviv folioh)

*Pegar con base de ingresos
merge m:1 folio using "$final/cict.dta"
drop _merge

*Se eliminan los que no son miembros de la familia en el hogar
destring parentesco, replace
drop if parentesco>=400 & parentesco <500
drop if parentesco>=700 & parentesco <800

*Pegar con base de datos de salud y seguridad social
merge 1:1 folio numren using "$tmp/salud_y_ss.dta"
drop _merge

***
***Generación indicador de Salud verificado por ingresos
***

*Generar variable de acceso a salud, verificado por ingresos
gen ASi= .
label var ASi "Ind Acceso a Salud verif x ingresos"

*Se reemplaza con el valor del acceso a salud anterior, si es que este último es menor a 1,
	*y su ingreso es menor a la suma de la linea de pobreza, más el costo del IMSS voluntario
replace ASi= asaludi if (asaludi < 1 & (ict < (LP + cnoderchsalij)))
replace ASi= ict/ (LP + cnoderchsalij) if (asaludi <1 & ((LP + cnoderchsalij) <=ict))
replace ASi= asaludi if (asaludi >= 1)

* Se reescala variable
* Para valores > 2, se iguala a 2
gen ASi_r = ASi
replace ASi_r= 1 + ((ASi-1)/9)    if ASi>1
replace ASi_r=2 if  (ASi > 2) 

*Generar indicadores de carencia
gen CASi = 1 - (ASi_r)
label var CASi "Ind de carencia en salud"

***
***Generación indicador de Salud verificado por ingresos
***

*Se crea variable de acceso a la seguridad social verificado por ingresos
gen ASSi = .

*Se Reemplaza según los que pertenecen a "clase alta" en ingresos
replace ASSi = 1 if ((asegsoci < 1) & (cict >= -1 & cict <= -0.5))
replace ASSi= asegsoci if (asegsoci >= 1)
replace ASSi= asegsoci if ((asegsoci < 1) & (cict > -0.5))

*Generar indicador de carencia de Seguridad Social
gen CASSi = 1 - (ASSi) 
*label var CASSi sum "Ind de carencia en seguridad social"

*Generar la base de datos
keep folio numren CASi CASSi
save "${final}/cass.dta", replace 

**************************************************************************
* 6.7  Indicador de Ingresos-Tiempo
**************************************************************************

*Abrir la base de datos de tiempo
use "$final/etj.dta", clear

*Se elimnan variables repetidas pero con diferente formato para realizar pegado
drop alcaldia entidad municipio ur_rur_2500

*Pegar con la base de ingresos
merge 1:1 folio using "$final/cict.dta"
drop _merge 

*Se reemplaza valores perdidos por cero
replace inglabtot=0 if inglabtot==.

*Generar el indicador de ingreso tiempo con verificación por ingresos laborales y tiempo
gen ytj = ict
replace ytj= ict - inglabtot + (inglabtot / ett) if ((ett>1 & ict <=LP)|(ict>LP)) 

*Generar la variable de adecuación de tiempo verificada por linea de pobreza
gen aytj = ytj / LP

*Generar la variable reescalada de adecuación de tiempo
gen aytj_r = aytj
replace aytj_r = 1 + ((aytj - 1) / 9) if (aytj > 1)
replace aytj_r = 2 if (aytj_r > 2)

*Generar la variable de carencia en Ingresos-tiempo
gen cyt = 1 - aytj_r 
replace cyt  = 1 if (cyt >= 1)
label var cyt "Carencia en Ingreso-tiempo"

*Guardar base con indicadores de Ingresos-Tiempo
keep folio ytj aytj aytj_r cyt

save "${final}/cyt.dta", replace


********************************************************************************
* Módulo 7.- Cálculo de indicador de MMIP
* 7.1 Pegar las bases finales y quedarse con una sola de trabajo
* 7.2 Calcular el NBI y el MMIP
* 7.3 Generar los estratos del MMIP
* 7.4 Guardado de base final

*
* Se Generar base final: final14.dta
* Se Generar base intermedia: basefinal_pegadas.dta
********************************************************************************

****************************
* 7.1 Pegado de bases
****************************

*Abrir base de población y se genera folio
use "$bases/poblacion.dta", clear
egen folio=concat(proyecto folioviv folioh)
sort  folio

*Se mantienen algunas variables de población importantes
keep folio numren parentesco sexo edad etnia lenguaind hablaind alfabetism asis_esc tiene_b edo_conyug ///
	disc1 disc2 disc3 disc4 disc5 disc6 disc7 segpop atemed
	
*Se eliminan los que no son miembros de la familia en el hogar
destring parentesco, replace
drop if parentesco>=400 & parentesco <500
drop if parentesco>=700 & parentesco <800
	
*Pegar con base de factor	
merge m:1 folio using "${final}/factexp.dta"
drop _merge

*Pegar con la base de NBI
merge m:1 folio using "${final}/nbi.dta"
drop _merge

*Pegar con la base de educación
merge 1:1 folio numren using "${final}/edu.dta"
drop _merge

*Pegar con la base de tiempo
merge m:1 folio using "${final}/etj.dta"
drop _merge

*Pegar con la base de ingresos
merge m:1 folio using "${final}/cict.dta"
drop _merge

*Pegar con la base Salud y Seguridad Social
merge 1:1 folio numren using "${final}/cass.dta"
drop _merge

*Pegar con la base de lienas de pobreza
merge m:1 folio using "${final}/cyt.dta"
drop _merge


***
***Guardar una base final con las bases pegadas para trabajar y hacer calculos
***
save "${final}/basefinal_pegadas.dta", replace

****************************
* 7.2 Cálculos de  NBI y MMIP
****************************

*Abrir base con todas las demas ya pegadas
use "${final}/basefinal_pegadas.dta", clear

*Generar indicador de NBI
gen nbi= (ccevj*.328) + (CSj_m*.037) + (CENJ*.028) + (CTELJ*.030) +  (CBDj *.058) + (rei*.236) + (CASSi*.1415) + (CASi*.1415)
label variable nbi "Indice global NBI"

*Generar indicador de MMIP
gen mmip= (nbi * .374) + (cyt * .626)
label variable mmip "Indice Pobreza MMIP"



****************************
* 7.3 Generar los estratos del MMIP
****************************

*** Etiqueta de estratos
label define estratos 6"Clase alta" 5"Clase media" 4"Satisfaccion mínima" 3"Pobreza moderada" 2"Pobreza alta" 1"Pobreza muy alta"

* 1. Estrato de calidad de espacio de la vivienda
gen E_ccevj=.
replace E_ccevj=6 if ccevj <=-0.5
replace E_ccevj=5 if (ccevj > -0.5 & ccevj <= -.1) 
replace E_ccevj=4 if (ccevj > -0.1 & ccevj <= 0) 
replace E_ccevj=3 if (ccevj > 0 & ccevj <= (1/3)) 
replace E_ccevj=2 if (ccevj > (1/3) & ccevj <= .5) 
replace E_ccevj=1 if (ccevj > .5 & ccevj <= 1) 
label var E_ccevj "Estratos de Calidad y Espacio de la Vivienda"
label values E_ccevj estratos
tab E_ccevj
tab E_ccevj [fw=factor_hog]

***
*Calidad y Espacio de la Vivienda
gen pobreza_ccevj=.
replace pobreza_ccevj=0 if E_ccevj>=4
replace pobreza_ccevj=1 if E_ccevj<=3
label var pobreza_ccevj "Pobreza por Calidad y Espacio de la Vivienda"

gen pobre_ext_ccevj=.
replace pobre_ext_ccevj=0 if E_ccevj>=3
replace pobre_ext_ccevj=1 if E_ccevj<=2
label var pobre_ext_ccevj "Pobreza extrema por Calidad y Espacio de la Vivienda"

tab E_ccevj pobreza_ccevj
tab E_ccevj pobre_ext_ccevj

* 2. Estrato de carencia de bienes durables
gen E_CBDj=.
replace E_CBDj=6 if CBDj<= -0.5                  
replace E_CBDj=5 if (CBDj> -0.5 & CBDj <= -.1) 
replace E_CBDj=4 if (CBDj> -0.1 & CBDj <= 0) 
replace E_CBDj=3 if (CBDj> 0 & CBDj <= (1/3)) 
replace E_CBDj=2 if (CBDj> (1/3) & CBDj <=.5) 
replace E_CBDj=1 if (CBDj> .5 & CBDj <= 1) 
label var E_CBDj "Estrato de carencia de bienes durables"
label values E_CBDj estratos
tab E_CBDj
tab E_CBDj [fw=factor_hog]

***
*Carencia de bienes durables 
gen pobreza_cbdj=.
replace pobreza_cbdj=0 if E_CBDj>=4
replace pobreza_cbdj=1 if E_CBDj<=3
label var pobreza_cbdj "Pobreza por Bienes durables"

gen pobre_ext_cbdj=.
replace pobre_ext_cbdj=0 if E_CBDj>=3
replace pobre_ext_cbdj=1 if E_CBDj<=2
label var pobre_ext_cbdj "Pobreza extrema por Bienes durables"

tab E_CBDj pobreza_cbdj
tab E_CBDj pobre_ext_cbdj


* 3. Estrato de adecuación sanitaria
gen E_CSj_m =.
replace E_CSj_m=6 if CSj_m<= -0.5                  
replace E_CSj_m=5 if (CSj_m> -0.5 & CSj_m <= -.1) 
replace E_CSj_m=4 if (CSj_m> -0.1 & CSj_m <= 0) 
replace E_CSj_m=3 if (CSj_m> 0 & CSj_m <= (1/3)) 
replace E_CSj_m=2 if (CSj_m> (1/3) & CSj_m <=.5) 
replace E_CSj_m=1 if (CSj_m> .5 & CSj_m <= 1) 
label var E_CSj_m "Estrato de adecuación sanitaria"
label values E_CSj_m estratos
tab E_CSj_m 
tab E_CSj_m [fw=factor_hog]

***
*Adecuacion sanitaria
gen pobreza_csj=.
replace pobreza_csj=0 if E_CSj>=4
replace pobreza_csj=1 if E_CSj<=3
label var pobreza_csj "Pobreza por Adecuacion Sanitaria"

gen pobre_ext_csj=.
replace pobre_ext_csj=0 if E_CSj>=3
replace pobre_ext_csj=1 if E_CSj<=2
label var pobre_ext_csj "Pobreza extrema por Adecuacion Sanitaria"

tab E_CSj pobreza_csj
tab E_CSj pobre_ext_csj


* 4. Estrato de carencia de teléfono
gen E_CTELJ=.
replace E_CTELJ=6 if CTELJ <= -0.5                  
replace E_CTELJ=5 if (CTELJ > -0.5 & CTELJ <= -.1) 
replace E_CTELJ=4 if (CTELJ > -0.1 & CTELJ <= 0) 
replace E_CTELJ=3 if (CTELJ > 0 & CTELJ <= (1/3)) 
replace E_CTELJ=2 if (CTELJ > (1/3) & CTELJ <=.5) 
replace E_CTELJ=1 if (CTELJ > .5 & CTELJ <= 1) 
label var E_CTELJ  "Estrato de carencia de teléfono"
label values E_CTELJ estratos
tab E_CTELJ 
tab E_CTELJ [fw=factor_hog]

***
*Carencia de Teléfono
gen pobreza_ctelj=.
replace pobreza_ctelj=0 if E_CTELJ>=4
replace pobreza_ctelj=1 if E_CTELJ<=3
label var pobreza_ctelj "Pobreza por Carencia de teléfono"

gen pobre_ext_ctelj=.
replace pobre_ext_ctelj=0 if E_CTELJ>=3
replace pobre_ext_ctelj=1 if E_CTELJ<=2
label var pobre_ext_ctelj "Pobreza extrema por Carencia de teléfono"

tab E_CTELJ pobreza_ctelj
tab E_CTELJ pobre_ext_ctelj

* 5. Estrato de carencia energética
gen E_CENJ=.
replace E_CENJ=6 if CENJ <= -0.5                  
replace E_CENJ=5 if (CENJ > -0.5 & CENJ <= -.1) 
replace E_CENJ=4 if (CENJ > -0.1 & CENJ <= 0) 
replace E_CENJ=3 if (CENJ > 0 & CENJ <= (1/3)) 
replace E_CENJ=2 if (CENJ > (1/3) & CENJ <=.5) 
replace E_CENJ=1 if (CENJ > .5 & CENJ <= 1) 
label var E_CENJ "Estrato de carencia energética"
label values E_CENJ estratos
tab E_CENJ  
tab E_CENJ [fw=factor_hog]  

***
*Carencia Energética
gen pobreza_cenj=.
replace pobreza_cenj=0 if E_CENJ>=4
replace pobreza_cenj=1 if E_CENJ<=3
label var pobreza_cenj "Pobreza por Carencia Energética"

gen pobre_ext_cenj=.
replace pobre_ext_cenj=0 if E_CENJ>=3
replace pobre_ext_cenj=1 if E_CENJ<=2
label var pobre_ext_cenj "Pobreza extrema por Carencia Energética"

tab E_CENJ pobreza_cenj
tab E_CENJ pobre_ext_cenj


* 6. Estrato de rezago educativo
gen E_rei=.
replace E_rei=6 if  rei <= -0.5                  
replace E_rei=5 if (rei > -0.5 & rei <= -.1) 
replace E_rei=4 if (rei > -0.1 & rei <= 0) 
replace E_rei=3 if (rei > 0 & rei <= (1/3)) 
replace E_rei=2 if (rei > (1/3) & rei <=.5) 
replace E_rei=1 if (rei > .5 & rei <= 1) 
label var E_rei  "Estrato de rezago educativo"
label values E_rei estratos
tab E_rei    
tab E_rei [fw=factor_hog]     

***
*Rezago Educativo
gen pobreza_rei=.
replace pobreza_rei=0 if E_rei>=4
replace pobreza_rei=1 if E_rei<=3
label var pobreza_rei "Pobreza por Rezago educativo"

gen pobre_ext_rei=.
replace pobre_ext_rei=0 if E_rei>=3
replace pobre_ext_rei=1 if E_rei<=2
label var pobre_ext_rei "Pobreza extrema por Rezago educativo"

tab E_rei pobreza_rei
tab E_rei pobre_ext_rei


* 7. Estratos de Acceso a Seguridad social
gen E_CASSi=.
replace E_CASSi=6 if CASSi <=  -0.5                  
replace E_CASSi=5 if (CASSi >  -0.5 & CASSi <= -.1) 
replace E_CASSi=4 if (CASSi >  -0.1 & CASSi <= 0) 
replace E_CASSi=3 if (CASSi >     0 & CASSi <= (1/3)) 
replace E_CASSi=2 if (CASSi > (1/3) & CASSi <=.5) 
replace E_CASSi=1 if (CASSi >    .5 & CASSi <= 1) 
label var E_CASSi "Estratos de Acceso a Seguridad Social"
label values E_CASSi estratos
tab E_CASSi  
tab E_CASSi   [fw=factor_hog]  

***
*Rezago de Acceso a Seguridad Social
gen pobreza_cassi=.
replace pobreza_cassi=0 if E_CASSi>=4
replace pobreza_cassi=1 if E_CASSi<=3
label var pobreza_cassi "Pobreza por Acceso a Seguridad Social"

gen pobre_ext_cassi=.
replace pobre_ext_cassi=0 if E_CASSi>=3
replace pobre_ext_cassi=1 if E_CASSi<=2
label var pobre_ext_cassi "Pobreza extrema por Acceso a Seguridad Social"

tab E_CASSi pobreza_cassi
tab E_CASSi pobre_ext_cassi


* 8. Estratos de Acceso a Salud
gen E_CASi=.
replace E_CASi=6 if CASi <= -0.5                  
replace E_CASi=5 if (CASi > -0.5 & CASi <= -.1) 
replace E_CASi=4 if (CASi > -0.1 & CASi <= 0) 
replace E_CASi=3 if (CASi > 0 & CASi <= (1/3)) 
replace E_CASi=2 if (CASi > (1/3) & CASi <=.5) 
replace E_CASi=1 if (CASi > .5 & CASi <= 1) 
label var E_CASi "Estratos de Acceso a Salud"
label values E_CASi estratos
tab E_CASi  
tab E_CASi   [fw=factor_hog]    

***
*Rezago de Acceso a Salud
gen pobreza_casi=.
replace pobreza_casi=0 if E_CASi>=4
replace pobreza_casi=1 if E_CASi<=3
label var pobreza_casi "Pobreza por Acceso a Salud"

gen pobre_ext_casi=.
replace pobre_ext_casi=0 if E_CASi>=3
replace pobre_ext_casi=1 if E_CASi<=2
label var pobre_ext_casi "Pobreza extrema por a Salud"

tab E_CASi pobreza_casi
tab E_CASi pobre_ext_casi


* 9. Estratos de Necesidades Básicas Insatisfechas 
gen E_nbi=.
replace E_nbi=6 if (nbi  <= -0.5)                  
replace E_nbi=5 if (nbi  > -0.5   & nbi  <= -.1) 
replace E_nbi=4 if (nbi  > -0.1   & nbi  <= 0) 
replace E_nbi=3 if (nbi  > 0      & nbi  <= (1/3)) 
replace E_nbi=2 if (nbi  > (1/3)  & nbi  <=.5) 
replace E_nbi=1 if (nbi  > .5     & nbi  <= 1) 
label var E_nbi  "Estratos de Necesidades Básicas Insatisfechas"
label values E_nbi estratos
tab E_nbi   [fw=factor_hog]     

***
*Pobreza por NBI
gen pobreza_nbi=.
replace pobreza_nbi=0 if E_nbi>=4
replace pobreza_nbi=1 if E_nbi<=3
label var pobreza_nbi "Pobreza por NBI"

gen pobre_ext_nbi=.
replace pobre_ext_nbi=0 if E_nbi>=3
replace pobre_ext_nbi=1 if E_nbi<=2
label var pobre_ext_nbi "Pobreza extrema por NBI"

tab E_nbi pobreza_nbi
tab E_nbi pobre_ext_nbi


* 10. Estratos de ingreso
gen E_cict=.
replace E_cict=6 if (cict >= -1    & cict <= -0.5)
replace E_cict=5 if (cict >  -0.5  & cict <= -0.1)
replace E_cict=4 if (cict >  -0.1  & cict <= 0)
replace E_cict=3 if (cict >    0   & cict <= (1/3))
replace E_cict=2 if (cict > (1/3)  & cict <= 0.5)
replace E_cict=1 if (cict >  0.5   &cict <= 1)
label var E_cict "Estratos del ingreso"
label values E_cict estratos
tab E_cict [fw=factor_hog]

***
*Pobreza por Ingreso
gen pobreza_cict=.
replace pobreza_cict=0 if E_cict>=4
replace pobreza_cict=1 if E_cict<=3
label var pobreza_cict "Pobreza por Ingreso"

gen pobre_ext_cict=.
replace pobre_ext_cict=0 if E_cict>=3
replace pobre_ext_cict=1 if E_cict<=2
label var pobre_ext_cict "Pobreza extrema por Ingreso"

tab E_cict pobreza_cict
tab E_cict pobre_ext_cict

* 11. Estratos de tiempo
gen E_ett=.
replace E_ett=6 if ett <= 0.5
replace E_ett=5 if (ett >  0.5 & ett <= .9)   
replace E_ett=4 if (ett >  0.9  & ett <= 1)    
replace E_ett=3 if (ett >  1  & ett <= 1.333)
replace E_ett=2 if (ett > 1.333  & ett <= 1.5)
replace E_ett=1 if (ett >  1.5   & ett <= 2)
label var E_ett "Estratos del tiempo"
label values E_ett estratos
tab E_ett [fw=factor_hog]

***
*Pobreza por Tiempo
gen pobreza_ett=.
replace pobreza_ett=0 if E_ett>=4
replace pobreza_ett=1 if E_ett<=3
label var pobreza_ett "Pobreza por Tiempo"

gen pobre_ext_ett=.
replace pobre_ext_ett=0 if E_ett>=3
replace pobre_ext_ett=1 if E_ett<=2
label var pobre_ext_ett "Pobreza extrema por Tiempo"

tab E_ett pobreza_ett
tab E_ett pobre_ext_ett

* 12. Estratos por Ingreso-Tiempo
gen E_cyt=.
replace E_cyt=6 if (cyt >= -1 & cyt<= -0.5)
replace E_cyt=5 if (cyt > -0.5 & cyt<= -0.1)
replace E_cyt=4 if (cyt > -0.1 & cyt<= 0)
replace E_cyt=3 if (cyt > 0 & cyt<= (1/3))
replace E_cyt=2 if (cyt >(1/3) & cyt<=  0.5)
replace E_cyt=1 if (cyt > 0.5 & cyt<= 1)
label var E_cyt "Estratos del ingreso-tiempo"
label values E_cyt estratos
tab E_cyt [fw=factor_hog]

***
*Pobreza por Ingreso-Tiempo
gen pobreza_cyt=.
replace pobreza_cyt=0 if E_cyt>=4
replace pobreza_cyt=1 if E_cyt<=3
label var pobreza_cyt "Pobreza por Ingreso-Tiempo"

gen pobre_ext_cyt=.
replace pobre_ext_cyt=0 if E_cyt>=3
replace pobre_ext_cyt=1 if E_cyt<=2
label var pobre_ext_cyt "Pobreza extrema por Ingreso-Tiempo"

tab E_cyt pobreza_cyt
tab E_cyt pobre_ext_cyt

* 13. Estratos del MMIP
gen E_mmip=.
replace E_mmip=6 if  mmip <= -0.5  
replace E_mmip=5 if (mmip >  -0.5  & mmip <= -.1)
replace E_mmip=4 if (mmip >  -0.1  & mmip <=  0)
replace E_mmip=3 if (mmip >    0   & mmip <=  (1/3))
replace E_mmip=2 if (mmip > (1/3)  & mmip <=  0.5 )
replace E_mmip=1 if (mmip >  0.5   & mmip <=  1)
label var E_mmip "Estratos del MMIP"
label values E_mmip estratos
tab E_mmip 
tab E_mmip [fw=factor_hog]

***
*Pobreza por MMIP
gen pobreza_mmip=.
replace pobreza_mmip=0 if E_mmip>=4
replace pobreza_mmip=1 if E_mmip<=3
label var pobreza_mmip "Pobreza MMIP"

gen pobre_ext_mmip=.
replace pobre_ext_mmip=0 if E_mmip>=3
replace pobre_ext_mmip=1 if E_mmip<=2
label var pobre_ext_mmip "Pobreza extrema MMIP"

tab E_mmip pobreza_mmip
tab E_mmip pobre_ext_mmip



********************************************************************
*** 7.4 Guardado de base final
********************************************************************

*Guardar la base de datos con variables importantes
keep folioviv foliohog numren tam_loc upm factor_hog folio ur_rur_2500 municipio entidad alcaldia tam_hog factorxind est_dis ///
	parentesco sexo edad etnia lenguaind hablaind alfabetism asis_esc tiene_b edo_conyug ///
	segpop atemed ///
	disc1 disc2 disc3 disc4 disc5 disc6 disc7 ///
	ACVj AEVh ccevj ABDj CBDj AA ADr AEX CSj_m ATlj CTELJ AElj ACK CENJ numren rescgen rei  ///
    ett ing_no_mon  ing_mon inglabth  ict LP LP_ae ict_ae LP_pc ict_pc ///
	CASi  CASSi ytj cict ///
	cyt nbi mmip ///
	E_ccevj  E_CBDj E_CSj_m  E_CTELJ  E_CENJ E_rei ///
	E_CASSi E_CASi  E_nbi E_cict  E_ett E_cyt  E_mmip ///
	pobreza_* pobre_ext*

save "$final/final14.dta", replace

