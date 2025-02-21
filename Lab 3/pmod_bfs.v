`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 02:31:13 PM
// Design Name: 
// Module Name: pmod_bfs
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


module pmod_bfs(
    input SCLK, //1 Mhz clock
    input CS_N,  //chip select, active low
    output reg SDATA, //3 0s, 8 bits of data, 4 0s
    output reg [2:0] state,  //current state
    output reg [3:0] i  //counting variable for place in output
    );
    
   parameter STATE0 = 000;  //state 0, output data_out[7:0]
   parameter STATE1 = 001;  //state 1, output data_out[15:8]
   parameter STATE2 = 010; //state 2, output data_out[23:16]
   parameter STATE3 = 011; //state 3, output data_out[31:24]
   parameter LEADING0 = 100; //3 leading 0s for data output
   parameter LAGGING0 = 101; //4 lagging 0s for data output
   parameter IDLE = 110;

   wire [7:0] data_out0;
   wire [7:0] data_out1;
   wire [7:0] data_out2;
   wire [7:0] data_out3;
   reg [2:0] next_state; 
   reg [1:0] next_out;  //next output set
  
   assign data_out0[7:0] = 8'b11111011; //state 0 output
   assign data_out1[7:0] = 8'b10011001; //state 1 output
   assign data_out2[7:0] = 8'b10000001; //state 2 output
   assign data_out3[7:0] = 8'b10101011; //state 3 output
   
   
   initial begin
   i = 0; 
   next_state = IDLE; 
   state = IDLE; 
   end
   
   always @ (negedge SCLK) begin
    state = next_state;
   end
   
   
   always @ (negedge SCLK) begin
            case (state)
            
            IDLE: begin
            SDATA <= 1'b0; //output = 0
            next_state <= CS_N ? IDLE : LEADING0;
            end
            
            LEADING0: begin //3 leading 0s
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = 1'b0;
                i = i + 1;
                if (i == 3) begin
                    next_state <= CS_N ? IDLE : next_out;
                end
            end
            
            STATE0: begin
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = data_out0[i-3];  //output i-3'th value
                i = i+1; //increment i
                if (i == 11) begin
                    next_out <= STATE1;
                    next_state <= CS_N ? IDLE : LAGGING0;
                end
            end
            
            STATE1: begin
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = data_out1[i-3];  //output i-3'th value
                i = i+1; //increment i
                if (i == 11) begin
                    next_out <= STATE2;
                    next_state <= CS_N ? IDLE : LAGGING0;
                end
            end
            
            STATE2: begin
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = data_out2[i-3];  //output i-3'th value
                i = i+1; //increment i
                if (i == 11) begin
                    next_out <= STATE3;
                    next_state <= CS_N ? IDLE : LAGGING0;
                end
            end
            
            STATE3: begin
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = data_out3[i-3];  //output i-3'th value
                i = i+1; //increment i
                if (i == 11) begin
                    next_out <= STATE0;
                    next_state <= CS_N ? IDLE : LAGGING0;
                end
            end
            
            LAGGING0: begin
                #40;  //wait 40 ns, to simulate Data Access Time
                SDATA = 1'b0;
                i = i + 1;
                if (i == 15) begin
                    next_state <= CS_N ? IDLE : LEADING0;
                    i <= 0;
                end
            end
           
           default: next_state <= IDLE;
            
           endcase
        end
        
    
    
    
endmodule
