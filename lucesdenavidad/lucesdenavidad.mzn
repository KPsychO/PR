par int: L;
par int: N;
par int: C;
enum colores;
array[colores] of par int: consumos;
array[colores] of par int: cantidades;

array[1..L] of var colores: solucion;

% no hay dos luces seguidas del mismo color
constraint forall (i in 1..L-2) (not (solucion[i] == solucion[i+1] /\ solucion[i+1] == solucion[i+2]));

%  en cualquier punto de la tira la suma de las luces de un color no supere en mas de una unidad la suma de las luces de todos los demas colores
constraint forall (i in 1..N) (forall (c in colores) (sum (k in 1..i) (if (solucion[k] == c) then 1 else -1 endif) <= 1));

%  las tiras de luces no deben consumir masde una cierta cantidad de energıa
constraint (sum (i in 1..L) (consumos[solucion[i]])) <= C;

% no debes usar mas bombillas de las disponibles
constraint forall (c in colores) ((sum (i in 1..L where (solucion[i] == c)) (1)) <= cantidades[c]);

solve satisfy;
% solve minimize sum (i in 1..L) (consumos[solucion[i]]);

output ["\(solucion[i])" | i in 1..L];