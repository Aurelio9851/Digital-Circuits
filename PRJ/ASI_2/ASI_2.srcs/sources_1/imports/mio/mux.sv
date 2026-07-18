module mux2(in1,in2,selector,out);
  
  output [31:0] out;
  input[31:0] in1;
  input[31:0] in2;
  input selector;

  assign out= selector ? in2 : in1;
  
endmodule

module mux3(in1,in2,in3,selector,out);
  
  output [31:0] out;
  input[31:0] in1;
  input[31:0] in2;
  input[31:0] in3;
  input[2:0] selector;

  assign out=  (selector == 2'b00) ? in1 :
               (selector == 2'b01) ? in2 :
               (selector == 2'b10) ? in3 : 
    			8'b00000000;
endmodule