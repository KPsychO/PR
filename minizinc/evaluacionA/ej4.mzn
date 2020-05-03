par int: T;
par int: D;
par int: L;
par int: M;
array[1..T] of par 1..D: durs;
array[1..T] of par 1..M: maq;
array[1..T] of par set of 1..T: dep;

array[1..T] of var 1..L: sol;  

% menor a L
constraint (max (i in 1..T) (sol[i]+ durs[i])) <= L;

% dependencias
constraint forall (i in 1..T) (forall (d in dep[i]) (sol[i] >= (sol[d] + durs[d])));

% no comparten maquinas
constraint forall (i in 1..T) (forall (j in 1..T where (i != j)) ((maq[i] == maq[j]) -> (sol[j] > (sol[i] + durs[i]))));

solve minimize (max (i in 1..T) (sol[i]+ durs[i]));

output ["\(sol)"];