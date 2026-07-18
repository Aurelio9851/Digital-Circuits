

module fsm(ready, valid, ready_out, valid_out, clk, arst, en,control);
   input valid, ready_out;
   output ready, valid_out;
   input clk, arst;
  output [1:0] en;
  output [4:0] control;
  
   wire clk,arst,valid,ready_out;
   reg [2:0] en;
   reg ready, valid_out;
   reg [2:0] ac_state;
  parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100,S5=3'b101;
  
   always @(posedge arst or posedge clk)
   begin
      if (arst)
         ac_state <= S0;
     else if(clk)
         case (ac_state)
            S0: ac_state <= (valid) ? S1 : S0;
           	S1: ac_state <= (valid) ? S3: S2;
            S2: ac_state <= S3;
            S3: ac_state <= (ready_out) ? S4 : S3;
           	S4: ac_state <= (valid) ? S3:S2;
            default: ac_state<=S0;
         endcase
   end

   always @(ac_state)
   begin
      case (ac_state)
         S0: begin
            ready <= 1;
            valid_out <= 0;
           	en = 3'b011;
         end
         S1: begin
            ready <= 1;
            valid_out <= 0;
            en = 3'b100;
         end
         S2: begin
            ready <= 1;
            valid_out <= 1;
            en = 3'b011;
         end
         S3: begin
            ready <= 0;
            valid_out <= 1;
            en = 3'b000;
         end
         S4: begin
            ready <= 1;
            valid_out <= 0;
            en = 3'b111;
         end
      endcase
   end
endmodule
