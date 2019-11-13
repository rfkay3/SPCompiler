declare a, real
store 1.5, a
declare b, real
store 2.0, b
declare c, real
store 2.5, c
declare d, real
store 5.0, d
declare &tempi1, integer
low a, b, &tempi1
declare &tempi2, integer
equ c, d, &tempi2
declare &tempi3, integer
and &tempi1, &tempi2, &tempi3
declare &tempi4, integer
equ b, c, &tempi4
declare &tempi5, integer
not &tempi4, &tempi5
declare &tempi6, integer
or &tempi3, &tempi5, &tempi6
jf &tempi6, :&temp1
declare &tempr1, real
rmult c, a, &tempr1
store &tempr1, d
write d
jmp :&temp2
:&temp1
declare &tempr2, real
rmult d, a, &tempr2
store &tempr2, b
write b
:&temp2
halt
