par int: altura;
enum Colores = {Azul,Rojo,Verde};
array [Colores] of int: disp;

% Piezas torre tamaño 10; colores 0 azul / 1 rojo / 2 verde;
array[0..altura-1] of var Colores: torre;

% cubos de color azul  3
% cubos de color rojo  5
% cubos de color verde 3

% No dos verdes consecutivas
constraint forall (i in 0..altura-2) (torre[i]=Verde -> torre[i+1]!=Verde);

% Piezas azules >= Piezas verdes en todo momento
constraint forall (i in 0..altura-1) (( sum (j in 0..i ) ( bool2int(torre[j]=Azul) )) >=
           ( sum (j in 0..i ) ( bool2int(torre[j]=Verde) )));

% No mas de 3 azules
constraint forall (c in Colores) (sum (i in 0..altura-1 ) ( bool2int(torre[i]=c) ) <= disp[c]);

%constraint forall (j in 0..2) (( sum (i in 0..9 ) ( bool2int(torre[i]=j) )) <= ?);

%No mas de 3 seguidos iguales??

% Piezas rojas >= Piezas azules + Piezas verdes
constraint ( sum (i in 0..altura-1 where (torre[i]=Rojo)) ( 1 )) >=
           ( sum (i in 0..altura-1 ) ( bool2int(torre[i]=Azul \/ torre[i]=Verde) ));



% Empieza con rojo
constraint torre[0] = Rojo;

% Obtener solución
solve minimize (sum (i in 0..altura-1 where (torre[i]=Azul)) ( 1 ));

output [ "\(altura-1-i) : \(torre[altura-1-i]);\n" | i in 0..altura-1 ];
