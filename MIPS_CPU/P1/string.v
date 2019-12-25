`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:49 10/18/2019 
// Design Name: 
// Module Name:    string 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
	
	parameter	s0 = 4'b0001,
				s1 = 4'b0010,
				s2 = 4'b0100,
				s3 = 4'b1000;
				
	reg [3:0] state;
	
	initial begin
		state = 4'b0001;
	end
	
	always @(posedge clk, posedge clr) begin
		if(clr)
			state <= s0;
		else begin
			case(state)
				s0:
				begin
					if(in>=48 && in<=57)
						state <= s1;
					else
						state <= s3;
				end
				s1:
				begin
					if(in==42 || in==43)
						state <= s2;
					else
						state <= s3;
				end
				s2:
				begin
					if(in>=48 && in<=57)
						state <= s1;
					else
						state <= s3;
				end
				s3:
					state <= s3;
				default:
					state <= s0;
			endcase
		end
	end
	
	assign out = state[1];


endmodule
