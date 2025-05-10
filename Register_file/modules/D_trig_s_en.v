module D_trig_s_en (
	input data,
	input Load,
	input clk,
	output reg out

);

wire data_en;
assign data_en = data & Load | out & ~Load;

always @(posedge clk) begin
	out <= data_en;
end

endmodule
	
	
