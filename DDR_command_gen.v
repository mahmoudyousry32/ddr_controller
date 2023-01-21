
module DDR_command_gen(	
	/*INPUTS*/			clk,
						rst,
						ctrl_addr,
						init_state,
						cmd_state,
	/*OUTPUTS*/			cke,
						csn,
						rasn,
						casn,
						wen,
						ddr_addr,
						ddr_ba);
						




input clk;
input rst;
input [3:0] cmd_state;
input [3:0] init_state;
input [24:0] ctrl_addr;

output cke;
output csn;
output rasn;
output casn;
output wen;
output [12:0] ddr_addr;
output [1:0]  ddr_ba  ;


reg 		[12:0] 		ddr_addr_reg;
reg 		[1:0] 		ddr_ba_reg;
reg 		[12:0] 		ddr_addr;
reg 		[1:0] 		ddr_ba;


reg 		cke_reg;
reg 		csn_reg;
reg 		rasn_reg;
reg 		casn_reg;
reg 		wen_reg;

reg 		cke;
reg 		csn;
reg 		rasn;
reg 		casn;
reg 		wen;
reg			wait_200us;

wire 	[1:0] 	ctrl_ba;
wire 	[12:0] 	ctrl_addr_row;
wire 	[9:0]	ctrl_addr_col;

assign	ctrl_ba			=	ctrl_addr[24:23];
assign	ctrl_addr_row	=	ctrl_addr[22:10];
assign	ctrl_addr_col	=	ctrl_addr[9:0]	;

`include "D:\DDR_parameters.v"



`define DDR_COMMAND_REG				{csn_reg,rasn_reg,casn_reg,wen_reg}
`define DDR_COMMAND					{csn,rasn,casn,wen}

always@(posedge clk,negedge rst)begin
if(!rst)
	begin
	`DDR_COMMAND_REG <= DESELECT;
	ddr_addr_reg	<= 13'b1111111111111;
	cke_reg			<= 0;
	ddr_ba_reg		<= 0;
	wait_200us		<= 0;
	end
else
	case(init_state)
	
	i_WAIT_200US			:			begin 
										`DDR_COMMAND_REG <= NOP;
										ddr_addr_reg	<= 13'b1111111111111;
										cke_reg			<= 0;
										ddr_ba_reg		<= 0;
										if(wait_200us) cke_reg <= 1;
										end
	
	i_NOP					:			begin
										`DDR_COMMAND_REG <= NOP;
										ddr_addr_reg	<= 13'b1111111111111;
										cke_reg			<= 1;
										ddr_ba_reg		<= 0;
										end
										
	i_PRECHARGE				:			begin
										`DDR_COMMAND_REG <= PRECHARGE;
										ddr_addr_reg	<= 13'b1111111111111;
										ddr_ba_reg		<= 0;
										end
										
	i_WAIT_tRP				:			begin
										`DDR_COMMAND_REG <= NOP;
										end
	
	i_EMR_SET				:			begin
										`DDR_COMMAND_REG <= LOAD_MODE_REGISTER;
										ddr_ba_reg		<=	EXTENDED_MODE_REG;
										ddr_addr_reg	<=	{11'b0,NORMAL_DRIVE_STRENGTH,DLL_ENABLE};
										end
										
	i_WAIT_tMRD				:			begin
										`DDR_COMMAND_REG	<=	NOP;
										end
										
	i_MR_SET				:			begin
										`DDR_COMMAND_REG <= LOAD_MODE_REGISTER;
										ddr_ba_reg		<= NORMAL_MODE_REG;
										ddr_addr_reg	<= {NORMAL_OP_MODE_DLL,CAS_LATENCY_2,BURST_TYPE,BURST_LENGTH_8};
										end
										
	i_AUTOREFRESH			:			begin
										`DDR_COMMAND_REG	<=	AUTO_REFRESH;
										end
	
	i_WAIT_tRFC				:			begin
										`DDR_COMMAND_REG	<=	NOP;
										end
	
	i_MR_SET_2				:			begin
										`DDR_COMMAND_REG	<=	LOAD_MODE_REGISTER;
										ddr_ba_reg			<=	NORMAL_MODE_REG;
										ddr_addr_reg		<=	{NORMAL_OP_MODE,CAS_LATENCY_2,BURST_TYPE,BURST_LENGTH_8};
										wait_200us		<= 1;
										end
								
	i_READY					:			begin
	
	
	
	
		case(cmd_state)
		c_IDLE					:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
									
		c_ACTIVE				:		begin
										`DDR_COMMAND_REG	<=	ACTIVE;
										ddr_addr_reg		<=	ctrl_addr_row;
										ddr_ba_reg			<=	ctrl_ba;
										end
		
		c_WAIT_tRCD				:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		
		c_READ					:		begin
										`DDR_COMMAND_REG	<=	READ;
										ddr_addr_reg		<=	{3'b001,ctrl_addr_col};
										ddr_ba_reg			<=	ctrl_ba;
										end
									
		c_WAIT_CAS_LATENCY		:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		
		c_WAIT_END_OF_R_BURST	:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		
		c_WRITE					:		begin
										`DDR_COMMAND_REG	<=	WRITE;
										ddr_addr_reg		<=	{2'b00,1'b1,ctrl_addr_col};
										ddr_ba_reg			<=	ctrl_ba;
										end
		
		c_WAIT_END_OF_W_BURST	:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		
		c_WAIT_WRITE_RECOVERY	:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
									
		c_AUTOREFRESH			:		begin
										`DDR_COMMAND_REG	<=	AUTO_REFRESH;
										end
		
		c_WAIT_tRFC				:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		
		c_DONE					:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
										
		c_REFRESH_DONE			:		begin
										`DDR_COMMAND_REG	<=	NOP;
										end
		endcase
		end
	endcase
end


always@(negedge clk , negedge rst)begin
if(!rst)begin
	`DDR_COMMAND <= DESELECT;
	ddr_addr	<= 0;
	ddr_ba	<= 0;
	cke <= 0;
	end
else
	begin
	`DDR_COMMAND <= `DDR_COMMAND_REG;
	cke	<=	cke_reg;
	ddr_ba	<= ddr_ba_reg;
	ddr_addr	<= ddr_addr_reg;
	end
end

endmodule
