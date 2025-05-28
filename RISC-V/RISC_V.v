module RISC_V(
	input clk,
	output out_proc
);

wire [31:0] PC;
wire [31:0] out_com;

wire [31:0] ALU_A;
wire [31:0] ALU_B;
wire [31:0] ALU_OUT;
wire [5:0] ALU_UPR;
wire comp;

wire WE_RF;
wire [4:0] RF_A;
wire [4:0] RF_B;
wire [4:0] RF_in;
wire [31:0] RF_data_A;
wire [31:0] RF_data_B;
wire [31:0] RF_data_in;
wire [31:0] data_mem;

wire [6:0] opcode_dec;
wire [2:0] func3;
wire [6:0] func7;
wire b_dec;
wire mem_WE_dec;
wire [4:0] memi;
wire jal;
wire jalr;
wire enpc;
wire ws;
wire  [31:0] out_mem;

wire [1:0] UPR_MUX_A;
wire [2:0] UPR_MUX_B;

wire [31:0] IMM_I;
wire [31:0] IMM_S;
wire [31:0] IMM_J;
wire [31:0] IMM_B;

assign IMM_I = {{20{out_com[31]}},out_com[31:20]};
assign IMM_S = {{20{out_com[31]}},out_com[31:25],out_com[11:7]};
assign IMM_J = {{12{out_com[31]}}, out_com[19:12], out_com[20], out_com [30:21],1'd0};
assign IMM_B = {{20{out_com[31]}},out_com[30:25], out_com[11:8],out_com[7], 1'd0};

assign func3 = out_com[14:12];
assign opcode_dec = out_com[6:0];
assign func7 = out_com [31:25];
assign RF_A = out_com[19:15] ;
assign RF_B = out_com[24:20];
assign RF_in = out_com [11:7];
assign data_mem = RF_data_B;

assign ALU_A = (UPR_MUX_A == 2'd0) ? RF_data_A :
					(UPR_MUX_A == 2'd1) ? PC : 32'd0;

assign ALU_B = (UPR_MUX_B == 3'd0) ? RF_data_B :
					(UPR_MUX_B == 3'd1) ? IMM_I :
					(UPR_MUX_B == 3'd2) ? {out_com[31:12],12'd0} :
					(UPR_MUX_B == 3'd3) ? IMM_S :
					(UPR_MUX_B == 3'd4) ? 32'd1 : 32'd0;

assign RF_data_in = (ws) ? out_mem : ALU_OUT;

Counter PeCount (
	.clk(clk),
	.comp(comp),
	.PC_en(enpc),
	.RD1(RF_data_A),
	.IMM_I(IMM_I),
	.IMM_J(IMM_J),
	.IMM_B(IMM_B),
	.b(b_dec),
	.jal(jal),
	.jalr(jalr),
	.PC(PC)
);

Decoder_R MAIN_DECODER (
	.opcode(opcode_dec),
	.func3(func3),
	.func7(func7),
	.jalr(jalr),
	.enpc(enpc),
	.jal(jal),
	.b(b_dec),
	.ws(ws),
	.memi(memi),
	.mwe(mem_WE_dec),
	.rfwe(WE_RF),
	.aop(ALU_UPR),
	.srcB(UPR_MUX_B),
	.srcA(UPR_MUX_A)
);

data_mem DATA_MEMORY(
	.memi(memi),
	.data(data_mem),
	.upr_in(ALU_OUT), 
	.out(out_mem),
	.clk(clk),
	.WrEn(mem_WE_dec)

);


ALU_3 ALU_RISCV(
	.Upr_ALU(ALU_UPR),
	.A(ALU_A),
	.B(ALU_B),
	.C(comp),
	.Out_ALU(ALU_OUT)
);

Register_file RF(
	.upr_A(RF_A),
	.upr_B(RF_B),
	.upr_in(RF_in),
	.in(RF_data_in),
	.A(RF_data_A),
	.B(RF_data_B),
	.clk(clk),
	.WrEn(WE_RF)

);
command_memory CM (
	.upr(PC),
	.out(out_com)
);


endmodule