`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2024 14:32:58
// Design Name: 
// Module Name: top_TB
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


module top_TB;
logic clk;
logic rst;
logic SWITCH1;
logic SWITCH2;
logic SWITCH3;
logic SWITCH4;
logic out_clk_1;
logic strobe;
logic dio;

top uut (
  .clk(clk),
  .rst(rst),
 .SWITCH1(SWITCH1),
 .SWITCH2(SWITCH2),
 .SWITCH3(SWITCH3),
 .SWITCH4(SWITCH4),
 .out_clk_1(out_clk_1),
 .strobe(strobe),
 .dio(dio)
 );
 
initial
begin
	clk = 1'd0;
	SWITCH1 = 1'd1; 
	SWITCH2 = 1'd1;
	SWITCH3 = 1'd1;
	SWITCH4 = 1'd1;
	rst = 1'd1;
	#5000 rst = 1'd0;
	#5000 rst = 1'd1;
end
always
begin
	#5 clk <= ~clk;
end
endmodule
