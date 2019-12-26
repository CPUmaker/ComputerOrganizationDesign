module im(
    input [31:0] addr,
    output [31:0] Instr
);

    reg [31:0] rom[1023:0];
    integer i;

    initial begin
        for (i = 0; i<1024; i=i+1) begin
            rom[i] = 32'h0000_0000;
        end
        $readmemh("code.txt", rom);
    end

    assign Instr = rom[addr[11:2]];

endmodule // im