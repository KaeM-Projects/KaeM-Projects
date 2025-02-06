/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: program memory
// 21.10.2024
/////////////////////////////////////

`include "definy.v"

module program_memory #(parameter ADDRESS_WIDTH = `pm_addr_width, parameter DATA_WIDTH = `instruction_width)(
input clk,
input [ADDRESS_WIDTH-1:0] address,
output reg [DATA_WIDTH-1:0] data_out
);
reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH];

always @(*) begin                
   data_out <= mem[address];
end


`define USE_INSTRUCTIONS
`include "definy.v"
reg [DATA_WIDTH-1:0] program_data [] =   // write program data for simulation purposes. TODO: implementation of hardware programming (and data memory too) by external device
{`include "program_file.v"};
initial begin
  foreach (program_data[i]) begin
    mem[i] = program_data[i];
     $display("mem[%0.d]: %h",i,mem[i]);
  end
  $display("Program memory initialized");
end
`undef USE_INSTRUCTIONS




endmodule