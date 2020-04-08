par int: N;

array[0..N-1] of var 0..N-1: sol;
var int: e;

constraint e<N;

constraint sum (j in 0..N-1 where (sol[j] == e)) (1) == (sol[e] + 1) \/ sum (j in 0..N-1 where (sol[j] == e)) (1) == (sol[e] - 1);
constraint forall (i in 0..N-1 where (i != e)) (sum (j in 0..N-1 where (sol[j] == i)) (1) == sol[i]);

solve satisfy;

output ["\(sol)"];