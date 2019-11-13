declare a, integer
store 2, a
declare A, integer
declare f, real
store 2.2, f
declare g, real
store 9.864, g
declare p, string
store "this is a string", p
declare z, string
store "and this is a string", z
declare str, string
declare h, boolean
store true, h
declare &tempb1, boolean
equal 77, 8, &tempb1
declare &tempb2, boolean
or &tempb1, true, &tempb2
declare &tempb3, boolean
not &tempb2, &tempb3
store &tempb3, h
halt
