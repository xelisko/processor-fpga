`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2023 19:09:57
// Design Name: 
// Module Name: SevSegDisBus
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


module SevSegDisBus(
    //Clock signal
    input CLK,
    //BUS Signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    //SevenSeg      
    output wire [3:0] SEG_SELECT_OUT,
    output wire [7:0] HEX_OUT
    );
    reg	[15:0] Seg7; 
    // Top Address is 0xD1
    // Stores 2*8 bits of data
    parameter BaseAddr = 8'hD0; 
    parameter AddrWidth = 1; 
    
    SevenSegmentDisplay display ( 
        .CLK(CLK),
            
        // Actual display values
        .DIGIT1(Seg7[11:8]), //4MSB Y Coordinates	
        .DIGIT2(Seg7[15:12]),//4LSB Y Coordinates	
        .DIGIT3(Seg7[3:0]),  //4MSB X Coordinates	
        .DIGIT4(Seg7[7:4]),  //4LSB X Coordinates	
        .HEX_OUT(HEX_OUT),
        .SEG_SELECT_OUT(SEG_SELECT_OUT)
    );
    
  
     
    //Tristate
    wire [7:0] BusDataIn;
    reg [7:0] Out;
    reg IOBusWE;
        
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (IOBusWE) ? Out : 8'hZZ;
    assign BusDataIn = BUS_DATA;
    
    //Memory
    reg [7:0] Mem [(2**AddrWidth)-1:0];
    
    always@(posedge CLK) begin
        // Get current SegSeven data from bus interface memory
        Seg7[7:0] <= Mem[0]; // Left 2 Seg7 Displays
        Seg7[15:8] <= Mem[1]; // Right 2 Seg7 Displays
    
        // find if this Device is being targeted
        if((BUS_ADDR >= BaseAddr) & (BUS_ADDR < BaseAddr + 2**AddrWidth)) begin
            if(BUS_WE) begin
                // The 2 lower bits of the address will specify the offset to this memory
                Mem[BUS_ADDR[1:0]] <= BusDataIn;
                IOBusWE <= 1'b0;
            end else
                IOBusWE <= 1'b1;
        end else
            IOBusWE <= 1'b0;
        
        // The 2 lower bits of the address will specify the offset to this memory
        Out <= Mem[BUS_ADDR[1:0]];
    end
endmodule
