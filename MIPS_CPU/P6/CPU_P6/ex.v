`ifdef _CTRL_V_
`else
    `include "ctrl.v"
`endif

`ifdef _MUX_V_
`else
    `include "mux.v"
`endif

`include "alu.v"
`include "multdiv.v"

module ex(
    input clk,
    input reset,
    input [31:0] Instr_EX,
    input [31:0] ForwardToALU_A_EX, ForwardToALU_B_EX, ImmEXT_EX,
    output busy_EX, state_EX,
    output [4:0] RegA3_EX,
    output [31:0] ALUout_EX
);

    wire [31:0] SrcA_EX, SrcB_EX, MultDiv_out_EX, ALU_Result_EX;
    wire [3:0] ALUOp_EX, HiLoOp_EX;
    wire [1:0] WRSel_EX;
    wire ASel_EX, BSel_EX, Overflow_EX, ALUoutSel_EX;
    alu myALU(
        .A(SrcA_EX), .B(SrcB_EX), .ALUOp(ALUOp_EX),
        .C(ALU_Result_EX), .Overflow(Overflow_EX)
    );      //there has a forward or stall
    multdiv myMultDiv(
        .clk(clk), .reset(reset),
        .A(SrcA_EX), .B(SrcB_EX), .HiLoOp(HiLoOp_EX),
        .C(MultDiv_out_EX), .busy(busy_EX), .state(state_EX)
    );
    ctrl EX_Ctrl(
        .Instr(Instr_EX),
        .ALUOp(ALUOp_EX), .WRSel(WRSel_EX), .ASel(ASel_EX), .BSel(BSel_EX), .ALUoutSel(ALUoutSel_EX), .HiLoOp(HiLoOp_EX)
    );
    


    mux2_1 MUX_SrcA_EX(
        .port0(ForwardToALU_A_EX), .port1( {27'd0, Instr_EX[10:6]} ),
        .Sel(ASel_EX), .out(SrcA_EX)
    );
    mux2_1 MUX_SrcB_EX(
        .port0(ForwardToALU_B_EX), .port1(ImmEXT_EX),
        .Sel(BSel_EX), .out(SrcB_EX)
    );
    mux2_1 MUX_ALUout_EX(
        .port0(ALU_Result_EX), .port1(MultDiv_out_EX),
        .Sel(ALUoutSel_EX), .out(ALUout_EX)
    );
    mux4_1 #(5) MUX_RegA3_EX(
        .port0(Instr_EX[20:16]), .port1(Instr_EX[15:11]), .port2(5'h1f), .port3(5'h00),
        .Sel( WRSel_EX|{Overflow_EX,Overflow_EX} ), .out(RegA3_EX)
    );      //if overflow then WRsel|Overflow

endmodule // ex