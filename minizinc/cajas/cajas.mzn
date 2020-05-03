par SX = 9;
par SY = 9;
par C = 5;
par cajas = array2d(1..5, 1..2, [3, 3, 4, 3, 5, 3, 6, 3, 9, 3]);

% Separamos la matriz de entrada en 2 arrays unidimensionales
par array [1..C] of 1..SX: cajax = [caja[i, 1] | i in 1..C];
par array [1..C] of 1..SY: cajay = [caja[i, 1] | i in 1..C];

array [1..C] of var 0..SX-1: solx;
array [1..C] of var 0..SX-1: soly;

constraint forall (i in 1..C) (solx[i] + cajax[i] <= SX);
constraint forall (i in 1..C) (soly[i] + cajay[i] <= SY);

constraint forall (i in 1..C, j in 1..C where (i != j) ())