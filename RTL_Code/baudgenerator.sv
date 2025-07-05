`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 22.06.2025 11:52:13
// Design Name: Baud Pulse Generator
// Module Name: baudgenerator
// Project Name: UART Controller
// Target Devices: 
// Tool Versions: 
// Description: The Baud Rate has to be kept constant for both, the core clock frequency for each can be different for different devices.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baudgenerator
	#(parameter ClkFreq_t, ClkFreq_r, BaudRate)
	(
    output logic 	t_clk,
    output logic 	r_clk,
    input  logic 	g_clk,
    input  logic 	enable
    );
    
    logic [7:0] r_count, t_count;
    logic [7:0] B_t, B_r;
    
    assign B_r = (((ClkFreq_r/BaudRate)/16)-1); //Value of Receiver clock for the specific core clock frequency and baud rate
    assign B_t = ((ClkFreq_t/BaudRate) - 1); //Value of Transmitter Clock for the specific core clock frequency and baud rate
    
    //For Transmitter Clock
    always@(posedge g_clk) begin
    	if (!enable) begin
    		t_count <= 0;
    		t_clk <= 0;
    	end
    	else begin
    		t_clk <= 0;
    		t_count <= t_count + 1;
    		if (t_count == B_t) begin
    			t_clk <= 1;
    			t_count <= 0;
    		end
    	end
    end
    
    //For Receiver Clock
    always@(posedge g_clk) begin
    	if (!enable) begin
    		r_count <= 0;
    		r_clk <= 0;
    	end
    	else begin
    		r_clk <= 0;
    		r_count <= r_count + 1;
    		if (r_count == B_r) begin
    			r_clk <= 1;
    			r_count <= 0;
    		end
    	end
    end
    
    
endmodule

