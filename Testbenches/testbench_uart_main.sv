`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 28.06.2025 23:42:43
// Design Name: Main Testbench
// Module Name: testbench_uart_main
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


module testbench_uart_main(
    );
    logic clk, enable; //Baud Generator
    //Transmitter
    logic [7:0] tx_input_data;
    logic tx_input_data_valid, tx_en, tx_output_data, tx_output_ready;
    //Receiver
    logic rx_en, rx_output_data_valid, rx_data;
    logic [7:0] rx_output_data;
    
    uart_main 
    	#(.ClkFreq_t(10_000_000), .BaudRate(115200), .ClkFreq_r(10_000_000)) 
    	uart(
			.clk(clk),
			.enable(enable),
			.tx_input_data(tx_input_data),
			.tx_input_data_valid(tx_input_data_valid),
			.tx_en(tx_en),
			.tx_output_data(tx_output_data), 
			.tx_output_ready(tx_output_ready),
			.rx_data(rx_data),
			.rx_en(rx_en),
			.rx_output_data_valid(rx_output_data_valid),
			.rx_output_data(rx_output_data)
		);
		
	assign rx_data = tx_output_data;
    
    initial begin
		clk = 0;
		forever #5 clk = !clk;
	end
	
	initial begin
		enable = 0;
		tx_en = 0;
		rx_en = 0;
		#50 enable = !enable;
		tx_en = !tx_en;
		#20 tx_input_data = 8'hdf; //1101_1111
		tx_input_data_valid = 1;
		//Parity = 0;
		#10300 tx_input_data_valid = 0;
		#10310 tx_input_data = 8'hbf; //1101_1111
		tx_input_data_valid = 1;
		//Parity = 1
	end
	
	initial begin
	   #905 rx_en = !rx_en;
	end
    
    //To test the receiver individually
    /*initial begin
        rx_data = 1; //IDLE State
    	#1405 rx_data = 1;//Test Bit
    	#800 rx_data = 1;//Test Bit
    	#800 rx_data = 0;//Start Bit
    	//Input Data : ce
    	#800 rx_data = 1;//Bit0
    	#800 rx_data = 1;//Bit1
    	#800 rx_data = 0;//Bit2
    	#800 rx_data = 0;//Bit3
    	#800 rx_data = 1;//Bit4
    	#800 rx_data = 1;//Bit5
    	#800 rx_data = 1;//Bit6
    	#800 rx_data = 0;//Bit7
    	#800 rx_data = 1;//Parity Bit
    	#800 rx_data = 1;//Stop Bit
    	#1600 rx_data = 1;//Test Bit
    	#800 rx_data = 1;//Test Bit
    	#800 rx_data = 1;//Test Bit
    	#800 rx_data = 0;//Start Bit
    	//Input Data : aa
    	#800 rx_data = 1;//Bit0
    	#800 rx_data = 0;//Bit1
    	#800 rx_data = 1;//Bit2
    	#800 rx_data = 0;//Bit3
    	#800 rx_data = 1;//Bit4
    	#800 rx_data = 0;//Bit5
    	#800 rx_data = 1;//Bit6
    	#800 rx_data = 0;//Bit7
    	#800 rx_data = 0;//Parity Bit
    	#800 rx_data = 0;//Error Stop Bit
    	#1600 rx_data = 1;//Stop Bit
    	#800 rx_data = 0;//Start Bit
    	#50 $finish;
    end*/
    
endmodule


