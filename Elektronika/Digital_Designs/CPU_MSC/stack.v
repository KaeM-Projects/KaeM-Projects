/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: Stos
// 11.11.2024
/////////////////////////////////////

`include "definy.v"

module stack#(
parameter data_width = `data_width,
parameter size = `stack_size)
(
input clk,
input rst,
input [data_width-1:0] stack_data_in,
input pop_signal,
input push_signal,
output reg [data_width-1:0] stack_data_out,
output reg stack_full
);

function integer calc_ptr_word_width();
  return $ceil($sqrt(real'(size)));  
endfunction

localparam ptr_word_size = calc_ptr_word_width();

reg [ptr_word_size-1:0] pointer;
reg [data_width-1:0] mem[size];
assign stack_full = (pointer == size); 
assign stack_data_out = mem[pointer?pointer-1:0];

always @(posedge clk, negedge rst) begin
  if(!rst) begin
    pointer <= 0;
  end
  else begin
    if(push_signal && !pop_signal && !stack_full)begin
      mem[pointer] <= stack_data_in;
      if (pointer < size) pointer <= pointer + 1;
    end
    else if (pop_signal && !push_signal && (pointer > 0)) begin
      if (pointer != 0 ) pointer <= pointer - 1;    
    end
  end
end


endmodule