`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 04:34:58 PM
// Design Name: 
// Module Name: light_sensor
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


module light_sensor #(parameter capture_rate = 1)(
    input clk_10Mhz, 
    input reset_n,
    input SDATA, //data from sensor
    output reg CS_N, //chip select, active low
    output reg [23:0] updatecount_value,
    output reg SCLK, //SClock, 1 Mhz clock
    output reg [7:0] data_out //8 bit output data from sensor
    );
    
    localparam max_updatecount = (10000000 / capture_rate) - 1; //determine how often to get data
    //reg [23:0] updatecount_value;
    
    wire get_data;
    
    assign get_data = (updatecount_value == max_updatecount); //get data at max count
    
    //counter for capture rate
    always @ (posedge clk_10Mhz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            updatecount_value <= 24'b0;
        end
        else if (updatecount_value == (max_updatecount)) begin
            updatecount_value <= 24'b0;
        end
        else begin
            updatecount_value <= updatecount_value + 24'b1;
        end
    end
    
    /*
    localparam max_sclkcount = 4-1; //2.5 Mhz clock for Sclk
    reg [3:0] sclk_value;
    
    wire rising_edge;  //flag for rising edge
    wire falling_edge;  //flag for falling edge
    
    assign rising_edge = ((sclk_value == 0) ? 1'b1 : 1'b0);  //rising edge = 1 at cnt 0, 0 else
    assign falling_edge = ((sclk_value == 2) ? 1'b1 : 1'b0); //falling edge = 1 at cnt 5, 0 else
    
    //counter for rising and falling edges
    always @ (posedge clk_10Mhz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            sclk_value <= 4'b0;
        end
        else if (sclk_value == (max_sclkcount)) begin
            sclk_value <= 4'b0;
        end
        else begin
            sclk_value <= sclk_value + 4'b1;
        end
    end
    
   
    //SCLK logic, inverts every 500ns (500*2 = 1000 ns = 1Mhz)
    always @(*) begin
        if (rising_edge == 1) begin
            SCLK <= 1'b1;
        end
        if (falling_edge == 1) begin
            SCLK <= 1'b0;
        end
    end

*/
    
    localparam STATE_IDLE = 3'b000;
    localparam STATE_WAIT = 3'b001;
    localparam STATE_READ0 = 3'b010;
    localparam STATE_READ1 = 3'b011;
    localparam STATE_READ2 = 3'b100;
    localparam STATE_READ3 = 3'b101;
    localparam STATE_DONE = 3'b110;
    
    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [14:0] hold_data;
    reg [3:0] data_counter;
    
    //state changing logic
    always @ (posedge clk_10Mhz) begin
    
        if (reset_n == 1'b0) begin
            current_state <= STATE_IDLE;
        end
        else begin
            current_state <= next_state;
        end
    
    end
    
    always @ (*) begin
        case (current_state)
        
            STATE_IDLE: begin               
                if (get_data == 1'b1) begin
                    next_state <= STATE_WAIT;
                    data_counter <= 4'b0;
                end
                else begin
                    next_state <= STATE_IDLE;
                end
            end
            
            STATE_WAIT: begin 
                CS_N <= 1'b0;  //Chip select low
                next_state <= STATE_READ0;
            end
            
            
            STATE_READ0: begin //SDATA changes (neg edge)
                next_state <= STATE_READ1; //wait 1 clock cycle, so not reading on same cycle as SDO changes
                SCLK <= 1'b0;  //set SCLK to 0 (neg edge of sclk)
            end
            
            STATE_READ1: begin //read in SDATA
                hold_data <= {hold_data[13:0], SDATA}; //shift
                data_counter <= data_counter + 1;  //tick up data counter
                
                next_state <= STATE_READ2;
            end
            
            STATE_READ2: begin //wait 1 cycle (posedge)
                 next_state <= STATE_READ3;
                 SCLK <= 1'b1; //set SCLK to 1 (pos edge of sclk)
            end
            
            STATE_READ3: begin //wait 1 cycle
                
                if (data_counter == 15)begin 
                    next_state <= STATE_DONE;
                end
                else begin
                    next_state <= STATE_READ0;
                end
            
            end
            
            STATE_DONE: begin
            CS_N <= 1'b1; //Chip select high
            data_out <= hold_data[11:4];  //only output data, not leading or lagging 0s
            next_state <= STATE_IDLE;
            end
            
            default: begin
            next_state <= STATE_IDLE;
            end
            
        endcase
    end
    
    
    
    
    
    
endmodule
