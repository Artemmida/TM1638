`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2024 14:42:36
// Design Name: 
// Module Name: BCD_TB
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


module BCD_TB;

logic clk;
logic rst;
logic SWITCH1;
logic SWITCH2;
logic SWITCH3;
logic SWITCH4;

logic [11:0] dec_out;
logic [3:0] dec_out1, dec_out10, dec_out100;

BCD uut (
    .clk(clk),
    .rst(rst),
    .SWITCH1(SWITCH1),
    .SWITCH2(SWITCH2),
    .SWITCH3(SWITCH3),
    .SWITCH4(SWITCH4),
    .dec_out(dec_out)
);
assign dec_out1 = dec_out[3:0];
assign dec_out10 = dec_out[7:4];
assign dec_out100 = dec_out[11:8];
initial
begin

clk = 1'd0;
rst = 1'd1;

SWITCH1= 1'd0;
SWITCH2= 1'd0;
SWITCH3= 1'd0;
SWITCH4= 1'd0;

#1 SWITCH1= 1'd1;
#4 rst = 1'd0;
#1 rst = 1'd1;

#95 SWITCH1= 1'd0;
#4 rst = 1'd0;
#1 rst = 1'd1;
#100 SWITCH2= 1'd1;
#100 $finish;
end

always
begin
    #1 clk <= ~clk;
end
endmodule