Parte 1: Carpeta "minizinc", completo
Parte 2: Carpeta "sat", completo
Parte 3: Completo en minizinc, en SAT-SMT tan solo encuentra la solucion, maximizada manualmente

Comparacion:
En minizinc alcanza como maximo un beneficio de 20000 tras algo mas de 1h de ejecucion.
sat alcanza un beneficio de algo mas de 275000 trans menos de 1 seg de ejecucion.

Esta diferencia tan grande de tiempos puede deberse a la codificacio usada, que no beneficia en nada al resolutor de minizinc al utilizar una matriz extra que contiene las cantidades almacenadas cada mes.
Estas variables extras podrian ser eliminadas aumentando ligeramente la complejidad de las formulas que las usan, cosa que no se ha realizado por falta de tiempo.

Extensiones:
1 y 2: Codificado completamente en minizinc y comentado en el fichero entregado
3: Codificada la tercera restriccion extra son soft-assert
4: no completada