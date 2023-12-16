Undergraduate Final Project (First Time Making One):

Dependencies:
    GNU Compilier Collection
      - https://gcc.gnu.org/
    Icarus verilog Compilier
      - https://steveicarus.github.io/iverilog/
    Gtkwave Simulator
      - https://gtkwave.sourceforge.net/
Ubuntu Distros Installation:
    sudo apt update
    sudo apt upgrade
    sudo apt install gcc
    sudo apt install iverilog
    sudo apt install gtkwave

How to Operate:
  make.sh:
    - This is how you operate the assembler, cleaning the junk folder, verilog compiler, and the verilog simulater.
    - Doing ./make.sh will give you the prompt of the commands and what they do.
    - To assemble:  ./make.sh assemble FILENAME.asm, it will give you the machine code in FILENAME.mac
    - To clean:    ./make.sh clean
    - To compile:  ./make.sh compile, follow the prompts
    - To simulate: ./make.sh simulate, follow the prompts

Assembly Code:
    - To create an assembly file use Vim, Nano, or preferred text editor.
    - The file needs the extension .asm in order for the assembler to accept it.
    - Examples of the assembly code can be found in demo.asm or Assembler/sample.asm

Assembler:
    - The assembler will first take the parameters.v, copy it and make it into a C++ header.
    - Then the assembler will read the .asm file and .mac file passed in through the command (the .mac file is created by the shell script).
    - It will create three new files:
      1. .mac file the actual machine code to be used by the processor.
      2. assembler.logs, this holds the name of the assembly file to be converted, all the errors thrown, error count, warning count, and whether it was successful or not.
      3. debugger, this is a sid-by-side comparision of your .asm code and the .mac code.
       
