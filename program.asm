declare a, integer
store 4, a
declare b, integer
store 2, b
declare c, integer
store 6, c
declare d, integer
store 8, d
:&temp1
declare &tempi1, integer
imult c, a, &tempi1
store &tempi1, d
declare &tempi2, integer
low a, b, &tempi2
declare &tempi3, integer
equ c, d, &tempi3
declare &tempi4, integer
and &tempi2, &tempi3, &tempi4
declare &tempi5, integer
equ b, c, &tempi5
declare &tempi6, integer
not &tempi5, &tempi6
declare &tempi7, integer
imult a, b, &tempi7
declare &tempi8, integer
low &tempi7, c, &tempi8
declare &tempi9, integer
not &tempi8, &tempi9
declare &tempi10, integer
and &tempi6, &tempi9, &tempi10
declare &tempi11, integer
or &tempi4, &tempi10, &tempi11
jt &tempi11, :&temp1
halt
