module Counter (
	input  clk,
	input comp,
	input PC_en,
	input [31:0] RD1,
	input [31:0] IMM_I,
	input [31:0] IMM_J,
	input [31:0] IMM_B,
	input b,
	input jal,
	input jalr,
	output reg [31:0] PC
);

wire [31:0] PC_PLUS;
wire b_comp;
wire upr_mux_1;
wire upr_mux_2;
wire [31:0] out_mux_2;
wire [31:0] PC_IN;
assign b_comp = b & comp;
assign upr_mux_1 = b_comp | jal;
assign upr_mux_2 = b;
assign PC_PLUS = (upr_mux_1 == 1'd0) ? 32'd4:out_mux_2;
assign out_mux_2 = (upr_mux_2 == 1'd0) ? IMM_J : IMM_B;
assign PC_IN = (jalr == 0) ? (PC+PC_PLUS) : (RD1+IMM_I);
						


always @(posedge clk) begin
	if (PC_en == 1) PC <= PC_IN;
	else PC <= PC;
end

endmodule
