module digital_driver(
    input clk,
    input reset,
    input WE,
    input [3:0] BE,
    input [31:0] Addr,
    input [31:0] Din,
    output [31:0] Dout,
    output [3:0] digital_tube_sel0,
    output [3:0] digital_tube_sel1,
    output digital_tube_sel2,
    output [7:0] digital_tube0,
    output [7:0] digital_tube1,
    output [7:0] digital_tube2
);

reg [31:0] digital_reg [1:0];
reg [9:0] count;
wire CS_Digital;
wire [7:0] tube [18:0];
wire [31:0] offset;

assign  tube[0] = 8'h81,    tube[1] = 8'hcf,    tube[2] = 8'h92,    tube[3] = 8'h86,
        tube[4] = 8'hcc,    tube[5] = 8'ha4,    tube[6] = 8'ha0,    tube[7] = 8'h8f,
        tube[8] = 8'h80,    tube[9] = 8'h84,
        tube[10] = 8'h88,   tube[11] = 8'he0,   tube[12] = 8'hb1,   tube[13] = 8'hc2,
        tube[14] = 8'hb0,   tube[15] = 8'hb8,   tube[16] = 8'hff,   tube[17] = 8'hfe;

assign CS_Digital = (Addr >= 32'h0000_7f38 && Addr <= 32'h0000_7f3f) ? 1'b1 : 1'b0;
assign offset = Addr - 32'h0000_7f38;

assign Dout = digital_reg[offset[2]];
assign digital_tube_sel0 =  (reset)             ?   4'b0000 :
                            (count[9:8]==2'b00) ?   4'b0001 :
                            (count[9:8]==2'b01) ?   4'b0010 :
                            (count[9:8]==2'b10) ?   4'b0100 :
                            (count[9:8]==2'b11) ?   4'b1000 :
                                                    4'b0000;
assign digital_tube_sel1 =  (reset)             ?   4'b0000 :
                            (count[9:8]==2'b00) ?   4'b0001 :
                            (count[9:8]==2'b01) ?   4'b0010 :
                            (count[9:8]==2'b10) ?   4'b0100 :
                            (count[9:8]==2'b11) ?   4'b1000 :
                                                    4'b0000;
assign digital_tube_sel2 =  (reset) ? 1'b0 : 1'b1;
assign digital_tube0    =   (digital_tube_sel0==4'b0001)    ?   tube[digital_reg[0][3:0]]   :
                            (digital_tube_sel0==4'b0010)    ?   tube[digital_reg[0][7:4]]   :
                            (digital_tube_sel0==4'b0100)    ?   tube[digital_reg[0][11:8]]  :
                            (digital_tube_sel0==4'b1000)    ?   tube[digital_reg[0][15:12]] :
                                                                tube[16];
assign digital_tube1    =   (digital_tube_sel1==4'b0001)    ?   tube[digital_reg[0][19:16]] :
                            (digital_tube_sel1==4'b0010)    ?   tube[digital_reg[0][23:20]] :
                            (digital_tube_sel1==4'b0100)    ?   tube[digital_reg[0][27:24]] :
                            (digital_tube_sel1==4'b1000)    ?   tube[digital_reg[0][31:28]] :
                                                                tube[16];
assign digital_tube2    =   (digital_tube_sel2) ?   tube[digital_reg[1][3:0]]   :   tube[16];

always @(posedge clk) begin
    if(reset) begin
        digital_reg[0] <= 32'd0;
        digital_reg[1] <= 32'd0;
        count <= 10'd0;
    end
    else begin
        count <= count + 10'd1;
        if(WE & CS_Digital)
            case (offset[2])
                1'b0: digital_reg[0] <= Din;
                1'b1: digital_reg[1] <= {24'd0, Din[7:0]};
                default: ;
            endcase
    end
end

endmodule // digital_driver