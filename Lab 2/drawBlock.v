`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 07:08:54 PM
// Design Name: 
// Module Name: drawBlock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// draws a square in the top right corner with a black screen
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drawBlock(
    input [11:0] colorIn,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    parameter colorBLACK = 12'b000000000000;
    parameter Ycoord = 128;
    parameter Xcoord = 511;
    
    always @(hcount or vcount)
    begin
        if (blank) //if outside display area:
            colorOut <= colorBLACK;  //set color to black, as stated in vga_controller_640_60.vhd
        else if ((hcount > Xcoord) & (vcount < Ycoord))
            colorOut <= colorIn;
        else
            colorOut <= colorBLACK;
        end
    
endmodule
