module bridge(
    input [31:0] PrAddr,
    input [31:0] PrWD,
    input [3:0] PrBE,
    input PrWE,
    input INT_Timer, INT_UART, INT_Switch, INT_Key,
    input [31:0] DEV_Timer_RD, DEV_Digital_RD, DEV_LED_RD, DEV_Switch_RD, DEV_Key_RD, DEV_UART_RD,
    output [31:0] PrRD,
    output [31:0] DEV_Addr,
    output [31:0] DEV_WD,
    output [7:2] HWInt,
    output DEV_WE,
    output [3:0] DEV_BE
);

    wire CS_Timer, CS_UART, CS_Switch, CS_Key;

    assign CS_Timer     = (PrAddr >= 32'h0000_7f00 && PrAddr <= 32'h0000_7f0b) ? 1'b1 : 1'b0;
    assign CS_UART      = (PrAddr >= 32'h0000_7f10 && PrAddr <= 32'h0000_7f2b) ? 1'b1 : 1'b0;
    assign CS_Switch    = (PrAddr >= 32'h0000_7f2c && PrAddr <= 32'h0000_7f33) ? 1'b1 : 1'b0;
    assign CS_LED       = (PrAddr >= 32'h0000_7f34 && PrAddr <= 32'h0000_7f37) ? 1'b1 : 1'b0;
    assign CS_Digital   = (PrAddr >= 32'h0000_7f38 && PrAddr <= 32'h0000_7f3f) ? 1'b1 : 1'b0;
    assign CS_Key       = (PrAddr >= 32'h0000_7f40 && PrAddr <= 32'h0000_7f43) ? 1'b1 : 1'b0;

    assign DEV_WE = PrWE;
    assign DEV_BE = PrBE;

    assign DEV_Addr = PrAddr;
    assign DEV_WD = PrWD;
    assign PrRD =   (CS_Timer)  ?   DEV_Timer_RD    :
                    (CS_Digital)?   DEV_Digital_RD  :
                    (CS_LED)    ?   DEV_LED_RD      :
                    (CS_Switch) ?   DEV_Switch_RD   :
                    (CS_Key)    ?   DEV_Key_RD      :
                    (CS_UART)   ?   DEV_UART_RD     :
                                    32'hxxxx_xxxx;
    
    assign HWInt = {2'b00, CS_Switch, INT_Key, INT_UART, INT_Timer};

endmodule // bridge