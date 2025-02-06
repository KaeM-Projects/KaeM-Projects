//--------------------------------------------------
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: licznik rozkazów
// 03.11.2024
//--------------------------------------------------
`include "definy.v"

module program_counter #(parameter pm_addr_width = `pm_addr_width)(
input clk,
input we,
input ce,
input rst,
input wire [pm_addr_width-1:0] data_in,
output reg [pm_addr_width-1:0] data_out
);

always @(posedge clk, negedge rst) begin //asynchronous reset to 0, write for enable "we"signal, counting when "ce" signal enable
  if (!rst) data_out <= 0;
  else if (we) data_out <= data_in;
  else if (ce) data_out <= data_out + 1;  
end


endmodule