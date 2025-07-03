module modern_shift_reg 
#(parameter N = 8) (
	input [31:0] data_i,
	input vld_i,
	input clk_i,
	input rst_i,
	output vld_o,
	output [31:0] data_o
);

logic [31:0] data_trig [N];
logic vld [N];
integer i;

always @(posedge clk_i) begin
	for (i = 1; i < N; i++ ) begin
		if (vld[i]) data_trig[i] <= data_trig[i-1];
		else data_trig[i] <= data_trig[i];
	end
	
	if (vld_i) data_trig [0] <= data_i ;
	else data_trig [0] <= data_trig[0];
	
end


always @(posedge clk_i) begin
	if (rst_i) begin
		for (i = 0; i < N; i++ ) begin
			vld[i] <= 1'd0;
		end
	end
	
	else begin
		vld [0] <= vld_i;
		for (i = 1; i < N; i++ ) begin
			vld [i] <= vld[i-1];
		end
		
		
	end
end

assign data_o = data_trig [N-1];
assign vld_o = vld [N-1];

endmodule
	