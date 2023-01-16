Tarea 3 - IPD432

Integrantes: 
	Patricio Carrasco O'Ryan
	Sebastian Espinoza Toro


Los archivos en la carpeta "Paralelismo" corresponden al diseño Fully-combinational datapath.
Los archivos en la carpeta "Pipelining" corresponden al diseño Fully-pipeline datapath.
Se agrega además la carpeta llamada DEBUG que contiene los proyectos con la ILAs incluidas para 
el debugueo y medición de latencia/throughput.
Instrucciones de uso:
Debe cargarse el bitstream a la tarjeta de desarrollo, el cual viene dentro de cada uno los proyectos adjuntos.
Debe tenerse instalado MATLAB y dentro de una misma carpeta tener los archivos "write2dev.m", "command2dev.m" y 
"coprocessorTesting.m". Este último debe correrse una vez programada la tarjeta.
El programa pedirá escribir el puerto COM en el que está conectada la tarjeta de desarrollo y posteriormente la 
cantidad de iteraciones que se desean en el programa, abriendo finalmente una figura con una serie de gráficos 
que representan un resumen de los resultados obtenidos.


En caso de importar solo las sources del proyecto, utilizar la siguiente configuración
------ Fully-combinational datapath ------ 

El reloj utilizado es de 35MHz.
Para la ejecución de este proyecto es necesario cambiar la estrategia de síntesis a 
Flow_AreaOptimized_medium en la pensaña de Flow->Settings->Synthesis settigs.

------ Fully-pipelinedatapath ------ 
El reloj utilizado es de 100MHz, por de una IP.
De utiliza la configuración por defecto de las estrategias de síntesis e implementación.