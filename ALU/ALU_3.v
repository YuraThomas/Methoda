module ALU_3 (
	input [4:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output C,
	output [31:0] Out_ALU
);
parameter ADD = 5'b00000;
parameter SUB = 5'b01000;
parameter SLL = 5'b00001;
parameter SLTS = 5'b00010;
parameter SLTU = 5'b00011;
parameter XOR = 5'b00100;
parameter SRL = 5'b00101;
parameter SRA = 5'b01101;
parameter OR = 5'b00110;
parameter AND = 5'b00111;
parameter EQ = 5'b11000;
parameter NE = 5'b11001;
parameter LTS = 5'b11100;
parameter GES = 5'b11101;
parameter LTU = 5'b11110;
parameter GEU = 5'b11111;

wire [31:0] out_or;
wire [31:0] out_and;
wire [31:0] out_add;
wire [31:0] out_sub;
wire [31:0] out_xor;
wire [31:0] out_sll;
wire [31:0] out_slts;
wire [31:0] out_sltu;
wire [31:0] out_srl;
wire [31:0] out_sra;
wire out_A_menshe_B_zn;
wire out_A_ne_menshe_B_zn;
wire out_A_menshe_B;
wire out_A_ne_menshe_B;
wire out_equal;
wire out_notequal;

assign out_A_ne_menshe_B_zn = ~out_A_menshe_B_zn;
assign out_A_ne_menshe_B = ~out_A_menshe_B;
assign out_equal = (A==B) ? 1'b1 : 1'b0;
assign out_A_menshe_B = (A<B) ? 1'b1 : 1'b0;
assign out_notequal = ~out_equal;

assign out_add = A+B;
assign out_sub = A-B;
assign out_sll = A << B;
assign out_slts = {{31{1'b0}},out_A_menshe_B_zn};
assign out_sltu = {{31{1'b0}},out_A_menshe_B};
assign out_srl = A >> B;
assign out_sra = A >>>B;


assign Out_ALU = (Upr_ALU == ADD) ? out_add:
					  (Upr_ALU == SUB) ? out_sub:
					  (Upr_ALU == SLL) ? out_sll:
					  (Upr_ALU == SLTS) ? out_slts:
					  (Upr_ALU == SLTU) ? out_sltu:
					  (Upr_ALU == XOR) ? out_xor:
					  (Upr_ALU == SRL) ? out_srl: 
					  (Upr_ALU == SRA) ? out_sra:
					  (Upr_ALU == OR) ? out_or:
					  (Upr_ALU == AND) ? out_and:32'b0;

assign C = (Upr_ALU == EQ) ? out_equal:
			  (Upr_ALU == NE) ? out_notequal:
			  (Upr_ALU == LTS) ? out_A_menshe_B_zn:
			  (Upr_ALU == GES) ? out_A_ne_menshe_B_zn:
			  (Upr_ALU == LTU) ? out_A_menshe_B:
			  (Upr_ALU == GEU) ? out_A_ne_menshe_B:1'b0;
					  
									  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(out_or)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(out_and)
);

sl_mod2 mod2_ALU (
	.A(A),
	.B(B),
	.out(out_xor)
);

comp_menshe zn_comp (
	.A(A),
	.B(B),
	.out(out_A_menshe_B_zn)
);			
endmodule
