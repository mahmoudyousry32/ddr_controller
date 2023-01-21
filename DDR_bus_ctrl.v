module DDR_bus_ctrl	(
					clk,
					clk_2x,
					rst,
					dq_io_en,
					cmd_state,
					data_out_rdy,
					sys_dataio_en,
					dqs_io_en);
					

input clk;
input clk_2x;
input rst;
input data_out_rdy;
input [3:0] cmd_state;

output dq_io_en;
output dqs_io_en;
output sys_dataio_en;

reg dq_io_en;
reg dqs_io_en;



`include "DDR_parameters.v"

always@(posedge clk ,negedge rst)begin
if(!rst) begin
	dq_io_en <= 0;
	dqs_io_en <= 0;
	end
else
case(cmd_state)

c_WRITE								:		begin
											dq_io_en <= 1; // 1 OUTPUT , 0 INPUT
											dqs_io_en <= 1;
											end

c_WAIT_END_OF_W_BURST				:		begin
											dq_io_en <= 1;
											dqs_io_en <= 1;
											end
											
c_WAIT_WRITE_RECOVERY				:		begin
											dq_io_en <= 1;
											dqs_io_en <= 1;
											end	
											
default								:		begin
											dq_io_en <= 0;
											dqs_io_en <= 0;
											end				
endcase
end

assign sys_dataio_en = data_out_rdy ;  //1 OUTPUT , 0 INPUT  default input

endmodule
											
