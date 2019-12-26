module im(
	input clk,
    input [31:0] addr,
    output [31:0] Instr
);
	
	wire [31:0] Addr_offset;
	
	assign Addr_offset = addr - 32'h0000_3000;

	DRAM_IM Bram_Im (
	  .clka(clk), // input clka
	  .wea(4'b0000), // input [3 : 0] wea
	  .addra(Addr_offset[12:2]), // input [10 : 0] addra
	  .dina(32'd0), // input [31 : 0] dina
	  .douta(Instr) // output [31 : 0] douta
);

endmodule // im