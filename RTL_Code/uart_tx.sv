`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 22.06.2025 22:14:47
// Design Name: UART Transmitter
// Module Name: uart_tx
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

/*********************************************
				Transmitter
***********************************************/
module uart_tx
(
    input [7:0] tx_i_data, //Parallel Data
    input tx_i_data_valid, //Input Data Valid
    input tx_clk, //Transmitter Clock
    input tx_en, //Synchronous Active Low Reset
    output reg tx_o_ready, //Transmitter ready to accept byte to be transmitted
    output reg tx_o //Serial Data Output
    //output logic [2:0] state
);
    
    reg [2:0] state; 
    reg [2:0] next; 
    reg [7:0] transmit_data;
    reg tx_done, parity;
    reg [3:0] count;
    
    reg [7:0] PISO_din;
    reg PISO_shift_load;
    wire PISO_dout;
    
    //PISO Instantiation
    PISO shift_reg
    				(
    					.d_in(PISO_din),
    					.shift_load(PISO_shift_load),
    					.rst(!tx_en),
    					.clk(tx_clk),
    					.d_out(PISO_dout)
    				);
    
    //State Declaration
    parameter IDLE = 3'h0, DATA_START = 3'h1, DATA_OUT = 3'h2, PARITY = 3'h3, DATA_STOP = 3'h4, RESET = 3'h5;
    
    //State Transition Logic
    always@(*) begin
    	case (state)
    		IDLE : begin
    			next = tx_i_data_valid ? DATA_START : IDLE;
    		end
    		DATA_START : begin
    			next = tx_clk ? DATA_OUT : DATA_START;
    		end
    		DATA_OUT : begin
    			next = (count == 7) ? PARITY : DATA_OUT;
    		end
    		PARITY : begin
    			next = (tx_o == parity)  ? DATA_STOP : PARITY;
    		end
    		DATA_STOP : begin
    			next = tx_done ? RESET : DATA_STOP;
    		end
    		RESET : begin
    			next = !transmit_data ? IDLE : RESET;
    		end
    		default : begin
    			next = IDLE;
    		end
    	endcase
    end
    	
    //Output Logic
    always @(*) begin
    	if(!tx_en) begin
    		tx_o_ready = 1'b0;
    		tx_o = 1'b0;
    	end
    	else begin
    		case (state)
    		
    			//IDLE State: Drive serial output pin High and if the data is valid, load the 8 bit data into a register
    			IDLE : begin
    				tx_o = 1'b1;
    				tx_o_ready = 1'b1;
    				if (tx_i_data_valid) begin
    					transmit_data = tx_i_data;
    					PISO_din = transmit_data;
    				end
    			end
    			
    			//DATA_START State: Send out a start bit (0) to indicate the start of data transmission
    			DATA_START : begin
    				tx_o = 1'b0;
    				PISO_shift_load = 1'b0;
    			end
    			
    			//DATA_OUT State: Send the data
    			DATA_OUT : begin
    				PISO_shift_load = 1'b1;
    				tx_o = PISO_dout;
    				parity = ^transmit_data;
    			end
    			
    			//PARITY State: Send a parity bit
    			PARITY : begin
    				tx_o = parity;
    				count = 1'b0;
    			end
    			
    			//DATA_STOP State: Send out a stop bit (1) to indicate the end of data transmission
    			DATA_STOP : begin
    				tx_o = 1'b1;
    				tx_done = 1'b1;
    			end
    			
    			//RESET State: Reset all the elements for a fresh new data
    			RESET : begin
    				count = 0;
    				transmit_data = 0;
    				PISO_din = 0;
    				tx_o = 1'b1;
    			end
    		endcase
    	end
    end
    
    //Clocked Logic
    always @(posedge tx_clk) begin
    	if (!tx_en) begin
    		state <= IDLE;
    		count <= 1'b0;
    	end
    	else begin
    		state <= next;
    		if (state == DATA_OUT)
    			count <= count + 1;
    		else
    			count <= 1'b0;
    	end
    end
    
endmodule



module PISO
(
	input [7:0] d_in,
	input shift_load,
	input rst,
	input clk,
	output reg d_out
);
	logic [7:0] q;
	
	genvar i;
	
	generate 
		for (i = 0; i < 8; i++) begin
			if (i == 0) begin : first_PISO
				Single_PISO PISO0 
				(
					.din(0),
					.dinnext(d_in[i]),
					.shift_load(shift_load),
					.rst(rst),
					.clk(clk),
					.dout(q[i])
				);
			end
			else begin : successive_PISO
				Single_PISO PISO1	
				(
					.din(q[i-1]),
					.dinnext(d_in[i]),
					.shift_load(shift_load),
					.rst(rst),
					.clk(clk),
					.dout(q[i])
				);
			end
		end
	endgenerate
	
	assign d_out = q[7];
	
endmodule

module Single_PISO(
	input din,
	input dinnext,
	input shift_load,
	input rst,
	input clk,
	output reg dout
);

	always @(posedge clk) begin
		if (rst)
			dout <= 0;
		else
			dout <= ((din & shift_load) | (dinnext & !shift_load));
	end
endmodule
