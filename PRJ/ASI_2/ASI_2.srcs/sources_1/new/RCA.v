module RippleCarryAdder 
  #(parameter N=16)
  (input wire [N-1:0] A, B,   
   input wire Cin,             
   output wire [N-1:0] Sum,     
   output wire Cout            
  );
  
  wire [N-1:0] Carry; 

  //primo Full adder
  FullAdder FA_0 (
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