//	INITILIZATION SEQUENCE 
//	1 	-	ASSERT CE LOW 																										+------+----------+
//	2 	-	WAIT 200 us																									      	| Time | Duration |
//	3 	-	Bring CKE HIGH																									   	+------+----------+
//	4 	-	Issue NOP or DESELECT command																						| tRP  | 20 ns    | 	3
//	5 	-	Issue PRECHARGE ALL command 																						| tMRD | 15 ns    |		2
//	6 	-	Wait at least tRP time, during this time NOPs or DESELECT commands must be given									| tRFC | 75 ns    |		10
//	7 	-	Issue LOAD MODE REGISTER command to program the extended mode register                                              | tD   | 200 us   |     26667
//	8 	-	Wait at least tMRD time; during this time NOPs or DESELECT commands must be given									| tRCD | 20 ns	  |	    3
//	9	-	Issue LOAD MODE REGISTER command to program the normal mode register												+------+----------+
//	10	-	Wait at least tMRD time; during this time NOPs or DESELECT commands must be given
//	11 	-	Issue a PRECHARGE ALL command
//	12	-	Wait at least tRP time; during this time NOPs or DESELECT commands must be given
//	13	-	Issue an AUTO REFRESH command
//	14	-	Wait at least tRFC time; during this time NOPs or DESELECT commands must be given
//	15	-	Issue an AUTO REFRESH command
//	16	- 	Wait at least tRFC time; during this time NOPs or DESELECT commands must be given
//	17	-	LMR command to clear the DLL bit (set M8 = 0)
//	18	-	Wait at least tMRD time; during this time NOPs or DESELECT commands must be given
//	19	-	Wait At least 200 clock cycles
//speed grading sg75Z

module DDR_ctrl(
/*INPUTS*/		clk,
				rst,
				addr_strobe,
				sys_addr_row,
				sys_ba,
				sys_addr_col,
				rd_wr_req,
/*OUTPUTS*/		init_done,
				ctrl_busy,
				init_state,
				cmd_state,
				addr_to_dp,
				refresh_counter,
				counter,
				wren
				);



input  clk;
input rst;
input  addr_strobe;
input [12:0] sys_addr_row;
input [9:0] sys_addr_col;
input [1:0]  sys_ba;
input  rd_wr_req;

output init_done;
output ctrl_busy;
output [3:0] init_state;
output [3:0] cmd_state;
output [24:0] addr_to_dp;
output [9:0] refresh_counter;
output [14:0] counter;
output wren;


reg addr_strobe_reg;
reg init_done;
reg ctrl_busy;
reg AR_flag;
reg tD_flag;
reg rd_wr_req_during_refresh;
reg refresh_req_reg ;
reg refresh_req ;
reg rd_wr_req_reg;
reg rd_wr_req_backup;
reg wren ;


reg 	[12:0] 		sys_addr_row_reg;
reg 	[9:0] 		sys_addr_col_reg;
reg 	[1:0] 		sys_ba_reg;
reg		[3:0] 		init_state;
reg 	[14:0] 		counter;
reg 	[3:0]		cmd_counter;
reg 	[9:0] 		refresh_counter;
reg 	[1:0] 		MR_flag;
reg 	[3:0] 		cmd_state;
reg		[24:0]		 addr_to_dp;

