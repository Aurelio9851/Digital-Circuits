module acc_pipe(X1, X2, X3, X4, Y, ready, valid, ready_out, valid_out, clk, arst);
	input signed [7:0] X1, X2, X3, X4;
	output signed [7:0] Y;
	input valid, ready_out;
	output ready, valid_out;
	input clk, arst;

	
  	wire signed [7:0] S1, S2;
	wire signed [7:0] Y1, Y2, Y3;
  	wire [2:0] enable;
	
	//parameters for N1
	parameter [7:0] n1_w1 = -8'd115;
	parameter [7:0] n1_w2 = 8'd1;
	parameter [7:0] n1_w3 = -8'd105;
	parameter [7:0] n1_w4 = 8'd16;
	parameter [15:0] n1_bias = 16'd12571;
	parameter [11:0] n1_xmin = -12'd127;
	parameter [11:0] n1_xmax = 12'd127;
	//parameters for N2
	parameter [7:0] n2_w1 = 8'd103;
	parameter [7:0] n2_w2 = -8'd22;
	parameter [7:0] n2_w3 = 8'd32;
	parameter [7:0] n2_w4 = -8'd56;
	parameter [15:0] n2_bias = -16'd8139;
	parameter [11:0] n2_xmin = -12'd127;
	parameter [11:0] n2_xmax = 12'd127;
	//parameters for N3
	parameter [7:0] n3_w1 = 8'd75;
	parameter [7:0] n3_w2 = -8'd85;
	parameter [7:0] n3_w3 = -8'd38;
	parameter [7:0] n3_w4 = 8'd92;
	parameter [15:0] n3_bias = 16'd10182;
	parameter [11:0] n3_xmin = -12'd127;
	parameter [11:0] n3_xmax = 12'd127;

  	//neuroni
  	neuron Neuron1(X1, X2, X3, X4, n1_w1, n1_w2, n1_w3, n1_w4, n1_bias, n1_xmin, n1_xmax, Y1);
  	neuron Neuron2(X1, X2, X3, X4, n2_w1, n2_w2, n2_w3, n2_w4, n2_bias, n2_xmin, n2_xmax, Y2);
  neuron Neuron3(S1, S2, 8'b0, 8'b0, n3_w1, n3_w2, n3_w3, n3_w4, n3_bias, n3_xmin, n3_xmax, Y3);
  
	//FSM
  	fsm automa(ready, valid, ready_out, valid_out, clk, arst,enable);
  	
  	//registri
  	registro reg1(clk, arst,enable[0],Y1,S1);
    registro reg2(clk, arst,enable[1],Y2,S2);
    registro reg3(clk, arst,enable[2],Y3,Y);
  
endmodule


module acc_pipe_v2(X1, X2, X3, X4, Y, ready, valid, ready_out, valid_out, clk, arst);
	input signed [7:0] X1, X2, X3, X4;
	output signed [7:0] Y;
	input valid, ready_out;
	output ready, valid_out;
	input clk, arst;

	
  	wire signed [7:0] S1, S2;
	wire signed [7:0] Y1, Y2, Y3;
  	wire [1:0] enable;
  	
  	wire ctrl1,ctrl2,ctrl5;
  	wire [1:0] ctrl3,ctrl4;
  	
  	wire signed [31:0] X;
  	assign X={X1,X2,X3,X4};
    wire signed [31:0] S;
    assign S={S1,S2,8'd0,8'd0};
	
	wire signed [31:0] IN1,IN2;
	wire signed [71:0] WBN1,WBN2,WBN3,W1,W2;
	//parameters for N1
	parameter [7:0] n1_w1 = -8'd115;
	parameter [7:0] n1_w2 = 8'd1;
	parameter [7:0] n1_w3 = -8'd105;
	parameter [7:0] n1_w4 = 8'd16;
	parameter [15:0] n1_bias = 16'd12571;
	parameter [11:0] n1_xmin = -12'd127;
	parameter [11:0] n1_xmax = 12'd127;
	assign WBN1={n1_w1,n1_w2,n1_w3,n1_w4,n1_bias,n1_xmin,n1_xmax};
	//parameters for N2
	parameter [7:0] n2_w1 = 8'd103;
	parameter [7:0] n2_w2 = -8'd22;
	parameter [7:0] n2_w3 = 8'd32;
	parameter [7:0] n2_w4 = -8'd56;
	parameter [15:0] n2_bias = -16'd8139;
	parameter [11:0] n2_xmin = -12'd127;
	parameter [11:0] n2_xmax = 12'd127;
    assign WBN2={n2_w1,n2_w2,n2_w3,n2_w4,n2_bias,n2_xmin,n2_xmax};
	//parameters for N3
	parameter [7:0] n3_w1 = 8'd75;
	parameter [7:0] n3_w2 = -8'd85;
	parameter [7:0] n3_w3 = -8'd38;
	parameter [7:0] n3_w4 = 8'd92;
	parameter [15:0] n3_bias = 16'd10182;
	parameter [11:0] n3_xmin = -12'd127;
	parameter [11:0] n3_xmax = 12'd127;
  	assign WBN3={n3_w1,n3_w2,n3_w3,n3_w4,n3_bias,n3_xmin,n3_xmax};

  	//neuroni
    neuron Neuron1(IN1[31:24], IN1[23:16], IN1[15:8], IN1[7:0], W1[71:64], W1[63:56], W1[55:48], W1[47:40], W1[39:24], W1[23:12], W1[11:0], Y1);
    neuron Neuron2(IN2[31:24], IN2[23:16], IN2[15:8], IN2[7:0], W2[71:64], W2[63:56], W2[55:48], W2[47:40], W2[39:24], W2[23:12], W2[11:0], Y2);
    
    mux_2_1 #(32) MUX1(X,S,ctrl1,IN1); 
    mux_2_1 #(32) MUX2(X,S,ctrl2,IN2); 
    mux_2_1 #(8)  MUX5(S1,S2,ctrl5,Y); 
    
    mux_4_1 #(72) MUX3(WBN1,WBN2,WBN3,72'b0,ctrl3,W1); 
    mux_4_1 #(72) MUX4(WBN1,WBN2,WBN3,72'b0,ctrl4,W2);
	//FSM
  	fsm_v2 automa(ready, valid, ready_out, valid_out, clk, arst,enable,ctrl1,ctrl2,ctrl3,ctrl4,ctrl5);
  	
  	//registri
    registro reg1(clk, arst,enable[0],Y1,S1);
    registro reg2(clk, arst,enable[1],Y2,S2);
  	
endmodule