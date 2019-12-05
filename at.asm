declare a, integer
declare &tempr1, real
store 4.01, &tempr1
declare &tempi1, integer
rtoi &tempr1, &tempi1
store &tempi1, a
declare f, real
declare &tempi2, integer
store 5, &tempi2
declare &tempr2, real
itor &tempi2, &tempr2
store &tempr2, f
declare &tempr3, real
radd a, f, &tempr3
declare &tempr4, real
store &tempr3, &tempr4
declare &tempi3, integer
rtoi &tempr4, &tempi3
store &tempi3, a
halt
