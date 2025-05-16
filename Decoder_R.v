module Decoder_R (
	input [6:0] opcode,
	input [2:0] func3,
	input [6:0] func7,
	output jalr,
	output enpc,
	output jal,
	output b,
	output ws,
	output [4:0] memi,
	output mwe,
	output rfwe,
	output [4:0] aop,
	output [2:0] srcB,
	output [1:0] srcA
);

parameter opcode_R = 7'd51;
wire [31:0] ZAT;	//Затычка в декодере
assign ZAT = 32'd1;


assign memi = (opcode == opcode_R) ? 5'd0 : ZAT[4:0];
assign aop = (opcode == opcode_R) ? {func7[6:5],func3} : ZAT[4:0];
assign enpc = (opcode == opcode_R) ? 1'd1 : ZAT[1];
assign ws = (opcode == opcode_R) ? 1'd0 : ZAT[0];
assign mwe = (opcode == opcode_R) ? 1'd0 : ZAT[0];
assign rfwe = (opcode == opcode_R) ? 1'd0 : ZAT[0];
assign jalr = (opcode == opcode_R) ? 1'd0 : ZAT[0];
assign jal = (opcode == opcode_R) ? 1'd0 : ZAT[0];
assign b = (opcode == opcode_R) ? 1'd0 : ZAT[0];


endmodule