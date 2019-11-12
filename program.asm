declare a, integer
store 2, a
declare b, integer
declare c, integer
declare d, integer
store 123234, d
declare x, real
declare y, real
store 2.2, y
declare z, real
store 1.0, z
declare i, character
store '1', i
declare j, character
declare k, character
store 'f', k
declare l, character
store '-', l
declare m, character
store '.', m
declare n, character
declare p, string
store "this is a string", p
declare &tempi1, integer
imult a, a, &tempi1
declare &tempi2, integer
iadd d, d, &tempi2
declare &tempi3, integer
iadd &tempi1, &tempi2, &tempi3
declare &tempi4, integer
store &tempi3, &tempi4
declare &tempr1, real
itor &tempi4, &tempr1
store &tempr1, x
halt
