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
	
	logic [0:151] MAIN_DATA_BUFF;
	
	enum logic [2:0]
{
    SINGLEWAITT,
    START,
    CMD12,
    MAIN_DATA,
    CMD3,
	WAITT
}
state1, new_state1;  
	logic [2:0] st1;
    
    localparam [0:7] CMD_1 = 8'b0000_0010;
    localparam [0:7] CMD_2 = 8'b0000_0011;
    localparam [0:7] CMD_3 = 8'b1111_0001;
    
    localparam [0:7] ZERO = 8'b1111_1100;

    
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


always_ff @(posedge int_clk_2 or negedge rst)
    if (!rst)
        state1 <= SINGLEWAITT;
    else
        state1 <= new_state1;

always_comb
begin
    if (!rst)
    begin
        MAIN_DATA_BUFF <= 152'b0;
    end
    else
    begin
       MAIN_DATA_BUFF <= {CMD_1, CMD_2, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, F, 8'd0, S, 8'd0, T, 8'd0, CMD_3};
	end
end

always_ff @(posedge int_clk_2)
begin
    case(state1)
        SINGLEWAITT:
					new_state1 <= START;
        START:
            if (st1 == 3'd1)         
            new_state1 <= CMD12;
        CMD12:
            if (st1 == 3'd2)         
            new_state1 <= MAIN_DATA;
        MAIN_DATA:
            if (st1 == 3'd3)        
            new_state1 <= CMD3;
        CMD3:
            if (st1 == 3'd4)         
            new_state1 <= WAITT;
        WAITT:
            if (st1 == 3'd5)          
            new_state1 <= WAITT;
    endcase
end
