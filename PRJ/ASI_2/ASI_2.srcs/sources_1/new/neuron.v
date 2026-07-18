// Code your design here



module activationFunc(x,f,xmin,xmax);

input signed [11:0] x;
output signed [7:0] f;
input signed [11:0] xmin, xmax;

assign f = (x< xmin) ? xmin : (x > xmax) ? xmax : x;


endmodule

module neuron(X1, X2, X3, X4, W1, W2, W3, W4, bias, xmin, xmax, Y);
	input signed [7:0] X1, X2, X3, X4, W1, W2, W3, W4;
	input signed [15:0] bias;
	input signed [11:0] xmin, xmax;
	output signed [7:0] Y;
	
	wire signed [15:0] Z1,Z2,Z3,Z4;
	wire signed [15:0] Z1_t,Z2_t,Z3_t,Z4_t;
	wire signed [18:0] Sum,Sum2;
	
	array_multiplier #(8) multiplier_1(X1,W1,Z1);
	array_multiplier #(8) multiplier_2(X2,W2,Z2);
	array_multiplier #(8) multiplier_3(X3,W3,Z3);
	array_multiplier #(8) multiplier_4(X4,W4,Z4);
	
    assign Z1_t=X1*W1;
    assign Z2_t=X2*W2;
    assign Z3_t=X3*W3;
    assign Z4_t=X4*W4;
	
	Carry_Save #(16) adder(Z1,Z2,Z3,Z4,bias,Sum[18:0]);
    //assign Sum[18]=Sum[17];
  	assign Sum2=(X1*W1)+(X2*W2)+(X3*W3)+(X4*W4)+bias;
  	
  	activationFunc attivazione(Sum[18:7],Y,xmin,xmax);

endmodule
