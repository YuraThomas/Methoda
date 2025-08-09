module my_i2c_tr(	
	input  [7:0]  data_master,
	input  [7:0]  slave_addr_i,
	input  [7:0]  memory_slave_addr,
	
	input         start,
	input         select_rezim,
	input         clk,
	input         rst,
	input         end_otpravka, // Если 1, то конец, иначе продолжать обмен данными
	
	inout         sda,
	output        scl_o,
	//input         A_slave,
	
	output [31:0] state_o, //state_fsm для отладки
	
	output [7:0]  addr_from_slave,
	output [7:0]  data_from_slave,
	
	output        vld_addr_data,
	output        vld_data,
	output [7:0]  count_data_to_slave_o
);

logic A_slave;
assign A_slave = sda;
assign state_o = state;

assign count_data_to_slave_o = count_data_to_slave;

logic [7:0] num_data_pack;
logic scl;
logic end_wait;


assign scl_o = scl;


logic [8:0] slave_addr;
assign slave_addr = {select_rezim, slave_addr_i};


localparam
	START_STATE_FSM = 4'd12,
	INITIAL_STATE_FSM = 4'd0,
	SLAVE_ADDR_FSM = 4'd1,
	WAIT_SLAVE_ADDR_FSM = 4'd2,
	ADDR_MEM_FSM = 4'd3,
	WAIT_ADDR_MEM_FSM = 4'd4,
	TR_DATA_FSM = 4'd5,
	WAIT_END_STATE_FSM = 4'd6,
	END_STATE_FSM = 4'd7,
	
	INPUT_ADDR_DATA_FSM = 4'd8,
	WAIT_ADDR_DATA_FSM = 4'd9,
	INPUT_DATA_FSM = 4'd10,
	WAIT_END_DATA_IN_FSM = 4'd11;
	
logic [3:0] state;
logic [3:0] next_state;


always @(*) begin
	next_state = state;
	case(state)
		INITIAL_STATE_FSM : begin
			if (start) next_state = START_STATE_FSM;
		end
		
		START_STATE_FSM : begin
			if (end_start) next_state = SLAVE_ADDR_FSM;
		end
		
		SLAVE_ADDR_FSM : begin
			if (end_slave_count) next_state = WAIT_SLAVE_ADDR_FSM;
		end
		
		WAIT_SLAVE_ADDR_FSM : begin
			if (~A_slave && end_wait) begin
				next_state = (~select_rezim) ? ADDR_MEM_FSM : INPUT_ADDR_DATA_FSM;
			end
		end
		
		
		INPUT_ADDR_DATA_FSM : if (end_addr_mem_slave) next_state = WAIT_ADDR_DATA_FSM;
		
		WAIT_ADDR_DATA_FSM : if (end_wait) next_state = INPUT_DATA_FSM;
		
		INPUT_DATA_FSM : next_state = (end_data_to_slave) ? WAIT_END_DATA_IN_FSM : INPUT_DATA_FSM;
		
		WAIT_END_DATA_IN_FSM : begin
			if(end_wait) begin
				if(~A_slave && ~end_otpravka) next_state = INPUT_DATA_FSM;
				else next_state = END_STATE_FSM;
			end
		end
		
		
		ADDR_MEM_FSM : begin
			if (end_addr_mem_slave) next_state = WAIT_ADDR_MEM_FSM;
		end
		
		WAIT_ADDR_MEM_FSM : begin
			if (end_wait) begin
				if  (~A_slave) next_state = TR_DATA_FSM;
				else next_state = INITIAL_STATE_FSM;
			end
		
		end
		
		TR_DATA_FSM : begin
			if (end_data_to_slave && end_otpravka) next_state = WAIT_END_STATE_FSM;
		end
		
		WAIT_END_STATE_FSM : begin
			if(end_wait) begin
				if(~A_slave && ~end_otpravka) next_state = TR_DATA_FSM;
				else next_state = END_STATE_FSM;
			end
		end
		
		
		END_STATE_FSM : begin
			if(end_start) next_state = INITIAL_STATE_FSM;
		end
	endcase
end

logic [3:0] num_slave_addr;
logic [3:0] num_slave_mem_addr;
logic sda_neg_clk;

logic vivod;
logic end_start;

