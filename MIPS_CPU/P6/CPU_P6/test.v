`include "mips.v"

module test();
    reg clk, reset;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        $display("The Beginning For Simulation:");
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        #2000;
        $finish;
    end
    always #5 clk = ~clk;
    mips MIPS(.clk(clk), .reset(reset));
endmodule
    