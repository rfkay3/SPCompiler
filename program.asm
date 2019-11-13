declare a, real
store 1.5, a
declare b, real
store 2.0, b
declare c, real
store 2.5, c
declare d, real
store 5.0, d
declare f, integer
store 4, f
declare &tempr1, real
radd a, b, &tempr1
declare &tempi1, integer
imult c, f, &tempi1
declare &tempi2, integer
store &tempi1, &tempi2
declare &tempr2, real
itor &tempi2, &tempr2
declare &tempr3, real
radd &tempr1, &tempr2, &tempr3
store &tempr3, a
declare &tempr4, real
store a, &tempr4
declare &tempi3, integer
rtoi &tempr4, &tempi3
store &tempi3, f
halt
