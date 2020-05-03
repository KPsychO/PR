include "alldifferent.mzn";
int: S = 4;
int: N = S * S;
int: digs = ceil(log(10.0,int2float(N))); % digits for output

array[1..N, 1..N] of var 1..N: puzzle;

% All different in rows
constraint forall (i in 1..N) (
        alldifferent( [ puzzle[i,j] | j in 1..N ]) );
% All different in columns.
constraint forall (j in 1..N) (
        alldifferent( [ puzzle[i,j] | i in 1..N ]) );
% All different in sub-squares:
constraint forall (x in [ k | k in 1..N-1 where (k mod S == 1)])(
        alldifferent( [ puzzle[i, j] | i in x..x+S-1, j in x..x+S-1 ] ) );
        
solve satisfy;

output [ show_int(digs,puzzle[i,j]) ++ " " ++
        if j mod S == 0 then " " else "" endif ++
        if j == N then
                if i != N then
                        if i mod S == 0 then "\n\n" else "\n" endif
        else "" endif else "" endif
        | i,j in 1..N ] ++ ["\n"];
