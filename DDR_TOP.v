module DDR_CONTROLLER_TOP	(
							clk,
							clk_2x,
							clk_n,
							clk_nx,
							rst,
							sys_data,
							addr_strobe,
							sys_addr_row,
							sys_ba,
							sys_addr_col,
							rd_wr_req,
							init_done,
							ctrl_busy,
							cke,
							csn,
							rasn,
							casn,
							wen,
							ddr_addr,
							ddr_ba,
							wren,
							ddr_dq,
							ddr_dqs,
							data_out_rdy,
							cmd_state,
							ddr_dqm
							);


input clk;
input clk_n;
input clk_2x;
input rst;
input addr_strobe;
input rd_wr_req;
input [12:0] sys_addr_row;
input [9:0] sys_addr_col;
input [1:0] sys_ba;

output init_done;
output ctrl_busy;
output cke;
output csn;
output rasn;
output casn;
output wen;
output wren;
output data_out_rdy;
output ddr_dqm;
output clk_nx;

output [3:0] cmd_state;
output [12:0] ddr_addr;
output [1:0] ddr_ba;

inout [7:0] ddr_dq;
inout ddr_dqs;
inout [15:0] sys_data;

wire [7:0] ddr_dq_w;
wire [7:0] ddr_dq_r;
wire ddr_dqs_r;
wire ddr_dqs_w;
wire [3:0] init_state;
wire [3:0] cmd_state;
wire [24:0] addr_to_dp;
wire [9:0] refresh_counter;
wire [14:0] counter;
wire data_out_rdy;
wire dq_io_en;
wire dqs_io_en;
wire [15:0] sys_data_r;
wire [15:0] sys_data_w;
wire sys_dataio_en;



`include "DDR_parameters.v"

DDR_ctrl CTRL(
/*INPUTS*/		.clk(clk),
				.rst(rst),
				.addr_strobe(addr_strobe),
				.sys_addr_row(sys_addr_row),
				.sys_ba(sys_ba),
				.sys_addr_col(sys_addr_col),
				.rd_wr_req(rd_wr_req),
/*OUTPUTS*/		.init_done(init_done), 
				.ctrl_busy(ctrl_busy), 
				.init_state(init_state),//wire
				.cmd_state(cmd_state),//wire
				.addr_to_dp(addr_to_dp),//wire
				.refresh_counter(refresh_counter),//wire
				.counter(counter),//wire
				.wren(wren)
				);


DDR_command_gen CMD_GEN(	
	/*INPUTS*/			.clk(clk),
						.rst(rst),
						.ctrl_addr(addr_to_dp),
						.init_state(init_state),
						.cmd_state(cmd_state),
	/*OUTPUTS*/			.cke(cke),
						.csn(csn),
						.rasn(rasn),
						.casn(casn),
						.wen(wen),
						.ddr_addr(ddr_addr),
						.ddr_ba(ddr_ba)
						);
						

DDR_datapath_read	DP_READ(
							.clk(clk),
							.clk_2x(clk_2x),
							.rst(rst),
							.init_state(init_state),
							.cmd_state(cmd_state),
							.counter(counter),
							.ddr_dq_r(ddr_dq_r),
							.ddr_dqs_r(ddr_dqs_r), //INOUT
							.data_out_rdy(data_out_rdy),//wire
							.sys_data_r(sys_data_r) //INOUT
							);

DDR_datapath_write	DP_WRITE(
							.clk(clk),
							.clk_2x(clk_2x),
							.rst(rst),
							.wren(wren),
							.sys_data_w(sys_data_w),
							.cmd_state(cmd_state),
							.ddr_dq_w(ddr_dq_w), //INOUT
							.ddr_dqs_w(ddr_dqs_w) //INOUT
							);

DDR_bus_ctrl	BUS_CTRL(
					.clk(clk),
					.clk_2x(clk_2x),
					.rst(rst),
					.dq_io_en(dq_io_en),//wire
					.cmd_state(cmd_state),
					.dqs_io_en(dqs_io_en), //wire
					.sys_dataio_en(sys_dataio_en),
					.data_out_rdy(data_out_rdy)
					);


assign ddr_dqs = dqs_io_en ? ddr_dqs_w : 1'bz;
assign ddr_dq = dq_io_en ? ddr_dq_w : 8'bz;
assign ddr_dqs_r = ddr_dqs;
assign ddr_dq_r = ddr_dq;
assign sys_data	= sys_dataio_en ? sys_data_r : 16'bz;
assign sys_data_w = sys_data;
assign ddr_dqm = 0;
assign clk_nx = clk_n;

endmodule
