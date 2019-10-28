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
iadd Mult, a, &tempi1
isub Add, d, &tempi2
iadd &tempi1, &tempi2, &tempi3
store &tempi3, b
halt
