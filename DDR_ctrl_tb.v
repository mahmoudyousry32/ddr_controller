`timescale 1ns/1ps
`define PERIOD 3.75 //38
`define PERIOD_n 3.75//38
`define PERIOD_2x 1.875//19


module DDR_crtl_tb;

reg rd_wr_req;
reg addr_strobe;
reg clk;
reg clk_2x;
reg clk_n;
reg rst;


reg [12:0] sys_addr_row;
reg [9:0] sys_addr_col;
reg [1:0] sys_ba;

wire cke;
wire init_done;
wire ctrl_busy;
wire csn;
wire rasn;
wire casn;
wire wen;
wire wren;
wire data_out_rdy;
wire ddr_dqm;

wire [3:0] init_state;
wire [3:0] cmd_state;
wire [24:0] addr_to_dp;
wire [8:0] refresh_counter;
wire [3:0] command;
wire [12:0] ddr_addr;
wire [1:0] ddr_ba;

wire [15:0] sys_data;
wire ddr_dqs;
wire [7:0] ddr_dq;

reg [15:0] sys_data_drive;
reg ddr_dqs_drive;
reg [7:0] ddr_dq_drive;

wire [15:0] sys_data_recived;
wire ddr_dqs_recived;
wire [7:0] ddr_dq_recived;

assign sys_data = sys_data_drive;
assign sys_data_recived = sys_data;
assign ddr_dq = ddr_dq_drive;
assign ddr_dq_recived = ddr_dq;
assign ddr_dqs = ddr_dqs_drive;
assign ddr_dqs_recived = ddr_dqs;
`include "DDR_parameters.v"

/*
inout  [15:0] sys_data;
inout ddr_dqs;
inout [7:0] ddr_dq;
*/
DDR_CONTROLLER_TOP	UUT(
							.clk(clk),
							.clk_n(clk_n),
							.clk_2x(clk_2x),
							.rst(rst),
							.sys_data(sys_data),
							.addr_strobe(addr_strobe),
							.sys_addr_row(sys_addr_row),
							.sys_ba(sys_ba),
							.sys_addr_col(sys_addr_col),
							.rd_wr_req(rd_wr_req),
							.init_done(init_done),
							.ctrl_busy(ctrl_busy),
							.cke(cke),
							.csn(csn),
							.rasn(rasn),
							.casn(casn),
							.wen(wen),
							.ddr_addr(ddr_addr),
							.ddr_ba(ddr_ba),
							.wren(wren),
							.ddr_dq(ddr_dq),
							.ddr_dqs(ddr_dqs),
							.data_out_rdy(data_out_rdy),
							.cmd_state(cmd_state),
							.ddr_dqm(ddr_dqm)
							);
							
ddr UUT2(
		.Clk(clk), 
		.Clk_n(clk_n), 
		.Cke(cke), 
		.Cs_n(csn), 
		.Ras_n(rasn), 
		.Cas_n(casn), 
		.We_n(wen),
		.Ba(ddr_ba) , 
		.Addr(ddr_addr), 
		.Dm(ddr_dqm), 
		.Dq(ddr_dq), 
		.Dqs(ddr_dqs));
/*
DDR_ctrl uut (
				.clk(clk),
				.rst(rst),
				.addr_strobe(addr_strobe),
				.sys_addr_row(sys_addr_row),
				.sys_ba(sys_ba),
				.sys_addr_col(sys_addr_col),
				.rd_wr_req(rd_wr_req),
				.init_done(init_done),
				.ctrl_busy(ctrl_busy),
				.init_state(init_state),
				.cmd_state(cmd_state),
				.addr_to_dp(addr_to_dp),
				.refresh_counter(refresh_counter));
 DDR_command_gen UUT_2(	
						.clk(clk),
						.rst(rst),
						.ctrl_addr(addr_to_dp),
						.init_state(init_state),
						.cmd_state(cmd_state),
						.cke(cke),
						.csn(command[3]),
						.rasn(command[2]),
						.casn(command[1]),
						.wen(command[0]),
						.ddr_addr(ddr_addr),
						.ddr_ba(ddr_ba));
*/
task read_from_ddr;
input [12:0] addr_row;
input [9:0] addr_col;
input [1:0] addr_ba;
input [63:0] data;

	begin
	@(posedge clk);
	sys_addr_col = addr_col;
	sys_addr_row = addr_row ;
	sys_ba = addr_ba;
	addr_strobe = 0 ;
	rd_wr_req = 1;
	@(posedge clk);
	addr_strobe = 1;
	rd_wr_req = 0;
	@(posedge clk);
	sys_addr_col = 0;
	sys_addr_row = 0 ;
	sys_ba = 0;
	wait(cmd_state == c_WAIT_END_OF_R_BURST);
	@(posedge clk);
	ddr_dq_drive = data[15:8] ;
	@(negedge clk);
	ddr_dq_drive = data[7:0] ;
	@(posedge clk);
	ddr_dq_drive = data[31:24];
	@(negedge clk);
	ddr_dq_drive = data[23:16];
	@(posedge clk);
	ddr_dq_drive = data[47:40];
	@(negedge clk);
	ddr_dq_drive = data[39:32];
	@(posedge clk);
	ddr_dq_drive = data[55:48];
	@(negedge clk);
	ddr_dq_drive = data[63:56];
	@(posedge clk);
	ddr_dq_drive = 8'bzzzz_zzzz;
	end
endtask

task read;
input [12:0] addr_row;
input [9:0] addr_col;
input [1:0] addr_ba;

	begin
	@(posedge clk);
	sys_addr_col = addr_col;
	sys_addr_row = addr_row ;
	sys_ba = addr_ba;
	addr_strobe = 0 ;
	rd_wr_req = 1;
	@(posedge clk);
	addr_strobe = 1;
	rd_wr_req = 0;
	@(posedge clk);
	sys_addr_col = 0;
	sys_addr_row = 0 ;
	sys_ba = 0;

	end
endtask

task write;
input [12:0] addr_row;
input [9:0] addr_col;
input [1:0] addr_ba;
input [63:0] data;

	

	begin
	@(posedge clk);
	sys_addr_col = addr_col;
	sys_addr_row = addr_row ;
	sys_ba = addr_ba;
	addr_strobe = 0 ;
	rd_wr_req = 0;
	@(posedge clk);
	addr_strobe = 1;
	rd_wr_req = 1;
	@(posedge clk);
	sys_addr_col = 0;
	sys_addr_row = 0 ;
	sys_ba = 0;
	wait(cmd_state == c_WRITE);
	@(posedge clk);
	sys_data_drive = data[15:0];
	@(posedge clk);
	sys_data_drive = data[31:16];
	@(posedge clk);
	sys_data_drive = data[47:32];
	@(posedge clk);
	sys_data_drive = data[63:48];
	@(posedge clk);
	sys_data_drive = 16'bzzzz_zzzz_zzzz_zzzz;
	end
endtask


initial 
	begin
	clk <= 1 ;
	forever #(`PERIOD) clk = ~clk;
	end
