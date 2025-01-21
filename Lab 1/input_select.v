`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2025 02:53:08 PM
// Design Name: CW
// Module Name: input_select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// input selecter, calculates what data to display for each display
// Dependencies: 
// none
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module input_select(
    input [15:0] sw,
    output reg [3:0] displayA,
    output reg [3:0] displayB,
    output reg [3:0] displayC,
    output reg [3:0] displayD
    );
    
    wire times2[4:0], sum[4:0];
    assign times2 = sw[13:8]<<1;
    assign sum = sw[7:4] + sw[3:0];
    
    always @ (sw)
        case(sw[15:14])
            2'b00: begin //case 0: last 4 of ID
                    displayA = 4'b0111; //7
                    displayB = 4'b0100; //4
                    displayC = 4'b0100; //4
                    displayD = 4'b0001; //1          
                    end
                    
            2'b01:  begin //case 1: values in hex
                    displayA = sw[13:12];
                    displayB = sw[11:8];
                    displayC = sw[7:4];
                    displayD = sw[3:0];            
                    end
                    
            2'b10:  begin  //case 2
                    displayA = sw[13:12];
                    displayB = sw[11:8];
                    displayC = times2[4];
                    displayD = times2[3:0];            
                    end
                    
            2'b11:  begin  //case 3
                    displayA = sw[7:4];
                    displayB = sw[3:0];
                    displayC = sum[4];
                    displayD = sum[3:0];            
                    end
        endcase
    
    
    
    
endmodule
