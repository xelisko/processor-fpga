`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2023 09:11:40
// Design Name: 
// Module Name: MouseBus
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


module MouseBus(
    // Standard signals
    input CLK,
    input RESET,
    // BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    // IO mouse
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    // interrupt signals
    output BUS_INTERRUPT_RAISE,
    input BUS_INTERRUPT_ACK
);

    parameter MouseBaseAddr = 8'hA0; // mouse base address in the memory map


    wire [7:0] BusDataIn;
    reg [7:0] Out;
    reg IOBusWE; // mouse write to bus enabler

    // If IOBusWE is high, drive data line. Otherwise, release data line
    assign BUS_DATA = IOBusWE ? Out : 8'hZZ;
    assign BusDataIn = BUS_DATA;


    wire [3:0] MouseStatus;
    wire [7:0] MouseX;
    wire [7:0] MouseY;
    wire SendInterrupt;

    MouseTransceiver mouse(
        // Standard signals
        .CLK(CLK),
        .RESET(RESET),
        // IO mouse
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        // Mouse info
        .MouseStatus(MouseStatus),
        .MouseX(MouseX),
        .MouseY(MouseY),
        .SendInterrupt(SendInterrupt)
    );


    // Clock the interrupt
    reg Interrupt; 

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin 
            Interrupt <= 1'b0;
        end
        else if (SendInterrupt) begin   //interrupt coming from the mouse
            Interrupt <= 1'b1;
        end
        else if (BUS_INTERRUPT_ACK) begin // clear the flag on ack
            Interrupt <= 1'b0;
        end
        else begin
            Interrupt <= Interrupt;
        end
    end 

    assign BUS_INTERRUPT_RAISE = Interrupt;


    reg [7:0] MouseInfo[2:0]; // 3 bytes

    // Refresh the stored values every CLK
    always @(posedge CLK) begin
        if ((BUS_ADDR >= MouseBaseAddr) & (BUS_ADDR < MouseBaseAddr + 8'h03)) begin // if mouse addressed
            if (BUS_WE) begin // if processor driving
                MouseInfo[BUS_ADDR[2:0]] <= BusDataIn; // lower 3 bits of the address
                IOBusWE <= 1'b0;
            end
            else begin
                MouseInfo[0] <= MouseInfo[0];
                MouseInfo[1] <= MouseInfo[1];
                MouseInfo[2] <= MouseInfo[2];
                IOBusWE <= 1'b1;
            end
        end
        else begin
            MouseInfo[0] <= {4'b0, MouseStatus};
            MouseInfo[1] <= MouseX;
            MouseInfo[2] <= MouseY;
            IOBusWE <= 1'b0;
        end
    end

    // Clocked output
    always @(posedge CLK) begin
        Out <= MouseInfo[BUS_ADDR[2:0]];
    end

endmodule
