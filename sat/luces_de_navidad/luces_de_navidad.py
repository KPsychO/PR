#!/usr/bin/python3

import sys

datos = input().split()
L = int(datos[0]) # Longitud de la linea de luces a fabricar
N = int(datos[1]) # número de colores diferentes
C = int(datos[2]) # consumo maximo de la tira
datos = input().split() 
consumo = []         # consumo de cada bombilla
for i in range(N):
    consumo.append(int(datos[i]))
datos = input().split() 
cantidad = []         # cantidad de cada bombilla
for i in range(N):
    cantidad.append(int(datos[i]))

# print(L)
# print(N)
# print(C)
# print(consumo)
# print(cantidad)
    
def asig (i):            # asig_0
    return "asig_"+str(i)  #   

def ncons (i):            # ncons_0
    return "ncons_"+str(i)  #    

def ntipo (i):           # ntipo_0
    return "ntipo_"+str(i) #    

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
#print(setlogic("QF_?"))

# declaración de variables de la solución
for i in range(L):
    print(intvar(asig(i)))
    print(intvar(ncons(i)))
    print(intvar(ntipo(i)))
# fin declaración

for i in range(L):
    for j in range(N):
        print(addassert(addimplies(addeq(asig(i), str(j)), addeq(ncons(i), str(consumo[j])))))

for i in range(L):
    for j in range(N):
        print(addassert(addimplies(addeq(asig(i), str(j)), addeq(ntipo(i), str(j)))))

# no hay dos luces seguidas del mismo color
# constraint forall (i in 1..L-2) (not (solucion[i] == solucion[i+1] /\ solucion[i+1] == solucion[i+2]));
for i in range(L-2):
    # print(addassert(addnot(addand(addeq(ntipo(i), ntipo(i+1)), addeq(ntipo(i+1), ntipo(i+2))))))
    print(addassert(addimplies(addeq(ntipo(i), ntipo(i+1)), addnot(addeq(ntipo(i), ntipo(i+2))))))

# en cualquier punto de la tira la suma de las luces de un color no supere en mas de una unidad la suma de las luces de todos los demas colores
# constraint forall (i in 1..N) (forall (c in colores) (sum (k in 1..i) (if (solucion[k] == c) then 1 else -1 endif) <= 1));


# las tiras de luces no deben consumir mas de una cierta cantidad de energıa
# constraint (sum (i in 1..L) (consumos[solucion[i]])) <= C;
suma = []
for i in range(L):
    suma.append(ncons(i))
print(addassert(addle(addsum(suma), C)))

# no debes usar mas bombillas de las disponibles
# constraint forall (c in colores) ((sum (i in 1..L where (solucion[i] == c)) (1)) <= cantidades[c]);
for i in range(N):
    suma = []
    for j in range(L):
        suma.append(bool2int(addeq(asig(j), str(i))))
    print(addassert(addle(addsum(suma), cantidad[i])))

checksat()

#getmodel()
for i in range(L):
    getvalue("("+asig(i)+")")
exit(0)