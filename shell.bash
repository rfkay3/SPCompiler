
#!/bin/bash

clear

echo "Running the make file..."

make
echo "running Executable with file program.asm..."
./pascal program.pas
echo "output of the program is below..."
echo "__________________________________________"
cat program.asm
