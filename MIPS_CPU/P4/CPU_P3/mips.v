`include "alu.v"
`include "ctrl.v"
`include "dm.v"
`include "ext.v"
`include "grf.v"
`include "im.v"
`include "npc.v"
`include "pc.v"
`include "mux.v"

module mips(
    input clk,
    input reset
);

    wire zero, DMWr, RFWr, BSel;
    wire [1:0] ALUOp, EXTOp, NPCOp, WRSel, WDSel;
    wire [31:0] PCValue, NPCValue, INSTR, reg1, reg2, pc4, ALUout, memData, EXTNumber, writeData, ALUBValue;
    wire [4:0] writeReg;
     

    pc myPC(.clk(clk), .reset(reset), .npc(NPCValue), .pc(PCValue));
    npc myNPC(.pc(PCValue), .Imm(INSTR[25:0]), .ra(reg1), .NPCOp(NPCOp), .npc(NPCValue), .pc4(pc4));
    im myIM(.addr(PCValue), .Instr(INSTR));
    grf myGRF(.clk(clk), .reset(reset), .WE(RFWr), .A1(INSTR[25:21]), .A2(INSTR[20:16]), .A3(writeReg),
                        .WD(writeData), .RD1(reg1), .RD2(reg2));
    alu myALU(.A(reg1), .B(ALUBValue), .ALUOp(ALUOp), .C(ALUout), .zero(zero));
    dm myDM(.clk(clk), .reset(reset), .WE(DMWr), .addr(ALUout), .WD(reg2), .RD(memData));
    ext myEXT(.EXTOp(EXTOp), .Imm(INSTR[15:0]), .out(EXTNumber));
    ctrl myCTRL(.opcode(INSTR[31:26]), .funct(INSTR[5:0]), .zero(zero), .DMWr(DMWr), .RFWr(RFWr),
                        .ALUOp(ALUOp), .EXTOp(EXTOp), .NPCOp(NPCOp), .WRSel(WRSel), .WDSel(WDSel), .BSel(BSel));
    mux4_1 #(5) WR_MUX(.port0(INSTR[20:16]), .port1(INSTR[15:11]), .port2(5'h1f), .Sel(WRSel), .out(writeReg));
    mux4_1 WD_MUX(.port0(ALUout), .port1(memData), .port2(pc4), .Sel(WDSel), .out(writeData));
    mux2_1 ALUB_MUX(.port0(reg2), .port1(EXTNumber), .Sel(BSel), .out(ALUBValue));

    always @(posedge clk) begin
        if(!reset) begin
            if(RFWr)
                $display("@%h: $%d <= %h", PCValue, writeReg, writeData);
            if(DMWr)
                $display("@%h: *%h <= %h",PCValue, ALUout, reg2);
        end
    end

endmodule
