module MAC_nand (
    input A,
    input B,
    input C,
    input Cin,
    output wire Sum_out,
    output wire Cout_out
);

  wire nand_out;
  //wire sum_out, cout_out;


  assign nand_out= ~(A & B);

  // Definizione del componente Full Adder
  FullAdder full_a (
      .A(nand_out),
      .B(Cin),
      .Cin(C),  
      .Sum(Sum_out),
      .Cout(Cout_out)
  );


endmodule
