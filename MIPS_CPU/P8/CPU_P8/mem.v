`ifdef _DEFINES_V_
`else
    `include "defines.v"
`endif

module mem(
    input clk, clk_dm, reset, flush,
    input Overflow_MEM,
    input [31:0] Instr_MEM,
    input [31:0] ALUout_MEM, ForwardToDM_WD_MEM, PrRD,
    output DMWr_MEM, CP0_Wr_MEM, isEret_MEM,
    output [3:0] BE_MEM,
    output [31:0] DM_RD_MEM, DM_WD_MEM,
    input [4:0] ExcCode_in,
    output [4:0] ExcCode_out
);

    wire [31:0] DM_EXT_Value, DM_RD_out, DM_WD_in;
    wire DMWr, isStore_MEM, isLoad_MEM;
    wire [2:0] DMEXTOp;
    wire [3:0] BE;
    wire CS_DM, CS_Timer, CS_UART, CS_Switch, CS_LED, CS_Digital, CS_Key, Exception, CS_Outer;

    assign CS_DM		= (ALUout_MEM[31:12]==20'h0000_0 || ALUout_MEM[31:12]==20'h0000_1)  ? 1'b1 : 1'b0;
    assign CS_Timer 	= (ALUout_MEM >= 32'h0000_7f00 && ALUout_MEM <= 32'h0000_7f0b)	? 1'b1 : 1'b0;
	assign CS_UART      = (ALUout_MEM >= 32'h0000_7f10 && ALUout_MEM <= 32'h0000_7f2b) ? 1'b1 : 1'b0;
    assign CS_Switch    = (ALUout_MEM >= 32'h0000_7f2c && ALUout_MEM <= 32'h0000_7f33) ? 1'b1 : 1'b0;
    assign CS_LED       = (ALUout_MEM >= 32'h0000_7f34 && ALUout_MEM <= 32'h0000_7f37) ? 1'b1 : 1'b0;
    assign CS_Digital   = (ALUout_MEM >= 32'h0000_7f38 && ALUout_MEM <= 32'h0000_7f3f) ? 1'b1 : 1'b0;
    assign CS_Key       = (ALUout_MEM >= 32'h0000_7f40 && ALUout_MEM <= 32'h0000_7f43) ? 1'b1 : 1'b0;
	assign CS_Outer		= CS_Timer|CS_UART|CS_Switch|CS_LED|CS_Digital|CS_Key;
    assign Exception = (ExcCode_in==5'd0) ? 1'b0 : 1'b1;
    assign DMWr_MEM = DMWr & ~flush;
    assign BE_MEM = BE;
    assign DM_EXT_Value = (CS_DM) ? DM_RD_out : PrRD;
    assign ExcCode_out =   ((isLoad_MEM && (Overflow_MEM||(!CS_DM&&!CS_Outer))) ||
                            (DMEXTOp==`LW_EXT && ALUout_MEM[1:0]!=2'b00) ||
                            ((DMEXTOp==`LH_EXT||DMEXTOp==`LHU_EXT) && (ALUout_MEM[0]!=1'b0||CS_Outer)) ||
                            ((DMEXTOp==`LB_EXT||DMEXTOp==`LBU_EXT) && CS_Outer))                    ?   5'd4 :
                           ((isStore_MEM && (Overflow_MEM||(!CS_DM&&!CS_Outer)||(CS_Timer&&ALUout_MEM[3:0]==4'h8))) ||
                            (BE==4'b1111 && ALUout_MEM[1:0]!=2'b00) ||
                            ((BE==4'b0011||BE==4'b1100) && (ALUout_MEM[0]!=1'b0||CS_Outer))    ||
                            ((BE==4'b0001||BE==4'b0010||BE==4'b0100||BE==4'b1000) && CS_Outer))     ?   5'd5 :
                                                                                                    ExcCode_in;
	assign DM_WD_MEM = DM_WD_in;

    dmdecode myDM_Decode(
        .Instr(Instr_MEM), .addr_byte(ALUout_MEM[1:0]),
		.Din(ForwardToDM_WD_MEM), .Dout(DM_WD_in),
        .BE(BE)
    );
    dm myDM(
        .clk(clk_dm), .reset(reset), .WE(DMWr & CS_DM & ~flush), .BE(BE),
        .addr(ALUout_MEM), .WD(DM_WD_in), .RD(DM_RD_out)
    );
    dmext myDMEXT(
        .Din(DM_EXT_Value), .DMEXTOp(DMEXTOp), .addr_byte(ALUout_MEM[1:0]),
        .Dout(DM_RD_MEM)
    );
    ctrl MEM_Ctrl(
        .Instr(Instr_MEM & {32{~Exception}}),
        .DMWr(DMWr), .DMEXTOp(DMEXTOp), .CP0_Wr(CP0_Wr_MEM), .isEret(isEret_MEM), .isStore(isStore_MEM), .isLoad(isLoad_MEM)
    );

endmodule // mem