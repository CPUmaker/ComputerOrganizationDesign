`ifdef _CTRL_V_
`else
    `include "ctrl.v"
`endif

`include "grf.v"
`include "npc.v"
`include "ext.v"
`include "cmp.v"

module id(
    input clk, reset, RFWr_WB,
    input [31:0] Instr_ID,
    input [31:0] ForwardRD1_ID, ForwardRD2_ID, RegWriteData_WB, PC_ID,
    input [4:0] RegA3_WB,
    output [1:0] NPCOp_ID,
    output [31:0] npcValue_ID, RegData1_ID, RegData2_ID, ImmEXT_ID
);

    wire equal;
    wire [1:0] EXTOp_ID;
    grf myGRF(
        .clk(clk), .reset(reset), .WE(RFWr_WB),
        .A1(Instr_ID[25:21]), .A2(Instr_ID[20:16]), .A3(RegA3_WB),
        .WD(RegWriteData_WB), .RD1(RegData1_ID), .RD2(RegData2_ID)
    );
    npc myNPC(.pc(PC_ID), .Imm(Instr_ID[25:0]), .ra(ForwardRD1_ID), .NPCOp(NPCOp_ID), .npc(npcValue_ID));
    ext myEXT(.EXTOp(EXTOp_ID), .Imm(Instr_ID[15:0]), .out(ImmEXT_ID));
    cmp myCMP(.A(ForwardRD1_ID), .B(ForwardRD2_ID), .equal(equal));     //there has a forward or stall
    ctrl ID_Ctrl(
        .Instr(Instr_ID), .equal(equal),
        .EXTOp(EXTOp_ID), .NPCOp(NPCOp_ID)
    );

endmodule // id