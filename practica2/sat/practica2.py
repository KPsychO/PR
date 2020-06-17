#!/usr/bin/python3

import sys

VALOR = int(input())
MAXV = int(input())
MAXN = int(input())
MCAP = int(input())
CA = int(input())
MinD = int(input())
MaxD = int(input())
MinB = int(input())
T = int(input())
K = int(input())
CVeg = int(input())
TiposVeg = []
data = input().split()
for i in range(CVeg):
    TiposVeg.append(data[i])
CNVeg = int(input())
TiposNVeg = []
data = input().split()
for i in range(CNVeg):
    TiposNVeg.append(data[i])
m = int(input())
PreciosVeg = []
for i in range(m):
    aux = []
    data = input().split()
    for j in range(CVeg):
        aux.append(int(data[j]))
    PreciosVeg.append(aux)
PreciosNVeg = []
for i in range(m):
    aux = []
    data = input().split()
    for j in range(CNVeg):
        aux.append(int(data[j]))
    PreciosNVeg.append(aux)
durezaVeg = []
data = input().split()
for i in range(CVeg):
    durezaVeg.append(float(data[i]))
durezaNVeg = []
data = input().split()
for i in range(CNVeg):
    durezaNVeg.append(float(data[i]))
cantidadVeg = []
data = input().split()
for i in range(CVeg):
    cantidadVeg.append(int(data[i]))
cantidadNVeg = []
data = input().split()
for i in range(CNVeg):
    cantidadNVeg.append(int(data[i]))

# print(PreciosVeg)
    
def comprasVeg (i,j):
    return "comprasVeg_"+str(i)+"_"+str(j)

def refinadoVeg (i,j):
    return "refinadoVeg_"+str(i)+"_"+str(j)

def almVeg (i,j):
    return "almVeg_"+str(i)+"_"+str(j)

def comprasNVeg (i,j):
    return "comprasNVeg_"+str(i)+"_"+str(j)

def refinadoNVeg (i,j):
    return "refinadoNVeg_"+str(i)+"_"+str(j)

def almNVeg (i,j):
    return "almNVeg_"+str(i)+"_"+str(j)  

def setlogic(l):
    return "(set-logic "+ l +")"

def intvar(v):
    return "(declare-fun "+v+" () Int)"

def bool2int(b):
    return "(ite "+b+" 1 0 )"

def addimplies(a1,a2):
    return "(=> "+str(a1)+" "+str(a2)+" )"
def addand(a1,a2):
    return "(and "+str(a1)+" "+str(a2)+" )"
def addor(a1,a2):
    return "(or "+str(a1)+" "+str(a2)+" )"
def addnot(a):
    return "(not "+str(a)+" )"

def addexists(a):
    if len(a) == 0:
        return "false"
    elif len(a) == 1:
        return a[0]
    else :
        x = a.pop()
        return "(or " + x + " " + addexists(a) + " )" 

def addeq(a1,a2):
    return "(= "+str(a1)+" "+str(a2)+" )" 
def addle(a1,a2):
    return "(<= "+str(a1)+" "+str(a2)+" )" 
def addge(a1,a2):
    return "(>= "+str(a1)+" "+str(a2)+" )" 
def addlt(a1,a2):
    return "(< "+str(a1)+" "+str(a2)+" )"
def addgt(a1,a2):
    return "(> "+str(a1)+" "+str(a2)+" )" 

def addplus(a1,a2):
    return "(+ "+str(a1)+" "+str(a2)+" )"

def addminus(a1,a2):
    return "(- "+str(a1)+" "+str(a2)+" )"

def addmul(a1,a2):
    return "(* "+str(a1)+" "+str(a2)+" )"

def addassert(a):
    return "(assert "+str(a)+" )"

def addassertsoft(a,w):
    return "(assert-soft "+str(a)+" :weight "+ str(w) + " )"

def addsum(a):
    if len(a) == 0:
        return "0"
    elif len(a) == 1:
        return a[0]
    else :
        x = a.pop()
        return "(+ " + str(x) + " " + addsum(a) + " )" 

def checksat():
    print("(check-sat)")
def getobjectives():
    print("(get-objectives)")
def getmodel():
    print("(get-model)")
def getvalue(l):
    print("(get-value " + str(l) + " )")

################################
# generamos un fichero smtlib2
################################

print("(set-option :produce-models true)")
print(setlogic("QF_LIRA"))

# declaración de variables de la solución
for i in range(m):
    for j in range(len(TiposVeg)):
        print(intvar(comprasVeg(i, j)))
        print(intvar(refinadoVeg(i, j)))
