`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2023 23:15:18
// Design Name: 
// Module Name: DIPSLAY_TB
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

module DISPLAY_TB();

    reg CLK;
    reg [7:0] BusAddr;
    wire [7:0] BusData;
    reg BusWE;
    wire [3:0] SEG_SELECT_OUT;
    wire [7:0] HEX_OUT;

    SevSegDisBus uut(
        .CLK(CLK),
        .BUS_ADDR(BusAddr),
        .BUS_DATA(BusData),
        .BUS_WE(BusWE),
        .SEG_SELECT_OUT(SEG_SELECT_OUT),
        .HEX_OUT(HEX_OUT)
    );

    reg [7:0] BusDataBuf; // declare a reg buffer for BusData

    assign BusData = BusWE ? BusDataBuf : 8'bz; // assign BusData based on BusWE

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        BusAddr = 8'hFF; // CPU state on reset
        BusWE = 1'b0; // CPU not writing

        #150    BusAddr = 8'hD0; // addressing left byte
                BusWE = 1'b1;
                BusDataBuf = 8'hFF; // write 8'hFF to left byte
        #30     BusAddr = 8'hFF;
                BusWE = 1'b0;

        #80     BusAddr = 8'hD1; // addressing right byte
                BusWE = 1'b1;
                BusDataBuf = 8'hF0; // write 8'hF0 to right byte
        #40     BusAddr = 8'hFF;
                BusWE = 1'b0;

        #1000
        $finish;
    end
endmodule