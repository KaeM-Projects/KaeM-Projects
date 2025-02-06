`include "ALU.sv"
`include "DffPIPO_CE_SET.sv"


module alu_accu_unit(
input clk, 
input nReset,
input [7:0] data_in,
input [2:0] alu_code,
input ci,
input ce,
output reg co,
output reg [7:0] data_out
);  


wire [2:0] ID_ALUCode; 
wire ID_Carry_CE;
wire ID_Accu_CE;

wire [7:0] Accu_out;
wire [7:0] ALU_2_Accu;
wire ALU_Co;

assign data_out = Accu_out;

//============================================================================
//++++++++++++++++++++++++++++++++++ MODULES +++++++++++++++++++++++++++++++++
//============================================================================

//ALU
ALU ALU_1(
.ALUCode(alu_code), // done
.DataIn(data_in),    //done
.AccuIn(Accu_out),
.Ci(ci), 
.Co(ALU_Co), //outputs
.DataOut(ALU_2_Accu)
);

//CARRY
DffPIPO_CE_SET #(.SIZE(1)) RegCY(
.CE(ce), //inputs
.D(ALU_Co),
.clk(clk),
.nReset(nReset),
.Q(co) //output
);

//ACCUMULATOR
DffPIPO_CE_SET A(
.CE(ce), //inputs
.D(ALU_2_Accu),
.clk(clk),
.nReset(nReset),
.Q(Accu_out) //output
);

endmodule