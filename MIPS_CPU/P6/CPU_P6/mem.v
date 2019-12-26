`ifdef _CTRL_V_
`else
    `include "ctrl.v"
`endif
`include "dm.v"
`include "dmdecode.v"
`include "dmext.v"

module mem(
    input clk, reset,
    input [31:0] Instr_MEM,
    input [31:0] ALUout_MEM, ForwardToDM_WD_MEM,
    output [31:0] DM_RD_MEM
);

    wire [31:0] DM_EXT_Value;
    wire DMWr;
    wire [2:0] DMEXTOp;
    wire [3:0] BE;

    dmdecode myDM_Decode(
        .Instr(Instr_MEM), .byte(ALUout_MEM[1:0]),
        .BE(BE)
    );
    dm myDM(
        .clk(clk), .reset(reset), .WE(DMWr), .BE(BE),
        .addr(ALUout_MEM), .WD(ForwardToDM_WD_MEM), .RD(DM_EXT_Value)
    );
    dmext myDMEXT(
        .Din(DM_EXT_Value), .DMEXTOp(DMEXTOp), .byte(ALUout_MEM[1:0]),
        .Dout(DM_RD_MEM)
    );
    ctrl MEM_Ctrl(
        .Instr(Instr_MEM),
        .DMWr(DMWr), .DMEXTOp(DMEXTOp)
    );

endmodule // mem