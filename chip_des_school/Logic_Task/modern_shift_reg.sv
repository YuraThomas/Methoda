module  shift_register_with_valid
#(parameter depth = 8,
  parameter width = 32) (
	input [width -1:0] data_i,
	input vld_i,
	input clk_i,
	input rst_i,
	output vld_o,
	output [width -1:0] data_o
);

localparam N = depth;

logic [width -1:0] data_trig [N];
logic [N-1 : 0] vld;
integer i;

always @(posedge clk_i) begin
	for (i = 1; i < N; i++ ) begin
		if (vld[i-1]) data_trig[i] <= data_trig[i-1];
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
