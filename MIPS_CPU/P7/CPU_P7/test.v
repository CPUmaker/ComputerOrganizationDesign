`include "mips.v"

module test();

    reg clk, reset, interrupt;
    wire [31:0] addr;
    
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        $display("The Beginning For Simulation:");
        clk = 0;
        reset = 1;
        interrupt = 0;
        #10;
        reset = 0;
        interrupt = 1;
        #5000;
        $finish;
    end

    always #5 clk = ~clk;

    mips MIPS(
        .clk(clk), .reset(reset), .interrupt(interrupt),
        .addr(addr)
    );
    
endmodule
    