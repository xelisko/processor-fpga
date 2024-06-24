`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 11:51:29
// Design Name:  
// Module Name: TOP
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

 
module TOP(
    // Standard signals
    input CLK,
    input RESET,
    // IO Mouse
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    //Buttons
    input [3:0] COMMAND,
    //Switches
    input [1:0] SWITCH,
    // 7-Seg display
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT,
    // LED
    output [7:0] LEDH,
    output [7:0] LEDL,
    //IR LED signal out
    output IR_LED,
    // VGA signals
    output [7:0] VGA_COLOUR,
    output VGA_HS,
    output VGA_VS
    
    
);

    // Main bus
    wire [7:0] BUS_ADDR;
    wire [7:0] BUS_DATA;
    wire BUS_WE;

    // ROM bus
    wire [7:0] ROM_ADDRESS;
    wire [7:0] ROM_DATA;

    // Interrupt
    wire [1:0] BUS_INTERRUPT_RAISE;
    wire [1:0] BUS_INTERRUPT_ACK;
    
    assign ROM_ADDRESS_ILA =  ROM_ADDRESS;
    assign ROM_DATA_ILA = ROM_DATA;
    assign BUS_ADDR_ILA = BUS_ADDR;
    assign BUS_DATA_ILA = BUS_DATA;
    assign BUS_WE_ILA = BUS_WE;

//ila_0 your_instance_name (
//	.clk(CLK), // input wire clk


//	.probe0(ROM_ADDRESS_ILA), // input wire [7:0]  probe0  
//	.probe1(ROM_DATA_ILA), // input wire [7:0]  probe1 
//	.probe2(BUS_ADDR_ILA), // input wire [7:0]  probe2 
//	.probe3(BUS_DATA_ILA), // input wire [7:0]  probe3 
//	.probe4(BUS_WE_ILA) // input wire [0:0]  probe4
//);
    Processor CPU(
        // Standard signals
        .CLK(CLK),
        .RESET(RESET),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // ROM bus signals
        .ROM_DATA(ROM_DATA),
        .ROM_ADDRESS(ROM_ADDRESS),
        // Interrupt signals
        .BUS_INTERRUPTS_RAISE(BUS_INTERRUPT_RAISE),
        .BUS_INTERRUPTS_ACK(BUS_INTERRUPT_ACK)
    );
    
        // IR transmitter wrapper
    IRTransmitter IR(
        .CLK(CLK),
        .RESET(RESET),
        .IR_LED(IR_LED),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );
    
    // switches wrapper
    Switches SWITCHES(
        //standard signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // switches
        .SWITCH(SWITCH)
    );
    
        // buttons wrapper
    Buttons BUTTONS(
        //standard signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // switches
        .COMMAND(COMMAND)
        );
        
    RAM MEM_DATA(
        // Standard signals
        .CLK(CLK),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );

    ROM MEM_INST(
        // Standard signals
        .CLK(CLK),
        // ROM bus signals
        .DATA(ROM_DATA),
        .ADDR(ROM_ADDRESS)
    );

    Timer TIMER(
        // Standard signals
        .CLK(CLK),
        .RESET(RESET),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // Interrupt signals
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPT_RAISE[1]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPT_ACK[1])
    );



    MouseBus MOUSE(
        // Standard signals
        .CLK(CLK),
        .RESET(RESET),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // IO mouse
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        // Interrupt signals
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPT_RAISE[0]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPT_ACK[0])
    );

    SevSegDisBus DISPLAY(
        // Standard signals
        .CLK(CLK),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // Display
        .HEX_OUT(HEX_OUT),
        .SEG_SELECT_OUT(SEG_SELECT_OUT)
    );

    LedBus LED(
        // Standard signals
        .CLK(CLK),
        .RESET(RESET),
        // Main bus signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // LED
        .LEDH(LEDH),
        .LEDL(LEDL)
    );
    // VGA moduule, Address: B0(x address), B1(y adress), B2(Pixel data in, Buffer write enable), B3(Color)
    VGA_Controller VGA_Controller(
        // Standard signals
        .CLK(CLK), 
        .RESET(RESET),
        // BUS signals
        .BUS_ADDR(BUS_ADDR), 
        .BUS_DATA(BUS_DATA),
        .BUS_WE(BUS_WE),
        // VGA outputs
        .VGA_COLOUR(VGA_COLOUR), 
        .VGA_HS(VGA_HS), 
        .VGA_VS(VGA_VS)
        ); 
endmodule
