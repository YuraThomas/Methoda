module ALU_2 (
	input [2:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output C,
	output [31:0] Out_ALU
);

wire [31:0] or_mux;
wire [31:0] and_mux;
wire [31:0] A_shift_1;
wire A_eq_B;
wire A_more_B;
assign A_shift_1 = {A[30:0], 1'b0};

assign Out_ALU = (Upr_ALU == 3'd0) ? 32'b0:
					  (Upr_ALU == 3'd1) ? A+B:
					  (Upr_ALU == 3'd2) ? A-B:
					  (Upr_ALU == 3'd3) ? and_mux:
					  (Upr_ALU == 3'd4) ? or_mux:
					  (Upr_ALU == 3'd5) ? 32'b0:
					  (Upr_ALU == 3'd6) ? 32'b0: A_shift_1;

assign A_more_B = (A > B) ? 1'b1 : 1'b0;
assign A_eq_B = (A == B) ? 1'b1 : 1'b0;
assign C = (Upr_ALU == 3'd5) ? A_more_B:
			  (Upr_ALU == 3'd6) ? A_eq_B: 1'b0;
									  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(or_mux)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(and_mux)
);					
endmodule
