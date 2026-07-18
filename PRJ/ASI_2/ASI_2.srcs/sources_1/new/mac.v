module MAC_Cell (
    input A,
    input B,
    input C,
    input Cin,
    output wire Sum_out,
    output wire Cout_out
);

  wire and_out;
  //wire sum_out, cout_out;


  assign and_out= (A & B);

  // Definizione del componente Full Adder
  FullAdder full_a (
      .A(and_out),
      .B(Cin),
      .Cin(C),  
      .Sum(Sum_out),
      .Cout(Cout_out)
  );

endmodule
