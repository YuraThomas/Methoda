module command_memory (

	input [31:0] upr,
	output [31:0] out
	

);

reg [31:0] ROM [0:31];

initial $readmemb ("Memory.txt",ROM);
assign out = ROM[upr[31:2]];


endmodule