initial 
	begin
	clk_n <= 0 ;
	forever #(`PERIOD_n) clk_n = ~clk_n;
	end
	
initial 
	begin
	clk_2x <= 1 ;
	forever #(`PERIOD_2x) clk_2x = ~clk_2x;
	end
	
initial
	begin
	rst <= 0;
	repeat(5)begin
	@(posedge clk);
	end
	rst = 1;
	end	

initial
	begin
	sys_addr_col <= 0;
	sys_addr_row <= 0 ;
	sys_ba <= 0;
	addr_strobe <= 1;
	rd_wr_req <= 0;
	sys_data_drive <= 16'bzzzz_zzzz_zzzz_zzzz;
	ddr_dqs_drive <= 1'bz;
	ddr_dq_drive <= 8'bzzzz_zzzz;
	wait(rst);
	wait(init_done);
	write(13'b1_0000_1111_0000,10'b11111_00000,2'b11,64'b0000011100100011_1101110001001010_1010110000110110_0110100011110001 );
	wait(cmd_state == c_DONE);
	@(posedge clk);
	read(13'b1_0000_1111_0000,10'b11111_00000,2'b11);
	wait(cmd_state == c_REFRESH_DONE);
	write(13'b1_0000_1111_0000,10'b11111_00000,2'b11,64'b0000011100100011_1101110001001010_1010110000110110_0110100011110001 );
	wait(cmd_state == c_DONE);
	write(13'b1_1000_1111_0101,10'b11111_01010,2'b10,64'b0000011100111111_1101110001001010_1010110000110110_0110100011110001 );
	wait(cmd_state == c_DONE);
	write(13'd12,10'd5,2'b01,64'hab_cd_ef_a1_b1_c1_d1_f1 );
	wait(cmd_state == c_DONE);
	read(13'd12,10'd5,2'b01);
	wait(cmd_state == c_DONE);
	read(13'b1_1000_1111_0101,10'b11111_01010,2'b10);
	wait(cmd_state == c_DONE);
	repeat(15)begin
	@(posedge clk);
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*read(13'd10,10'd5,2'b11);
	wait(cmd_state == 4'b1100);
	@(posedge clk);
	write(13'd12,10'd6,2'b01);
	wait(refresh_counter == 103);
	@(posedge clk);
	addr_strobe = 0 ;
	rd_wr_req = 1;
	@(posedge clk);
	addr_strobe = 1 ;
	rd_wr_req = 0;
	wait(cmd_state == 4'b0010);
	repeat(40)begin
	@(posedge clk);
	end
	wait(refresh_counter == 102);
	@(posedge clk);
	addr_strobe = 0 ;
	rd_wr_req = 0;
	@(posedge clk);
	addr_strobe = 1 ;
	rd_wr_req = 1;
	wait(cmd_state == 4'b0010);
	repeat(40)begin
	@(posedge clk);
	end
	wait(refresh_counter == 0);
	@(posedge clk);
	addr_strobe = 0 ;
	rd_wr_req = 1;
	@(posedge clk);
	addr_strobe = 1 ;
	rd_wr_req = 0;
	wait(cmd_state == 4'b0010);
	repeat(40)begin
	@(posedge clk);
	end
	read(13'd10,10'd5,2'b11);
	wait(cmd_state == 4'b1100);
	read(13'd10,10'd5,2'b11);
	wait(cmd_state == 4'b1100);
	write(13'd12,10'd6,2'b01);
	wait(cmd_state == 4'b1100);
	write(13'd12,10'd6,2'b01);
	repeat(40)begin
	@(posedge clk);
	end*/
	
	$finish;
	end
	
endmodule

	
	
	
	
