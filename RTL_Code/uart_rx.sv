`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nilanjan Chowdhury
// 
// Create Date: 22.06.2025 22:14:47
// Design Name: UART Receiver
// Module Name: uart_rx
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

/*********************************
			Receiver
**********************************/
module uart_rx(
	input i_rx, // Serial Data In
	input rx_clk, //Receiver Clock
	input rx_en, //Enable Receiver
	output reg [7:0] rx_o_data, //Output Data
	output reg rx_o_data_valid, //Data Valid
	output reg [3:0] count, state
    );
    
    reg rx_done;
    reg [2:0] next;
    reg [7:0] rx_data;
    reg parity, data_valid;
    
    
    
    //SIPO Instantiation
    reg [2:0] SIPO_count;
    reg [7:0] SIPO_dout;
    reg SIPO_en;
    SIPO register(
    				.din(i_rx),
    				.en(SIPO_en),
    				.clk((&count)),
    				.dout(SIPO_dout)
    );
    
    //State Declaration
    parameter IDLE = 3'h0, DATA_START = 3'h1, DATA_IN = 3'h2, DATA_PARITY = 3'h3, DATA_STOP = 3'h4;
    
    
    // Combinational state transition logic
    always @(*) begin
        next = state;
        if (rx_en) begin
            case (state)
                IDLE:
                    next = (!i_rx) ? DATA_START : IDLE;

                DATA_START:
                    next = (count == 4'h7) ? ((!i_rx) ? DATA_IN : IDLE) : DATA_START;

                DATA_IN: begin
                    next = rx_done ? DATA_PARITY : DATA_IN;
                    parity = ^rx_o_data;
                end
                DATA_PARITY:
                    next = (count == 4'hf) ? DATA_STOP : DATA_PARITY;

                DATA_STOP:
                    next = (count == 4'hf) ? IDLE : DATA_STOP;

                default:
                    next = IDLE;
            endcase
        end else begin
            next = IDLE;
        end
    end

    // Generate SIPO enable
    always_comb begin
        SIPO_en = (state == DATA_START || state == DATA_IN);
    end

    // Main sequential block
    always_ff @(posedge rx_clk) begin
        if (!rx_en) begin
            count            <= 4'h0;
            state            <= IDLE;
            SIPO_count       <= 4'h0;
            rx_o_data_valid  <= 1'b0;
            rx_o_data        <= 8'h00;
            rx_done          <= 1'b0;
            data_valid       <= 1'b0;
            parity           <= 1'b0;
        end else begin
            state <= next;

            // Count logic
            if (state != next)
                count <= 4'h0;
            else
                count <= count + 1;

            // Sample and shift in data during DATA_IN
            if (state == DATA_IN && count == 4'hf)
                SIPO_count <= SIPO_count + 1;

            // Load received byte
            if (state == DATA_IN && SIPO_count == 3'd7 && count == 4'hf) begin
                rx_o_data <= SIPO_dout;
                rx_done   <= 1'b1;
            end else begin
                rx_done <= 1'b0;
            end

            // Parity check
            if (state == DATA_PARITY && count == 4'hf) begin
                data_valid  <= (i_rx == parity);
            end

            // Stop bit check and final valid signal
            if (state == DATA_STOP && count == 4'hf && i_rx && data_valid)
                rx_o_data_valid <= 1'b1;
            else if (state == IDLE)
                rx_o_data_valid <= 1'b0;

            // Reset SIPO count outside of DATA_IN
            if (state != DATA_IN)
                SIPO_count <= 4'h0;
        end
    end


    
endmodule

module SIPO(
	input din,
	input en,
	input clk,
	output reg [7:0] dout
	);
	genvar i;
	
	generate
		for (i = 0; i <= 7; i++) begin
			if (i == 0)
				single_SIPO first_SIPO(
							.din(din),
							.en(en),
							.dout(dout[i]),
							.clk(clk)
				);
			else
				single_SIPO successive_SIPO(
							.din(dout[i-1]),
							.en(en),
							.dout(dout[i]),
							.clk(clk)
				);
		end
	endgenerate
	
	
endmodule

module single_SIPO(
	input din,
	input en,
	input clk,
	output reg dout
	);
	
	always @(posedge clk) begin
		if (en) begin
			dout <= din;
		end
		else begin
			dout <= 1'b0;
		end
	end
	
endmodule