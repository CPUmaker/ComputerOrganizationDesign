module im(
    input [31:0] addr,
    output [31:0] Instr
);

    reg [31:0] rom[1023:0];

    initial $readmemh("code.txt", rom);

    assign Instr = rom[addr[11:2]];

endmodule // im