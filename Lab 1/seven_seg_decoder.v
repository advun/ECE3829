`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2025 04:39:57 PM
// Design Name: CW
// Module Name: seven_seg_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Decodes numbers into cooresponding cathode assignments for a seven segment display
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_decoder(
    input [3:0] ABCD,
    input [6:0] abcdefg
    );
    
    always @ (*)  //all values are flipped, as cathodes have to be low to turn on LED
        case(buttons)
            default: abcdefg = 7'b1111111;
            4'b0000: abcdefg = 7'b0000001;  //0
            4'b0001: abcdefg = 7'b1001111;  //1
            4'b0010: abcdefg = 7'b0010010;  //2
            4'b0011: abcdefg = 7'b0000110;  //3
            4'b0100: abcdefg = 7'b1001100;  //4
            4'b0101: abcdefg = 7'b0100100;  //5
            4'b0110: abcdefg = 7'b0100000;  //6
            4'b0111: abcdefg = 7'b0001111;  //7
            4'b1000: abcdefg = 7'b0000000;  //8
            4'b1001: abcdefg = 7'b0001100;  //9
            4'b1010: abcdefg = 7'b0001000;  //A
            4'b1011: abcdefg = 7'b1100000;  //B
            4'b1100: abcdefg = 7'b0110001;  //C
            4'b1101: abcdefg = 7'b1000010;  //D
            4'b1110: abcdefg = 7'b0110000;  //E
            4'b1111: abcdefg = 7'b0111000;  //F
        endcase
endmodule
