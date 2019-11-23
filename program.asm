declare less, integer
store true, less
declare more, integer
store false, more
declare a, real
store 1.5, a
declare b, real
store 4.0, b
declare c, real
store 2.0, c
declare d, real
store 5.0, d
declare x, real
store 22.4, x
declare f, character
store 'a', f
declare g, integer
declare j, integer
store 2, j
declare m, integer
store 92, m
:&temp1
declare &tempr1, real
radd b, a, &tempr1
store &tempr1, a
write d
declare &tempi1, integer
high a, b, &tempi1
jmp :&temp1
jt &tempi1, :&temp2
halt
