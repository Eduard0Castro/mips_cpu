`timescale 1ns/100ps
module Adder_TB();

    reg [15:0] OperandoA;
    reg [15:0] OperandoB;
    wire [16:0] Soma;

    Adder DUT (
        .Soma(Soma),
        .OperandoA(OperandoA),
        .OperandoB(OperandoB)
    );

    initial begin

        OperandoA = 16'd10;
        OperandoB = 16'd20;
        #10;

        OperandoA = 16'hFFFF;
        OperandoB = 16'd1;
        #10;
		  
        OperandoA = 16'd0;
        OperandoB = 16'd0;
        #10;

        OperandoA = 16'h7FFF;
        OperandoB = 16'h7FFF;
        #20;
        $stop;
    end

endmodule
