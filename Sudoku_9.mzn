include "alldifferent.mzn";
int: S = 3;
int: N = S * S;
int: digs = ceil(log(10.0,int2float(N))); % digits for output

array[0..N-1, 0..N-1] of var 1..N: puzzle;

% All different in rows
constraint forall (i in 0..N-1) (
        alldifferent( [ puzzle[i,j] | j in 0..N-1 ]) );
% All different in columns.
constraint forall (j in 0..N-1) (
        alldifferent( [ puzzle[i,j] | i in 0..N-1 ]) );
% All different in sub-squares:
constraint forall (x in [ k | k in 0..8 where (k mod S == 0)])(
        alldifferent( [ puzzle[i, j] | i in x..x+S-1, j in x..x+S-1 ] ) );
        
solve satisfy;

output ["\(puzzle)"];