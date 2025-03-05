`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 11:53:23 PM
// Design Name: 
// Module Name: typing
// Project Name: 
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


module typing(
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    parameter colorBLACK = 12'b000000000000;

    wire [11:0] letter0;
    wire [11:0] letter1;
    wire [11:0] letter2;
    wire [11:0] letter3;
    
    letter l0 (0, hcount, vcount, blank, letter0);
    letter l1 (1, hcount, vcount, blank, letter1);
    letter l2 (2, hcount, vcount, blank, letter2);
    letter l3 (3, hcount, vcount, blank, letter3);
    
    always @ (hcount or vcount)
    begin
            if (blank) // if outside display area
            colorOut <= colorBLACK;  // set color to black

            
            else begin
            colorOut <= (letter0 | letter1 | letter2 | letter3); //combine letters
            end
        end
    
endmodule
