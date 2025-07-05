`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 22.06.2025 14:58:14
// Design Name: Baud Pulse Generator Testbench
// Module Name: testbench_baudgenerator
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


module testbench_baudgenerator;
	logic t_clk, r_clk;
	logic clk, rstn;
	
	baudgenerator #(.ClkFreq_t(10_000_000), .BaudRate(115200), .ClkFreq_r(10_000_000)) Baud(
					.enable(rstn),
					.g_clk(clk),
					.t_clk(t_clk),
					.r_clk(r_clk)
					);
	
	initial begin
		clk = 0;
		forever #5 clk = !clk;
	end
	
	initial begin
		rstn = 0;
		#7 rstn = 1;
		$monitor($time, " Global Clock = %0b		Transmitter Clock = %0b\n", clk, t_clk);
		$monitor($time, " Global Clock = %0b		Receiver Clock = %0b\n", clk, r_clk);
	end
	
endmodule
