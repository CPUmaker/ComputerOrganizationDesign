module key_driver(
    input clk,
    input reset,
    input [31:0] Addr,
    output [31:0] Dout,
    input [7:0] user_key,
    output reg INT_Key
);

    reg [7:0] key_reg;
    wire CS_Key;

    assign CS_Key = (Addr >= 32'h0000_7f40 && Addr <= 32'h0000_7f43) ? 1'b1 : 1'b0;
    assign Dout = {24'd0, key_reg};

    always @(posedge clk) begin
        if(reset) begin
            key_reg <= 8'd0;
            INT_Key <= 1'b0;
        end
        else begin
            key_reg <= ~user_key;
            if(key_reg|(~user_key) != key_reg)
                INT_Key <= 1'b1;
			else
				INT_Key <= 1'b0;
        end
    end

endmodule // key_driver