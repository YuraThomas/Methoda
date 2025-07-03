module shift_register_with_valid
# (
    parameter width = 8, depth = 4
)
(
    input                clk,
    input                rst,

    input                in_vld,
    input  [width - 1:0] in_data,

    output               out_vld,
    output [width - 1:0] out_data
);

reg [width - 1:0] shreg [0:depth - 1];
reg [depth - 1:0] vld_shreg;

assign out_vld  = vld_shreg[depth - 1];
assign out_data = shreg[depth - 1];

integer i;

always_ff @(posedge clk) begin
    if (rst) begin
      shreg[0] <= '0;
    end else begin
      if (in_vld)
        shreg[0] <= in_data;
    end

    for (i=1; i<depth; i++) begin
      if (rst) begin
        shreg[i] <= '0;
      end
      else begin
        if (vld_shreg[i-1])
          shreg[i] <= shreg[i-1];
      end
    end

end

always_ff @(posedge clk) begin
  if (rst)
    vld_shreg <= '0;
  else begin
    vld_shreg[depth - 1:0] <= {vld_shreg[depth - 2:0], in_vld};
  end
end

endmodule
    // Task:
    //
    // Implement a variant of a shift register module
    // that moves a transfer of data only if this transfer is valid.
    //
    // For the discussion of shift registers
    // see the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0



