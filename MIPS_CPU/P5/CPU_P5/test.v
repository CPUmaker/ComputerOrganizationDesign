`include "mips.v"

module test();

    reg clk, reset;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        #1000;
        $finish;
    end

    always #5 clk = ~clk;

    mips myMIPS(.clk(clk), .reset(reset));

endmodule // test