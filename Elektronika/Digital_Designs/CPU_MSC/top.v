/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: tb_top
// 21.10.2024
/////////////////////////////////////


module top;
reg clk;
reg rst;

initial begin
  clk = 1;
  rst = 0;
  #10
  rst = 1;
  //#1000 $finish;
end

always @(posedge clk) if (cpu_inst.pc_inst.data_out == 12'hFFF) $finish;


always #5 clk = ~clk;


cpu_top #() cpu_inst(
.clk(clk),
.rst(rst)
);


endmodule