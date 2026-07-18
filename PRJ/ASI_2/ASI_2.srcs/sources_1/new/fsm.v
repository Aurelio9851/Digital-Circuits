
module fsm(ready, valid, ready_out, valid_out, clk, arst, en);
   input valid, ready_out;
   output ready, valid_out;
   input clk, arst;
   output [2:0] en;
  
   wire clk,arst,valid,ready_out;
   reg [2:0] en;
   reg ready=0, valid_out=0;
  reg [2:0] ac_state=3'b000;
  parameter [2:0] EMPTY=3'b000, FIRST=3'b001, SECOND=3'b010, PIPE_UNREAD=3'b011, PIPE_READ=3'b100;
  
  always @(posedge arst or posedge clk)
   begin
      if (arst)
         ac_state <= EMPTY;
      else
         case (ac_state)
            EMPTY: ac_state <= (valid) ? FIRST : EMPTY;
            FIRST: ac_state <= (valid) ? PIPE_UNREAD: SECOND;
           	SECOND: ac_state <= (valid) ? 
                  (ready_out ? FIRST : PIPE_UNREAD) :
                  (ready_out ? EMPTY : SECOND);
           PIPE_UNREAD: ac_state <= (ready_out) ? PIPE_READ : PIPE_UNREAD;
           PIPE_READ: ac_state <= (valid) ? PIPE_UNREAD:SECOND;
            default: ac_state<=EMPTY;
         endcase
   end

  always @(ac_state)
   begin
      case (ac_state)
         EMPTY: begin
            ready <= 1;
            valid_out <= 0;
           	en = 3'b011;
         end
         FIRST: begin
            ready <= 1;
            valid_out <= 0;
            en = 3'b111;
         end
         SECOND: begin
            ready <= 1;
            valid_out <= 1;
            en = 3'b011;
         end
         PIPE_UNREAD: begin
            ready <= 0;
            valid_out <= 1;
            en = 3'b000;
         end
         PIPE_READ: begin
            ready <= 1;
            valid_out <= 0;
            en = 3'b111;
         end
      endcase
   end
endmodule



module fsm_v2(ready, valid, ready_out, valid_out, clk, arst, en,ctrl1,ctrl2,ctrl3,ctrl4,ctrl5);
    
    input valid, ready_out;
    output ready, valid_out;
    input clk, arst;
    output [1:0] en;
    output ctrl1,ctrl2,ctrl5;
    output [1:0] ctrl4,ctrl3;
  
    wire clk,arst,valid,ready_out;
    reg [1:0] en;
    reg ctrl1,ctrl2,ctrl5;
    reg [1:0] ctrl4,ctrl3;
    reg ready=0, valid_out=0;
    reg [2:0] ac_state=3'b000;
    parameter [1:0] EMPTY=3'b000, FULL=3'b001,UNREAD=3'b011;
  
  always @(posedge arst or posedge clk)
   begin
      if (arst)
         ac_state <= EMPTY;
      else
         case (ac_state)
            EMPTY: ac_state <= (valid) ? FULL : EMPTY;
            FULL: ac_state <=  UNREAD;
            UNREAD: ac_state <= (ready_out) ? EMPTY : UNREAD;
            default: ac_state<=EMPTY;
         endcase
   end

  always @(ac_state)
   begin
            ctrl1<= 0;
            ctrl2<=0;
            ctrl3<= 0;
            ctrl4<=2'b01;
            ctrl5<=2'b0;
      case (ac_state)
         EMPTY: begin
            ready <= 1;
            valid_out <= 0;
           	en = 2'b11;
         end
         FULL: begin
            ready <= 0;
            valid_out <= 0;
            ctrl1<= 1;
            ctrl3<=2'b10;
            en = 2'b01;
         end
         UNREAD: begin
            ready <= 0;
            valid_out <= 1;
            en = 2'b00;
         end
          
      endcase
   end
endmodule