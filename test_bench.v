`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:45:04 07/06/2024
// Design Name:   FIFO_register
// Module Name:   C:/Users/milug/OneDrive/Desktop/ise/FIFO_reg/test_bench.v
// Project Name:  FIFO_reg
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIFO_register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_bench;
    // Inputs
    reg [15:0] data_in;
    reg r_en;
    reg w_en;
    reg reset;
    reg clk;

    // Outputs
    wire [15:0] data_out;
    wire empty;
    wire full;
	 wire [5:0] count;
    // Instantiate the Unit Under Test (UUT
    reg_FIFO #(.width(32), .depth(16)) uut (
        .data_in(data_in), 
        .r_en(r_en), 
        .w_en(w_en), 
        .reset(reset), 
        .clk(clk), 
        .data_out(data_out), 
        .empty(empty), 
        .full(full),
		  .count_1(count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end
	integer i, j, k, f;

    initial begin
        data_in = 0;
        r_en = 0;
        w_en = 0;
        reset = 0;
		  //reset
        reset = 1;
        #200;
        reset = 0;
        #200;
        // write
        for (i = 0; i < 32; i = i + 1) begin
            data_in = i;
            w_en = 1;
            #100;
            w_en = 0;
            #100;
        end

        // read 
        for (j = 0; j < 32; j = j + 1) begin
            r_en = 1;
            #100;
            r_en = 0;
            #100;
        end
			
        // read and write
        for (k = 0; k < 32; k = k + 1) begin
            data_in = k;
            r_en = 1;
            w_en = 1;
            #100;
            r_en = 0;
            w_en = 0;
            #100;
        end
		  data_in = 23;
		  w_en = 1;
		  r_en = 0;
		  #100;
		  data_in = 32;
		  w_en = 1;
		  r_en = 1;
		  #100;
		  data_in = 13;
		  w_en = 0;
		  r_en = 1;
		  reset = 1;
		  #100;
		  data_in = 13;
		  reset = 0;
		  w_en = 1;
		  for (f = 0; f < 32; f = f + 1) begin
            data_in = k;
            r_en = 1;
            w_en = 1;
            #100;
            r_en = 0;
            w_en = 0;
            #100;
        end
		  // write
        for (i = 0; i < 32; i = i + 1) begin
            data_in = i;
            w_en = 1;
            #100;
            w_en = 0;
            #100;
        end
		  #100; 
		  reset = 1;
		  #100;
		  reset = 0;
		  r_en = 1;
		  data_in = 23;
		  w_en = 1;
		  r_en = 0;
		  #100;
		  data_in = 32;
		  w_en = 1;
		  #50;
		  r_en = 0;
		  #50;
		  data_in = 13;
		  w_en = 1;
		  #100;
		  w_en = 0;
		  r_en = 1;
		  #100;
		  r_en = 0;
		  for (i = 0; i < 32; i = i + 1) begin
            data_in = i;
            w_en = 1;
            #100;
            w_en = 0;
            #100;
        end
		  r_en = 1;
    end
endmodule
