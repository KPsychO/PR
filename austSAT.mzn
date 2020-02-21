% Colouring Australia using nc colours
enum color = {rojo, azul, amarillo};

par color: crojo = rojo;

var bool: wa0; var bool: wa1; var bool: wa2;
var bool: nt0; var bool: nt1; var bool: nt2; 
var bool: sa0; var bool: sa1; var bool: sa2; 
var bool: q0; var bool: q1; var bool: q2; 
var bool: nsw0; var bool: nsw1; var bool: nsw2; 
var bool: v0; var bool: v1; var bool: v2; 
var bool: t0; var bool: t1; var bool: t2;      

constraint wa0 \/ wa1 \/ wa2;
constraint nt0 \/ nt1 \/ nt2;
constraint sa0 \/ sa1 \/ sa2;
constraint q0 \/ q1 \/ q2;
constraint nsw0 \/ nsw1 \/ nsw2; 
constraint v0 \/ v1 \/ v2;
constraint t0 \/ t1 \/ t2;

constraint not wa0 \/ not wa1;
constraint not wa0 \/ not wa2;
constraint not wa1 \/ not wa2;

constraint not nt0 \/ not nt1;
constraint not nt0 \/ not nt2;
constraint not nt1 \/ not nt2;

constraint not sa0 \/ not sa1;
constraint not sa0 \/ not sa2;
constraint not sa1 \/ not sa2;

constraint not q0 \/ not q1;
constraint not q0 \/ not q2;
constraint not q1 \/ not q2;

constraint not nsw0 \/ not nsw1;
constraint not nsw0 \/ not nsw2;
constraint not nsw1 \/ not nsw2;

constraint not v0 \/ not v1;
constraint not v0 \/ not v2;
constraint not v1 \/ not v2;

constraint not t0 \/ not t1;
constraint not t0 \/ not t2;
constraint not t1 \/ not t2;

%constraint wa != nt;
constraint not wa0 \/ not nt0;
constraint not wa1 \/ not nt1;
constraint not wa2 \/ not nt2;

%constraint wa != sa;
constraint not wa0 \/ not sa0;
constraint not wa1 \/ not sa1;
constraint not wa2 \/ not sa2;

%constraint nt != sa;
constraint not nt0 \/ not sa0;
constraint not nt1 \/ not sa1;
constraint not nt2 \/ not sa2;

%constraint nt != q;
constraint not nt0 \/ not q0;
constraint not nt1 \/ not q1;
constraint not nt2 \/ not q2;

%constraint sa != q;
constraint not sa0 \/ not q0;
constraint not sa1 \/ not q1;
constraint not sa2 \/ not q2;

%constraint sa != nsw;
constraint not sa0 \/ not nsw0;
constraint not sa1 \/ not nsw1;
constraint not sa2 \/ not nsw2;

%constraint sa != v;
constraint not sa0 \/ not v0;
constraint not sa1 \/ not v1;
constraint not sa2 \/ not v2;

%constraint q != nsw;
constraint not q0 \/ not nsw0;
constraint not q1 \/ not nsw1;
constraint not q2 \/ not nsw2;

%constraint nsw != v;
constraint not nsw0 \/ not v0;
constraint not nsw1 \/ not v1;
constraint not nsw2 \/ not v2;

output ["wa: "++show(if wa0 then rojo elseif wa1 then azul else amarillo endif) ++ "\t",
        "nt: "++show(if nt0 then rojo elseif nt1 then azul else amarillo endif) ++ "\t",
        "sa: "++show(if sa0 then rojo elseif sa1 then azul else amarillo endif) ++ "\n",
        "q: "++show(if q0 then rojo elseif q1 then azul else amarillo endif) ++ "\t",
        "nsw: "++show(if nsw0 then rojo elseif nsw1 then azul else amarillo endif) ++ "\t",
        "v: "++show(if v0 then rojo elseif v1 then azul else amarillo endif) ++ "\n",
        "t: "++show(if t0 then rojo elseif t1 then azul else amarillo endif) ++ "\n"];
