`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 07:20:46 PM
// Design Name: 
// Module Name: drawStripe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// draws a horizontal blue stripe along the bottom of the screen
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drawStripe(
    input [11:0] colorIn,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    
    parameter colorBLACK = 12'b000000000000;
    parameter ycoord = 447;
    
    always @(hcount or vcount)
    begin
        if (blank) //if outside display area:
            colorOut <= colorBLACK;  //set color to black, as stated in vga_controller_640_60.vhd
        else if (vcount > ycoord)
            colorOut <= colorIn;
        else
            colorOut <= colorBLACK;
        end
        
        
endmodule
