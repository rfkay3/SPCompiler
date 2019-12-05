declare a, integer
store 4, a
declare b, integer
store 2, b
declare c, integer
store 6, c
declare d, integer
store 8, d
declare f, character
declare moo, character
store 'd', moo
declare lol, boolean
store true, lol
declare defFalse, boolean
store 0, defFalse
:&temp1
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
imult a, b, &tempi6
declare &tempi7, integer
low &tempi6, c, &tempi7
declare &tempi8, integer
not &tempi7, &tempi8
declare &tempi9, integer
and &tempi5, &tempi8, &tempi9
declare &tempi10, integer
or &tempi3, &tempi9, &tempi10
jf &tempi10, :&temp2
declare &tempi11, integer
imult c, a, &tempi11
store &tempi11, d
store b, a
:&temp3
declare &tempi12, integer
iadd b, 1, &tempi12
store &tempi12, a
declare &tempi13, integer
high a, d, &tempi13
jt &tempi13, :&temp3
jmp :&temp1
:&temp2
store a, d
halt
