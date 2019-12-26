module switch_driver(
    input clk,
    input reset,
    input [31:0] Addr,
    output [31:0] Dout,
	output reg INT_Switch,
    input [7:0] dip_switch0,
    input [7:0] dip_switch1,
    input [7:0] dip_switch2,
    input [7:0] dip_switch3,
    input [7:0] dip_switch4,
    input [7:0] dip_switch5,
    input [7:0] dip_switch6,
    input [7:0] dip_switch7
);

    reg [31:0] switch_reg [1:0];
    wire CS_Switch;
    wire [31:0] offset;

    assign CS_Switch = (Addr >= 32'h0000_7f2c && Addr <= 32'h0000_7f33) ? 1'b1 : 1'b0;
    assign offset = Addr - 32'h0000_7f2c;

    assign Dout = switch_reg[offset[2]];

    always @(posedge clk) begin
        if(reset) begin
            switch_reg[0] <= 32'd0;
            switch_reg[1] <= 32'd0;
			INT_Switch <= 1'b0;
        end
        else begin
            switch_reg[0] <= ~{dip_switch3, dip_switch2, dip_switch1, dip_switch0};
            switch_reg[1] <= ~{dip_switch7, dip_switch6, dip_switch5, dip_switch4};
			if(switch_reg[0] != {dip_switch3, dip_switch2, dip_switch1, dip_switch0})
				INT_Switch <= 1'b1;
			else if(switch_reg[1] != {dip_switch7, dip_switch6, dip_switch5, dip_switch4})
				INT_Switch <= 1'b1;
			else
				INT_Switch <= 1'b0;
        end
    end     

endmodule // switch_driver