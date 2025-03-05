`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 08:16:01 PM
// Design Name: 
// Module Name: drawMovingBlock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// draws a block that moves vertically down the screen, returning to the top afterwards
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drawMovingBlock(
    input btnL,
    input clk_25MHz,
    input reset_n,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    parameter colorRED = 12'b111100000000;
    parameter colorBLUE = 12'b000000001111;
    parameter colorBLACK = 12'b000000000000;
    
    parameter blockWIDTH = 32;
    parameter blockHEIGHT = 32;
    
    parameter MAX_COUNT = 12500000 - 1;  //2Hz clock from 25Mhz clock = 12.5 mill cycles 
    
    reg [10:0] block_y_position;   // Y position of the red block (initially at the top)
    reg [10:0] block_x_position = 320;   // X position (centered horizontally at 320)
    
    reg [23:0] count_value;
   
   //only updates every 0.5 sec so long as button is held
    assign update = (count_value == MAX_COUNT) && btnL; 
   
    //2Hz counter
    always @ (posedge clk_25MHz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            count_value <= 24'b0;
        end
        else if (count_value == (MAX_COUNT)) begin
            count_value <= 24'b0;
        end
        else begin
            count_value <= count_value + 24'b1;
        end
    end
    
    
    always @ (posedge clk_25MHz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            block_y_position <= 0; //reset to top if reset
        end
        else if (update) begin
            block_y_position <= block_y_position + blockHEIGHT;
            if (block_y_position + blockHEIGHT >= 480) begin //480 = height of screen
                block_y_position <= 0;  //reset to top if at bottom
            end
        end
    end
    
    
    always @(hcount or vcount)
    begin
        if (blank) //if outside display area:
            colorOut <= colorBLACK;  //set color to black, as stated in vga_controller_640_60.vhd
        else if (hcount >= block_x_position && hcount < block_x_position + blockWIDTH &&
                vcount >= block_y_position && vcount < block_y_position + blockHEIGHT)
            colorOut <= colorRED;
        else
            colorOut <= colorBLUE;
        end
endmodule
