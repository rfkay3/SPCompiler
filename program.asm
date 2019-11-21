declare less, integer
store true, less
declare more, integer
declare a, real
store 1.5, a
declare b, real
store 2.0, b
declare c, real
store 2.5, c
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
declare &tempi1, integer
isub j, m, &tempi1
declare &tempi2, integer
declare &tempi3, integer
store &tempi1, &tempi3
declare &tempr1, real
itor &tempi3, &tempr1
low &tempr1, x, &tempi2
declare &tempi4, integer
not &tempi2, &tempi4
store &tempi4, more
declare &tempi5, integer
high a, b, &tempi5
declare &tempi6, integer
not &tempi5, &tempi6
declare &tempi7, integer
equ c, d, &tempi7
declare &tempi8, integer
and &tempi6, &tempi7, &tempi8
declare &tempi9, integer
equ b, c, &tempi9
declare &tempi10, integer
not &tempi9, &tempi10
declare &tempi11, integer
or &tempi8, &tempi10, &tempi11
jf &tempi11, :&temp1
declare &tempr2, real
rmult c, a, &tempr2
declare &tempr3, real
store &tempr2, &tempr3
declare &tempi12, integer
rtoi &tempr3, &tempi12
store &tempi12, g
write d
jmp :&temp2
:&temp1
declare &tempr4, real
rmult d, a, &tempr4
store &tempr4, b
write b
:&temp2
halt
