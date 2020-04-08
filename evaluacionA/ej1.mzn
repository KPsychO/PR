par int: N;
% constraint assert (N>0);

array[0..N-1] of var 0..N-1: sol;

constraint forall (i in 0..N-1) (sum (j in 0..N-1 where (sol[j] == i)) (1) == sol[i]);

solve satisfy;

output ["\(sol)"];