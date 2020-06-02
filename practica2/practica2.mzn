par int: VALOR;
par int: MAXV;
par int: MAXN;
par int: MCAP;
par int: CA;
par int: MinD;
par int: MaxD;
par int: MinB;
enum TiposVeg;
enum TiposNVeg;
array[1..12, TiposVeg] of par int: PreciosVeg;
array[1..12, TiposNVeg] of par int: PreciosNVeg;
array[TiposVeg] of par float: durezaVeg;
array[TiposNVeg] of par float: durezaNVeg;
array[TiposVeg] of par int: cantidadVeg;
array[TiposNVeg] of par int: cantidadNVeg; 

array[1..12, TiposVeg] of var 0..9999: comprasVeg;
array[1..12, TiposNVeg] of var 0..9999: comprasNVeg;
array[1..12, TiposVeg] of var 0..9999: refinadoVeg;
array[1..12, TiposNVeg] of var 0..9999: refinadoNVeg;

% No se compra mas aceite del que se puede almacenar
constraint forall (i in 1..12, j in TiposVeg) (comprasVeg[i, j] <= MCAP);
constraint forall (i in 1..12, j in TiposNVeg) (comprasNVeg[i, j] <= MCAP);

% No se refina mas aceite de cada clase del permitido
constraint forall (i in 1..12) (sum (j in TiposVeg) (refinadoVeg[i, j]) < MAXV);
constraint forall (i in 1..12) (sum (j in TiposNVeg) (refinadoNVeg[i, j]) < MAXN);

% Todo el aceite comprado debe ser refinado(menos el ultimo, que debe quedar almacenado)
constraint forall (i in 1..11, j in TiposVeg) (comprasVeg[i,j] == refinadoVeg[i, j]);
constraint forall (i in 1..11, j in TiposNVeg) (comprasNVeg[i,j] == refinadoNVeg[i, j]);
% constraint forall (i in 1..11, j in TiposVeg) ((comprasVeg[i, j] - refinadoVeg[i, j]) == 0);
% constraint forall (i in 1..11, j in TiposNVeg) ((comprasNVeg[i, j] - refinadoNVeg[i, j]) == 0);

% El valor del producto final (calculado sumando todos los aceites refinados cada mes) debe ser mayor que MinB
constraint sum (i in 1..12) ((((sum (j in TiposVeg) (refinadoVeg[i, j])) + (sum (k in TiposNVeg) (refinadoNVeg[i,k])))* VALOR) - (((sum (j in TiposVeg) (comprasVeg[i, j]*PreciosVeg[i,j])) + (sum (k in TiposNVeg) (comprasNVeg[i,k]*PreciosNVeg[i,k]))))) >= MinB;

% La dureza debe ser valida
constraint forall (i in 1..12) (((sum (j in TiposVeg) (durezaVeg[j]*refinadoVeg[i,j])) + (sum (k in TiposNVeg) (durezaNVeg[k]*refinadoNVeg[i, k]))) / ((sum (l in TiposVeg) (refinadoVeg[i,l])) + (sum (m in TiposNVeg) (refinadoNVeg[i, m]))) > MinD);
constraint forall (i in 1..12) (((sum (j in TiposVeg) (durezaVeg[j]*refinadoVeg[i,j])) + (sum (k in TiposNVeg) (durezaNVeg[k]*refinadoNVeg[i, k]))) / (sum (l in TiposVeg) (refinadoVeg[i,l]) + sum (m in TiposNVeg) (refinadoNVeg[i, m])) < MaxD);

% % Deben quedar cantidadVeg y cantidadNVeg toneladas de cada tipo al final de ano
constraint forall (j in TiposVeg) ((comprasVeg[12, j] - refinadoVeg[12, j]) == cantidadVeg[j]);
constraint forall (j in TiposNVeg) ((comprasNVeg[12, j] - refinadoNVeg[12, j]) == cantidadNVeg[j]);

solve satisfy;
% solve maximize sum (i in 1..12) ((((sum (j in TiposVeg) (refinadoVeg[i, j])) + (sum (k in TiposNVeg) (refinadoNVeg[i,k])))* VALOR) - (((sum (j in TiposVeg) (comprasVeg[i, j]*PreciosVeg[i,j])) + (sum (k in TiposNVeg) (comprasNVeg[i,k]*PreciosNVeg[i,k])))));

output 
  [
  "\(comprasVeg[i, j]) " | i in 1..12, j in TiposVeg
  ];