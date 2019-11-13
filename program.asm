declare a, integer
store 2, a
declare A, integer
declare f, real
store 2.2, f
declare g, real
store 9.864, g
declare p, string
store "this is a string", p
declare z, string
store "and this is a string", z
declare str, string
declare h, boolean
store true, h
concat p, z, p
concat p, "lol", p
store p, p
declare &tempi1, integer
imult 3, 5, &tempi1
declare &tempi2, integer
imod &tempi1, 7, &tempi2
declare &tempi3, integer
idiv 55, &tempi2, &tempi3
declare &tempi4, integer
store &tempi3, &tempi4
declare &tempr1, real
itor &tempi4, &tempr1
declare &tempr2, real
radd 2.4, &tempr1, &tempr2
declare &tempi5, integer
store 54, &tempi5
declare &tempr3, real
itor &tempi5, &tempr3
declare &tempr4, real
rsub &tempr2, &tempr3, &tempr4
store &tempr4, A
declare &tempb1, boolean
low 1, 2, &tempb1
store &tempb1, h
declare &tempb2, boolean
high 2, 1, &tempb2
store &tempb2, h
store true, h
store false, h
declare &tempb3, boolean
low 55, 2, &tempb3
declare &tempb4, boolean
not &tempb3, &tempb4
declare &tempb5, boolean
high 34, 2039, &tempb5
declare &tempb6, boolean
not &tempb5, &tempb6
declare &tempb7, boolean
equal &tempb4, &tempb6, &tempb7
store &tempb7, h
halt
