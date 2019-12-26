module dm(
    input clk,
    input reset,
    input WE,
    input [3:0] BE,
    input [31:0] addr,
    input [31:0] WD,
    output [31:0] RD
);
	
	BRAM_DM Bram_Dm (
	  .clka(clk), // input clka
	  .rsta(reset), // input rsta
	  .ena(1'b1), // input ena
	  .wea(BE & {4{WE}}), // input [3 : 0] wea
	  .addra(addr[12:2]), // input [10 : 0] addra
	  .dina(WD), // input [31 : 0] dina
	  .douta(RD) // output [31 : 0] douta
);

endmodule // dm