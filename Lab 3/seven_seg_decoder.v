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
    output reg [6:0] abcdefg
    );
    
    always @ (*) begin //all values are flipped, as cathodes have to be low to turn on LED
        case(ABCD)
            default: abcdefg = 7'b1111111;
            4'b0000: abcdefg = 7'b1000000;  //0
            4'b0001: abcdefg = 7'b1111001;  //1
            4'b0010: abcdefg = 7'b0100100;  //2
            4'b0011: abcdefg = 7'b0110000;  //3
            4'b0100: abcdefg = 7'b0011001;  //4
            4'b0101: abcdefg = 7'b0010010;  //5
            4'b0110: abcdefg = 7'b0000010;  //6
            4'b0111: abcdefg = 7'b1111000;  //7
            4'b1000: abcdefg = 7'b0000000;  //8
            4'b1001: abcdefg = 7'b0011000;  //9
            4'b1010: abcdefg = 7'b0001000;  //A
            4'b1011: abcdefg = 7'b0000011;  //B
            4'b1100: abcdefg = 7'b1000110;  //C
            4'b1101: abcdefg = 7'b0100001;  //D
            4'b1110: abcdefg = 7'b0000110;  //E
            4'b1111: abcdefg = 7'b0001110;  //F
        endcase
     end
     
endmodule