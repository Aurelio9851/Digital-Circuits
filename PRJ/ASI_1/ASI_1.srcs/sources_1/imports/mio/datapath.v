`timescale 1ns/1ps



module RippleCarryAdder 
  #(parameter N=16)
  (input wire [N-1:0] A, B,   
   input wire Cin,             
   output wire [N-1:0] Sum,     
   output wire Cout            
  );
  
  wire [N-1:0] Carry; 

  //primo Full adder
  FullAdder FA (
    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .Sum(Sum[0]),
    .Cout(Carry[0])
      );
  // Full Adder per ogni bit
  genvar i;
  generate
    for (i = 1; i < N; i=i+1) begin: gen_adder
      FullAdder FA (
        .A(A[i]),
        .B(B[i]),
        .Cin(Carry[i-1]),
        .Sum(Sum[i]),
        .Cout(Carry[i])
      );
    end
  endgenerate

  assign Cout = Carry[N-1];

endmodule

// Definizione del Full Adder
module FullAdder
  (input wire A, B, Cin,
   output wire Sum, Cout);
	
  //assign Sum = A ^ B ^ Cin;  A xor B xor Cin
 
  //In tecnologica Cmos è vantaggioso scriverlo in termini di Cout
  assign Sum = (~ Cout & (A | B | Cin)) | (A & B & Cin);
  assign Cout = (A & B) | (B & Cin) | (Cin & A);  
endmodule

module sum
  #(parameter N=16)
  (input signed [N-1:0] A, B,
  input opcode,
  output signed [N-1:0] Y,
  output c0
);
  wire [1:0] temp;

  assign temp = {1'b0, opcode};
  assign {c0, Y} = A + B + temp;

endmodule

module mux_2_1 #(parameter N=16)(
  input signed [N-1:0] A, B,
  input select,
  output signed [N-1:0] Y
);
  assign Y = select ? B : A;

endmodule

module registro #(parameter M=16) (
  input clock,
  input arst,
  input enable,
  input [M-1:0] D,
  output [M-1:0] Y
);
  reg [M-1:0] Q;

  always @(posedge clock or posedge arst) begin
    if (arst)
      Q <= {(M){1'b0}};
    else if (clock)
      if (enable)
        Q <= D;
  end

  assign Y = Q;

endmodule

module buffer #(parameter N=16) (
input signed [N-1:0] A,
output signed [N-1:0] Y
);

assign Y=A;

endmodule

module datapath #(parameter pipe = 2,N=16) (
  input signed [N-1:0] A, B,
  input [2:0] opcode,
  input wire enable_A,
  input wire enable_B,
  input wire enable_out,
  input wire clock,
  input wire reset,
  output signed [N-1:0] Y,
  output wire co
);

  //0-vector
  wire signed [N-1:0] op2;
  assign op2 = {(N){1'b0}};
  
  //wire mux
  wire signed [N-1:0] M1, M2;
    
  //wire per registri ingresso/uscite
  wire signed [N-1:0] A_r, B_r, Y_r,M2_r,S_r;
  wire C_r;
  
  //wire per registri all'interno del RCA
  wire signed [N/2-1:0] A_temp,M2_temp,S_temp;
  wire C_temp,Ctemp_out;

 //wire buffer
  wire signed [N/2-1:0] S_buffer,A_buffer,M2_Buffer;
  
  generate
    if (pipe == 0)
    begin : pipe0
      mux_2_1 mux1(B, op2 , opcode[2], M1);
      mux_2_1 mux2(M1, ~M1, opcode[1], M2);
      sum sum1(A, M2, opcode[0], Y, co);
    end
    
    else if (pipe == 1)
    begin : pipe1
      mux_2_1 mux1(B_r, op2, opcode[2], M1);
      mux_2_1 mux2(M1, ~M1, opcode[1], M2);
      //sommatore
      RippleCarryAdder #(N)summer(A_r,M2,opcode[0],Y_r,C_r);
      
      //registri su ingressi 
      registro #(N)regA(clock, reset, enable_A, A, A_r);
      registro #(N)regB(clock, reset, enable_B, B, B_r);
      //registri sulle uscite
      registro #(N)regY(clock, reset, enable_out, Y_r , Y);
      registro #(1) regC(clock, reset, enable_out, C_r , co);
    end
    
    else if(pipe == 2)
      begin: pipe2
        //mux
        mux_2_1 mux1(B_r, op2, opcode[2], M1);
      	mux_2_1 mux2(M1, ~M1, opcode[1], M2);
        
        //registro su B che ha un percorso combinatorio prima del sommatore       
        registro #(N)regB(clock, reset, enable_B, B, B_r);        
                
        //prima pipe --archi rossi
        registro #(N)regA(clock, reset, enable_A, A, A_r);
        registro #(N)regM2(clock, reset, enable_A, M2, M2_r);
        registro #(N)regY(clock, reset, enable_out, S_r , Y);
        registro #(1) regC(clock, reset, enable_out, C_r , co);      
        
        //seconda pipe --arco verde
        buffer   #(N/2) buffer_A(A_r[N-1:N/2],A_buffer);
        registro #(N/2)regA_temp(clock, reset, 1'b1, A_buffer,A_temp);
        buffer   #(N/2) buffer_M2(M2_r[N-1:N/2],M2_Buffer);
        registro #(N/2)regM_temp(clock, reset, 1'b1,M2_Buffer, M2_temp);
        //uscita
        registro #(N/2)regS_temp(clock, reset, 1'b1, Y_r[N/2-1:0], S_temp);
        buffer   #(N/2) buffer_S(S_temp,S_buffer);
        
        
        //RCA Pipelined a due livelli
        RippleCarryAdder #(N/2)rca_1(A_r[N/2-1:0],M2_r[N/2-1:0],opcode[0],Y_r[N/2-1:0],C_temp);
        registro #(1) regC_tmp(clock, reset, 1'b1, C_temp , Ctemp_out); //registro nella catena del riporto
        RippleCarryAdder #(N/2)rca_2(A_temp,M2_temp,Ctemp_out,Y_r[N-1:N/2],C_r);
        
        //somma in ingresso all'ultimo livello di pipe uscite
        //uscita buffer primo stadio + uscita secondo RCA     
        assign S_r ={Y_r[N-1:N/2],S_buffer};
               
      end
  endgenerate

endmodule

