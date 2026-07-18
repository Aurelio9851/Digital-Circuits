`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2024 11:58:33
// Design Name: 
// Module Name: array_multiplier
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


module array_multiplier
#(parameter N=3)
(
  input wire [N-1:0] A, B,
  output wire [2*N-1:0] Prod,
  output wire Cout
    );
    
  
   wire [2*N-2:0] mac_out [N-2:0];
   
   wire [2*N-2:0] carry_out [N-2:0];
   wire [N-1:0] last_sum ,last_cout;
  
    
    //MAC prima fila
   genvar i,j;
  generate
        for (i = 0; i < N-1; i = i + 1) begin : gen_adder_1
          MAC_Cell MC (
            .A(A[0]),
            .B(B[i]),
            .C(1'b0),
            .Cin(1'b0),
            .Sum_out(mac_out[0][i]),
            .Cout_out(carry_out[0][i])
          );
        end
        MAC_nand MC (
            .A(A[0]),
            .B(B[N-1]),
            .C(1'b0),
            .Cin(1'b0),
            .Sum_out(mac_out[0][N-1]),
            .Cout_out(carry_out[0][N-1])
          );  
     assign Prod[0]= mac_out[0][0]; 
    endgenerate
    
  // MAC i-esima fila
  generate
    for(j=1; j<N-1;j=j+1) begin: matrix
        for (i = j; i < N+j-1; i = i + 1) begin : gen_adder_i
          MAC_Cell MC (
            .A(A[j]),
            .B(B[i-j]),
            .C(mac_out[j-1][i]),
            .Cin(carry_out[j-1][i-1]),
            .Sum_out(mac_out[j][i]),
            .Cout_out(carry_out[j][i])
          );
        end
        MAC_nand MC (
            .A(A[j]),
            .B(B[N-1]),
            .C(1'b0),
            .Cin(carry_out[j-1][N-2+j]),
            .Sum_out(mac_out[j][N-1+j]),
            .Cout_out(carry_out[j][N-1+j])
          );
        
    assign Prod[j]= mac_out[j][j]; 
    end
    
    endgenerate
    
    
    // MAC ultima fila
    generate
    for (i = N-1; i < 2*N-2; i = i + 1) begin : gen_adder_last
          MAC_nand MC (
            .A(A[N-1]),
            .B(B[i-N+1]),
            .C(mac_out[N-2][i]),
            .Cin(carry_out[N-2][i-1]),
            .Sum_out(last_sum[i-N+1]),
            .Cout_out(last_cout[i-N+1])
          );
        end
        MAC_Cell MC_last (
            .A(A[N-1]),
            .B(B[N-1]),
            .C(1'b0),
            .Cin(carry_out[N-2][2*N-3]),
            .Sum_out(last_sum[N-1]),
            .Cout_out(last_cout[N-1])
          );
    assign Prod[N-1]= last_sum[0]; 
    endgenerate
    
      // Ripple Carry Adder
  RippleCarryAdder #(N) VMA (
    .A({1'b1, last_sum[N-1:1]}),
    .B(last_cout),
    .Cin(1'b1),
    .Sum(Prod[2*N-1:N]),
    .Cout(Cout)
  );
  
endmodule