`include "D:\DDR_parameters.v"

/*
parameter CAS_LATENCY	=	2;
parameter BURST_LENGTH	=	4;
parameter BURST_TYPE	=	0;
parameter SYS_CLK = 7.5;

parameter i_WAIT_200US	=	4'b0001;
parameter i_NOP			=	4'b0010;
parameter i_PRECHARGE	=	4'b0011;
parameter i_WAIT_tRP	=	4'b0100;
parameter i_EMR_SET		=	4'b0101;
parameter i_WAIT_tMRD	=	4'b0110;
parameter i_MR_SET		=	4'b0111;
parameter i_AUTOREFRESH	=	4'b1000;
parameter i_WAIT_tRFC	=	4'b1001;
parameter i_MR_SET_2	= 	4'b1010;
parameter i_READY		=	4'b1011;

parameter c_IDLE					=	4'b0001;
parameter c_REFRESH_DONE			=	4'b0010;
parameter c_ACTIVE					=	4'b0011;
parameter c_WAIT_tRCD				=	4'b0100;
parameter c_READ					=	4'b0101;
parameter c_WRITE					=	4'b0110;
parameter c_WAIT_CAS_LATENCY		=	4'b0111;
parameter c_WAIT_END_OF_R_BURST		=	4'b1000;
parameter c_WAIT_END_OF_W_BURST		=	4'b1001;
parameter c_AUTOREFRESH				=	4'b1010;
parameter c_NOP						=	4'b1011;
parameter c_DONE					=	4'b1100;
parameter c_WAIT_tRFC				=	4'b1101;
parameter c_WAIT_WRITE_RECOVERY		=	4'b1110;


/*
***********DONT FORGET TO UNCOMMENT THIS*********************
parameter tRP 			= 	20/SYS_CLK 	;
parameter tMRD 			= 	15/SYS_CLK - 1	;
parameter tRFC			= 	75/SYS_CLK - 1	;
parameter tRCD			=	20/SYS_CLK	;
parameter tWR			=	30/SYS_CLK - 1;
parameter init_200uS 	=	200000/SYS_CLK	;

parameter RERESH_INTERVAL	=	7850/SYS_CLK - 50;

parameter tRP 			= 	200/SYS_CLK 	;
parameter tMRD 			= 	150/SYS_CLK - 1	;
parameter tRFC			= 	750/SYS_CLK - 1	;
parameter tRCD			=	200/SYS_CLK	;
parameter tWR			=	300/SYS_CLK - 1;
parameter init_200uS 	=	200000/SYS_CLK	+ 1;

parameter RERESH_INTERVAL	=	7800/SYS_CLK - 1;
*/
//------------------INITILIZATION STATE MACHINE---------------------------------------------------------------------------------------------
always@(posedge clk,negedge rst)
begin
	if(!rst) begin
		init_state <= i_WAIT_200US;
		counter <= 0 ;
		init_done <= 0;
		MR_flag <= 0;
		AR_flag <= 0;
		tD_flag <= 0;
		end
	else
	case(init_state)	
	i_WAIT_200US				:		begin
										counter <= counter + 1;
										if(counter == init_200uS) begin
											counter <= 0;
											if(!tD_flag) init_state <= i_NOP;
											else	init_state <= i_READY;
											end
										end
										
	i_NOP						:		init_state <= i_PRECHARGE;
	
	i_PRECHARGE					:		init_state <= i_WAIT_tRP ;
	
	i_WAIT_tRP					:		begin
										counter <= counter + 1;
										if(counter == tRP)begin
											counter <= 0;
											if(!MR_flag) init_state <= i_EMR_SET;
											else init_state <= i_AUTOREFRESH;
											end
										end
	
	i_EMR_SET					:		init_state <= i_WAIT_tMRD ;
	
	i_WAIT_tMRD					:		begin
										counter <= counter + 1 ;
										if(counter == tMRD)
											begin
											counter <= 0;
											if(!MR_flag) init_state <= i_MR_SET;
											else if (MR_flag == 2'b01)  init_state <= i_PRECHARGE;
											else
												begin
												init_state <= i_WAIT_200US;
												tD_flag <= 1;
												end
											end
										end
	
	i_MR_SET					:		begin	
										init_state <= i_WAIT_tMRD;
										MR_flag <= 1;
										end
										
	i_AUTOREFRESH				:		init_state <= i_WAIT_tRFC;
	
	i_WAIT_tRFC					:		begin
										counter <= counter + 1;
										if(counter == tRFC )
											begin
											counter <= 0;
											if(!AR_flag) 
												begin 
												init_state <= i_AUTOREFRESH ;
												AR_flag <= 1;
												end
											else init_state <= i_MR_SET_2 ;
											end
										end
	
	i_MR_SET_2					:		begin
										init_state <= i_WAIT_tMRD ;
										MR_flag <= 2'b11;
										end
	
	i_READY						:		begin
										init_done <= 1;
										init_state <= i_READY;
										end
										
	default						: 		init_state <= i_NOP;
	
	endcase
	end

//--------------------------------REFRESH COUNTER------------------------------------------
always@(posedge clk,negedge rst)begin
if(!rst) 
	begin
	refresh_counter <= 0;
	refresh_req <= 0;
	end
else 
	begin
	if(init_done) 
		begin
		refresh_counter <= refresh_counter + 1;
		refresh_req <= 0 ;
		if(refresh_counter == RERESH_INTERVAL)
			begin
			refresh_counter <= 0 ;
			refresh_req <= 1 ;
			end
		end
	end
end

//----------------------REFRESH REQUEST GENERATION-----------------------------------------
always@(posedge clk,negedge rst)begin
if(!rst) refresh_req_reg <= 0;
else 
	begin
	if(init_done && refresh_req) refresh_req_reg <= 1;
	else if(cmd_state == c_REFRESH_DONE) refresh_req_reg <= 0 ;
	end
end
	


//----------------------SYSTEM ADDRESS AND RD/WR REQUEST LATCHING-----------------------------------------
always@(posedge clk,negedge rst)begin
if(!rst)
	begin
	addr_strobe_reg <= 1;
	sys_addr_row_reg <= 0;
	sys_addr_col_reg <= 0 ;
	sys_ba_reg <= 0 ;
	rd_wr_req_reg <= 0;
	addr_to_dp <= 0;
	rd_wr_req_backup <= 0;
	end
else 
	begin
	if(init_done) 
		begin
		addr_strobe_reg <= addr_strobe;
		rd_wr_req_reg <= rd_wr_req;
		sys_addr_row_reg <= sys_addr_row;
		sys_addr_col_reg <= sys_addr_col;
		sys_ba_reg	<= sys_ba;
		if(!addr_strobe_reg) 
			begin
			addr_to_dp <= {sys_ba_reg,sys_addr_row_reg,sys_addr_col_reg};
			rd_wr_req_backup <= rd_wr_req_reg;
			end 
		end
	end
end
//----------------------READ/WRITE REQUEST DURING REFRESH CHECKING-----------------------------------------
always@(posedge clk,negedge rst)begin
if(!rst)
	rd_wr_req_during_refresh <= 0;
else
	begin
	if(!refresh_req_reg) 
		rd_wr_req_during_refresh <= 0;
	else
		begin
		if(!addr_strobe_reg && refresh_req_reg)
			rd_wr_req_during_refresh <= 1 ;
		end
	end
end
//----------------------COMMANDS STATE MACHINE--------------------------------------------------------------------------------------------------------------------------------------
always@(posedge clk,negedge rst)begin
if(!rst)
	begin
	cmd_state <= c_IDLE;
	ctrl_busy <= 0;
	wren <= 0;
	cmd_counter <= 0 ;
	end
else
	begin
	case(cmd_state)
	
	c_IDLE						:					begin
													ctrl_busy <= 0;
													if(refresh_req_reg && init_done) 
														begin
														cmd_state <= c_AUTOREFRESH;
														ctrl_busy <= 1;
														end
													else if(init_done && (rd_wr_req_during_refresh || !addr_strobe_reg))
														begin
														cmd_state <= c_ACTIVE;
														ctrl_busy <= 1;
														end
													end
													
	
	c_ACTIVE					:					cmd_state <= c_WAIT_tRCD;
	
	
	c_WAIT_tRCD					:					begin
														cmd_counter <= cmd_counter + 1;
														if(cmd_counter == tRCD)
														begin
														cmd_counter <= 0;
														if(rd_wr_req_backup) cmd_state <= c_READ;
														else if(!rd_wr_req_backup) begin
																cmd_state <= c_WRITE;
																end
														end
													end
	
	
	c_READ						:					cmd_state <= c_WAIT_CAS_LATENCY;
	
	
	c_WAIT_CAS_LATENCY			:					begin
													cmd_counter <= cmd_counter + 1;
													if(cmd_counter == CAS_LATENCY - 1 )
														begin
														cmd_counter <= 0;
														cmd_state <= c_WAIT_END_OF_R_BURST ;
														end
													end
													
	
	c_WAIT_END_OF_R_BURST		:					begin
													cmd_counter <= cmd_counter + 1;
													if(cmd_counter == BURST_LENGTH - 1 )
														begin 
														cmd_counter <= 0 ;
														cmd_state <= c_DONE;
														end
													end
													
													
													
	c_WRITE						:					begin
													wren <= 1;
													cmd_state <= c_WAIT_END_OF_W_BURST;
													end
	
	
	c_WAIT_END_OF_W_BURST		:					begin
													cmd_counter <= cmd_counter + 1;
													if(cmd_counter == BURST_LENGTH - 1 )
														begin 
														cmd_counter <= 0 ;
														cmd_state <= c_WAIT_WRITE_RECOVERY;
														wren <= 0;
														end
													end
	
	
	c_WAIT_WRITE_RECOVERY		:					begin
													cmd_counter <= cmd_counter + 1;
													if(cmd_counter == tWR)begin
														cmd_counter <= 0 ;
														cmd_state <= c_DONE;
														end
													end
													
	c_AUTOREFRESH				:					cmd_state <= c_WAIT_tRFC;
	
	
	c_WAIT_tRFC					:					begin
													cmd_counter <= cmd_counter + 1;
													if(cmd_counter == tRFC )
														begin
														cmd_counter <= 0 ;
														cmd_state <= c_REFRESH_DONE;
														end
													end
													
	
	
	c_REFRESH_DONE				:					cmd_state <= c_IDLE;
	
	
	c_DONE						:					cmd_state <= c_IDLE;
	
	default						:					cmd_state <= c_IDLE;
	endcase
	end
end



endmodule
