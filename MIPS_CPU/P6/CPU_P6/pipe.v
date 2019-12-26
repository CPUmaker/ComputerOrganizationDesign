module pipe(
    input clk,
    input reset,
    input WE,
    input [31:0] Instr_in, pc_in, pc8_in, RegData1_in, RegData2_in, ImmEXT_in, ALUout_in, DM_RD_in,
    input [4:0] RegA3_in,
    output reg [31:0] Instr_out, pc_out, pc8_out, RegData1_out, RegData2_out, ImmEXT_out, ALUout_out, DM_RD_out,
    output reg [4:0] RegA3_out
);

    initial begin
        Instr_out = 0;
        pc_out = 32'h0000_3000;
        pc8_out = 0;
        RegA3_out = 0;
        RegData1_out = 0;
        RegData2_out = 0;
        ImmEXT_out = 0;
        ALUout_out = 0;
        RegData2_out = 0;
        DM_RD_out = 0;
    end

    always @(posedge clk) begin
        if(reset) begin
            Instr_out <= 0;
            pc_out <= 32'h0000_3000;
            pc8_out <= 0;
            RegA3_out <= 0;
            RegData1_out <= 0;
            RegData2_out <= 0;
            ImmEXT_out <= 0;
            ALUout_out <= 0;
            DM_RD_out <= 0;
        end
        else if(WE) begin
            Instr_out <= Instr_in;
            pc_out <= pc_in;
            pc8_out <= pc8_in;
            RegA3_out <= RegA3_in;
            RegData1_out <= RegData1_in;
            RegData2_out <= RegData2_in;
            ImmEXT_out <= ImmEXT_in;
            ALUout_out <= ALUout_in;
            DM_RD_out <= DM_RD_in;
        end
    end 

endmodule // pipe