for i in range(m):
    for j in range(len(TiposNVeg)):
        print(intvar(comprasNVeg(i, j)))
        print(intvar(refinadoNVeg(i, j)))
for i in range(-1, m):
    for j in range(len(TiposVeg)):
        print(intvar(almVeg(i, j)))
    for j in range(len(TiposNVeg)):
        print(intvar(almNVeg(i, j)))
for i in range(m):
    print(intvar("ben_"+str(i)))
# fin declaración

# Todos los valores deben ser >= 0
for i in range (m):
    for j in range(len(TiposVeg)):
        print(addassert(addge(refinadoVeg(i, j), 0)))
        print(addassert(addge(comprasVeg(i, j), 0)))
        print(addassert(addge(almVeg(i, j), 0)))
    for j in range(len(TiposNVeg)):
        print(addassert(addge(refinadoNVeg(i, j), 0)))
        print(addassert(addge(comprasNVeg(i, j), 0)))
        print(addassert(addge(almNVeg(i, j), 0)))

# % No se refina mas aceite de cada clase del permitido
# constraint forall (i in 1..4) (sum (j in TiposVeg) (refinadoVeg[i, j]) <= MAXV);
for i in range(m):
    suma = []
    for j in range(len(TiposVeg)):
        suma.append(refinadoVeg(i, j))
    print(addassert(addle(addsum(suma), MAXV)))
# constraint forall (i in 1..4) (sum (j in TiposNVeg) (refinadoNVeg[i, j]) <= MAXN);
for i in range(m):
    suma = []
    for j in range(len(TiposNVeg)):
        suma.append(refinadoNVeg(i, j))
    print(addassert(addle(addsum(suma), MAXN)))

# % almVeg[0, j] y almNVeg[0, j] == 0
# constraint forall (j in TiposVeg) (almVeg[0, j] == cantidadVeg[j]);
for j in range(len(TiposVeg)):
    print(addassert(addeq(almVeg(-1, j), cantidadVeg[j])))

# constraint forall (j in TiposNVeg) (almNVeg[0, j] == cantidadNVeg[j]);
for j in range(len(TiposNVeg)):
    print(addassert(addeq(almNVeg(-1, j), cantidadNVeg[j])))

# % Al final de ano quedan cantidadVeg y cantidadNVeg de aceite en el almacen
# constraint forall (j in TiposVeg) (almVeg[4, j] == cantidadVeg[j]);
for j in range(len(TiposVeg)):
    print(addassert(addeq(almVeg(m-1, j), cantidadVeg[j])))

# constraint forall (j in TiposNVeg) (almNVeg[4, j] == cantidadNVeg[j]);
for j in range(len(TiposNVeg)):
    print(addassert(addeq(almNVeg(m-1, j), cantidadNVeg[j])))

# % El aceite almacenado es comprado-refinado -> Solo cuenta como almacenado el aceite que no se usa a final de mes
# constraint forall (i in 1..4, j in TiposVeg) (almVeg[i,j] == ((almVeg[i-1, j]+comprasVeg[i, j])-refinadoVeg[i,j]));
for i in range(m):
    for j in range(len(TiposVeg)):
        print(addassert(addeq(addminus(addplus(almVeg(i-1, j), comprasVeg(i, j)), refinadoVeg(i, j)), almVeg(i, j))))

# constraint forall (i in 1..4, j in TiposNVeg) (almNVeg[i, j] == ((almNVeg[i-1, j]+comprasNVeg[i, j])-refinadoNVeg[i,j]));
for i in range(m):
    for j in range(len(TiposNVeg)):
        print(addassert(addeq(addminus(addplus(almNVeg(i-1, j), comprasNVeg(i, j)), refinadoNVeg(i, j)), almNVeg(i, j))))

# % No se almacena mas aceite del pemitido de ningun tipo
# constraint forall (i in 1..4, j in TiposVeg) (almVeg[i,j] <= MCAP);
for i in range(m):
    for j in range(len(TiposVeg)):
        print(addassert(addle(almVeg(i, j), MCAP)))

# constraint forall (i in 1..4, j in TiposNVeg) (almNVeg[i, j] <= MCAP);
for i in range(m):
    for j in range(len(TiposNVeg)):
        print(addassert(addle(almNVeg(i, j), MCAP)))

