// Code your design here



module activationFunc(x,f,xmin,xmax);

input signed [11:0] x;
output signed [7:0] f;
input signed [11:0] xmin, xmax;

assign f = (x< xmin) ? xmin : (x > xmax) ? xmax : x;


endmodule


module RippleCarryAdder 
  #(parameter N=16)
  (input wire [N-1:0] A, B,   // Operandi di input
   input wire Cin,             // Carry in
   output wire [N-1:0] Sum,     // Somma
   output wire Cout            // Carry out
  );
  
  wire [N:0] Carry; // Array di carry

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

  assign Sum = A ^ B ^ Cin;
  assign Cout = (A & B) | (B & Cin) | (Cin & A);

endmodule

module neuron(X1, X2, X3, X4, W1, W2, W3, W4, bias, xmin, xmax, Y);
	input signed [7:0] X1, X2, X3, X4, W1, W2, W3, W4;
	input signed [15:0] bias;
	input signed [11:0] xmin, xmax;
	output signed [7:0] Y;
	
	wire signed [18:0] Sum;
  	wire signed [15:0] Z1, Z2, Z3, Z4;
  
  	assign Sum=(X1*W1)+(X2*W2)+(X3*W3)+(X4*W4)+bias;
  	
  	activationFunc attivazione(Sum[18:7],Y,xmin,xmax);

endmodule
