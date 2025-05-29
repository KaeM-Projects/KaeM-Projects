//UVM cwiczenia
//1. DUT


module dut(
input clk,
input arstn,
input [7:0] data_1,
input [7:0] data_2,
output reg [7:0] data_out_comb,
output reg [7:0] data_out_sync,
output reg cy_comb,
output reg cy_sync
);


always_comb begin
  if(!arstn) begin
      data_out_comb <= 8'h0;
      cy_comb <= 1'b0;
    end
  else begin
      {cy_comb,data_out_comb} <= data_1 + data_2;
  end
end


always_ff @(posedge clk or negedge arstn) begin

  if(!arstn) begin
      data_out_sync <= 8'h0;
      cy_sync <= 1'b0;
    end
  else begin
      {cy_sync,data_out_sync} <= data_1 + data_2;
  end

end


endmodule
