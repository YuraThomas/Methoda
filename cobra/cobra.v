module cobra (
	input clk,
	input [31:0] SW,
	output [31:0] HEX

);

wire [4:0] upr_in;
wire [4:0] upr_1;
wire [4:0] upr_2;
wire [31:0] A;
wire [31:0] B;
wire WrEn;
reg [31:0]data_RF;
wire [31:0] pr_data_RF;
wire [31:0] instr;
wire [3:0] UPR_ALU;
wire [31:0] OUT_ALU;
reg [31:0] PC = 32'b0;
wire c;
wire [31:0] work_const;
wire upr_mux2;
wire [1:0] upr_data;


assign upr_in = instr[12:8];
assign upr_1 = instr[22:18];
assign upr_2 = instr[17:13];
assign UPR_ALU = instr[26:23];
assign WrEn = instr[29];
assign upr_mux2 = c&instr[30]|instr[31];
assign work_const = {{24{instr[7]}}, instr[7:0] };
assign upr_data = instr[28:27];
assign pr_data_RF = data_RF;
assign HEX = A;

Register_file rfcbr (
	.upr_A(upr_1),
	.upr_B(upr_2),
	.upr_in(upr_in),
	.in(data_RF),
	.A(A),
	.B(B),
	.clk(clk),
	.WrEn(WrEn)
); 

always @(posedge clk) begin
	if (upr_mux2==1) begin
		PC <= PC + work_const;
	end
	
	else  begin
		PC <= PC + 1;
	end
end

mux_RF mxcbr (
	.upr_data(upr_data),
	.SW(SW),
	.work_const(work_const),
	.OUT_ALU(OUT_ALU),
	.data_RF(pr_data_RF)
);

ALU_3 alcbr (
	.Upr_ALU(UPR_ALU),
	.A(A),
	.B(B),
	.C(c),
	.Out_ALU(OUT_ALU)
);

command_memory cmcbr (
	.upr(PC),
	.out(instr)
);


endmodule
