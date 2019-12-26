`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:35:42 12/18/2019
// Design Name:   mips
// Module Name:   E:/HDL_PROGRAM/p8/test.v
// Project Name:  p8
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk_in;
	reg sys_rstn;
	reg [7:0] dip_switch0;
	reg [7:0] dip_switch1;
	reg [7:0] dip_switch2;
	reg [7:0] dip_switch3;
	reg [7:0] dip_switch4;
	reg [7:0] dip_switch5;
	reg [7:0] dip_switch6;
	reg [7:0] dip_switch7;
	reg [7:0] user_key;
	reg uart_rxd;

	// Outputs
	wire [3:0] digital_tube_sel0;
	wire [3:0] digital_tube_sel1;
	wire digital_tube_sel2;
	wire [7:0] digital_tube0;
	wire [7:0] digital_tube1;
	wire [7:0] digital_tube2;
	wire [31:0] led_light;
	wire uart_txd;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk_in(clk_in), 
		.sys_rstn(sys_rstn), 
		.digital_tube_sel0(digital_tube_sel0), 
		.digital_tube_sel1(digital_tube_sel1), 
		.digital_tube_sel2(digital_tube_sel2), 
		.digital_tube0(digital_tube0), 
		.digital_tube1(digital_tube1), 
		.digital_tube2(digital_tube2), 
		.led_light(led_light), 
		.dip_switch0(dip_switch0), 
		.dip_switch1(dip_switch1), 
		.dip_switch2(dip_switch2), 
		.dip_switch3(dip_switch3), 
		.dip_switch4(dip_switch4), 
		.dip_switch5(dip_switch5), 
		.dip_switch6(dip_switch6), 
		.dip_switch7(dip_switch7), 
		.user_key(user_key), 
		.uart_rxd(uart_rxd), 
		.uart_txd(uart_txd)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		sys_rstn = 1;
		{dip_switch3, dip_switch2, dip_switch1, dip_switch0} = 32'd1;
		{dip_switch7, dip_switch6, dip_switch5, dip_switch4} = 32'd1;
		user_key = 8'b0000_0000;
		uart_rxd = 0;

		// Wait 100 ns for global reset to finish
		#200 sys_rstn = 0;
		#200 user_key = 8'b0000_0001;
        
		// Add stimulus here

	end
	
	always @(*) begin
		if(uut.CPU.ID_UNIT.myGRF.WE)
			$display("@%h:%d <= %h",uut.CPU.WB_UNIT.PC8_WB-32'd8, uut.CPU.ID_UNIT.myGRF.A3, uut.CPU.ID_UNIT.myGRF.WD);
	end
	
	always #50 clk_in = ~clk_in;
      
endmodule

