//UVM cwiczenia
//1. interface


interface dut_if(
input clk,
input arstn
);
logic [7:0] data_1;
logic [7:0] data_2;
logic [7:0] data_out_comb;
logic [7:0] data_out_sync;
logic cy_comb;
logic cy_sync;

modport driver ( //modport for uvm driver
  input clk,
  input arstn,
  output data_1,
  output data_2,
  input data_out_comb,
  input data_out_sync,
  input cy_comb,
  input cy_sync
);

modport monitor(  //modport for uvm monitor
  input clk,
  input arstn,
  input data_1,
  input data_2,
  input data_out_comb,
  input data_out_sync,
  input cy_comb,
  input cy_sync
);

endinterface