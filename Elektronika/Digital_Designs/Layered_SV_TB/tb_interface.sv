//----------------------------------------------------------
interface alu_acc_unit_intf(
  input logic clk,
  input logic aresetn
);

  logic [7:0]  data_in;    
  logic [7:0]  data_out;  
  logic        co;
  logic        ci;
  logic        ce;
  logic [2:0]  alu_code;

  
  //driver clocking block
  clocking driver_clk_block @(posedge clk);
    default input #1 output #1;
    output data_in;
    output alu_code;
    output ci;
    output ce;
    input  data_out; 
    input  co;
  endclocking
  
  //monitor clocking block
  clocking monitor_clk_block @(posedge clk);
    default input #1 output #1;
    input  data_in;
    input  alu_code;
    input  data_out; 
    input  co;
    input  ci;
    input  ce;
  endclocking
  
  //driver modport
  modport driver_mode (
    clocking driver_clk_block, 
    input clk, 
    input aresetn
  );
  
  //monitor modport  
  modport monitor_mode (
    clocking monitor_clk_block,
    input clk,
    input aresetn
  );
  
endinterface
