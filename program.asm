declare a, real
store 1.5, a
declare b, real
store 2.0, b
declare c, real
store 2.5, c
declare d, real
store 5.0, d
declare &tempb1, boolean
low a, b, &tempb1
declare &tempb2, boolean
equal c, d, &tempb2
declare &tempb3, boolean
and &tempb1, &tempb2, &tempb3
declare &tempb4, boolean
equal b, c, &tempb4
declare &tempb5, boolean
not &tempb4, &tempb5
declare &tempb6, boolean
or &tempb3, &tempb5, &tempb6
jf &tempb6, :&temp1
declare &tempr1, real
rmult c, a, &tempr1
store &tempr1, d
jmp :&temp2
:&temp1
declare &tempr2, real
rmult d, a, &tempr2
store &tempr2, b
:&temp2
halt
