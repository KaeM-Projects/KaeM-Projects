`timescale 1s / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2023 13:54:06
// Design Name: 
// Module Name: presc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module presc_tb(    );
reg CLK;
wire C_CLK;
reg [3:0] tmp = 0;


    prescaler pres_1(
                     .CLK   (CLK),
                     .C_CLK (C_CLK)
                     );
                     
    initial CLK = 1'b0;
    always #1 CLK = ~CLK;
    
    always @(posedge C_CLK) begin
        tmp = tmp+1;
        if (tmp == 4) $stop;
    
    end
    
    initial
	$monitor($time, " Output CLK = %d, C_CLK = %d",  CLK, C_CLK);
endmodule
