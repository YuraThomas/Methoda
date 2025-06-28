module Poisk (
  input  clk,
  input  rst,
  input  a,
  output detected
);

localparam IDLE = 3'd0,
			  perv_yes = 3'd1,
			  vtor_yes =3'd2,
			  tret_yes = 3'd3,
			  chetv_yes = 3'd4,
			  pyat_yes = 3'd5,
			  six_yes = 3'd6;

reg [2:0] state;
reg [2:0] new_state;
  
always @(*) begin
  case (state)
      IDLE: new_state = (a) ? perv_yes : IDLE;
		perv_yes: new_state = (a) ? vtor_yes : IDLE;
		vtor_yes: new_state = (~a) ? tret_yes : vtor_yes;
		tret_yes: new_state = (~a) ? chetv_yes : IDLE; 
		chetv_yes: new_state = (a) ? pyat_yes : IDLE;
		pyat_yes: new_state = (a) ? six_yes : perv_yes;
		six_yes: new_state = (a) ? vtor_yes : tret_yes;
		default: new_state = IDLE;
    endcase
end
  
always @(posedge clk)
    if (rst)
      state <= IDLE;
    else
      state <= new_state;
  
assign detected = (state == six_yes);
endmodule
