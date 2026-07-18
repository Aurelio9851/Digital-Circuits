// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

`define maxpositive 32767
`define minnegative -32768

//`include "datapath.v"
`timescale 1ns/1ps

module datapathTB();
  reg signed [15:0] A,B;
  reg [2:0] opcode;
  wire signed [15:0] Y;
  wire co;
  integer file;
  
  reg clk = 1'b0;
  reg arst;
  
  datapath #(.pipe(2)) myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clock(clk),.reset(arst),.enable_A(1'b1),.enable_B(1'b1),.enable_out(1'b1));
  
  function string operation(input reg [2:0] opcode);
    case(opcode)
      3'b000: operation = "Sum";
      3'b001: operation = "Sumi";
      3'b010: operation = "Subd";
      3'b011: operation = "Sub";
      3'b100: operation = "Pt1";
      3'b101: operation = "Inc";
      3'b110: operation = "Dec";
      3'b111: operation = "Pt2";
      default: operation = "Null";
    endcase
  endfunction
  
  always
	begin
		#2;
		clk <= ~clk;
	end
  
  initial
    begin : initLabel
      arst=1;
      #10
      arst=0;
      // operation: Sum
      opcode = 3'b000; A = 16'd5; B = 16'd128;
      #20;
      $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Sumi
      opcode = 3'b001; A = 16'd5; B = 16'd128;
      #20;
      $display("[time: %0dns, sumi] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Subd
      opcode = 3'b010; B = 16'd5; A = 16'd10;
      #20;
      $display("[time: %0dns, subd] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Sub
      opcode = 3'b011; A = 16'd5; B = 16'd128;
      #20;
      $display("[time: %0dns, sub] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // random generate
      $display("Start random generation");
       for (int i = 0; i < 10; i = i + 1) begin
        // $random(opcode); A={$random} % 100; B={$random} % 100;
            #20;
         $display("[time: %0dns, %0s] OP:%0b A:%0d, B:%0d, Y:%0d, co:%b",$time,operation(opcode), opcode,A, B, Y, co);
       end   
      
      
      
      $display("Start reading from file");
      file= $fopen("input.txt","r");
      if(file==0)
         begin
          $display("File non trovato");
          $finish;
          end
      while(!$feof(file))
          begin
            
            $fscanf (file,"%b %d %d\n", opcode,A, B);
            #20;
            $display("[time: %0dns, %0s] OP:%0b A:%0d, B:%0d, Y:%0d, co:%b",$time, operation(opcode),opcode,A, B, Y, co);
  			
		  end
 
      $finish;
      
	  
    end
  
endmodule