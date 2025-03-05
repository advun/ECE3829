`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 03:57:15 PM
// Design Name: 
// Module Name: drawFullscreen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// displays a blank yellow screen
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drawFullscreen(
    input [11:0] colorIn,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    parameter colorBLACK = 12'b000000000000;
    
    always @(hcount or vcount)
    begin
        if (blank) //if outside display area:
            colorOut <= colorBLACK;  //set color to black, as stated in vga_controller_640_60.vhd
        else
            colorOut <= colorIn;
    end
    
    
endmodule
