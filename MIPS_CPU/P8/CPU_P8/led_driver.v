module led_driver(
    input clk,
    input reset,
    input WE,
    input [3:0] BE,
    input [31:0] Addr,
    input [31:0] Din,
    output [31:0] Dout,
    output [31:0] led_light
);

    reg [31:0] led_reg;
    wire CS_LED;

    assign CS_LED = (Addr >= 32'h0000_7f34 && Addr <= 32'h0000_7f37) ? 1'b1 : 1'b0;

    assign Dout = led_reg;
    assign led_light = ~led_reg;

    always @(posedge clk) begin
        if(reset) begin
            led_reg <= 32'd0;
        end
        else if(WE & CS_LED) begin
            led_reg <= Din;
        end
    end

endmodule // led_driver