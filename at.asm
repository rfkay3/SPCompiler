declare p1, integer
declare &tempi1, integer
call :#intadd
store &#intadd, &tempi1
store &tempi1, p1
declare &tempi2, integer
call :#intadd
store &#intadd, &tempi2
declare &tempi3, integer
idiv &tempi2, 2, &tempi3
declare &tempi4, integer
iadd 13, &tempi3, &tempi4
store &tempi4, p1
halt

:#intadd
declare &#intadd, integer
declare p, integer
store 4, p
store p, intadd
return &#intadd

:#whodey
declare f, string
declare &temps1, string
call :#inbar
store &#inbar, &temps1
store &temps1, f

:#inbar
declare &#inbar, string
declare a, integer
store 5, a
store p1, a
store "not a character", inbar
return &#inbar

:#foo
declare foo23, integer
store 9, foo23

