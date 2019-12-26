module mips(
    input clk_in,
    input sys_rstn,
    output [3:0] digital_tube_sel0, digital_tube_sel1,
    output digital_tube_sel2,
    output [7:0] digital_tube0, digital_tube1, digital_tube2,
    output [31:0] led_light,
    input [7:0] dip_switch0, dip_switch1, dip_switch2, dip_switch3, dip_switch4, dip_switch5, dip_switch6, dip_switch7,
    input [7:0] user_key,
    input uart_rxd,
    output uart_txd
);

    wire [31:0] PrAddr, PrWD, PrRD, DEV_Addr, DEV_WD, 
                DEV_Timer_RD, DEV_Digital_RD, DEV_LED_RD, DEV_Switch_RD, DEV_Key_RD, DEV_UART_RD;
    wire [7:2] HWInt;
    wire [3:0] PrBE, DEV_BE;
    wire    PrWE, DEV_WE,
            INT_Timer, INT_UART, INT_Key, INT_Switch,
			CLK_OUT1, CLK_OUT2;

    cpu CPU(
        .clk(CLK_OUT1), .reset(~sys_rstn), .clk_for_bram(CLK_OUT2),
        .PrAddr(PrAddr), .PrBE(PrBE), .PrWE(PrWE), .PrWD(PrWD),
        .PrRD(PrRD), .HWInt(HWInt)
    );
	CLOCK CLK(
		// Clock in ports
		.CLK_IN1(clk_in),      // IN
		// Clock out ports
		.CLK_OUT1(CLK_OUT1),     // OUT
		.CLK_OUT2(CLK_OUT2)
	);    // OUT
    bridge BRIDGE(
        .PrAddr(PrAddr), .PrBE(PrBE), .PrWE(PrWE), .PrWD(PrWD),
        .PrRD(PrRD), .HWInt(HWInt),
        .DEV_Timer_RD(DEV_Timer_RD), .DEV_Digital_RD(DEV_Digital_RD), .DEV_LED_RD(DEV_LED_RD), 
        .DEV_Switch_RD(DEV_Switch_RD), .DEV_Key_RD(DEV_Key_RD), .DEV_UART_RD(DEV_UART_RD),
        .INT_Timer(INT_Timer), .INT_UART(INT_UART), .INT_Key(INT_Key), .INT_Switch(INT_Switch),
        .DEV_Addr(DEV_Addr), .DEV_WD(DEV_WD), .DEV_WE(DEV_WE), .DEV_BE(DEV_BE)
    );

    //---------------Outer Devices--------------
    TC TIMER(
        .clk(CLK_OUT1), .reset(~sys_rstn), .WE(DEV_WE),
        .Addr(DEV_Addr), .Din(DEV_WD), .Dout(DEV_Timer_RD), 
        .IRQ(INT_Timer)
    );
    digital_driver myDigital(
        .clk(CLK_OUT1), .reset(~sys_rstn), .WE(DEV_WE), .BE(DEV_BE),
        .Addr(DEV_Addr), .Din(DEV_WD), .Dout(DEV_Digital_RD),
        .digital_tube_sel0(digital_tube_sel0), .digital_tube_sel1(digital_tube_sel1), .digital_tube_sel2(digital_tube_sel2),
        .digital_tube0(digital_tube0), .digital_tube1(digital_tube1), .digital_tube2(digital_tube2)
    );
    led_driver myLED(
        .clk(CLK_OUT1), .reset(~sys_rstn), .WE(DEV_WE), .BE(DEV_BE),
        .Addr(DEV_Addr), .Din(DEV_WD), .Dout(DEV_LED_RD),
        .led_light(led_light)
    );
    switch_driver mySwitch(
        .clk(CLK_OUT1), .reset(~sys_rstn),
        .Addr(DEV_Addr), .Dout(DEV_Switch_RD), .INT_Switch(INT_Switch),
        .dip_switch0(dip_switch0), .dip_switch1(dip_switch1), .dip_switch2(dip_switch2), .dip_switch3(dip_switch3),
        .dip_switch4(dip_switch4), .dip_switch5(dip_switch5), .dip_switch6(dip_switch6), .dip_switch7(dip_switch7)
    );
    key_driver myKey(
        .clk(CLK_OUT1), .reset(~sys_rstn),
        .Addr(DEV_Addr), .Dout(DEV_Key_RD), .INT_Key(INT_Key),
        .user_key(user_key)
    );
    uart_driver myUART(
        .clk(CLK_OUT1), .reset(~sys_rstn), .WE(DEV_WE), .BE(DEV_BE),
        .Addr(DEV_Addr), .Din(DEV_WD), .Dout(DEV_UART_RD),
        .uart_rxd(uart_rxd), .uart_txd(uart_txd), .INT_UART(INT_UART)
    );

endmodule // mips
