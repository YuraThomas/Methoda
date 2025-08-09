module my_i2c_r 
#(parameter SLAVE_ADDR = 0) (
	input         clk,
	input         rst,

	//input         sda_in,
	
	inout         sda,
	input         scl,
	
	output [31:0] state_o, //state_fsm для отладки
	
	output [7:0]  addr_from_master, //адрес даты от мастера
	output [7:0]  data_from_master, //дата от мастера
	output [7:0]  slave_from_master, //адрес слейва от мастера
	
	output        vld_addr_slave, // валидность адреса памяти от slave
	output        vld_addr_data, // валидность адреса памяти от master
	output        vld_data, // валидность данных от master
	output [7:0]  count_data_to_slave_o,
	output        slave_rez
);

logic sda_in;
assign sda_in = sda;

logic start;
logic end_wait;
logic select_rezim;
logic detect_end;
logic vld_memory_slave;
logic [7:0] memory_slave_addr;
logic [7:0] tr_data;


assign slave_from_master = slave_addr [8:1];
assign slave_rez = slave_addr[0];
assign vld_addr_slave = vld_slave;
assign addr_from_master = memory_slave_addr;
assign vld_addr_data = vld_memory_slave;
assign data_from_master = tr_data;

assign state_o = state;
assign count_data_to_slave_o = count_data_to_slave;

logic [7:0] num_data_pack;
logic [8:0] slave_addr;


localparam
	START_STATE_FSM = 3'd1,
	INITIAL_STATE_FSM = 3'd0,
	SLAVE_ADDR_FSM = 3'd2,
	WAIT_SLAVE_ADDR_FSM = 4'd3,
	ADDR_MEM_FSM = 3'd4,
	WAIT_ADDR_MEM_FSM = 3'd5,
	TR_DATA_FSM = 3'd6,
	WAIT_END_STATE_FSM = 3'd7;
	
	
logic [2:0] state;
logic [2:0] next_state;
logic sel_num_slave;

always @(*) begin
	next_state = state;
	case(state)
		INITIAL_STATE_FSM : begin
			sel_num_slave = 1'd0;
			if (start) next_state = SLAVE_ADDR_FSM;
		end
		
		
		SLAVE_ADDR_FSM : begin
			if (end_slave_count) begin
				if ((slave_addr[8:1] == SLAVE_ADDR)) next_state = WAIT_SLAVE_ADDR_FSM;
				else next_state = INITIAL_STATE_FSM;
				
			end
		end
		
		WAIT_SLAVE_ADDR_FSM : begin
			if (end_wait) begin
				next_state = ADDR_MEM_FSM;
			end
		end
		
		ADDR_MEM_FSM : begin
			if (end_addr_mem_slave) next_state = WAIT_ADDR_MEM_FSM;
		end
		
		WAIT_ADDR_MEM_FSM : begin
			if (end_wait) next_state = TR_DATA_FSM;
		end
		
		
		TR_DATA_FSM : begin
			if (end_data_to_slave) next_state = WAIT_END_STATE_FSM;
			
			else begin
				if(detect_end) begin
					next_state = INITIAL_STATE_FSM;
				end
				else next_state = TR_DATA_FSM;
			end
		end
		
		WAIT_END_STATE_FSM : begin
			if (end_wait) begin 
		       next_state = TR_DATA_FSM;
			end
		end
	endcase
end

always @(posedge clk) begin
	sda <= 1'dz;
	case(state)

		WAIT_SLAVE_ADDR_FSM : begin
			sda <= 1'd0;
		end
		
		WAIT_ADDR_MEM_FSM : begin
			sda <= 1'd0;
		end
		
		WAIT_END_STATE_FSM : begin
		
			if (~detect_end) sda <= 1'd0;
			else sda <= 1'dz;
		end
			
	endcase
end

logic [3:0] num_slave_addr;
logic [3:0] num_slave_mem_addr;
logic sda_neg_clk;

logic vivod;
logic end_start;


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


counter slave_addr_counter(
	.rst(rst),
	.enable((state == SLAVE_ADDR_FSM)),
	.end_count(5'd10),
	.clk(scl),
	.out_cnt(end_slave_count),
	.num (count_slave_addr)
);

counter WAIT_counter(
	.rst(rst),
	.enable(((state == WAIT_END_STATE_FSM) || 
	        (state == WAIT_SLAVE_ADDR_FSM) || (state == WAIT_ADDR_MEM_FSM))),
	.end_count(5'd1),
	.clk(scl),
	.out_cnt(end_wait),
	.num (num_count_wait)
);

counter memory_addr_counter(
	.rst(rst),
	.enable(((state == ADDR_MEM_FSM))),
	.end_count(5'd8),
	.clk(scl),
	.out_cnt(end_addr_mem_slave),
	.num (count_memory_slave_addr)
);

counter data_counter(
	.rst(rst),
	.enable(state == TR_DATA_FSM),
	.end_count(5'd8),
	.clk(scl),
	.out_cnt(end_data_to_slave),
	.num(count_data_to_slave)
);

logic vld_slave;

from_1_to_8
#(.NUM(9)) get_slave_addr (
	.data_i(sda_in),
	.clk(scl),
	.enable((state == SLAVE_ADDR_FSM)),
	.rst(rst),
	.vld(vld_slave),
	.data_o(slave_addr)
);

from_1_to_8
#(.NUM(8)) get_memory_slave_addr (
	.data_i(sda_in),
	.clk(scl),
	.enable((state == ADDR_MEM_FSM)),
	.rst(rst),
	.vld(vld_memory_slave),
	.data_o(memory_slave_addr)
);

from_1_to_8
#(.NUM(8)) get_data (
	.data_i(sda_in),
	.clk(scl),
	.enable((state == TR_DATA_FSM)),
	.rst(rst),
	.vld(vld_data),
	.data_o(tr_data)
);

detect_start_end my_start_end_detector (
	.rst(rst),
	.sda(sda_in),
	.clk(clk),
	.scl(scl),
	.enable((state == INITIAL_STATE_FSM    || 
				state == WAIT_END_STATE_FSM   ||
				state == TR_DATA_FSM)),
	
	.detected_start(start),
	.detected_end(detect_end)
	
);

endmodule