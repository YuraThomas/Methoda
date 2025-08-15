module my_fifo
#(parameter width = 2, depth = 40)
(
    input                clk,
    input                rst,
    input                push,
    input                pop,
    input  [width - 1:0] write_data,
    output logic [width - 1:0] read_data,
    output               empty,
    output               full
);

localparam pointer_depth = $clog2 (depth);
localparam depth_minus_1 = depth - 1;


logic [pointer_depth +1 : 0] count_in_fifo;
logic [pointer_depth +1 : 0] count_out_fifo;

reg [pointer_depth : 0] chislo;
logic [width-1 : 0] fifo [depth -1 : 0];

wire uslovie_schitivanie = pop && (chislo > 0);

always @(posedge clk) begin
	if (rst) begin
		count_in_fifo <= '0;
		count_out_fifo <= '0;
		chislo <= '0;
	end
	else begin
		if (push && ~pop) begin 
			fifo [count_in_fifo] <= write_data;
			chislo <= chislo +1;
			
			if (count_in_fifo == (depth_minus_1)) count_in_fifo <= '0;
			else count_in_fifo <= count_in_fifo +1;
		end
	
		if (uslovie_schitivanie && ~(push&&pop)) begin 
			chislo <= chislo - 1;
            if (count_out_fifo == (depth_minus_1)) count_out_fifo <= '0;
            else count_out_fifo <= count_out_fifo +1;
		end
        
        if (push && pop) begin
            fifo [count_in_fifo] <= write_data;
            if (count_out_fifo == (depth_minus_1)) count_out_fifo <= '0;
            else count_out_fifo <= count_out_fifo +1;
            if (count_in_fifo == (depth_minus_1)) count_in_fifo <= '0;
			else count_in_fifo <= count_in_fifo +1;
        end
        
        
			
	end
end

assign read_data = fifo [count_out_fifo];
assign empty = (chislo == '0);
assign full = (chislo == (depth));
endmodule

