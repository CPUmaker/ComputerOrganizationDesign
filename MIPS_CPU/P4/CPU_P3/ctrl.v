module ctrl(
    input [5:0] opcode,
    input [5:0] funct,
    input zero,
    output DMWr,
    output RFWr,
    output [1:0] ALUOp,
    output [1:0] EXTOp,
    output [1:0] NPCOp,
    output [1:0] WRSel,
    output [1:0] WDSel,
    output BSel
);

    wire addu, subu, ori, lw, sw, beq, lui, jal, jr;
    wire [5:0] opcNot, funNot;
    assign opcNot = ~opcode;
    assign funNot = ~funct;

    and (addu, &opcNot, funct[5], funNot[4], funNot[3], funNot[2], funNot[1], funct[0]);
    and (subu, &opcNot, funct[5], funNot[4], funNot[3], funNot[2], funct[1], funct[0]);
    and (jr, &opcNot, funNot[5], funNot[4], funct[3], funNot[2], funNot[1], funNot[0]);
    and (ori, opcNot[5], opcNot[4], opcode[3], opcode[2], opcNot[1], opcode[0]);
    and (lw, opcode[5], opcNot[4], opcNot[3], opcNot[2], opcode[1], opcode[0]);
    and (sw, opcode[5], opcNot[4], opcode[3], opcNot[2], opcode[1], opcode[0]);
    and (beq, opcNot[5], opcNot[4], opcNot[3], opcode[2], opcNot[1], opcNot[0]);
    and (lui, opcNot[5], opcNot[4], opcode[3], opcode[2], opcode[1], opcode[0]);
    and (jal, opcNot[5], opcNot[4], opcNot[3], opcNot[2], opcode[1], opcode[0]);

    or (DMWr, sw);
    or (RFWr, addu, subu, ori, lw, lui, jal);
    or (ALUOp[0], subu);
    or (ALUOp[1], ori);
    or (EXTOp[0], lw, sw);
    or (EXTOp[1], lui);
    or (NPCOp[0], beq&zero, jr);
    or (NPCOp[1], jal, jr);
    or (WRSel[0], addu, subu);
    or (WRSel[1], jal);
    or (WDSel[0], lw);
    or (WDSel[1], jal);
    or (BSel, ori, lw, sw, lui);

endmodule