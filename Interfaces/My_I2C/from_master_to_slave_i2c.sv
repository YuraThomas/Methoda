module from_master_to_slave_i2c (
	input  [7:0]  data_master,
	input  [7:0]  slave_addr_i,
	input  [7:0]  memory_slave_addr,
	
	input         start,
	input         select_rezim,
	input         clk,
	input         rst,
	input         end_otpravka, // Если 1, то конец, иначе продолжать обмен данными
	
	//output        sda_o,
	output        sda,
	//output        sda_i,
	output        scl_o,
	
	output [31:0] state_master,
	
	output [31:0] state_slave_1,
	output [7: 0] addr_from_master_1,
	output [7: 0] data_from_master_1,
	output [7: 0] slave_from_master_1,
	output        vld_addr_slave_1, 
	output        vld_addr_data_1,
	output        vld_data_1,
	output        slave_rez_1,
	
	output [31:0] state_slave_2,
	output [7: 0] addr_from_master_2,
	output [7: 0] data_from_master_2,
	output [7: 0] slave_from_master_2,
	output        vld_addr_slave_2, 
	output        vld_addr_data_2,
	output        vld_data_2,
	output        slave_rez_2
);

logic scl;
logic sda_out;
logic sda_in;

assign sda_o = sda_out;
assign sda_i = sda_in;
assign scl_o = scl;


my_i2c_tr i2c_master(	
	.data_master(data_master),
	.slave_addr_i(slave_addr_i),
	.memory_slave_addr(memory_slave_addr),
	
	.start(start),
	.select_rezim(select_rezim),
	.clk(clk),
	.rst(rst),
	.end_otpravka(end_otpravka),
	
	.sda(sda),
	.scl_o(scl),
	//.A_slave(sda_in),
	
	.state_o(state_master),
	
	.addr_from_slave(),
	.data_from_slave(),
	
	.vld_addr_data(),
	.vld_data(),
	.count_data_to_slave_o()
);


my_i2c_r  
#(.SLAVE_ADDR(0))i2c_slave_1(
	.clk(clk),
	.rst(rst),

	//.sda_in(sda_out),
	
	.sda(sda),
	.scl(scl),
	
	.state_o(state_slave_1), 
	
	.addr_from_master(addr_from_master_1),
	.data_from_master(data_from_master_1),
	.slave_from_master(slave_from_master_1),
	
	.vld_addr_slave(vld_addr_slave_1), 
	.vld_addr_data(vld_addr_data_1),
	.vld_data(vld_data_1),
	.count_data_to_slave_o(),
	.slave_rez(slave_rez_1)

);

my_i2c_r  
#(.SLAVE_ADDR (10)) i2c_slave_2(
	.clk(clk),
	.rst(rst),

	//.sda_in(sda_out),
	
	.sda(sda),
	.scl(scl),
	
	.state_o(state_slave_2), 
	
	.addr_from_master(addr_from_master_2),
	.data_from_master(data_from_master_2),
	.slave_from_master(slave_from_master_2),
	
	.vld_addr_slave(vld_addr_slave_2), 
	.vld_addr_data(vld_addr_data_2),
	.vld_data(vld_data_2),
	.count_data_to_slave_o(),
	.slave_rez(slave_rez_2)

);


endmodule