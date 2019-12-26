`ifdef _CTRL_V_
`else
    `include "ctrl.v"
`endif
`include "dm.v"

module mem(
    input clk, reset,
    input [31:0] Instr_MEM,
    input [31:0] ALUout_MEM, ForwardToDM_WD_MEM,
    output [31:0] DM_RD_MEM
);

    wire DMWr;

    dm myDM(
        .clk(clk), .reset(reset), .WE(DMWr),
        .addr(ALUout_MEM), .WD(ForwardToDM_WD_MEM), .RD(DM_RD_MEM)
    );
    ctrl MEM_Ctrl(
        .Instr(Instr_MEM),
        .DMWr(DMWr)
    );

endmodule // mem