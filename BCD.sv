`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 11:27:31
// Design Name: 
// Module Name: BCD
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
module BCD
(
    input logic clk,
    input logic rst,
    input logic SWITCH_BCD1,
    input logic SWITCH_BCD2,
    input logic SWITCH_BCD3,
    input logic SWITCH_BCD4,
    output logic [11:0] dec_out
);
    logic [7:0] bin_in;
    logic [7:0] bin;
    logic [2:0] state;
    logic [3:0] i;
    logic [11:0] bcd;
    
    localparam RESET = 3'd0;
    localparam START = 3'd1;
    localparam SHIFT = 3'd2;
    localparam ADD = 3'd3;
    localparam FINISH = 3'd4;
    localparam WAITT = 3'd5;
    
    
always_ff @(posedge clk)
begin
    if (SWITCH_BCD1) // to set the first value 
    begin
        bin_in <= 8'd243;
    end
    else if (SWITCH_BCD2) // to set the second value 
    begin
        bin_in <= 8'd5;
    end
    else if (SWITCH_BCD3) // to set the third value 
    begin
        bin_in <= 8'd76;
    end
    else if (SWITCH_BCD4) // to set the fourth value 
    begin
        bin_in <= 8'd198;
    end
    else // to set the default value 
    begin
        bin_in <= 8'd0;
    end
end
    
    
always_ff @ (posedge clk)
    if (!rst)
        state <= RESET;
    else
    begin
        case (state)
        RESET:
        begin
            i <= 'd0;
            bcd <= 'd0;
            bin <= 'd0;
            dec_out <= 'd0;
            state <= START;
        end
        START:
        begin
            bcd <= 'd0;
            bin <= bin_in;
            state <= SHIFT;
        end
        SHIFT:
        begin
            bin <= {bin [6:0], 1'd0};
            bcd <= {bcd [10:0], bin[7]};
            i <= i + 4'd1;
            if (i == 4'd7)
                state <= FINISH;
            else
                state <= ADD;
        end
        ADD:
        begin
            if (bcd[3:0] > 'd4)
            begin
                bcd[3:0] <= bcd[3:0] + 4'd3;
            end
            if (bcd[7:4] > 'd4)
            begin
                bcd[7:4] <= bcd[7:4] + 4'd3;
            end
            if (bcd[11:8] > 'd4)
            begin
                bcd[11:8] <= bcd[11:8] + 4'd3;
            end
            state <= SHIFT;
        end
        FINISH:
        begin
            i <= 4'd0;
            dec_out <= bcd;
            state <= WAITT;
        end
        WAITT:
        begin
            state <= WAITT;
        end
        default:
            state <= WAITT;
        endcase
    end
endmodule