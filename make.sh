###################################		CLEAN		#################################################
if [[ $1 = "clean" ]]
then
	echo Cleaning...
	find -name *.out -delete		# Removes all executibles - General
	find -name  *.vcd -delete	        # Removes all dump file - Verilog
	echo Complete
###################################	      ASSEMBLE		#################################################
elif [[ $1 = "assemble" ]]
then
	if [ -f $2 ]
	then
			# If both are true it assembles
			echo Assembling...        $2
			## Converts parameters.v --> parameters.h, Makes it C++ compliant
			g++ Assembler/fixup.cc -o Junk/fixup.out	  # Creates parameters.h and converts the `defines to #define
			./Junk/fixup.out				  # Runs fixup
			## Converts .asm --> .mac
			g++ Assembler/assemble.cc -o Junk/assemble.out    # Compiles assembler
			# Creates a .mac with the same names as the .asm file,
			#	then runs the .asm through the assembler outputting the machine code into the .mac file
			Junk/assemble.out $2 "${2%.*}.mac"		  
			echo Complete: "${2%.*}.mac" has the machine code
			echo
	fi
################################	       COMPILE			#################################################
elif [[ $1 = "compile" ]]
then
	####	Prompts user and get the file they want to compile   ####
	echo Module files:
	echo
	echo "Enter the name of file you want to compile:"
	echo 
	echo "Source_File                                Dependencies:"
	echo  "-----------                                -------------"
	echo "CONTROLLER.v"
	echo "DATAPATH.v                                 ALU.v    IR.v   PC.v   REG.v"
	echo "IR.v"
	echo "PC.v"
	echo "PROCESSOR.v                                ALU.v   CONTROLLER.v   DATAPATH.v   IR.v   PC.v   RAM.v   REG.v"
	echo "RAM.v"
	echo "REG.v"
	echo --------- 
	read -p "FileName >> " Module
	
	##	Checks if file exists	##
	if [ -f "Modules/$Module" ]
	then
		echo
		echo Compiling...
		echo
		if [[ $Module = "CONTROLLER.v"  ]]
		then
			iverilog Modules/CONTROLLER.v -o Junk/CONTROLLER.out
		
		elif [[ $Module = "DATAPATH.v"  ]]
		then
			iverilog Modules/DATAPATH.v Modules/ALU.v Modules/IR.v Modules/MUX.v Modules/PC.v Modules/REG.v -o Junk/DATAPATH.out
		
		elif [[ $Module = "IR.v"  ]]
		then
			iverilog Modules/IR.v -o Junk/IR.out
		
		elif [[ $Module = "PC.v"  ]]
		then
			iverilog Modules/PC.v -o Junk/PC.out
		
		elif [[ $Module = "PROCESSOR.v"  ]]
		then
			iverilog Modules/PROCESSOR.v Modules/ALU.v Modules/CONTROLLER.v Modules/DATAPATH.v Modules/IR.v Modules/MUX.v Modules/PC.v Modules/RAM.v Modules/REG.v -o Junk/PROCESSOR.out
		
		elif [[ $Module = "RAM.v"  ]]
		then
			iverilog Modules/RAM.v -o Junk/RAM.out
		
		elif [[ $Module = "REG.v"  ]]
		then
			iverilog Modules/REG.v -o Junk/REG.out
		fi
		echo
		echo Complete
		echo
	else
		echo Failed: $Module does not exist
	fi
################################	       SIMULATE			#################################################
elif [[ $1 = "simulate" ]]
then
	####	Prompts user and get the file they want to compile   ####
	echo Module files:
	echo
	echo "Enter the name of file you want to simulate:"
	echo 
	echo "Source_File                                Dependencies:"
	echo  "-----------                                -------------"
	echo "CONTROLLER_tb.v                               CONTROLLER.v"
	echo "IR_tb.v                                       IR.v"
	echo "PC_tb.v                                       PC.v"
	echo "PROCESSOR_tb.v                                ALU.v   CONTROLLER.v   DATAPATH.v   IR.v   PC.v   PROCESSOR.v   RAM.v   REG.v"
	echo "RAM_tb.v                                      RAM.v"
	echo --------- 
	read -p "FileName >> " Module
	echo
	echo Enter the .mac file that has the machine instructions for the test input
	read -p "FileName >> " Mac_File
	cp Mac_File Testbenches/binary.mac
	echo
	# RAM_tb.v has a secondary input file that is to test the load data function of it
	if [[ -f "Testbenches/$Modules" ]]
	then
		if [[ $Module = "RAM_tb.v" ]]
		then
			echo Enter the file that has the data for the test input
			read -p "Filename >> " Data_File
			echo
			cp Data_File Testbenches/data.mac
		fi
		if [ -f $Mac_File ]
		then
			echo
			echo Simulating...
			echo
			if [[ $Module = "CONTROLLER_tb.v" ]]
			then
				iverilog Testbenches/CONTROLLER_tb.v Modules/CONTROLLER.v -o Junk/CONTROLLER.out
				vvp Junk/CONTROLLER.out
				gtkwave Junk/CONTROLLER.vcd
		
			elif [[ $Module = "IR_tb.v" ]]
			then
				iverilog Testbenches/IR_tb.v Modules/IR.v parameters.v -o Junk/IR.out
				vvp Junk/IR.out
				gtkwave Junk/IR.vcd
			
			elif [[ $Module = "PC_tb.v" ]]
			then
				iverilog Testbenches/PC_tb.v Modules/PC.v -o Junk/PC.out
				vvp Junk/PC.out
				gtkwave Junk/PC.vcd
				
			elif [[ $Module = "PROCESSOR_tb.v" ]]
			then
				iverilog Testbenches/PROCESSOR_tb.v Modules/ALU.v Modules/CONTROLLER.v Modules/DATAPATH.v Modules/IR.v Modules/MUX.v Modules/PC.v Modules/PROCESSOR.v Modules/RAM.v Modules/REG.v parameters.v -o Junk/PROCESSOR.out
				vvp Junk/PROCESSOR.out
				gtkwave Junk/PROCESSOR.vcd

			elif [[ $Module = "RAM_tb.v" ]]
			then
				iverilog Testbenches/RAM_tb.v Modules/RAM.v -o Junk/RAM.out
				vvp Junk/RAM.out
				gtkwave Junk/RAM.vcd
		
			else
				echo Failed: $Module does not exist
			fi
		else
			echo Failed: $Mac_File does not exist
		fi
	else
		echo Failed: $Module does not exist
	fi
################################	        ERROR			#################################################
else
	echo
	echo How to Operate
	echo -------------	
	echo
	echo "Assembler:"
	echo "         - Command: ./make.sh assembler FILENAME.asm"
	echo "	 - The .asm file is the assembly code you want to convert."
	echo "	 - The assembler will return a file of the same name as the .asm, but with the .mac file extension."
	echo 
	echo "Verilog Compilier (iverilog):"
	echo "         - Command: ./make.sh compile"
	echo "         - It will prompt you for the file name of the module you want to compile."
	echo "         - You can change whether a testbench randomizes data and its range of value in parameters.v"
	echo 
	echo "Verilog Simulator (gtkwave):"
	echo "         - Command: ./make.sh simulate"
	echo "         - It will prompt you for the file name of the testbench you want to simulate."
	echo "         - After, it will prompt you for the .mac file to be used a input (Even if you are randomizing data or the testbench does not need it)."
	echo "         - If the testbench you selected was RAM_tb.v it will prompt you for an additional file."
	echo "             This file is the data input file for the testbench."
	echo
fi
