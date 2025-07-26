`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 22:47:02
// Design Name: Transmitter Testbench
// Module Name: testbench_tx
// Project Name: UART Controller
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/* To test PISO Indivudually
module testbench;
	logic [7:0] din;
	logic clk, rst, dout, load_shift;
	
	PISO shift_register
	(
		.clk(clk),
		.rst(rst),
		.shift_load(load_shift),
		.d_in(din),
		.d_out(dout)
	);
	
	initial begin
		clk = 0;
		forever #5 clk = !clk;
	end
	
	initial begin
		din = 8'ha5;
		load_shift = 0;
		#5.5 load_shift = 1;
		din = 8'hz;
	end
	
	initial begin
		#90 $finish;
	end
	
endmodule
*/

module testbench_tx;
	logic [7:0] din;
	logic clk, tx_en, tx_out, tx_ready, data_valid;
	//logic [2:0] state;
	
	uart_tx transmitter
	(
		.tx_i_data(din),
		.tx_i_data_valid(data_valid),
		.tx_clk(clk),
		.tx_en(tx_en),
		.tx_o(tx_out),
		.tx_o_ready(tx_ready)
		//.state(state)
	);
	
	initial begin
		clk = 0;
		forever #5 clk = !clk;
	end
	
	initial begin
		tx_en = 1'b0;
		#30 tx_en = 1'b1;
		#20 din = 8'haa;
		data_valid = 1'b1;
		#50 din = 8'h19;
		data_valid = !data_valid;
		#110 data_valid = !data_valid;
	end
	
	initial begin
		#345 tx_en = 1'b0;
	end
	
	initial begin
		#400 $finish;
	end
	
endmodule