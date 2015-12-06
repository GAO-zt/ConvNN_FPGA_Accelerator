//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_layer_input_buffer(
//--input
	clk,
	rst_n,
	kernel_calc_fin,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	kernel_calc_fin;

input		[KERNEL_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output 		[`DATA_WIDTH-1:0]	data_out;	//	3

reg			[`DATA_WIDTH-1:0]	buffer [0:KERNEL_SIZE-1];		//	2[3] 32x2

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		{buffer[0],buffer[1]}	<=	KERNEL_SIZE*`DATA_WIDTH 'h0;
	end	
	else if (kernel_calc_fin) begin
		{buffer[0],buffer[1]}	<=	data_in;
	end
	else begin
		buffer[0]	<=	buffer[1];
		buffer[1]	<=  `DATA_WIDTH 'b0;
	end
end

assign	data_out	=	buffer[0];





`ifdef DEBUG

/* shortreal data_in_ob [INPUT_SIZE];
always @(data_in) begin
	data_in_ob[0]	=	$bitstoshortreal(data_in[(INPUT_SIZE-0)*`DATA_WIDTH-1:(INPUT_SIZE-1)*`DATA_WIDTH]);
	data_in_ob[1]	=	$bitstoshortreal(data_in[(INPUT_SIZE-1)*`DATA_WIDTH-1:(INPUT_SIZE-2)*`DATA_WIDTH]);
	data_in_ob[2]	=	$bitstoshortreal(data_in[(INPUT_SIZE-2)*`DATA_WIDTH-1:(INPUT_SIZE-3)*`DATA_WIDTH]);
	data_in_ob[3]	=	$bitstoshortreal(data_in[(INPUT_SIZE-3)*`DATA_WIDTH-1:(INPUT_SIZE-4)*`DATA_WIDTH]);
	data_in_ob[4]	=	$bitstoshortreal(data_in[(INPUT_SIZE-4)*`DATA_WIDTH-1:(INPUT_SIZE-5)*`DATA_WIDTH]);
	data_in_ob[5]	=	$bitstoshortreal(data_in[(INPUT_SIZE-5)*`DATA_WIDTH-1:(INPUT_SIZE-6)*`DATA_WIDTH]);	
end	
 */
shortreal buffer_ob[KERNEL_SIZE];
always @(*) begin
	 buffer_ob[0]=	$bitstoshortreal(buffer[0]);
	 buffer_ob[1] =	$bitstoshortreal(buffer[1]);
	 // buffer_in_ob[2] =	$bitstoshortreal(buffer[1][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 // buffer_in_ob[3] =	$bitstoshortreal(buffer[1][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
     // buffer_in_ob[4] =	$bitstoshortreal(buffer[2][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 // buffer_in_ob[5] =	$bitstoshortreal(buffer[2][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
end	 
	 
`endif

endmodule



	


