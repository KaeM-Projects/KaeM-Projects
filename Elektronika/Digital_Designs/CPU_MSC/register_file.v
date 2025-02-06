/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: 
// 21.10.2024
/////////////////////////////////////
`include "definy.v"


module register_file #(parameter data_width = `data_width, parameter regs_No = `regs_number)(
input clk,
input we,
input rst,
input [1:0] reg_addr,       //TODO constant foo call for reg addr width
input signed [data_width-1:0] reg_in,
output reg signed [data_width-1:0] reg_out
);

reg [data_width-1:0] registers [regs_No];

always @(*) begin
  reg_out <= registers[reg_addr]; 
end

always @(posedge clk or negedge rst) begin
    if (!rst) foreach (registers[i]) registers[i] <= {data_width{1'b0}};
    else if (we)  registers[reg_addr] <= reg_in;
end
endmodule