`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 27.06.2025 18:30:30
// Design Name: Receiver Testbench
// Module Name: testbench_rx
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


module testbench_rx(

    );
    /* To test SIPO Individually
    //SIPO Testbench
    logic din, clk, en;
    logic [7:0] dout;
    
    SIPO shift_reg(
    				.din(din),
    				.en(en),
    				.clk(clk),
    				.dout(dout)
    );
    
    initial begin
    	clk = 1'b0;
    	forever #5 clk = !clk;
    end
    
    initial begin
    	en = 0;
    	#7 en = 1;
    	#5  din = 0;
    	#10 din = 1;
    	#10 din = 0;
    	#10 din = 1;
    	#10 din = 0;
    	#10 din = 0;
    	#10 din = 1;
    	#10 din = 1;
    	#30 $finish;
    end
    //End of SIPO Testbench
    */
    
    
    //RX TestBench
    logic input_data, clk, receiver_enable;
    logic output_valid, enable, rx_clk, SIPO_en;
    logic [7:0] output_data, SIPO_dout;
    logic [3:0] count;
    logic [2:0] state, SIPO_count;
    
    uart_rx recevier(
    	.i_rx(input_data),
    	.rx_clk(rx_clk),
    	.rx_en(receiver_enable),
    	.rx_o_data_valid(output_valid),
    	.rx_o_data(output_data)
    );
    
    initial begin
    	rx_clk = 1'b0;
    	forever #5 rx_clk = !rx_clk;
    end
    
    initial begin
    	receiver_enable = 0;
    	enable = 1'b0;
    	#7 enable = 1'b1;
    	receiver_enable = 1; 
    end
    
    //For rx_clk with 10_000_000Hz clock and 115200mbits/s baud
    /*initial begin
    	input_data = 1; //IDLE State
    	#1405 input_data = 1;//Test Bit
    	#800 input_data = 1;//Test Bit
    	#800 input_data = 0;//Start Bit
    	//Input Data : ce
    	#800 input_data = 1;//Bit0
    	#800 input_data = 1;//Bit1
    	#800 input_data = 0;//Bit2
    	#800 input_data = 0;//Bit3
    	#800 input_data = 1;//Bit4
    	#800 input_data = 1;//Bit5
    	#800 input_data = 1;//Bit6
    	#800 input_data = 0;//Bit7
    	#800 input_data = 1;//Parity Bit
    	#800 input_data = 1;//Stop Bit
    	#1600 input_data = 1;//Test Bit
    	#800 input_data = 1;//Test Bit
    	#800 input_data = 1;//Test Bit
    	#800 input_data = 0;//Start Bit
    	//Input Data : aa
    	#800 input_data = 1;//Bit0
    	#800 input_data = 0;//Bit1
    	#800 input_data = 1;//Bit2
    	#800 input_data = 0;//Bit3
    	#800 input_data = 1;//Bit4
    	#800 input_data = 0;//Bit5
    	#800 input_data = 1;//Bit6
    	#800 input_data = 0;//Bit7
    	#800 input_data = 0;//Parity Bit
    	#800 input_data = 0;//Error Stop Bit
    	#1600 input_data = 1;//Stop Bit
    	#800 input_data = 0;//Start Bit
    	#50 $finish;
    end*/
    
    initial begin
    	input_data = 1; //IDLE State
    	#20 input_data = 1;//Test Bit
    	#50 input_data = 1;//Test Bit
    	#30 input_data = 0;//Start Bit
    	//Input Data : ce
    	#165 input_data = 1;//Bit0
    	#165 input_data = 1;//Bit1
    	#165 input_data = 0;//Bit2
    	#165 input_data = 0;//Bit3
    	#165 input_data = 1;//Bit4
    	#165 input_data = 1;//Bit5
    	#165 input_data = 1;//Bit6
    	#165 input_data = 0;//Bit7
    	#165 input_data = 1;//Parity Bit
    	#165 input_data = 1;//Stop Bit
    	#330 input_data = 1;//Test Bit
    	#165 input_data = 1;//Test Bit
    	#165 input_data = 1;//Test Bit
    	#165 input_data = 0;//Start Bit
    	//Input Data : aa
    	#165 input_data = 1;//Bit0
    	#165 input_data = 0;//Bit1
    	#165 input_data = 1;//Bit2
    	#165 input_data = 0;//Bit3
    	#165 input_data = 1;//Bit4
    	#165 input_data = 0;//Bit5
    	#165 input_data = 1;//Bit6
    	#165 input_data = 0;//Bit7
    	#165 input_data = 0;//Parity Bit
    	#165 input_data = 0;//Error Stop Bit
    	#330 input_data = 1;//Stop Bit
    	#165 input_data = 0;//Start Bit
    	#50 $finish;
    end
    
    
endmodule


