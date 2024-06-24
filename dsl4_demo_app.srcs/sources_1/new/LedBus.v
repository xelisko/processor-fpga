`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2023 15:32:49
// Design Name: 
// Module Name: LedBus
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

  
module LedBus(
    // Standard signals
input CLK,
input RESET,
// BUS signals
input [7:0] BUS_DATA,
input [7:0] BUS_ADDR, 
input BUS_WE,
// LEDs 
output reg [7:0] LEDH,   //left hand side LEDs
output reg [7:0] LEDL   //right hand side LEDs
);

parameter LEDBaseAddr = 8'hC0;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        LEDH <= 8'h00;
        LEDL <= 8'h00;
    end
    else begin
        if ((BUS_ADDR == LEDBaseAddr) & BUS_WE) begin // CPU writing to LED module low byte
            LEDL <= BUS_DATA;
            LEDH <= LEDH;
        end
        else if ((BUS_ADDR == LEDBaseAddr + 8'h01) & BUS_WE) begin // CPU writing to LED module high byte
            LEDL <= LEDL;
            LEDH <= BUS_DATA;
        end
        else begin
            LEDH <= LEDH;
            LEDL <= LEDL;
        end
    end
end

endmodule
