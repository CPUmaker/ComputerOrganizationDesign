`define SB 6'b101_000
`define SH 6'b101_001
`define SW 6'b101_011


module dmdecode(
    input [31:0] Instr,
    input [1:0] addr_byte,
	input [31:0] Din,
	output reg [31:0] Dout,
    output reg [3:0] BE
);

    always @(*) begin
        case (Instr[31:26])
            `SB: begin
				Dout = {Din[7:0], Din[7:0], Din[7:0], Din[7:0]};
                case (addr_byte)
                    2'b00:  BE = 4'b0001;
                    2'b01:  BE = 4'b0010;
                    2'b10:  BE = 4'b0100;
                    2'b11:  BE = 4'b1000;
                    default:BE = 4'b0000;
                endcase
            end
            `SH: begin
				Dout = {Din[15:0], Din[15:0]};
                case (addr_byte[1])
                    1'b0:   BE = 4'b0011;
                    1'b1:   BE = 4'b1100;
                    default:BE = 4'b0000;
                endcase
            end
            `SW: begin
				Dout = Din;
							BE = 4'b1111;
			end
            default: begin
				Dout = 32'hxxxx_xxxx;
							BE = 4'b0000;
			end
        endcase
    end 

endmodule // dmdecode