/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: Data MEMORY
// 21.10.2024
/////////////////////////////////////
`include "definy.v"

module data_memory #(parameter ADDRESS_WIDTH = `dm_addr_width, parameter DATA_WIDTH = `data_width)(
input clk,
input wr,
input [ADDRESS_WIDTH-1:0] address,
input signed [DATA_WIDTH-1:0] data_in,
output reg signed [DATA_WIDTH-1:0] data_out
);
reg signed [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH];

always @(*) data_out <= mem[address];

always @(posedge clk) if(wr) mem[address] = data_in;


reg [DATA_WIDTH-1:0] dm_data [] =  // write data for simulation purposes. TODO: implementation of hardware programming (and program memory too) by external device
`include "data_mem_file.v";
initial begin
  foreach (dm_data[i]) begin
    mem[i] = dm_data[i];
  end
  $display("Data memory initialized");
end


endmodule