par int: T;
par int: D;
par int: L;
array[1..T] of par 1..D: durs;
array[1..T] of par set of 1..T: dep;

array[1..T] of var 1..L: sol;  

% menor a L
constraint (max (i in 1..T) (sol[i]+ durs[i])) <= L;

% dependencias
constraint forall (i in 1..T) (forall (d in dep[i]) (sol[i] >= (sol[d] + durs[d])));

solve minimize (max (i in 1..T) (sol[i]+ durs[i]));

output ["\(sol)"];