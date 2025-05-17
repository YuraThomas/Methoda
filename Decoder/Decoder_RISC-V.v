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
parameter opcode_S = 7'd35;
parameter opcode_B= 7'd99;
parameter opcode_J = 7'd111;
parameter opcode_U_lui = 7'd55;
parameter opcode_U_auipc = 7'd23;

wire [31:0] ZAT;	//Затычка в декодере
assign ZAT = 32'd1;

assign srcA = (opcode == opcode_R) ? 2'd0 :
				  (opcode == opcode_I_1) ? 2'd0 :
				  (opcode == opcode_I_2) ? 2'd0 : 
				  (opcode == opcode_I_3) ? 2'd1 :
				  (opcode == opcode_S) ? 2'd3 :
				  (opcode == opcode_B) ? 2'd0 :
				  (opcode == opcode_J) ? 2'd1 :
				  (opcode == opcode_U_lui) ? 2'd2 :
				  (opcode == opcode_U_auipc) ? 2'd1 : ZAT[1:0];
				  



assign srcB = (opcode == opcode_R) ? 3'd0 :
				  (opcode == opcode_I_1) ? 3'd1 : 
				  (opcode == opcode_I_2) ? 3'd1 :
				  (opcode == opcode_I_3) ? 3'd4 :
				  (opcode == opcode_S) ? 3'd3 :
				  (opcode == opcode_B) ? 3'd0 :
				  (opcode == opcode_J) ? 3'd4 :
				  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 3'd2 : ZAT[2:0];

assign memi = (opcode == opcode_R) ? 5'd0 :
				  (opcode == opcode_I_1) ? 5'd0 :
				  (opcode == opcode_I_2) ? {1'b1, 1'b0, func3} :
				  (opcode == opcode_I_3) ? 5'd0 :
				  (opcode == opcode_S) ? {1'b0, 1'b1, func3} : 
				  (opcode == opcode_B) ? 5'd0 :
				  (opcode == opcode_J) ? 5'd0 : 
				  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 5'd0 : ZAT[4:0];
				  
				  
assign aop = (opcode == opcode_R) ? {func7[6:5], func3} :
				 (opcode == opcode_I_1) ? {2'd0, func3} :
				 (opcode == opcode_I_2) ? {2'd0, func3} :
				 (opcode == opcode_I_3) ? 5'd0 :
				 (opcode == opcode_S) ? 5'd0 :
				 (opcode == opcode_B) ? {2'd3, func3} : 
				 (opcode == opcode_J) ? 5'd0 :
				 ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 5'd0 : ZAT[4:0];

assign enpc = (opcode == opcode_R) ? 1'd1 :
				  (opcode == opcode_I_1) ? 1'd1 :
				  (opcode == opcode_I_2) ? 1'd1 :
				  (opcode == opcode_I_3) ? 1'd1 :
				  (opcode == opcode_S) ? 1'd1 :
				  (opcode == opcode_B) ? 1'd1 :
				  (opcode == opcode_J) ? 1'd1 :
				  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd1 : ZAT[0];

assign ws = (opcode == opcode_R) ? 1'd0 : 
				(opcode == opcode_I_1) ? 1'd0 :
				(opcode == opcode_I_2) ? 1'd1 :
				(opcode == opcode_I_3) ? 1'd0 :
				(opcode == opcode_S) ? 1'd1 : 
				(opcode == opcode_B) ? 1'd0 : 
				(opcode == opcode_J) ? 1'd0 :
				((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd0 : ZAT[0];

assign mwe = (opcode == opcode_R) ? 1'd0 :
				 (opcode == opcode_I_1) ? 1'd0 :
				 (opcode == opcode_I_2) ? 1'd1 :
				 (opcode == opcode_I_3) ? 1'd0 :
				 (opcode == opcode_S) ? 1'd1 :
				 (opcode == opcode_B) ? 1'd0 :
				 (opcode == opcode_J) ? 1'd0 :
				 ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd0 : ZAT[0];

assign rfwe = (opcode == opcode_R) ? 1'd1 :
				  (opcode == opcode_I_1) ? 1'd1 :
				  (opcode == opcode_I_2) ? 1'd1 :
				  (opcode == opcode_I_3) ? 1'd1 :
				  (opcode == opcode_S) ? 1'd0 :
				  (opcode == opcode_B) ? 1'd0 :
				  (opcode == opcode_J) ? 1'd1 : 
				  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd1 : ZAT[0];

assign jalr = (opcode == opcode_R) ? 1'd0 :
				  (opcode == opcode_I_1) ? 1'd0 :
				  (opcode == opcode_I_2) ? 1'd0 :
				  (opcode == opcode_I_3) ? 1'd1 :
				  (opcode == opcode_S) ? 1'd0 :
				  (opcode == opcode_B) ? 1'd0 :
				  (opcode == opcode_J) ? 1'd0 :
				  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd0 : ZAT[0];


assign jal = (opcode == opcode_R) ? 1'd0 :
				 (opcode == opcode_I_1) ? 1'd0 :
				 (opcode == opcode_I_2) ? 1'd0 :
				 (opcode == opcode_I_3) ? 1'd0 :
				 (opcode == opcode_S) ? 1'd0 :
				 (opcode == opcode_B) ? 1'd0 :
				 (opcode == opcode_J) ? 1'd1 :
				 ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd0 : ZAT[0];

assign b = (opcode == opcode_R) ? 1'd0 :
			  (opcode == opcode_I_1) ? 1'd0 :
			  (opcode == opcode_I_2) ? 1'd0 :
			  (opcode == opcode_I_3) ? 1'd0 :
			  (opcode == opcode_S) ? 1'd0 :
			  (opcode == opcode_B) ? 1'd1 : 
			  (opcode == opcode_J) ? 1'd0 :
			  ((opcode == opcode_U_lui) |(opcode == opcode_U_auipc))  ? 1'd0 : ZAT[0];
endmodule