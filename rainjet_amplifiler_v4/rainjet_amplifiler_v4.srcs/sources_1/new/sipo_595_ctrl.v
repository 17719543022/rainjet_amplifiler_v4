module sipo_595_ctrl (
		clk,
		rst_n,

		trigger_595,
		dl_num,

		// SN74HC595PW serial-in, parallel-out control
		FPGA_DOUT_OE, 
		FPGA_DOUT_LCK,
		FPGA_DOUT_RST,
		FPGA_DOUT_SCK,
		FPGA_DOUT_SIN
	);

	input             clk;
	input             rst_n;
	input [ 7:0]      dl_num;
	input             trigger_595;

	output            FPGA_DOUT_OE;
	output            FPGA_DOUT_LCK;
	output            FPGA_DOUT_RST;
	output            FPGA_DOUT_SCK;
	output            FPGA_DOUT_SIN;

	parameter         DOUT_WIDTH = 40;
	parameter         DIV_UNIT = 16;
	parameter         DIV_WIDTH = 4;

	reg               FPGA_DOUT_SCK;
	reg               FPGA_DOUT_LCK;

	reg  [15:0]       digital_output_state_cnt;
	wire [15:0]       digital_output_bit_index = digital_output_state_cnt[15:DIV_WIDTH];
	wire [15:0]       digital_output_basic_cnt = digital_output_state_cnt[DIV_WIDTH-1:0];
	reg               shift_point;
	reg               shift_point_pre;
	wire [63:0]       digital_595_SIN;
	reg  [63:0]       shift_register;

    dl_num_convert dl_num_convert (
		.clk                           (clk),
	    .dl_num                        (dl_num),
	    .dl_index                      (digital_595_SIN)
	);

	always @(posedge clk)
	if (trigger_595)
	    shift_register <= digital_595_SIN;
	else if (shift_point)
	    shift_register <= {1'b0, shift_register[63:1]};

	always @(posedge clk)
	begin
	    shift_point <= shift_point_pre;
	    shift_point_pre <= (digital_output_basic_cnt == 'd1);
	end

	always @(posedge clk)
	if (~rst_n)
	    digital_output_state_cnt <= 'd0;
	else if (trigger_595)
	    digital_output_state_cnt <= (DOUT_WIDTH+2)*DIV_UNIT - 1;
	else if (digital_output_state_cnt != 'd0)
	    digital_output_state_cnt <= digital_output_state_cnt - 'd1;

	always @(posedge clk)
	if (~rst_n)
	    FPGA_DOUT_LCK <= 1'b0;
	else if (digital_output_bit_index == 'd1)
	begin
	    case (digital_output_basic_cnt)
	        DIV_UNIT/2 + 'd1 : FPGA_DOUT_LCK <= 1'b1;
	        'd1              : FPGA_DOUT_LCK <= 1'b0;
	    default : ;
	    endcase
	end

	always @(posedge clk)
	if (~rst_n)
	    FPGA_DOUT_SCK <= 1'b0;
	else if (digital_output_bit_index > 'd1)
	begin
	    case (digital_output_basic_cnt)
	        DIV_UNIT/2 + 'd1 : FPGA_DOUT_SCK <= 1'b1;
	        'd1              : FPGA_DOUT_SCK <= 1'b0;
	    default : ;
	    endcase
    end
	
	assign FPGA_DOUT_OE = 1'b0;
	assign FPGA_DOUT_RST = 1'b1;
	assign FPGA_DOUT_SIN = shift_register[0];





endmodule
