`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 06:22:03 PM
// Design Name: 
// Module Name: pmod_sim
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


module pmod_sim(

    );
    
    parameter TEST0 = 8'b11111011; //test 0
    parameter TEST1 = 8'b10011001; //test 1
    parameter TEST2 = 8'b10000001; //test 2
    parameter TEST3 = 8'b10101011; //test 3
    
    reg SCLK;
    reg CS_N;
    reg [7:0] test_data;
    reg [7:0] expected_data;
    reg [1:0] test_mode;
    reg [7:0] holder;  //store bits in a 
    
    wire SDATA;
    integer j;
    
    always @(*) begin
        case (test_mode) 
        2'b00: begin test_data = TEST0; expected_data = TEST0; end
        2'b01: begin test_data = TEST1; expected_data = TEST1; end
        2'b10: begin test_data = TEST2; expected_data = TEST2; end
        2'b11: begin test_data = TEST3; expected_data = TEST3; end
        endcase
    end
    
    
    pmod dut1 (.SCLK(SCLK), .CS_N (CS_N), .test_data(test_data), .SDATA(SDATA));
    

    initial begin
    forever #500 SCLK = ~SCLK;  //period of 1000 ns for 1Mhz clk, 50% duty cycle
    end
    
    
    initial begin
    SCLK = 0;
    CS_N = 1;
    test_mode = 2'b00;
    j = 0;
    holder = 0;

    #5000;
    
    CS_N = 0;
    #(3000) //wait 3 clock cycles, to avoid 0s
    $display("Test %0d", test_mode);
    for (j = 0; j<8; j = j + 1) begin
        #(1000) //wait 1 clock cycle
        holder [7-j] = SDATA; //MSB first
    end
    if (holder == expected_data) begin
            $display ("Pass: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder,$realtime);
        end 
        else begin
            $display ("Fail: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder, $realtime);
        end
    
    #(5000)
    
    CS_N = 1;
    
    
    test_mode = 2'b01;

    #5000;
    
    CS_N = 0;
    #(3000) //wait 3 clock cycles, to avoid 0s
    $display("");
    $display("Test %0d", test_mode);
    for (j = 0; j<8; j = j + 1) begin
        #(1000) //wait 1 clock cycle
        holder [7-j] = SDATA; //MSB first
    end
    if (holder == expected_data) begin
            $display ("Pass: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder,$realtime);
        end 
        else begin
            $display ("Fail: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder, $realtime);
        end
    
    #(5000)
    
    CS_N = 1;
    
     
    test_mode = 2'b10;

    #5000;
    
    CS_N = 0;
    #(3000) //wait 3 clock cycles, to avoid 0s
    $display("");
    $display("Test %0d", test_mode);
    for (j = 0; j<8; j = j + 1) begin
        #(1000) //wait 1 clock cycle
        holder [7-j] = SDATA; //MSB first
    end
    if (holder == expected_data) begin
            $display ("Pass: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder,$realtime);
        end 
        else begin
            $display ("Fail: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder, $realtime);
        end
    
    #(5000)
    
    CS_N = 1;
     
    test_mode = 2'b11;

    #5000;
    
    CS_N = 0;
    #(3000) //wait 3 clock cycles, to avoid 0s
    $display("");
    $display("Test %0d", test_mode);
    for (j = 0; j<8; j = j + 1) begin
        #(1000) //wait 1 clock cycle
        holder [7-j] = SDATA; //MSB first
    end
    if (holder == expected_data) begin
            $display ("Pass: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder,$realtime);
        end 
        else begin
            $display ("Fail: Expected = %0b, Actual = %0b, Time = %0t", expected_data, holder, $realtime);
        end
    
    #(5000)

    $finish;
    
    end
    
endmodule
