`include "uart.v"

module uart_driver(
    input clk,
    input reset,
    input WE,
    input [3:0] BE,
    input [31:0] Addr,
    input [31:0] Din,
    output [31:0] Dout,
    output INT_UART,
    input uart_rxd,
    output uart_txd
);

    wire [31:0] offset;
    wire CS_UART, STB;

    assign offset = Addr - 32'h0000_7f10;
    assign CS_UART = (Addr >= 32'h0000_7f10 && Addr <= 32'h0000_7f2b) ? 1'b1 : 1'b0;
    assign STB = CS_UART;
//
    MiniUART U_MiniUART(
		.ADD_I(offset[4:2]), .DAT_I(Din), .DAT_O(Dout), .STB_I(STB),
		.WE_I(WE), .CLK_I(clk), .RST_I(reset), .RxD(uart_rxd), .TxD(uart_txd), .RS_O(INT_UART)
	);

endmodule // uart_driver