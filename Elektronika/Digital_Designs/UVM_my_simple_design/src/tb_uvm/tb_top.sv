`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_top();

  logic clk;
  logic arstn;
  
  dut_if dut_if_inst(.*);
  

  dut dut_inst (
    .clk(clk),
    .arstn(arstn),
    .data_1(dut_if_inst.data_1),
    .data_2(dut_if_inst.data_2),
    .data_out_comb(dut_if_inst.data_out_comb),
    .data_out_sync(dut_if_inst.data_out_sync),
    .cy_comb(dut_if_inst.cy_comb),
    .cy_sync(dut_if_inst.cy_sync)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    arstn = 0;
    #20 arstn = 1;
  end
  
  initial begin
    uvm_config_db#(virtual dut_if)::set(null, "*", "vif", dut_if_inst);
    //run_test("my_test");
    run_test("test_autoseq");
  end
  
endmodule