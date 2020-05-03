par int: N;
par int: vIda;
par int: vVuelta;
enum cancs;
array[1..N] of par int: satis;
array[1..N] of par int: dur;

array[1..N] of var opt cancs: ida;
array[1..N] of var opt cancs: vuelta;

constraint assert (N > 0 /\ vIda > 0 /\ vVuelta > 0, "N, vIda y vVuelta deben ser mayores que 0");
constraint assert (forall(c in cancs) (dur[c] > 0), "Todas las duracion han de ser mayores que 0");

function var int: sumaSats(array[int] of var opt cancs : cancs) = 
    sum (c in cancs where occurs(c)) (satis[deopt(c)]);

function var int: sumaDurs(array[int] of var opt cancs : cancs) = 
    sum (c in cancs where occurs(c)) (dur[deopt(c)]);

function int: sumaSats(array[int] of opt cancs : cancs) = 
    sum (c in cancs where occurs(c)) (satis[deopt(c)]);
    
function int: sumaDurs(array[int] of opt cancs : cancs) = 
    sum (c in cancs where occurs(c)) (dur[deopt(c)]);  

constraint sumaDurs(ida) == vIda;
constraint sumaDurs(vuelta) == vVuelta;

% no empty sols
constraint forall (c in 1..N-1) (absent(ida[c]) -> absent(ida[c+1]));
constraint forall (c in 1..N-1) (absent(vuelta[c]) -> absent(vuelta[c+1]));

% ordered sols
constraint forall (c in 1..N-1 where (occurs(ida[c]) /\ occurs(ida[c+1]))) (satis[deopt(ida[c])] >= satis[deopt(ida[c+1])]);
constraint forall (c in 1..N-1 where (occurs(vuelta[c]) /\ occurs(vuelta[c+1]))) (satis[deopt(vuelta[c])] >= satis[deopt(vuelta[c+1])]);

% no repeated sols
constraint forall (c in 1..N-1 where (occurs(ida[c]) /\ occurs(ida[c]))) (satis[deopt(ida[c])] == satis[deopt(ida[c+1])] -> deopt(ida[c]) < deopt(ida[c+1]));
constraint forall (c in 1..N-1 where (occurs(vuelta[c]) /\ occurs(vuelta[c]))) (satis[deopt(vuelta[c])] == satis[deopt(vuelta[c+1])] -> deopt(vuelta[c]) < deopt(vuelta[c+1]));
constraint forall (c in ida where occurs(c)) (forall (d in vuelta where occurs(d)) (deopt(c) != deopt(d)));


solve maximize (sumaSats(ida) + sumaSats(vuelta));

output ["ida: \(ida) -> \(sumaSats(ida))\n vuelta: \(vuelta) -> \(sumaSats(vuelta))"];