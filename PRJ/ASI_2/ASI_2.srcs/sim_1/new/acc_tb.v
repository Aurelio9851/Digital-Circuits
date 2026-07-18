module tb_neuron();
	reg signed [7:0] X1, X2, X3, X4, W1, W2, W3, W4;
	reg signed [15:0] bias;
	reg signed [11:0] xmin, xmax;
	wire signed [7:0] Y;
	reg signed [7:0] Yfile;
	
	integer f1, f2;
	integer i;
	integer nb;
	integer nerror = 0;
	integer nvalues = 0;
	
	neuron UUT (.X1(X1), .X2(X2), .X3(X3), .X4(X4), .W1(W1), .W2(W2), .W3(W3), .W4(W4), .bias(bias), .xmin(xmin), .xmax(xmax), .Y(Y));
	
	initial
	begin
		f1 = $fopen("neuronInputs.dat","r");
		f2 = $fopen("neuronOutputs.dat","r");
		xmin = -12'd127;
		xmax = 12'd127;
		for(i=0; i<100; i=i+1)
		begin
			nvalues = nvalues + 1;
			nb = $fscanf(f1,"%d %d %d %d %d %d %d %d %d\n",X1, X2, X3, X4, W1, W2, W3, W4, bias);
			nb = $fscanf(f2,"%d\n",Yfile);
			#10;
			if (Yfile != Y) 
			begin
				$display("i: %d - computed value Y=%0d is different from data in the output file Y=%0d",i,Y,Yfile);
				nerror = nerror + 1;
			end
		end
		
      $display("%d neuron cases evaluated, %d errors found", nvalues, nerror);
		
		$fclose(f1);
		$fclose(f2);
	end
endmodule


module tb_accelerator1();
	reg signed [7:0] X1, X2, X3, X4;
	wire signed [7:0] Y;
	reg valid, ready_out;
	wire ready, valid_out;
	reg clk = 1'b0;
	reg arst;
	
	integer f1, f2;
	integer i,j;
	integer seed =13;
	integer nb;
	reg signed [7:0] Yfile;
	integer nerror = 0;
	integer nvalues = 0;
	
	acc_pipe UUT(.X1(X1), .X2(X2), .X3(X3), .X4(X4), .Y(Y), .ready(ready), .valid(valid), .ready_out(ready_out), .valid_out(valid_out), .clk(clk), .arst(arst));
	
	always
	begin
		#5;
		clk <= ~clk;
	end
	
	//constant signals to ease the test
	initial
	begin
		valid = 1'b1;
		ready_out = 1'b1;
	end
	
	//inputs
	initial
	begin
		f1 = $fopen("accel_in.dat","r");
		//initial reset
		arst = 1'b1;
		#50;
		arst = 1'b0;
		//data loop: on the negedge of the clock
		for(i=0; i<100; i=i+1)
		begin
			nb = $fscanf(f1,"%d %d %d %d\n",X1, X2, X3, X4);
			while(ready != 1'b1)
			begin
				#10; //next posedge clk data will be consumed
			end
			#10; //values have been read
		end
		
		$fclose(f1);
	end
	
	//outputs
	initial
	begin
		f2 = $fopen("accel_out.dat","r");
		#10; // guard for initial undefined values
		for(j=0; j<100; j=j+1)
		begin
			nvalues = nvalues + 1;
			while(valid_out != 1'b1)
			begin
				#10; //next posedge clk data will be consumed
			end
			nb = $fscanf(f2,"%d\n",Yfile);
			if(Y != Yfile)
			begin
				$display("j:%d, output failed",j);
				nerror = nerror + 1;
			end
			#10;
		end
		$fclose(f2);
		$display("%d cases evaluated, %d errors found", nvalues, nerror);
		$finish;
	end

endmodule

//module Carry_Save_TB;
//  parameter N = 6;

//  reg [N-1:0] A, B, C, D, E;
//  wire [N+1:0] Sum;
//  wire Cout;

//  Carry_Save #(N) UUT (
//    .A(A),
//    .B(B),
//    .C(C),
//    .D(D),
//    .E(E),
//    .Sum(Sum),
//    .Cout(Cout)
//  );

//  initial begin
//    // Inizializzazione degli ingressi
//    A = -6'd14;
//    B = -6'd19;
//    C = 6'b0;
//    D = 6'b0;
//    E = 6'b0;

//    // Attivazione della simulazione
//    #1;

//    // Stampa degli ingressi
//    $display("Input A: %b", A);
//    $display("Input B: %b", B);
//    $display("Input C: %b", C);
//    $display("Input D: %b", D);
//    $display("Input E: %b", E);

//    // Stampa dei risultati
//    #1;
//    $display("Output Sum: %b", Sum);
//    $display("Output Cout: %b", Cout);

//    // Termina la simulazione
//    #1;
//    $finish;
//  end
//endmodule


module testbench;
  // Parametri
  parameter N = 8;

  // Segnali di ingresso
  reg [N-1:0] A, B;
  
  // Segnali di uscita
  wire [2*N-1:0] Prod;
  wire Cout;

  // Instanzia il modulo da testare
  array_multiplier #(N) dut (
    .A(A),
    .B(B),
    .Prod(Prod),
    .Cout(Cout)
  );

  // Inizializzazione segnali
  initial begin
    // Imposta il seme del generatore di numeri casuali per riproducibilità
    //$randomseed(42);

    // Inizializza A e B con valori casuali
    A = 8'heb;
    B = 8'h8d;
     //096f
//     A=-8'd4;
//     B=8'd2;
    // Applica i segnali di ingresso
    #10; // Aspetta qualche ciclo per stabilizzare l'output
    $display("A = %b", A);
    $display("B = %b", B);
    $display("Prod = %b", Prod);
    $display("Cout = %b", Cout);
    $stop;
  end
endmodule
