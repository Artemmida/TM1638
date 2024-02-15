`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 11:33:12
// Design Name: 
// Module Name: TM1638_TB
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


module TM1638_TB;
logic clk;
logic rst;
logic [0:7] F;
logic [0:7] S;
logic [0:7] T;

logic out_clk_1;
logic strobe;
logic dio;

TM1638 uut (
.clk(clk),
.rst(rst),
.F(F),
.S(S),
.T(T),

.out_clk_1(out_clk_1),
.strobe(strobe),
.dio(dio)
);

initial
begin
	clk = 1'd0;
	F = 8'd218; // abcdefg "2" "1101_1010"
	S = 8'd96; // abcdefg "1" "0110_0000"
	T = 8'd224; // abcdefg "7" "1110_0000"
	rst = 1'd1;
	#5000 rst = 1'd0;
	#5000 rst = 1'd1;
end
always
begin
	#5 clk <= ~clk;
end
endmodule
