module mul
(
input clk,
input rst,

input  [31:0] a,
input  [31:0] b,
output [31:0] mod_a,
output [31:0] mod_b,

output [63:0] ab,
output logic vld
);

wire znak;

assign znak = a[31] ^ b[31];
assign mod_a = a_abs;
assign mod_b = b_abs;

logic [31:0] a_abs;
logic [31:0] b_abs;

logic [31:0] a_norm;
logic [31:0] b_norm;



assign a_abs = (a[31]) ? (~a + 1) : a;
assign b_abs = (b[31]) ? (~b + 1) : b;

logic [63:0] ab_abs;
logic [31:0] cnt;

logic [31:0] max_abs;
logic [31:0] min_abs;

assign max_abs = (a_abs > b_abs) ? a_abs : b_abs;
assign min_abs = (a_abs > b_abs) ? b_abs : a_abs;

assign vld = ~(cnt < min_abs);

assign ab = (znak) ? (~(ab_abs) + 1) : ab_abs;

always_ff @(posedge clk) begin
	if (rst) begin
		ab_abs <= '0;
		cnt <= '0;
	end
	
	else begin
		if (cnt < min_abs) begin
			ab_abs <= ab_abs + max_abs;
			cnt <= cnt + 1'b1;
		end
		
		else begin
			cnt <= '0;
			ab_abs <= '0;
			
		end
	end
end

endmodule

