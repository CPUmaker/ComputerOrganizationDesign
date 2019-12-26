module cmp(
    input [31:0] A, B,
	input CmpWithZero,
    output equal, less, greater
);

	wire equal_B, less_B, greater_B, equal_Z, less_Z, greater_Z;

    assign equal_B = (A==B) ? 1'b1 : 1'b0;
    assign less_B =		(($signed(A)<$signed(B)) ? 1'b1 : 1'b0);
    assign greater_B =	(($signed(A)>$signed(B)) ? 1'b1 : 1'b0);
	
	assign equal_Z = (A==32'd0) ? 1'b1 : 1'b0;
    assign less_Z =		(($signed(A)<$signed(32'd0)) ? 1'b1 : 1'b0);
    assign greater_Z =	(($signed(A)>$signed(32'd0)) ? 1'b1 : 1'b0);
	
	assign equal =		(CmpWithZero==1'b1) ? equal_Z : equal_B;
    assign less =		(CmpWithZero==1'b1) ? less_Z : less_B;
    assign greater =	(CmpWithZero==1'b1) ? greater_Z : greater_B;

endmodule // cmp