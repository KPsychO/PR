% M juguetes | N ninos | S satisfaccion
% Cantidad de juguetes x tipo
% Tipo juguetes
% Satisfaccion por ninos para cada juguete
par int: M;
par int: N;
par int: S;
enum Juguetes;
array [Juguetes] of par int: Cantidad;
array [1..N, Juguetes] of par int: Satisfacciones;

array [1..N, 1..2] of var Juguetes: solucion;

% Los juguetes elegidos deben sumar mas que S
constraint forall (i in 1..N) (Satisfacciones[i, solucion[i, 1]] + Satisfacciones[i, solucion[i, 2]] >= S);

% Los tipos de los jugutes han de ser diferentes
constraint forall (i in 1..N) (solucion[i, 1] != solucion[i, 2]);

% No se debe coger mas juguetes de los que hay
constraint forall (t in Juguetes) ((sum (i in 1..N where (solucion[i, 1] == t \/ solucion[i, 2] == t)) (1)) <= Cantidad[t]);

solve satisfy;

output [ "\(i) : \(solucion[i, 1]), \(solucion[i, 2]) : \(Satisfacciones[i, solucion[i, 1]] + Satisfacciones[i, solucion[i, 2]]);\n" | i in 1..N ];