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
parameter opcode_I_1 = 7'd19;
parameter opcode_I_2 = 7'd3;
parameter opcode_I_3 = 7'd103;

wire [31:0] ZAT;	//Затычка в декодере
assign ZAT = 32'd1;

assign srcA = (opcode == opcode_R) ? 2'd0 :
				  (opcode == opcode_I_1) ? 2'd0 :
				  (opcode == opcode_I_2) ? 2'd0 : 
				  (opcode == opcode_I_3) ? 2'd1 : ZAT[1:0];

assign srcB = (opcode == opcode_R) ? 3'd0 :
				  (opcode == opcode_I_1) ? 3'd1 : 
				  (opcode == opcode_I_2) ? 3'd1 :
				  (opcode == opcode_I_2) ? 3'd4 : ZAT[2:0];

assign memi = (opcode == opcode_R) ? 5'd0 :
				  (opcode == opcode_I_1) ? 5'd0 :
				  (opcode == opcode_I_2) ? {1'b1, 1'b0, func3} :
				  (opcode == opcode_I_3) ? 5'd0 : ZAT[4:0];
				  
				  
assign aop = (opcode == opcode_R) ? {func7[6:5], func3} :
				 (opcode == opcode_I_1) ? {2'd0, func3} :
				 (opcode == opcode_I_2) ? {2'd0, func3} :
				 (opcode == opcode_I_3) ? 5'd0 : ZAT[4:0];

assign enpc = (opcode == opcode_R) ? 1'd1 :
				  (opcode == opcode_I_1) ? 1'd1 :
				  (opcode == opcode_I_2) ? 1'd1 :
				  (opcode == opcode_I_3) ? 1'd1 : ZAT[1];

assign ws = (opcode == opcode_R) ? 1'd0 : 
				(opcode == opcode_I_1) ? 1'd0 :
				(opcode == opcode_I_2) ? 1'd1 :
				(opcode == opcode_I_3) ? 1'd0 : ZAT[0];

assign mwe = (opcode == opcode_R) ? 1'd0 :
				 (opcode == opcode_I_1) ? 1'd0 :
				 (opcode == opcode_I_2) ? 1'd1 :
				 (opcode == opcode_I_3) ? 1'd0 : ZAT[0];

assign rfwe = (opcode == opcode_R) ? 1'd1 :
				  (opcode == opcode_I_1) ? 1'd1 :
				  (opcode == opcode_I_2) ? 1'd1 :
				  (opcode == opcode_I_3) ? 1'd1 : ZAT[0];

assign jalr = (opcode == opcode_R) ? 1'd0 :
				  (opcode == opcode_I_1) ? 1'd0 :
				  (opcode == opcode_I_2) ? 1'd0 :
				  (opcode == opcode_I_3) ? 1'd1 : ZAT[0];

assign jal = (opcode == opcode_R) ? 1'd0 :
				 (opcode == opcode_I_1) ? 1'd0 :
				 (opcode == opcode_I_2) ? 1'd0 :
				 (opcode == opcode_I_3) ? 1'd0 : ZAT[0];

assign b = (opcode == opcode_R) ? 1'd0 :
			  (opcode == opcode_I_1) ? 1'd0 :
			  (opcode == opcode_I_2) ? 1'd0 :
			  (opcode == opcode_I_3) ? 1'd0 : ZAT[0];
endmodule