`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 11:29:47
// Design Name: 
// Module Name: TM1638
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


module TM1638
(
    input logic clk,
	(*mark_debug="true"*) input logic rst,
	input logic [0:7] F,
    input logic [0:7] S,
    input logic [0:7] T,	
	
    (*mark_debug="true"*) output logic out_clk_1,
    (*mark_debug="true"*) output logic strobe,
    (*mark_debug="true"*) output logic dio
);
    (*mark_debug="true"*) logic int_clk_2;
	
    logic [4:0] l; 


    
always_ff @(posedge clk)
begin
    if (!rst)
    begin
        l <= 5'd0;
        int_clk_2 <= 1'b1;
    end
    else
    begin
        if (l < 5'd24) 
            l <= l+5'd1;
        else
        begin
            int_clk_2 <= ~int_clk_2; 
            l <= 5'd0;
        end 
    end 
end




