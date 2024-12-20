`timescale 1ns/100ps
module TB();

	reg CLK;	
	wire CS;
	wire CS_P;
	wire WE;
	
//	reg CLK_MUL;
	reg CLK_SYS;
	reg reset;
	reg[31:0] Data_BUS_READ;
	reg[31:0] Prog_BUS_READ;
	wire[31:0] Data_BUS_WRITE;
	wire[31:0] ADDR_Prog;
	reg [31:0] instruction;
	wire[31:0] ADDR;
	reg [31:0] ctrl;
	reg [31:0] writeBack;



	cpu DUT (
		.CLK(CLK),
		.reset(reset),
		.Data_BUS_READ(Data_BUS_READ),
		.ADDR(ADDR),
		.ADDR_Prog(ADDR_Prog),
		.Data_BUS_WRITE(Data_BUS_WRITE),
		.Prog_BUS_READ(Prog_BUS_READ),
		.CS(CS),
		.CS_P(CS_P),
		.WE(WE)
	);

	initial begin
//		$init_signal_spy("/TB/DUT/CLK_MUL", "CLK_MUL", 1);
		$init_signal_spy("/TB/DUT/CLK_SYS", "CLK_SYS", 1);
		$init_signal_spy("/TB/DUT/instruction", "instruction", 1);
		$init_signal_spy("/TB/DUT/writeBack", "writeBack", 1);
		$init_signal_spy("/TB/DUT/ctrl_wb", "ctrl", 1);


		Data_BUS_READ = 32'h22b4;
		Prog_BUS_READ = 32'h064f;
		CLK = 0;
		reset = 1;
		#1000 reset = 0;
		#5000000 $stop;
	end

	always #12 CLK = ~CLK;
	
//	always #280 $display(DUT.INST_MEM.out);
	
endmodule
