module dm(
    input clk,
    input reset,
    input WE,
    input [31:0] addr,
    input [31:0] WD,
    output [31:0] RD
);

    reg [31:0] ram[1023:0];
    integer i;

    initial begin
        for(i=0; i<1024; i=i+1) begin
            ram[i] <= 32'h0000_0000;
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            for(i=0; i<1024; i=i+1) begin
                ram[i] <= 32'h0000_0000;
            end
        end 
        else if(WE) begin
            ram[addr[11:2]] <= WD;
        end
    end

    assign RD = ram[addr[11:2]];

endmodule // dm