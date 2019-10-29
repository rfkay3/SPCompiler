
#!/bin/bash

clear

echo "Running the make file..."

make clean
make
echo "running executable with file: program.asm..."

echo "output of the program is below..."
echo "__________________________________________"
./pascal program.pas

echo "Here is the contents of the .asm file..."
cat program.asm
cat program.pas
