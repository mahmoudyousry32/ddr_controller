


parameter CAS_LATENCY	=	2;
parameter BURST_LENGTH	=	4;
parameter BURST_TYPE	=	1'b0;
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



parameter tRP 			= 2;	//20/SYS_CLK 	;
parameter tMRD 			= 1	;//15/SYS_CLK - 1	;
parameter tRFC			= 9;	//75/SYS_CLK - 1	;
parameter tRCD			= 2	;//20/SYS_CLK	;
parameter tWR			= 4;	//30/SYS_CLK - 1;
parameter init_200uS 	= 26666;	//200000/SYS_CLK	;
parameter RERESH_INTERVAL	= 996;	//7850/SYS_CLK - 50;

parameter DESELECT				=		4'b1000;
parameter NOP					=		4'b0111;
parameter ACTIVE				=		4'b0011;
parameter READ					=		4'b0101;
parameter WRITE					=		4'b0100;
parameter PRECHARGE				=		4'b0010;
parameter AUTO_REFRESH			=		4'b0001;
parameter LOAD_MODE_REGISTER	=		4'b0000;

parameter NORMAL_OP_MODE_DLL	=		6'b000010;
parameter NORMAL_OP_MODE		=		6'b000000;
parameter CAS_LATENCY_2			=		3'b010;
parameter BURST_LENGTH_8		=		3'b011;
parameter NORMAL_MODE_REG		=		2'b00;
parameter EXTENDED_MODE_REG		=		2'b01;
parameter NORMAL_DRIVE_STRENGTH	=		1'b0;
parameter DLL_ENABLE			=		1'b0;

