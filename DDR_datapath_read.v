module DDR_datapath_read	(
						clk,
						clk_2x,
						rst,
						init_state,
						cmd_state,
						counter,
						ddr_dq_r,
						ddr_dqs_r,
						data_out_rdy,
						sys_data_r,
						);
						


input clk;
input clk_2x;
input rst;
input [3:0] init_state;
input [3:0] cmd_state;
input [7:0] ddr_dq_r;
input ddr_dqs_r;
input [14:0] counter;

output [15:0] sys_data_r;
output data_out_rdy;


reg [7:0] ddr_din_clk_2x;
reg	[7:0] ddr_din_posedge;
reg	[7:0] ddr_din_negedge;
reg	[7:0] ddr_din_h;
reg	[7:0] ddr_din_l;
reg	dout_ready_1;
reg	dout_ready_2;
reg	dout_ready_3;

`include "D:\DDR_parameters.v"

always@(posedge clk_2x,negedge rst)begin
if(!rst) ddr_din_clk_2x <= 0;
else	ddr_din_clk_2x <= ddr_dq_r;
end

always@(posedge clk,negedge rst)begin
if(!rst) ddr_din_posedge <= 0;
else	ddr_din_posedge	<= ddr_din_clk_2x;
end

always@(negedge clk,negedge rst)begin
if(!rst) ddr_din_negedge <= 0;
else	ddr_din_negedge	<= ddr_din_clk_2x;
end

always@(posedge clk,negedge rst)begin
if(!rst)begin
	ddr_din_h <= 0;
	ddr_din_l <= 0;
	end
else begin
	ddr_din_h <= ddr_din_posedge;
	ddr_din_l <= ddr_din_negedge;
	end
end

always@(posedge clk,negedge rst)begin
if(!rst) begin
	dout_ready_1 <= 0;
	dout_ready_2 <= 0;
	dout_ready_3 <= 0;
	end
else begin
	if(cmd_state == c_WAIT_END_OF_R_BURST) 
		dout_ready_1 <= 1;
	else 
		dout_ready_1 <= 0;
	
	dout_ready_2	<= dout_ready_1;
	dout_ready_3	<= dout_ready_2;
	end
end

assign data_out_rdy = dout_ready_3;
assign sys_data_r		= {ddr_din_h,ddr_din_l};

endmodule
	
	
		
		




