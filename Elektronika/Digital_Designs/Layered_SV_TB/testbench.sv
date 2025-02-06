
`timescale 1ps/1ps

module testbench_top;
  bit clk;
  bit aresetn;
  
  reg [7:0] data_out;
  always #5 clk = ~clk;
  

  initial
  begin
 	 clk = 0;
	  aresetn = 0;
    #7 aresetn = 1;
  end
  
  alu_acc_unit_intf intf(clk, aresetn);

  test test1(intf);
  
	alu_accu_unit uut(
    .clk(intf.clk), 
    .nReset(intf.aresetn),
    .data_in(intf.data_in),
    .alu_code(intf.alu_code),
    .co(intf.co),
    .ci(intf.ci),
    .ce(intf.ce),
    .data_out(intf.data_out)
  );

endmodule