# % % El beneficio debe ser mayor que minB
# constraint forall (i in 1..4) (totalRefinado(i)*VALOR - (totalCosteCompra(i) + totalAlmacenado(i)*CA) >= MinB);
# constraint forall (i in 1..4) (((sum (j in TiposVeg) (refinadoVeg[i, j]*VALOR - (comprasVeg[i, j]*PreciosVeg[i, j] + almVeg[i, j]*CA))) + (sum (j in TiposNVeg) (refinadoNVeg[i, j]*VALOR - (comprasNVeg[i, j]*PreciosNVeg[i, j] + almNVeg[i, j]*CA)))) >= MinB);
for i in range(m):
    sumarefveg = []
    sumacomveg = []
    sumaalmveg = []
    for j in range(len(TiposVeg)):
        sumarefveg.append(addmul(refinadoVeg(i, j), VALOR))
        sumacomveg.append(addmul(comprasVeg(i, j), PreciosVeg[i][j]))
        sumaalmveg.append(addmul(almVeg(i, j), CA))
    sumarefNveg = []
    sumacomNveg = []
    sumaalmNveg = []
    for j in range(len(TiposNVeg)):
        sumarefNveg.append(addmul(refinadoNVeg(i, j), VALOR))
        sumacomNveg.append(addmul(comprasNVeg(i, j), PreciosNVeg[i][j]))
        sumaalmNveg.append(addmul(almNVeg(i, j), CA))
    # print(addassert(addgt(addplus(addminus(addsum(sumarefveg), addplus(addsum(sumacomveg), addsum(sumaalmveg))), addminus(addsum(sumarefNveg), addplus(addsum(sumacomNveg), addsum(sumaalmNveg)))), MinB)))
    print(addassert(addeq(addplus(addminus(addsum(sumarefveg), addplus(addsum(sumacomveg), addsum(sumaalmveg))), addminus(addsum(sumarefNveg), addplus(addsum(sumacomNveg), addsum(sumaalmNveg)))), "ben_"+str(i))))

# sumar beneficios
sum = []
for i in range(m):
    sum.append("ben_"+str(i))
print(addassert(addge(addsum(sum), MinB)))

# % % La dureza debe ser valida
# constraint forall (i in 1..4) ((durVeg(i) + durNVeg(i)) <= MaxD*totalRefinado(i));
for i in range(m):
    totalRef = []
    sumaVeg = []
    for j in range(len(TiposVeg)):
        sumaVeg.append(addmul(refinadoVeg(i, j), durezaVeg[j]))
        totalRef.append(refinadoVeg(i, j))
    sumaNVeg = []
    for j in range(len(TiposNVeg)):
        sumaNVeg.append(addmul(refinadoNVeg(i, j), durezaNVeg[j]))
        totalRef.append(refinadoNVeg(i, j))
    print(addassert(addle(addplus(addsum(sumaVeg), addsum(sumaNVeg)), addmul(MaxD, addsum(totalRef)))))

# constraint forall (i in 1..4) ((durVeg(i) + durNVeg(i)) >= MinD*totalRefinado(i));
for i in range(m):
    totalRef = []
    sumaVeg = []
    for j in range(len(TiposVeg)):
        sumaVeg.append(addmul(refinadoVeg(i, j), durezaVeg[j]))
        totalRef.append(refinadoVeg(i, j))
    sumaNVeg = []
    for j in range(len(TiposNVeg)):
        sumaNVeg.append(addmul(refinadoNVeg(i, j), durezaNVeg[j]))
        totalRef.append(refinadoNVeg(i, j))
    print(addassert(addge(addplus(addsum(sumaVeg), addsum(sumaNVeg)), addmul(MinD, addsum(totalRef)))))

# constraint forall (i in 1..12) ((refinadoVeg[i, VEG1] > 0 /\ refinadoVeg[i, VEG2] > 0) -> refinadoNVeg[i, ANV3] > 0);
# for i in range(m):
#     print(addassertsoft(addimplies(addor(addgt(refinadoVeg(i, 1), 0), addgt(refinadoVeg(i, 2), 0)), addgt(refinadoNVeg(i, 3)))))

checksat()

# getmodel()
for i in range(m):
    for j in range(len(TiposVeg)):
        getvalue("("+comprasVeg(i, j)+")")
        getvalue("("+refinadoVeg(i, j)+")")
        getvalue("("+almVeg(i, j)+")")

for i in range(m):
    for j in range(len(TiposNVeg)):
        getvalue("("+comprasNVeg(i, j)+")")
        getvalue("("+refinadoNVeg(i, j)+")")
        getvalue("("+almNVeg(i, j)+")")
for i in range(m):
    getvalue("(ben_"+str(i)+")")

exit(0)