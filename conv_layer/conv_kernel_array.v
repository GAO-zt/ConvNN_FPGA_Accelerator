//
module conv_kernel_array(	
	//--input
	clk,
	rst_n,
	i_pixel_bus,
	i_weight,
	current_state,
	
	//--output
	o_pixel_bus
	
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	STAGE_INIT			=	3'd0;
parameter	STAGE_PRELOAD		=	3'd1;	
parameter	STAGE_ROW_0			=	3'd2;
parameter	STAGE_ROW_1			=	3'd3;
parameter	STAGE_ROW_2			=	3'd4;
parameter	STAGE_BIAS			=	3'd5;
parameter	STAGE_LOAD			=	3'd6;
parameter	STAGE_IDLE			=	3'd7;

input 							clk;
input							rst_n;
input	[ARRAY_SIZE*WIDTH-1:0]	i_pixel_bus;
input	[WIDTH-1:0]				i_weight;
input	[2:0]					current_state;

output	[ARRAY_SIZE*WIDTH-1:0]	o_pixel_bus;

wire	[WIDTH-1:0]				i_pixel_0_0;
wire	[WIDTH-1:0]				i_pixel_0_1;
wire	[WIDTH-1:0]				i_pixel_0_2;
wire	[WIDTH-1:0]				i_pixel_0_3;
wire	[WIDTH-1:0]				i_pixel_0_4;
wire	[WIDTH-1:0]				i_pixel_0_5;

wire	[WIDTH-1:0]				o_pixel_0_0;
wire	[WIDTH-1:0]				o_pixel_0_1;
wire	[WIDTH-1:0]				o_pixel_0_2;
wire	[WIDTH-1:0]				o_pixel_0_3;
wire	[WIDTH-1:0]				o_pixel_0_4;
wire	[WIDTH-1:0]				o_pixel_0_5;

reg								output_flag;
reg								output_flag_delay_0;
reg								output_flag_delay_1;
reg								output_flag_delay_2;

reg								clear;
reg								clear_delay_0;
reg								clear_delay_1;
reg								clear_delay_2;

// distribute the bus line to each kernel
assign	i_pixel_0_0	=	i_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH];
assign	i_pixel_0_1	=	i_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH];
assign	i_pixel_0_2	=	i_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH];
assign	i_pixel_0_3	=	i_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH];
assign	i_pixel_0_4	=	i_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH];
assign	i_pixel_0_5	=	i_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH];

// assign	o_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_0 : 32'b0;
// assign	o_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_1 : 32'b0;
// assign	o_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_2 : 32'b0;
// assign	o_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_3 : 32'b0;
// assign	o_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_4 : 32'b0;
// assign	o_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH]	=  (output_flag_delay_2)? o_pixel_0_5 : 32'b0;

assign	o_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH]	=  o_pixel_0_0;
assign	o_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH]	=  o_pixel_0_1;
assign	o_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH]	=  o_pixel_0_2;
assign	o_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH]	=  o_pixel_0_3;
assign	o_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH]	=  o_pixel_0_4;
assign	o_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH]	=  o_pixel_0_5;

//	clock delay
/* always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		output_flag	<=	0;
	else if(current_state == STAGE_ROW_0)
		output_flag	<=	1;
	else if(current_state == STAGE_ROW_1)
		output_flag	<=	1;
	else if(current_state == STAGE_ROW_2)
		output_flag	<=	1;
	else if(current_state == STAGE_BIAS)
		output_flag	<=	1;
	else
		output_flag	<=	0;
end */
		
/* always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		output_flag_delay_0	<= 0;
		output_flag_delay_1 <= 0;
		output_flag_delay_2 <= 0;
	end
	else begin
		output_flag_delay_0	<=	output_flag;
		output_flag_delay_1	<=	output_flag_delay_0;
		output_flag_delay_2	<=	output_flag_delay_1;
	end
end */

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		clear	<=	0;
	else if(current_state == STAGE_BIAS)
		clear	<=	1;
	else
		clear	<=	0;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		clear_delay_0	<=	0;
		clear_delay_1	<=	0;
		clear_delay_2	<=	0;
	end
	else begin
		clear_delay_0	<=	clear;
		clear_delay_1	<=	clear_delay_0;
		clear_delay_2	<=	clear_delay_1;
	end
end
		
conv_kernel U_conv_kernel_0_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),
	.i_pixel	(i_pixel_0_0),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_0)
);

conv_kernel U_conv_kernel_0_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),	
	.i_pixel	(i_pixel_0_1),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_1)
);

conv_kernel U_conv_kernel_0_2(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),
	.i_pixel	(i_pixel_0_2),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_2)
);

conv_kernel U_conv_kernel_0_3(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),
	.i_pixel	(i_pixel_0_3),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_3)
);

conv_kernel U_conv_kernel_0_4(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),
	.i_pixel	(i_pixel_0_4),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_4)
);

conv_kernel U_conv_kernel_0_5(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_2),
	.i_pixel	(i_pixel_0_5),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_5)
);

//	array_1

/* conv_kernel U_conv_kernel_1_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_0),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_1),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_2(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_2),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_3(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_3),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_4(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_4),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_5(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_5),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
); */

endmodule