module DDR_datapath_write	(
							clk,
							clk_2x,
							rst,
							wren,
							sys_data_w,
							cmd_state,
							ddr_dq_w,
							ddr_dqs_w);


input clk;
input clk_2x;
input rst;
input wren;
input [15:0] sys_data_w;
input [3:0] cmd_state;

output [7:0] ddr_dq_w;
output ddr_dqs_w;

wire [7:0] sys_din_h = sys_data_w [15:8];
wire [7:0] sys_din_l = sys_data_w [7:0];

reg high_low_byte;
reg	[7:0] din_reg_1;
reg	[7:0] din_reg_2;
reg	[7:0] din_reg_3;

reg wren_n_delay1;
reg wren_n_delay2;
reg wren_n_delay3;

reg ddr_dqs_w;

`include "D:\DDR_parameters.v"



always@(posedge clk_2x,negedge rst)
begin	
	if(!rst)
	begin
		din_reg_1		<=	0;
		din_reg_2		<=	0;
		din_reg_3		<=	0;
		high_low_byte	<=	0;
	end
		
	else
	begin
		if(wren && cmd_state == c_WAIT_END_OF_W_BURST)
		begin
			if(!high_low_byte)
			din_reg_1 <= sys_din_h;
			else din_reg_1 <= sys_din_l;
			high_low_byte <= ~high_low_byte;
		end
		din_reg_2 <= din_reg_1;
		din_reg_3 <= din_reg_2;
	end
end

always@(negedge clk_2x,negedge rst)
begin
	if(!rst)
	begin
		wren_n_delay1	<=	0;
		wren_n_delay2	<=	0;
		wren_n_delay3	<=	0;
	end
	else
	begin
		wren_n_delay1 <= wren;
		wren_n_delay2 <= wren_n_delay1;
		wren_n_delay3 <= wren_n_delay2;
	end
end

always@(negedge clk_2x,negedge rst)
if(!rst) ddr_dqs_w <= 0 ;
else if(wren_n_delay3) ddr_dqs_w <= ~ddr_dqs_w;
else	ddr_dqs_w <= 0 ;

		
	
	
assign ddr_dq_w = din_reg_3;

endmodule
