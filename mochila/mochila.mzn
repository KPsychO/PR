par int: MW;
constraint assert (MW > 0, "w must b greater than 0");
enum items;
array [items] of par int: weights;
constraint assert (forall(i in items) (weights[i] > 0), "all weights must be greater than 0");

% Solution (OPT -> MAYBE)
array[1..card(items)] of var opt items: sol;

function var int: suma(array[int] of var opt items: s) = 
    sum (o in s where occurs(o)) (weights[deopt(o)]);

function int: suma (array[int] of opt items: s) = 
    sum (o in s where occurs(o)) (weights[deopt(o)]);

%Solution can't have empty answers
constraint forall (i in 1..card(items)-1) (absent(sol[i]) -> absent(sol[i+1]));

% Order items from greater to smaller
constraint forall (i in 1..card(items)-1 where (occurs(sol[i]) /\ occurs(sol[i+1]))) (weights[deopt(sol[i])] >= weights[deopt(sol[i+1])]);

% no repeated elems
constraint forall (i in 1..card(items) -1 where (occurs(sol[i]) /\ occurs(sol[i+1]))) (weights[deopt(sol[i])] = weights[deopt(sol[i+1])] -> deopt(sol[i]) < deopt(sol[i+1]));

% sum of weights is lesser than W
constraint suma(sol) <= MW;

solve maximize suma(sol);

output ["\(sol) : \(suma(sol))"];