declare less, integer
store true, less
declare more, integer
store false, more
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
:&temp1
declare &tempi1, integer
<<<<<<< HEAD
low a, b, &tempi1
=======
high a, b, &tempi1
jmp :&temp1
>>>>>>> 629d2e3c7fb81e95b1aa9b6182f095e45d43f2ea
jf &tempi1, :&temp2
declare &tempr1, real
rmult c, a, &tempr1
declare &tempr2, real
store &tempr1, &tempr2
declare &tempi2, integer
rtoi &tempr2, &tempi2
store &tempi2, g
write d
jmp :&temp1
:&temp2
halt
