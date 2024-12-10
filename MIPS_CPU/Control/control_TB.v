`timescale 1ns/100ps
module control_TB();
	reg  [31:0] instruction;
	wire [31:0] ctrl;
		
	control DUT (
		.instruction(instruction),
		.ctrl(ctrl)
	);
	
	initial begin
		//formato i       opcode| rs  |  rt |        offset
		instruction = 32'b000010_00000_00001_0000_0011_0101_0000; // LW
		
		#50
		instruction = 32'b000010_00000_00010_0000_0011_0101_0001; // LW
		
		#50 
		instruction = 32'b000011_00001_00010_0000_0011_0101_0010; // SW
		
		#50 
		instruction = 32'b000011_00010_00010_0000_0011_0101_0011; // SW
		
		#50
		//formato R		 opcode|   rs  |  rt | rd  |     op
		instruction = 32'b000001_00001_00010_00011_01010_110010; //MUL
		
		#50
		instruction = 32'b000001_00001_00010_00110_01010_100000; //ADD
		
		#50
		instruction = 32'b000001_00001_00010_00111_01010_100010; //SUB
		
		#50
		instruction = 32'b000001_00001_00010_01000_01010_100100; //AND
		
		#50
		instruction = 32'b000001_00001_00010_01001_01010_100101; //OR
		
		#50 $stop;
	end
	
endmodule
