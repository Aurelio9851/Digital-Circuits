

module registro(clk, arst, enable, D, Y);

  input arst;
  input clk;
  input enable;
  parameter N = 8; 
  input [N-1:0] D;
  output [N-1:0] Y;
  reg [N-1:0] Q;
  


  always @(posedge clk or posedge arst)
  begin
    if (arst)
      Q <= 0;
    else
      if (enable)
        Q <= D;
  end

  assign Y = Q;

endmodule
