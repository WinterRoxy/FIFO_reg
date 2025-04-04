`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:39:35 07/06/2024 
// Design Name: 
// Module Name:    FIFO_register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module reg_FIFO #(parameter width = 32, depth = 16)(
    input [depth - 1:0] data_in,
    input r_en, w_en, reset, clk,
    output [depth - 1:0] data_out,
    output empty, full, 
	 output [5:0] count_1
);
	assign count_1 = count;
    reg [depth - 1:0] reg_state;
    reg [depth - 1:0] reg_file [width - 1 : 0];
    reg empty_flag = 1, full_flag = 0;
    reg [5:0] count = 6'b0;
	reg [4:0] r_ptr = 5'b0 , w_ptr = 5'b0 ;
    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            w_ptr <= 5'b0;
            r_ptr <= 5'b0;
            count <= 6'b0;
				reg_state <= 16'bx;
        end
		  else begin
		  casex({r_en, w_en, full_flag, empty_flag})			
				   4'b010x, 4'b1101: begin // write
								reg_file[w_ptr] <= data_in;
								count <= count + 1'b1;
								w_ptr <= w_ptr + 1'b1;
								if (w_ptr == width - 1'b1) begin
										w_ptr <= 5'b0;
									end
								end
					4'b10x0, 4'b1110:	begin // read
								if(count == 0)begin									
								end
								else begin
									reg_state <= reg_file[r_ptr];
									count <= count - 1'b1;
									r_ptr <= r_ptr + 1'b1;
									if (r_ptr == width - 1'b1) begin
											r_ptr <= 5'b0;
										end
									end
								end
					4'b1100: begin //read and write
							  reg_file[w_ptr] <= data_in;
							  reg_state <= reg_file[r_ptr];
							  w_ptr <= w_ptr + 1'b1;
							  r_ptr <= r_ptr + 1'b1;
							  if (w_ptr == width - 1'b1) begin
										w_ptr <= 5'b0;
									end
							  if (r_ptr == width - 1'b1) begin
										r_ptr <= 5'b0;
									end
							  end					 
					default:begin end							  
        endcase
		  end
		end

    always @(posedge clk) begin
        if (count == 0) begin
            empty_flag = 1'b1;
            full_flag = 1'b0;
        end 
		  else if (count >= width) begin
            full_flag = 1'b1;
            empty_flag = 1'b0;
        end 
		  else begin
            empty_flag = 1'b0;
            full_flag = 1'b0;
        end
    end
    assign empty = (reset)? 1'b1 : empty_flag;
    assign full = (reset)?1'b0 : full_flag;
    assign data_out = (reset)? 16'bx: reg_state;
endmodule
