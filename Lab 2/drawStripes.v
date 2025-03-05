`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 06:52:49 PM
// Design Name: 
// Module Name: drawStripes
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// displays red and white stripes along the screen
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drawStripes(
    input [11:0] colorIn0,
    input [11:0] colorIn1,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    parameter colorBLACK = 12'b000000000000;
    parameter stripWidth = 16;  //width of strips

    always @ (hcount or vcount) 
    begin
    if (blank) //if outside display area:
            colorOut <= colorBLACK;  //set color to black, as stated in vga_controller_640_60.vhd
    else if ((hcount / stripWidth) % 2  == 0)  //if strip number is even
            colorOut <= colorIn1;
    else //if strip number is odd
            colorOut <= colorIn0;
    end
    
    
endmodule
