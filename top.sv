`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2024 13:55:28
// Design Name: 
// Module Name: top
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

module top( input logic clk,
            input logic rst, 
            input logic SWITCH1, 
            input logic SWITCH2, 
            input logic SWITCH3, 
            input logic SWITCH4,
            output logic out_clk_1,
            output logic strobe,
            output logic dio
            );


logic [11:0] dec_out;
logic [7:0] F; // abcdefg "First value"
logic [7:0] S; // abcdefg "Second value"
logic [7:0] T; // abcdefg "Third value"	
	
BCD uut1 (.clk(clk), .rst(rst), .SWITCH1(SWITCH1), .SWITCH2(SWITCH2), .SWITCH3(SWITCH3),.SWITCH4(SWITCH4), .dec_out(dec_out));

translator uut2 (.in(dec_out[3:0]), .out(T));
translator uut3 (.in(dec_out[7:4]), .out(S));
translator uut4 (.in(dec_out[11:8]), .out(F));

TM1638 uut5 (.clk(clk), .rst(rst), .F(F), .S(S), .T(T), .out_clk_1(out_clk_1), .strobe(strobe), .dio(dio)); 

endmodule