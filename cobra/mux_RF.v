module mux_RF (
	input [1:0] upr_data,
	input [31:0] SW,
	input [31:0] work_const,
	input [31:0] OUT_ALU,
	output reg [31:0] data_RF
);
always @(*) begin
	case (upr_data[1:0])
		2'd0: data_RF = work_const;
		2'd1: data_RF = SW;
		2'd2: data_RF = OUT_ALU;
		default: begin
			data_RF = 0;
		end
	endcase;
end

endmodule