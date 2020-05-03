par int: D;
par int: T;
enum turns = {AA, BB, CC};
par int: N;
par int: maxDT;
par int: maxDL;
par int: minDT;
array[1..T] of par bool: supervisors;

array[1..D, 1..T] of var opt turns: sol;

constraint assert (D > 0, "D <= 0");
constraint assert (T > 0, "T <= 0");
constraint assert (N > 0, "N <= 0");
constraint assert (T > N, "T <= N");
constraint assert (maxDT > 0, "maxDT <=0");
constraint assert (maxDL > 0, "maxDL <=0");
constraint assert (minDT < D, "minDT >= D");
constraint assert (3*N < T, "3*N >= T");
constraint assert (sum (i in 1..T where supervisors[i]) (1) >= 3, "Supervisores insuficientes");

% 1. Cada turno tiene N trabajadores.
constraint forall (i in 1..D) (sum (j in 1..T where (occurs(sol[i, j]))) (1) == (3*N));
constraint forall (i in 1..D, t in turns) (sum (j in 1..T where (occurs(sol[i, j]) /\ deopt(sol[i, j]) == t)) (1) == N);

% 2. Un trabajador solo puede estar en un turno cada dia.
% No es necesario, dado que la representacion de la solucion no permite mas de un turno por trabajador

% 3. Dado un numero MaxDT, garantizar que nadie trabaja MaxDT dias consecutivos.
constraint forall (j in 1..T) (forall (i in 1..(D-maxDT)) (sum (x in i..i+maxDT where occurs(sol[x, j])) (1) <= maxDT));

% 4. Dado un numero MaxDL, garantizar que nadie tiene MaxDL dias libres consecutivos.
constraint forall (j in 1..T) (forall (i in 1..(D-maxDL)) (sum (x in i..i+maxDL where absent(sol[x, j])) (1) <= maxDL));

% 5. Dado un numero MinDT, garantizar que todos trabajan como minimo MinDT en los D dias.
constraint forall (j in 1..T) (sum (i in 1..D where (occurs(sol[i, j]))) (1) >= minDT);

% 6. Un trabajador no puede hacer el ultimo turno de un día y el primero del dia siguiente.
constraint forall (i in 1..D-1) (forall (j in 1..T where (occurs(sol[i, j])) /\ occurs(sol[i+1, j])) ((deopt(sol[i, j]) == CC) -> (deopt(sol[i+1, j]) != AA)));

% 7. Dada una serie de parejas de trabajadores incompatibles, dos trabajadores incompatibles no pueden estar en el mismo turno.
% Dada una matriz o array de pares de trabajadores incompatibles, si en un turno y dia occurs(A) -> absent(B)

% 8. Dados cuales de los trabajadores son “supervisores”, garantizar que en cada turno hay un supervisor.
constraint forall (i in 1..D) (forall (t in turns) (sum (j in 1..T where (occurs(sol[i, j]) /\ deopt(sol[i, j]) == t /\ supervisors[j])) (1) >= 1));

solve satisfy;

output ["       " ++ "\(supervisors[j])" ++ " " | j in 1..T];

output ["\n"];

output [
    if j == 1 then "Dia \(i): " else "" endif ++
    "\(sol[i, j])" ++ "           " ++
    if j == T then "\n" else "" endif
    | i in 1..D, j in 1..T
    ];