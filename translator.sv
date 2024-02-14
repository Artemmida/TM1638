`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 15:26:11
// Design Name: 
// Module Name: translator
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

module translator(

    input logic [3:0] inputt,
    output logic [7:0] outputt
);
    
always_comb
begin
case (input)
    4'd0: outputt = 8'b1111_1100;
    4'd1: outputt = 8'b0110_0000;
    4'd2: outputt = 8'b1101_1010;
    4'd3: outputt = 8'b1111_0010;
    4'd4: outputt = 8'b0110_0110;
    4'd5: outputt = 8'b1011_0110;
    4'd6: outputt = 8'b1011_1110;
    4'd7: outputt = 8'b1110_0000;
    4'd8: outputt = 8'b1111_1110;
    4'd9: outputt = 8'b1111_0110;
    default: outputt = 8'b0000_0001;
endcase
end
endmodule
