module detect_6 (
   input  clk,
   input  rst,
   input  a,
   output detected
);

reg [5:0] out_shreg;

always @(posedge clk) begin

	if (rst) out_shreg = 6'd0;
	
	else begin
		out_shreg[0] <= a;
		out_shreg[1] <= out_shreg[0];
		out_shreg[2] <= out_shreg[1];
		out_shreg[3] <= out_shreg[2];
		out_shreg[4] <= out_shreg[3];
		out_shreg[5] <= out_shreg[4];
	end
end

assign detected = (out_shreg == 6'b110011);

endmodule
