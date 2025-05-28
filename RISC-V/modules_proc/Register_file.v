module Register_file(
	input [4:0] upr_A,
	input [4:0] upr_B,
	input [4:0] upr_in,
	input [31:0] in,
	output [31:0] A,
	output [31:0] B,
	input clk,
	input WrEn

);

reg  [31:0] RAM [0:31];

assign A = (upr_A == 5'd0) ? 32'd0: RAM [upr_A];
assign B = (upr_B == 5'd0) ? 32'd0: RAM [upr_B];

always @(posedge clk) begin
	if (WrEn) begin
		RAM[upr_in] <= in;
	end

end


endmodule 