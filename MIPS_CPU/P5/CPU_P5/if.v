`include "pc.v"
`include "im.v"

module ifetch(
    input clk, reset, WE,
    input [1:0] NPCOp_ID,
    input [31:0] npcValue_ID, 
    output [31:0] pcValue_IF, Instr_IF
);

    wire [31:0] npcValue_IF;
    pc myPC(
        .clk(clk), .reset(reset), .WE(WE),
        .npc(npcValue_IF), .pc(pcValue_IF)
    );
    im myIM(.addr(pcValue_IF), .Instr(Instr_IF));

    assign npcValue_IF = (NPCOp_ID==2'b00) ? pcValue_IF+32'd4 : npcValue_ID;

endmodule // if