always @(posedge clk) begin
	sda<=1'dz;
	case (state)
	
		INITIAL_STATE_FSM : begin
			sda <= 1'dz;
		end
		
		START_STATE_FSM : begin
		if (detect_pos_scl) sda <= 1'd0;
		else sda <= 1'd1;
		
			
	   end
	  
		SLAVE_ADDR_FSM : begin
			if (count_slave_addr < 9) begin
				sda <= slave_addr[count_slave_addr];
			end
		end
	

		ADDR_MEM_FSM : begin
			if (count_memory_slave_addr < 8) begin
				sda <= memory_slave_addr[count_memory_slave_addr];
			end
			
			else sda <= 1'dz;
		end
	

		TR_DATA_FSM : begin
			if (count_data_to_slave < 8) begin
				sda <= data_master[count_data_to_slave];
			end 

			else sda <= 1'dz;
		end

	
		END_STATE_FSM : begin
			if (num_end < 2) begin
				if (detect_pos_scl) sda <= 1'd1;
				else sda <= 1'd0;
			end
				
		end
	
		INPUT_ADDR_DATA_FSM : sda <= 1'dz;
		
		WAIT_ADDR_DATA_FSM : sda <= 1'd0;
		
		INPUT_DATA_FSM : sda <= 1'dz;
		
		WAIT_END_DATA_IN_FSM : sda <= end_otpravka;
	
	endcase
	
	
end



always @(posedge clk) begin
	if (rst) state = INITIAL_STATE_FSM;
	else state <= next_state;
end


logic end_slave_count;
logic end_addr_mem_slave;
logic end_data_to_slave;
logic end_count_exit;

logic [4:0] count_memory_slave_addr;
logic [4:0] count_slave_addr;
logic [4:0] count_data_to_slave;
logic [4:0] num_end;

counter slave_addr_counter(
	.rst(rst),
	.enable((state == SLAVE_ADDR_FSM)),
	.end_count(5'd9),
	.clk(scl),
	.out_cnt(end_slave_count),
	.num (count_slave_addr)
);

counter WAIT_counter(
	.rst(rst),
	.enable(((state == WAIT_ADDR_DATA_FSM) || (state == WAIT_END_STATE_FSM) || 
	        (state == WAIT_SLAVE_ADDR_FSM) || (state == WAIT_ADDR_MEM_FSM)) ||
			  (state == WAIT_END_DATA_IN_FSM)),
	.end_count(5'd1),
	.clk(scl),
	.out_cnt(end_wait),
	.num ()
);

counter memory_addr_counter(
	.rst(rst),
	.enable(((state == ADDR_MEM_FSM) || (state == INPUT_ADDR_DATA_FSM))),
	.end_count(5'd8),
	.clk(scl),
	.out_cnt(end_addr_mem_slave),
	.num (count_memory_slave_addr)
);

counter data_counter(
	.rst(rst),
	.enable(((state == TR_DATA_FSM) || (state == INPUT_DATA_FSM))),
	.end_count(5'd8),
	.clk(scl),
	.out_cnt(end_data_to_slave),
	.num(count_data_to_slave)
);

counter end_counter(
	.rst(rst),
	.enable( (state == END_STATE_FSM)),
	.end_count(5'd2),
	.clk(scl),
	.out_cnt(end_count_exit),
	.num(num_end)
);

from_1_to_8 data_addr_mem (
	.data_i(sda),
	.clk(scl),
	.enable((state == INPUT_ADDR_DATA_FSM)),
	.rst(rst),
	.vld(vld_addr_data),
	.data_o(addr_from_slave)
);

from_1_to_8 data (
	.data_i(sda),
	.clk(scl),
	.enable((state == INPUT_DATA_FSM)),
	.rst(rst),
	.vld(vld_data),
	.data_o(data_from_slave)
);

devider_CLK generate_SCL (
	.clk(clk),
	.SCL(scl)
);

start_end_sda nachalo_conec (
	.clk(clk),
   .scl(scl),
	.enable((state == END_STATE_FSM) || (state == START_STATE_FSM)),
	.sda(),
	.vivod(vivod),
	.end_clk(end_start)
	
);

logic detect_pos_scl;
logic detect_neg_scl;

detect_pos_neg_scl for_start_end(
	.clk(clk),
	.scl(scl),
	.enable((state == END_STATE_FSM || state == START_STATE_FSM || state == WAIT_SLAVE_ADDR_FSM) ),
	.rst(rst),
	.detect_pos_scl (detect_pos_scl),
	.detect_neg_scl (detect_neg_scl)
);
endmodule