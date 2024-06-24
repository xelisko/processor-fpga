`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2023 22:56:01
// Design Name: 
// Module Name: LED_TB
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


module LED_TB(

);

    reg CLK;
    reg RESET;
    reg [7:0] BusAddr;
    reg [7:0] BusData; // LED is pure output, use reg for inputting to LED
    reg BusWE;
    wire [7:0] LEDH;
    wire [7:0] LEDL;

    LedBus uut(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_ADDR(BusAddr),
        .BUS_DATA(BusData),
        .BUS_WE(BusWE),
        .LEDH(LEDH),
        .LEDL(LEDL)
    );


    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        RESET = 1'b1;
        BusAddr = 8'hFF; // CPU state on reset
        BusWE = 1'b0; // CPU not writing

        #100    RESET = 1'b0;
        #100    BusAddr = 8'hC0; // addressing low byte
                BusWE = 1'b1;
                BusData = 8'hFF;
        #10     BusAddr = 8'hFF;
                BusWE = 1'b0;

        #50     BusAddr = 8'hC1; // addressing high byte
                BusWE = 1'b1;
                BusData = 8'hF0;
        #10     BusAddr = 8'hFF;
                BusWE = 1'b0;

        #100000
        $finish;
    end
endmodule
