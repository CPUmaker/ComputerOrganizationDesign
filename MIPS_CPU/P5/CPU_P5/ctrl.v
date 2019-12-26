`define _CTRL_V_

module ctrl(
    input [31:0] Instr,
    input equal,
    output DMWr,
    output RFWr,
    output [1:0] ALUOp,
    output [1:0] EXTOp,
    output [1:0] NPCOp,
    output [1:0] WRSel,
    output [1:0] WDSel,
    output BSel,
    output isCalc_R, isCalc_I, isLoad, isStore, isBranch, isJal, isJr
);

    wire special, addu, subu, ori, lw, sw, beq, lui, j, jal, jr;
    wire [5:0] opcode, funct;
    assign opcode = Instr[31:26];
    assign funct = Instr[5:0];
    

    assign addu =   special && (funct == 6'b100_001) ? 1'b1 : 1'b0;
    assign subu =   special && (funct == 6'b100_011) ? 1'b1 : 1'b0;
    assign jr   =   special && (funct == 6'b001_000) ? 1'b1 : 1'b0;
    assign special  =   (opcode == 6'b000_000) ? 1'b1 : 1'b0;
    assign ori      =   (opcode == 6'b001_101) ? 1'b1 : 1'b0;
    assign lw       =   (opcode == 6'b100_011) ? 1'b1 : 1'b0;
    assign sw       =   (opcode == 6'b101_011) ? 1'b1 : 1'b0;
    assign beq      =   (opcode == 6'b000_100) ? 1'b1 : 1'b0;
    assign lui      =   (opcode == 6'b001_111) ? 1'b1 : 1'b0;
    assign j        =   (opcode == 6'b000_010) ? 1'b1 : 1'b0;
    assign jal      =   (opcode == 6'b000_011) ? 1'b1 : 1'b0;
    

    assign DMWr =   sw  ?   1'b1 :
                            1'b0;
    
    assign RFWr =   addu||subu||ori||lw||lui||jal   ?   1'b1 :
                                                        1'b0;
    
    assign ALUOp    =   addu    ?   2'b00 :
                        subu    ?   2'b01 :
                        ori     ?   2'b10 :
                                    2'b00;
    
    assign EXTOp    =   ori     ?   2'b00 :
                        lw||sw  ?   2'b01 :
                        lui     ?   2'b10 :
                                    2'b00;
    
    assign NPCOp    =   (beq&&equal)    ?   2'b01 :
                        jal||j          ?   2'b10 :
                        jr              ?   2'b11 :
                                            2'b00;
    
    assign WRSel    =   addu||subu      ?   2'b01 :
                        jal             ?   2'b10 :
                                            2'b00;
    
    assign WDSel    =   lw      ?   2'b01 :
                        jal     ?   2'b10 :
                                    2'b00;
    
    assign BSel     =   ori||lw||sw||lui    ?   1'b1 :
                                                1'b0;


    assign isCalc_R = addu | subu;
    assign isCalc_I = ori | lui;
    assign isLoad = lw;
    assign isStore = sw;
    assign isBranch = beq;
    assign isJal = jal;
    assign isJr = jr;

endmodule