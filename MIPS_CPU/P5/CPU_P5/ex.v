`ifdef _CTRL_V_
`else
    `include "ctrl.v"
`endif

`ifdef _MUX_V_
`else
    `include "mux.v"
`endif

`include "alu.v"

module ex(
    input [31:0] Instr_EX,
    input [31:0] ForwardToALU_A_EX, ForwardToALU_B_EX, ImmEXT_EX,
    output [4:0] RegA3_EX,
    output [31:0] ALUout_EX
);

    wire [31:0] SrcB_EX;
    wire [1:0] ALUOp_EX, WRSel_EX;
    wire BSel_EX;
    alu myALU(.A(ForwardToALU_A_EX), .B(SrcB_EX), .ALUOp(ALUOp_EX), .C(ALUout_EX));      //there has a forward or stall
    ctrl EX_Ctrl(
        .Instr(Instr_EX),
        .ALUOp(ALUOp_EX), .WRSel(WRSel_EX), .BSel(BSel_EX)
    );

    mux2_1 MUX_SrcB_EX(
        .port0(ForwardToALU_B_EX), .port1(ImmEXT_EX),
        .Sel(BSel_EX), .out(SrcB_EX)
    );
    mux4_1 #(5) MUX_RegA3_EX(
        .port0(Instr_EX[20:16]), .port1(Instr_EX[15:11]), .port2(5'h1f),
        .Sel(WRSel_EX), .out(RegA3_EX)
    );

endmodule // ex