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
    logic [7:0] i;
    logic [4:0] j;
	logic [7:0] k;
	
	logic [0:151] MAIN_DATA_BUFF;
	
	enum logic [2:0]
{
    SINGLEWAITT,
    START,
    CMD12,
    MAIN_DATA,
    CMD33,
	WAITT
}
state1, new_state1;  
	logic [2:0] st1;
    
    localparam [0:7] CMD1 = 8'b0000_0010;
    localparam [0:7] CMD2 = 8'b0000_0011;
    localparam [0:7] CMD3 = 8'b1111_0001;
    
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
       MAIN_DATA_BUFF <= {CMD1, CMD2, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, ZERO, 8'd0, F, 8'd0, S, 8'd0, T, 8'd0, CMD3};
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
            new_state1 <= CMD33;
        CMD33:
            if (st1 == 3'd4)         
            new_state1 <= WAITT;
        WAITT:
            if (st1 == 3'd5)          
            new_state1 <= WAITT;
    endcase
end

always_ff @(posedge int_clk_2)
begin
	case (state1)
		SINGLEWAITT:
		begin
            strobe <= 1'd1;
            i <= 8'd0;
            j <= 5'd0;
            out_clk_1 <= 1'd1;
			st1 <= 3'd0;
		end
		START:
		begin
		    strobe <= 1'd0;
            st1 <= 3'd1;
		end    
		CMD12:
		begin 
			if (((i < 8'd16) || ( i > 8'd19)) && (i < 8'd36))
			begin 
				strobe <= 1'd0;
				out_clk_1 <= ~out_clk_1;
				i <= i+8'd1;
			end
			else if (((i > 8'd15) && (i < 8'd20)) || (i == 8'd36))
			begin
				strobe <= 1'd0;
				out_clk_1 <= 1'd1;
				i <= i+8'd1;
				if (i > 8'd16 && i < 8'd19)
					strobe <= 1'd1;
			end
			else
			begin
				strobe <= 1'd0;
				out_clk_1 <= 1'd1;
				st1 <= 3'd2;
				i <= 8'd0;
			end
		end
		MAIN_DATA:
		begin
			if (j < 5'd16)
			begin
				if (i < 8'd16)
				begin
					out_clk_1 <= ~out_clk_1;
					i <= i+8'd1;
				end
				else
				begin
					out_clk_1 <= 1'd1;
					i <= 8'd0;
					j <= j+5'd1;
				end
			end
			else if (j < 5'd18)
			begin
				strobe <= 1'd1;
				out_clk_1 <= 1'd1;
				i <= 8'd0;
				j <= j+5'd1;
			end
			else
			begin
				strobe <= 1'd0;
				out_clk_1 <= 1'd1;
				j <= 5'd0;
				st1 <= 3'd3;
			end
		end
		CMD33:
		begin
			if ((i > 8'd1) && (i < 8'd16))
			begin
				strobe <= 1'd0;
				out_clk_1 <= ~out_clk_1;
				i <= i+8'd1;
			end
			else if ((i == 8'd1) || (i == 8'd16))
			begin
				strobe <= 1'd0;
				out_clk_1 <= 1'd1;
				i <= i+8'd1;
			end
			else if (i == 8'd0)
			begin
				strobe <= 1'd1;
				out_clk_1 <= 1'd1;
				i <= i+8'd1;
			end 
			else
			begin
				strobe <= 1'd1;
				i <= 8'd0;
				st1 <= 3'd4;
			end
		end
	    WAITT:
		begin
			st1 <= 3'd5;
		end
	endcase
end

always_ff @(negedge out_clk_1 or negedge rst)
    if (!rst)
    begin
        dio <= 1'd0;
        k <= 8'd0;
    end
    else
    begin
        dio <= MAIN_DATA_BUFF[k];
        k <= k + 8'd1;
        if (k == 8'd151)
              k <= 8'd0;                        
    end
endmodule
