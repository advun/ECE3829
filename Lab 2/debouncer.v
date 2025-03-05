`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 09:50:24 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// debounces input buttons and switches
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(
    input in,
    input clk_25MHz,
    input reset_n,
    output reg out
    );
    
    parameter MAX_COUNT = 250000 - 1; //10 ms @25Mhz is 250000 cycles
    
    reg [18:0] count_value; 
    reg in1, in2; //two synchronizers to avoid metastability
    
    always @ (posedge clk_25MHz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            count_value <= 19'b0;
            out <= in;
            in1 <= 0;
            in2 <= 0;
        end
        
        else begin
            in1 <= in;
            in2 <= in1;
            
            
            if (in1 != in2) begin //reset if input changes
                count_value <= 19'b0;
            end
            else if (count_value == MAX_COUNT) begin
                count_value <= 19'b0;
                out <= in2; //reset counter and set out = in
            end
            else begin//tick up counter
                count_value <= count_value + 19'b1;
            end
       end
   end
    
endmodule
