`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2023 23:22:07
// Design Name: 
// Module Name: ROM
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

 
module ROM( 
	//standard signals
	input CLK,
	//BUS signals
	output reg  [7:0] 	DATA,
	input  [7:0]  			ADDR
);
	
	parameter ROMAddrWidth  = 8;

	//Memory
	reg [7:0] ROM [(2**ROMAddrWidth)-1:0];

	// Load program
	initial  $readmemh("C:/DSL4/dsl4_demo_app/dsl4_demo_app.srcs/ROM2.txt", ROM); 

	//single port ram
	always@(posedge CLK)
		DATA <= ROM[ADDR];

endmodule
