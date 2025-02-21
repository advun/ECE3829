`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 06:09:49 PM
// Design Name: 
// Module Name: pmod
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


module pmod(
    input SCLK, //1 Mhz clock
    input CS_N,  //chip select, active low
    input [7:0] test_data,
    output reg SDATA //3 0s, 8 bits of data, 4 0s
    );
    
    reg [14:0] output_data;
    reg [4:0] counter;
    
    initial begin
    output_data = 15'b0;
    counter = 0;
    end
    

    always @ (negedge SCLK) begin
        if (CS_N == 1) begin
            SDATA <= 1'bZ; // in tri-state
            counter <= 0;  //reset counter
            output_data <= {3'b0, test_data[7:0], 4'b0};  // Update on CS_N low
        end
        else if (counter < 15) begin
            SDATA <= output_data[14]; //output MSB
            output_data <= {output_data[13:0], 1'b0};  //shift output data to the left. new MSB
            counter <= counter + 1;
        end
        else begin
        SDATA <= 0;
        end
   end
   
   
endmodule
