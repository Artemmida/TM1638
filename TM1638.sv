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
    input logic clk, // input clock 100 MHz
	(*mark_debug="true"*) input logic rst, // reset
	input logic [0:7] F, // abcdefg "First value"
    input logic [0:7] S, // abcdefg "Second value"
    input logic [0:7] T, // abcdefg "Third value"	
	
    (*mark_debug="true"*) output logic out_clk_1, // clock 1 MHz
    (*mark_debug="true"*) output logic strobe, // strobe signal
    (*mark_debug="true"*) output logic dio // data input-output signals
);
    (*mark_debug="true"*) logic int_clk_2; // internal clock 2 MHz
	
    logic [4:0] l; // counter for creating 2 MHz int_clk_2
    logic [7:0] i; // counter for creating 1 MHz out_clk_1
    logic [4:0] j; // additional counter for creating 1 MHz out_clk_1
	logic [7:0] k; // counter for dio signals
	
	logic [0:151] MAIN_DATA_BUFF; // stores all data with cmds and main data
	
	enum logic [2:0] // State machine
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
    
    localparam [0:7] CMD1 = 8'b0000_0010; // first command for writing data with auto increasing address mode 
    localparam [0:7] CMD2 = 8'b0000_0011; // second command for starting from 0 address
    localparam [0:7] CMD3 = 8'b1111_0001; // last command for displaing data
    
    localparam [0:7] ZERO = 8'b1111_1100; // abcdefg "0"

// arty has rst=1 as default => negedge rst
    
always_ff @(posedge clk) // creating 2 MHz int_clk_2 from 100 MHz clk 
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
        else //every 25th tact of posedge clk switching int_clk_2 => 100->2 MHz
        begin
            int_clk_2 <= ~int_clk_2; 
            l <= 5'd0;
        end 
    end 
end


always_ff @(posedge int_clk_2 or negedge rst) //resetig state machine with reset and swithing by posedge int_clk_2
    if (!rst)
        state1 <= SINGLEWAITT;
    else
        state1 <= new_state1;

always_comb //inicialization of state machine's data
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

always_ff @(posedge int_clk_2) // the sequence of switging states
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

always_ff @(posedge int_clk_2) // forming strobe signal and 1 MHz out_clk_1  
begin
	case (state1)
		SINGLEWAITT: // initial state? setting parametrs 
		begin
            strobe <= 1'd1;
            i <= 8'd0;
            j <= 5'd0;
            out_clk_1 <= 1'd1;
			st1 <= 3'd0;
		end
		START: // for delay between negedge strobe and negedge out_clk_1
		begin
		    strobe <= 1'd0;
            st1 <= 3'd1;
		end    
		CMD12: // clk for cmd_1 and cmd_2
		begin 
			if (((i < 8'd16) || ( i > 8'd19)) && (i < 8'd36))
			begin 
				strobe <= 1'd0;
				out_clk_1 <= ~out_clk_1; // creating 1 MHz out_clk_1 from 2 MHz int_clk_2 
				i <= i+8'd1;
			end
			else if (((i > 8'd15) && (i < 8'd20)) || (i == 8'd36))
			begin
				strobe <= 1'd0;
				out_clk_1 <= 1'd1;
				i <= i+8'd1;
				if (i > 8'd16 && i < 8'd19) // for delay between first command and strobe signal
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
		MAIN_DATA: // clk for main_data_buff
		begin
			if (j < 5'd16) // for delay between 8-bit data in main_data_buff
			begin
				if (i < 8'd16) // clk for bits in 8-bit data
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
		CMD33: // clk for cmd_3
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
	    WAITT: // waiting state
		begin
			st1 <= 3'd5;
		end
	endcase
end

// 7 reads date by posedge out_clk_1 so we need to preset data by negedge out_clk
always_ff @(negedge out_clk_1 or negedge rst) //  sending data to 7 according to state and out_clk_1
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


