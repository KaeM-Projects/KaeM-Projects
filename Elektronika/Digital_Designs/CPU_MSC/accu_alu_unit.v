`include "definy.v"

module accu_and_alu_unit #(
parameter data_width = `data_width
)(
input clk,
input rst,
input [3:0] opcode,
input acc_ce,
input [7:0] data_in,
output reg [7:0] data_out,
output cy
);


wire cy_alu_accu;
wire [data_width-1:0] allu_to_accu_data;
wire [data_width-1:0] accu_to_alu_data;

assign data_out = accu_to_alu_data;

accu #() accu_inst(
.clk(clk),
.ce(acc_ce),
.rst(rst),
.cy_i(cy_alu_accu),
.cy_o(cy),
.data_in(allu_to_accu_data),
.data_out(accu_to_alu_data)
);


Alu #()alu_inst(
.OP(opcode),
.data_in(data_in),
.cr_in(accu_to_alu_data),
.cy(cy_alu_accu),
.data_out(allu_to_accu_data)
);


endmodule