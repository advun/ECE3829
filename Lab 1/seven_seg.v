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
// seven_seg_decoder
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input [3:0] displayD,
    input [3:0] displayC,
    input [3:0] displayB,
    input [3:0] displayA,
    input [3:0] buttonsLRUD,
    output reg [3:0] an,
    output [6:0] seg
    );
    
    
    reg [3:0] dispHolder;

    
    always @ (*) begin
        case(buttonsLRUD)//turns on display according to button press
            default: an = 4'b1111;  //no anode low (anode active low)
            
            4'b0001: begin //if button D pressed
                        an = 4'b1110;  //anode 0 low (D)
                        dispHolder = displayD; //display values for D
                     end
                     
            4'b0010: begin //if button U pressed
                        an = 4'b1101;  //anode 1 low (C)
                        dispHolder = displayC; //display values for C
                     end
            
            4'b0100: begin //if button R pressed
                        an = 4'b1011;  //anode 2 low (B)
                        dispHolder = displayB; //display values for B
                     end
                     
            4'b1000: begin //if button L pressed
                        an = 4'b0111;  //anode 3 low (A)
                        dispHolder = displayA; //display values for A
                     end
            endcase 
        end
            
    seven_seg_decoder cath_decoder (dispHolder, seg);  //convert displayed value to seven segment cathodes


endmodule 
