module Carry_Save #(parameter N=4) (
  input wire [N-1:0] A, B, C, D, E,
  output wire [N+2:0] Sum,
  output wire Cout
);

   wire [N+2:0] A_ext, B_ext, C_ext, D_ext, E_ext;
   
   assign A_ext={A[N-1],A[N-1],A[N-1],A};
   assign B_ext={B[N-1],B[N-1],B[N-1],B};
   assign C_ext={C[N-1],C[N-1],C[N-1],C};
   assign D_ext={D[N-1],D[N-1],D[N-1],D};
   assign E_ext={E[N-1],E[N-1],E[N-1],E};

  wire [N+2:0] Sum_temp1, Carry_temp1, Carry_temp2;
  wire [N+2:1] Sum_temp2;
  wire [N+3:2] Sum_temp3;
  wire [N+3:1] Carry_temp3;

  // Full Adder prima fila
  genvar i;
  generate
    for (i = 0; i < N+3; i = i + 1) begin : gen_adder_1
      FullAdder FA (
        .A(A_ext[i]),
        .B(B_ext[i]),
        .Cin(C_ext[i]),
        .Sum(Sum_temp1[i]),
        .Cout(Carry_temp1[i])
      );
    end

    // primo FA seconda fila
    FullAdder FA_0_2 (
      .A(Sum_temp1[0]),
      .B(D[0]),
      .Cin(E[0]),
      .Sum(Sum[0]),
      .Cout(Carry_temp2[0])
    );

    // seconda fila
    for (i = 1; i < N+3; i = i + 1) begin : gen_adder_2
      FullAdder FA (
        .A(Sum_temp1[i]),
        .B(D_ext[i]),
        .Cin(Carry_temp1[i-1]),
        .Sum(Sum_temp2[i]),
        .Cout(Carry_temp2[i])
      );
    end

    // primo FA terza fila
    FullAdder FA_0_3 (
      .A(Sum_temp2[1]),
      .B(E[1]),
      .Cin(Carry_temp2[0]),
      .Sum(Sum[1]),
      .Cout(Carry_temp3[1])
    );

    // terza fila
    for (i = 2; i < N+3; i = i + 1) begin : gen_adder_3
      FullAdder FA (
        .A(Sum_temp2[i]),
        .B(E_ext[i]),
        .Cin(Carry_temp2[i-1]),
        .Sum(Sum_temp3[i]),
        .Cout(Carry_temp3[i])
      );
    end

    // ultimo FA merging cout
    FullAdder FA_3_N (
      .A( Carry_temp1[N+2]),
      .B(Carry_temp2[N+2]),
      .Cin(1'b0),
      .Sum(Sum_temp3[N+3]),
      .Cout(Carry_temp3[N+3])
    );

  endgenerate

  RippleCarryAdder#(N+3) VMA(.A({1'b0, Sum_temp3}), .B(Carry_temp3), .Cin(1'b0), .Sum(Sum[N+2:2]), .Cout(Cout));

endmodule
