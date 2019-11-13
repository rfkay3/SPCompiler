program
var
real a := 1.5, b := 2.0, c := 2.5, d := 5.0;
begin

IF ((a < b) AND (c = d)) OR (b <> c) THEN
BEGIN
d := c * a;
WRITE(d);
END
ELSE
BEGIN
b := d * a;
WRITE(b);
END

{ if 8 < 9 ThEn
    b := 10; }

end.
