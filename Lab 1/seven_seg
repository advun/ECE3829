`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2025 02:53:08 PM
// Design Name: CW
// Module Name: seven_seg 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// turns on displays and updates displays
// Dependencies: 
// none
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input [3:0] buttons,
    input [3:0] dispA,
    input [3:0] dispB,
    input [3:0] dispC,
    input [3:0] dispD,
    output reg [3:0] an,
    output [6:0] seg
    );
    
    wire [3:0] dispHolder;
    
    always @ (*)
        case(buttons)//turns on display according to button press
            default: an = 4'b1111;  //no anode low
            4'b0001: an = 4'b1110;  //anode 0 low
            4'b0010: an = 4'b1101;  //anode 1 low
            4'b0100: an = 4'b1011;  //anode 2 low
            4'b1000: an = 4'b0111;  //anode 3 low
            endcase 
            
            
            
    seven_seg_decoder cath_decoder (dispHolder, seg);  


endmodule 
