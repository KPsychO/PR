par int: VALOR;
par int: MAXV;
par int: MAXN;
par int: MCAP;
par int: CA;
par int: MinD;
par int: MaxD;
par int: MinB;
% par int: K; % Para contraints ampliadas
% par int: T; % Para contraints ampliadas
enum TiposVeg = {VEG1, VEG2};
enum TiposNVeg = {ANV1, ANV2, ANV3};
array[1..12, TiposVeg] of par int: PreciosVeg;
array[1..12, TiposNVeg] of par int: PreciosNVeg;
array[TiposVeg] of par float: durezaVeg;
array[TiposNVeg] of par float: durezaNVeg;
array[TiposVeg] of par int: cantidadVeg;
array[TiposNVeg] of par int: cantidadNVeg; 

array[1..12, TiposVeg] of var 0..MCAP+MAXV: comprasVeg;
array[1..12, TiposNVeg] of var 0..MCAP+MAXN: comprasNVeg;
array[1..12, TiposVeg] of var 0..MAXV: refinadoVeg;
array[1..12, TiposNVeg] of var 0..MAXN: refinadoNVeg;
array[0..12, TiposVeg] of var 0..MCAP: almVeg;
array[0..12, TiposNVeg] of var 0..MCAP: almNVeg;

% funcion para calcular el total de aceite refinado cada mes
function var int: totalRefinado(var int : i) =
    (sum (v in TiposVeg) (refinadoVeg[i, v])) + (sum (n in TiposNVeg) (refinadoNVeg[i, n]));
function var int: totalCosteCompra(var int : i) =
    (sum (v in TiposVeg) (comprasVeg[i, v]*PreciosVeg[i, v])) + (sum (n in TiposNVeg) (comprasNVeg[i, n]*PreciosNVeg[i ,n]));
function var int: totalAlmacenado(var int : i) =
    (sum (v in TiposVeg) (almVeg[i, v])) + (sum (n in TiposNVeg) (almNVeg[i, n]));
function var float : durVeg (var int : i) =
    sum (j in TiposVeg) (refinadoVeg[i, j]*durezaVeg[j]);
function var float : durNVeg (var int : i) =    
    sum (j in TiposNVeg) (refinadoNVeg[i, j]*durezaNVeg[j]);

% No se refina mas aceite de cada clase del permitido
constraint forall (i in 1..12) (sum (j in TiposVeg) (refinadoVeg[i, j]) <= MAXV);
constraint forall (i in 1..12) (sum (j in TiposNVeg) (refinadoNVeg[i, j]) <= MAXN);

% almVeg[0, j] y almNVeg[0, j] == 0
constraint forall (j in TiposVeg) (almVeg[0, j] == cantidadVeg[j]);
constraint forall (j in TiposNVeg) (almNVeg[0, j] == cantidadNVeg[j]);

% Al final de ano quedan cantidadVeg y cantidadNVeg de aceite en el almacen
constraint forall (j in TiposVeg) (almVeg[12, j] == cantidadVeg[j]);
constraint forall (j in TiposNVeg) (almNVeg[12, j] == cantidadNVeg[j]);

% El aceite almacenado es comprado-refinado -> Solo cuenta como almacenado el aceite que no se usa a final de mes
constraint forall (i in 1..12, j in TiposVeg) (almVeg[i,j] == ((almVeg[i-1, j]+comprasVeg[i, j])-refinadoVeg[i,j]));
constraint forall (i in 1..12, j in TiposNVeg) (almNVeg[i, j] == ((almNVeg[i-1, j]+comprasNVeg[i, j])-refinadoNVeg[i,j]));

% No se almacena mas aceite del pemitido de ningun tipo
constraint forall (i in 1..12, j in TiposVeg) (almVeg[i,j] <= MCAP);
constraint forall (i in 1..12, j in TiposNVeg) (almNVeg[i, j] <= MCAP);

% % El beneficio debe ser mayor que minB
constraint forall (i in 1..12) (((sum (j in TiposVeg) (refinadoVeg[i, j]*VALOR - (comprasVeg[i, j]*PreciosVeg[i, j] + almVeg[i, j]*CA))) + (sum (j in TiposNVeg) (refinadoNVeg[i, j]*VALOR - (comprasNVeg[i, j]*PreciosNVeg[i, j] + almNVeg[i, j]*CA)))) >= MinB);
% constraint forall (i in 1..12) (totalRefinado(i)*VALOR - (totalCosteCompra(i) + totalAlmacenado(i)*CA) >= MinB);

% % La dureza debe ser valida
constraint forall (i in 1..12) ((durVeg(i) + durNVeg(i)) <= MaxD*totalRefinado(i));
constraint forall (i in 1..12) ((durVeg(i) + durNVeg(i)) >= MinD*totalRefinado(i));

% El producto no debe hacerse con m´as de K aceites. Cada mes los aceites seleccionadas pueden cambiar
% constraint forall (i in 1..12) ((sum (j in TiposVeg) (refinadoVeg[i, j] > 0) + sum (j in TiposNVeg) (refinadoNVeg[i, j] > 0)) <= K);

% Si un mes usamos un cierto aceite, entonces debemos usar como m´ınimo T toneladas.
% constraint forall (i in 1..12, j in TiposVeg) ((refinadoVeg[i, j]>0) -> (refinadoVeg[i, j] > T));
% constraint forall (i in 1..12, j in TiposNVeg) ((refinadoNVeg[i, j]>0) -> (refinadoNVeg[i, j] > T));

% Si usamos el aceite VEG 1 o el aceite VEG 2 en un cierto mes, entonces ANV 3 tambi´en debe ser usado ese mes. Pod´eis proponer generalizaciones de esta restricci´on.
% constraint forall (i in 1..12) ((refinadoVeg[i, VEG1] > 0 /\ refinadoVeg[i, VEG2] > 0) -> refinadoNVeg[i, ANV3] > 0);

solve maximize sum (i in 1..12) (totalRefinado(i)*VALOR - (totalCosteCompra(i) + totalAlmacenado(i)*CA));

% solve satisfy;

output ["Compras: \n"];
output 
  [
  "\(comprasVeg[i, j]) " | i in 1..12, j in TiposVeg
  ];
output ["\n"];
output
  [
  "\(comprasNVeg[i, j]) " | i in 1..12, j in TiposNVeg
  ];
output ["\n"];
output ["Refinados: \n"];
output 
  [
  "\(refinadoVeg[i, j]) " | i in 1..12, j in TiposVeg
  ];
output ["\n"];
output 
  [
  "\(refinadoNVeg[i, j]) " | i in 1..12, j in TiposNVeg
  ];
output ["\n"];
output ["Almacenado: \n"];
output 
  [
  "\(almVeg[i, j]) " | i in 0..12, j in TiposVeg
  ];
output ["\n"];
output 
  [
  "\(almNVeg[i, j]) " | i in 0..12, j in TiposNVeg
  ];
output ["\n"];
output ["Beneficio: \n"];
output ["\(sum (i in 1..12) (((sum (j in TiposVeg) (refinadoVeg[i, j]*VALOR - (comprasVeg[i, j]*PreciosVeg[i, j] + almVeg[i, j]*CA))) + sum (j in TiposNVeg) (refinadoNVeg[i, j]*VALOR - (comprasNVeg[i, j]*PreciosNVeg[i, j] + almNVeg[i, j]*CA)))))"];

% En SMT en lugar de QF_LIA, usar QF_LIRA o asumir que dureza llegar con 1 decimal y multiplicarmos todo x 10