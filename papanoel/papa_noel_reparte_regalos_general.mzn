include "alldifferent.mzn";

par int: M;
par int: N;
par int: S;
par int: K;
enum Juguetes;
array [Juguetes] of par int: Cantidad;
array [1..N, Juguetes] of par int: Satisfacciones;

array [1..N, 1..K] of var Juguetes: solucion;

constraint assert (M > 0, "El numero de juguetes debe ser mayor de 0");
constraint assert (N > 0, "El numero de ninos debe ser mayor que 0");
constraint assert (S >= 0, "La satisfaccion debe ser mayor o igual a 0");
constraint assert (forall (j in Juguetes)(Cantidad[j] >= 0), "La cantidad de juguetes de cada tipo debe ser mayor o igual que 0");

% Los juguetes elegidos deben sumar mas que S
constraint forall (i in 1..N) (sum ([Satisfacciones[i, solucion[i, k]] | k in 1..K]) >= S);

% Los tipos de los jugutes han de ser diferentes
constraint forall (i in 1..N) (alldifferent([solucion[i, k] | k in 1..K])); 

% No se debe coger mas juguetes de los que hay
constraint forall (t in Juguetes) ((sum([1 | k in 1..K, i in 1..N where (solucion[i, k] == t)])) <= Cantidad[t]);

% Evitar redundancia de soluciones
% constraint forall (i in 1..N) (forall (j in 1..K-1) (solucion[i, j] > solucion[i, j +1]));

% solve satisfy;
solve maximize (sum ([Satisfacciones[i, solucion[i, k]] | k in 1..K, i in 1..N ]));

output [ "\(i) : \([solucion[i, k] | k in 1..K]) : \(sum ([Satisfacciones[i, solucion[i, k]] | k in 1..K]));\n" | i in 1..N ];