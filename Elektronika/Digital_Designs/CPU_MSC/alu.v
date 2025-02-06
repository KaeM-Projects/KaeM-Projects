/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: ALU
// 21.10.2024
/////////////////////////////////////
`include "definy.v"

module Alu #(
parameter data_width = `data_width ,
parameter op_code_width = `op_code_width
)(
input [op_code_width-1:0] OP, //operation code
input signed [data_width-1:0] data_in,  //input data
input signed [data_width-1:0] cr_in,    //input data from currenbt result register
output reg cy,  //carry-out value, 1'b1 if result exceeds 127 or -128.
output reg signed [data_width-1:0] data_out //output data.
);

always @(*) begin     //alu operations
  case(OP)
	 `LD  : begin data_out <= data_in; cy <= 0; end    
	 `ADD : begin data_out <= cr_in + data_in; cy <= ((cr_in + data_in) > 127) || ((cr_in + data_in) < -127) ? 1'b1 : 1'b0;end
	 `SUB : begin data_out <= cr_in - data_in; cy <= ((cr_in - data_in) < -127) || ((cr_in - data_in) > 127) ? 1'b1 : 1'b0;end
	 `AND : begin data_out <= data_in & cr_in; cy <= 0; end
	 `OR  : begin data_out <= data_in | cr_in; cy <= 0; end
   `XOR : begin data_out <= data_in ^ cr_in; cy <= 0; end
   `NOT : begin data_out <= ~ data_in; cy <= 0; end
	 `NOP : data_out <= {data_width{1'bx}};
	 default : {cy, data_out} <= {data_width+1{1'b0}};
  endcase

end
endmodule