`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 22.06.2025 22:14:47
// Design Name: Main Module
// Module Name: uart_main
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


module uart_main #(parameter ClkFreq_t = 10_000_000, ClkFreq_r = 10_000_000, BaudRate = 115200)
	(
		input clk, // Core Clock
		input enable, //Reset
		//Transmitter Ports
		input [7:0] tx_input_data, // Parallel Data Input
		input tx_input_data_valid, // Input Data Valid
		input tx_en, //Transmitter Enable
		output reg tx_output_data, //Serial Data Output
		output reg tx_output_ready, //Transmitter can accept data
		//Receiver Ports
		input rx_data, //Serial Data Input
		input rx_en, //Enable Receiver
		output reg [7:0] rx_output_data, //Output Data
		output reg rx_output_data_valid //Output Data Valid
    );
    
    reg [3:0] count, state;
    reg tx_clk, rx_clk;
    
    //Clock Generator
    //wire tx_clk, rx_clk;
    baudgenerator 
    	#(.ClkFreq_t(ClkFreq_t), .ClkFreq_r(ClkFreq_r), .BaudRate(BaudRate))
    	clockgenerator (
    		.t_clk(tx_clk),
    		.r_clk(rx_clk),
    		.g_clk(clk),
    		.enable(enable)
    	);
    
    //Transmitter
    uart_tx transmitter(
    	.tx_i_data(tx_input_data),
    	.tx_i_data_valid(tx_input_data_valid),
    	.tx_clk(tx_clk),
    	.tx_en(tx_en),
    	.tx_o_ready(tx_output_ready),
    	.tx_o(tx_output_data)
    );
    
    //Receiver
    uart_rx receiver(
    	.i_rx(rx_data),
    	.rx_clk(rx_clk),
    	.rx_en(rx_en),
    	.rx_o_data(rx_output_data),
    	.rx_o_data_valid(rx_output_data_valid),
    	.count(count),
    	.state(state)
    );
    
    /*uart_rx recevier(
    	.i_rx(input_data),
    	.rx_clk(rx_clk),
    	.rx_en(receiver_enable),
    	.rx_o_data_valid(output_valid),
    	.rx_o_data(output_data)
    );
    
    baudgenerator 
    	#(.ClkFreq_t(10_000_000), .ClkFreq_r(10_000_000), .BaudRate(115200))
    	clockgenerator (
    		.r_clk(rx_clk),
    		.g_clk(clk),
    		.rstn(rstn)
    	);*/
    
    
endmodule