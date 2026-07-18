`timescale 1ns/1ps
`include "registro.sv"
`include "Fsm.sv"
`include "neuron.v"
`include "mux.sv"

module acc_pipe(X1, X2, X3, X4, Y, ready, valid, ready_out, valid_out, clk, arst);
	input signed [7:0] X1, X2, X3, X4;
	output signed [7:0] Y;
	input valid, ready_out;
	output ready, valid_out;
	input clk, arst;

	
  	wire signed [7:0] S1, S2;
	wire signed [7:0] Y1, Y2, Y3;
  	wire [2:0] enable;
 	wire[4:0] control;
	
  	wire signed [31:0] X;
  	assign X={X1,X2,X3,X4};
    wire signed [31:0] S;
    assign X={S1,S2,8'd0,8'd0};
      	
	//parameters for N1
	parameter [7:0] n1_w1 = -8'd115;
	parameter [7:0] n1_w2 = 8'd1;
	parameter [7:0] n1_w3 = -8'd105;
	parameter [7:0] n1_w4 = 8'd16;
	parameter [15:0] n1_bias = 16'd12571;
	parameter [11:0] n1_xmin = -12'd127;
	parameter [11:0] n1_xmax = 12'd127;
    wire signed [71:0] WBN1;
  	assign WBN1={n1_w1,n1_w2,n1_w3,n1_w4,n1_bias,n1_xmin,n1_xmax};
	//parameters for N2
	parameter [7:0] n2_w1 = 8'd103;
	parameter [7:0] n2_w2 = -8'd22;
	parameter [7:0] n2_w3 = 8'd32;
	parameter [7:0] n2_w4 = -8'd56;
	parameter [15:0] n2_bias = -16'd8139;
	parameter [11:0] n2_xmin = -12'd127;
	parameter [11:0] n2_xmax = 12'd127;
    wire signed [71:0] WBN2;
    assign WBN2={n2_w1,n2_w2,n2_w3,n2_w4,n2_bias,n2_xmin,n2_xmax};
	//parameters for N3
	parameter [7:0] n3_w1 = 8'd75;
	parameter [7:0] n3_w2 = -8'd85;
	parameter [7:0] n3_w3 = -8'd38;
	parameter [7:0] n3_w4 = 8'd92;
	parameter [15:0] n3_bias = 16'd10182;
	parameter [11:0] n3_xmin = -12'd127;
	parameter [11:0] n3_xmax = 12'd127;
  	wire signed [71:0] WBN3;
  	assign WBN3={n3_w1,n3_w2,n3_w3,n3_w4,n3_bias,n3_xmin,n3_xmax};
  	  
	//FSM
  	fsm automa(ready, valid, ready_out, valid_out, clk, arst,enable);
  	  
  	//mux
    wire signed [31:0] In1;
    wire signed [31:0] In2;
    wire signed [71:0] W1;
    wire signed [71:0] W2;
    mux2 M1(X,S,control[0],In1);
    mux2 M2(X,S,control[1],In2);
    mux3 M3(WBN1,WBN2,WBN3,control[2],W1);
    mux3 M4(WBN1,WBN2,WBN3,control[3],W2);
    mux2 M5(S1,S2,control[4],Y);
  
  	//neuroni
  neuron Neuron1(In1[7:0], In1[15:8], In1[23:16], In1[31:24], W1[7:0],W1[15:0], W1[23:16], W1[31:24], W1[47:32], W1[59:48],W1[71:60], Y1);
  neuron Neuron2(In2[7:0], In2[15:8], In2[23:16], In2[31:24], W2[7:0], 		W2[15:8], W2[23:16], W2[31:24], W2[47:32], W2[59:48],W2[71:60], Y2);
  
	//registri
  	registro reg1(clk, arst,enable[0],Y1,S1);
    registro reg2(clk, arst,enable[1],Y2,S2);
  	
  
	
endmodule