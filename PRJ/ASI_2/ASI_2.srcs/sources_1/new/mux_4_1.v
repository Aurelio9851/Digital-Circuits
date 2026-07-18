`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2024 17:16:29
// Design Name: 
// Module Name: mux_4_1
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


module mux_4_1#(parameter N=8)(
  input signed [N-1:0] A, B,C,D,
  input [1:0] select,
  output signed [N-1:0] Y
   );
    
  assign Y = select[0] ? 
            (select[1] ? D : B) :
            (select[1] ? C : A);
endmodule
