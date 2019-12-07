declare p, integer
store 8, p
store 2, p
halt

:#topScope
declare topScope, integer
declare a, integer
store 1, a
store 6, topScope
return topScope

:#midScope1
declare midScope1, real
declare &tempi1, integer
store a, &tempi1
declare &tempr1, real
itor &tempi1, &tempr1
store &tempr1, midScope1
return midScope1

