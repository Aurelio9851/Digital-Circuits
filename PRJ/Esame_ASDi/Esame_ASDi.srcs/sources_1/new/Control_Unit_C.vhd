----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 14:25:32
-- Design Name: 
-- Module Name: Control_Unit_C - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control_Unit_C is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        STATO_A: in std_logic;
        STATO_B: in std_logic;
        STATO_COMP: in std_logic;
        READY_A: in std_logic;
        READY_B: in std_logic;
        WRITE_A: out std_logic;
        WRITE_B: out std_logic;
        W_EQ: out std_logic; 
        READ: out std_logic;
        ACK_A: out std_logic;
        ACK_B: out std_logic;
        COUNT_A: out std_logic;
        COUNT_B: out std_logic;
        COUNT_C: out std_logic;
        RESET_COUNT: out std_logic
     );
end Control_Unit_C;

architecture Behavioral of Control_Unit_C is
type stato is (IDLE,A,B,AB,A2B,B2A,ACKA,ACKB,ACKAB,SYNC_B,READING,EQ,INC,FINISH);

signal stato_corrente : stato := IDLE;
signal stato_prossimo : stato;


begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;               
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;
    
cu_process:   process(stato_corrente,ready_A,ready_B,stato_A,stato_B,stato_COMP)
        begin
        WRITE_A<='0';
        WRITE_B<='0';
        W_EQ<='0';
        READ<='0';
        ACK_A<='0';
        ACK_B<='0';
        COUNT_A<='0';
        COUNT_B<='0';
        COUNT_C<='0';
        RESET_COUNT<='0';
    case stato_corrente is
        when IDLE=>
                if (stato_A='1' and stato_B='1') then stato_prossimo<=SYNC_B;
                else
                    if ((ready_A='1' and stato_A='0') and (ready_B='1' and stato_B='0')) then
                        stato_prossimo<=AB;
                    elsif (ready_A='1' and stato_A='0') then
                        stato_prossimo<=A;      
                    elsif (ready_B='1' and stato_B='0') then
                        stato_prossimo<=B;  
                    else stato_prossimo<=IDLE;  
                    end if;
                end if;
            
        when A=>
            write_A<='1';
            count_A<='1';
            ACK_A<='1';
            stato_prossimo<=ACKA;
            
        when ACKA=>
            ACK_A<='1';
            if ready_A='0' then stato_prossimo<= IDLE;
            else 
                if (ready_B='1' and stato_B='0') then
                    stato_prossimo<= A2B;
                else stato_prossimo<=ACKA;
                end if;
           end if;   

        when A2B=>
            write_B<='1';
            count_B<='1';
            ACK_A<='1';
            ACK_B<='1';
            stato_prossimo<= ACKAB;
            
       when ACKAB=>
            ACK_A<='1';
            ACK_B<='1';
            if ready_A='0' and ready_B='0' then stato_prossimo<=IDLE;
            elsif ready_A='0' then stato_prossimo<=ACKB;
            elsif ready_B='0' then stato_prossimo<=ACKA;
            else stato_prossimo<= ACKAB;
            end if;
                
       when B=>
            write_B<='1';
            count_B<='1';
            ACK_B<='1';
            stato_prossimo<=ACKB;
            
       when ACKB=>
            ACK_B<='1';
            if ready_B='0' then stato_prossimo<= IDLE;
            else 
                if (ready_A='1' and stato_A='0') then
                    stato_prossimo<= B2A;
                else stato_prossimo<=ACKB;
                end if;
           end if;  
       when B2A=>
            write_A<='1';
            count_A<='1';
            ACK_A<='1';
            ACK_B<='1';
            stato_prossimo<= ACKAB; 
       
       when AB=>
            write_A<='1';
            count_A<='1';
            ACK_A<='1';
            write_B<='1';
            count_B<='1';
            ACK_B<='1';
            stato_prossimo<= ACKAB; 

       when SYNC_B=>
            count_B<='1';
            if stato_a='0' then stato_prossimo<=IDLE;
            else  stato_prossimo<=READING;
            end if;

       when READING=>
            read<='1';
            if stato_a='0' then stato_prossimo<=FINISH;
            else stato_prossimo<=EQ;
            end if;
       when EQ=>
            count_a<='1';
            count_b<='1';
            if stato_comp='1' then
                stato_prossimo<=INC;
            else stato_prossimo<=READING;
            end if;
       when INC=>
            count_C<='1';
            stato_prossimo<=READING;
       when FINISH=>
            W_EQ<='1';
            RESET_COUNT<='1';
            stato_prossimo<=SYNC_B;
    end case;
   end process;

end Behavioral;

architecture Behavioral_v2 of Control_Unit_C is

type state_A is (IDLE,RICEVI,RICEVUTO,COUNT_INC,FINISH);
type state_B is (IDLE,RICEVI,RICEVUTO,COUNT_INC,FINISH);
type state_C is (IDLE,READING,EQ,INC,COUNT,FINISH);

signal A_corrente,A_prossimo : state_A := IDLE;
signal B_corrente,B_prossimo : state_B := IDLE;
signal C_corrente,C_prossimo : state_C := IDLE;

signal stop_a,stop_b,next_en: std_logic:='0';

signal count_a_tmp, count_b_tmp: std_logic:='0';
signal count_ac_tmp, count_bc_tmp: std_logic:='0';

begin

---------------------controller A
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                A_corrente <= IDLE;               
            else
                A_corrente <= A_prossimo;
            end if;
        end if;
    end process;
    
A_process:   process(A_corrente,ready_a,stato_a,next_en)
        begin
        WRITE_A<='0';
        ACK_A<='0';
        count_a_tmp<='0';
        stop_a<='0';
    case A_corrente is
        when IDLE=>
                if ready_a='1' then
                    A_prossimo<=RICEVI;
                else
                    A_prossimo<=IDLE;       
                end if;
            
        when RICEVI=>
            ack_a<='1'; --questo fa da ack
            write_a<='1';
            A_prossimo<=RICEVUTO;
            
        when RICEVUTO=>
            ack_a<='1';
            if ready_a='1' then        
                A_prossimo<=RICEVUTO;
            else        --abbasso prelevato -> mando il segnale DONE
                A_prossimo<=COUNT_INC;
            end if;
       when COUNT_INC=>
                count_a_tmp<='1';
                if stato_a='0' then A_prossimo<=IDLE;
                else A_prossimo<=FINISH;
                end if;
       when FINISH=>
                stop_a<='1';
                if next_en='1' then 
                    A_prossimo<=IDLE;
                else A_prossimo<=FINISH;
                end if;
    end case;
   end process;

------------controller B
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
               B_corrente <= IDLE;               
            else
                B_corrente <= B_prossimo;
            end if;
        end if;
    end process;
    
B_process:   process(B_corrente,ready_B,stato_B,next_en)
        begin
        WRITE_B<='0';
        ACK_B<='0';
        count_b_tmp<='0';
        stop_B<='0';
    case B_corrente is
        when IDLE=>
                if ready_B='1' then
                    B_prossimo<=RICEVI;
                else
                    B_prossimo<=IDLE;       
                end if;
            
        when RICEVI=>
            ack_B<='1'; --questo fa da ack
            write_B<='1';
            B_prossimo<=RICEVUTO;
            
        when RICEVUTO=>
            ack_B<='1';
            if ready_B='1' then        
                B_prossimo<=RICEVUTO;
            else        --abbasso prelevato -> mando il segnale DONE
                B_prossimo<=COUNT_INC;
            end if;
       when COUNT_INC=>
                count_b_tmp<='1';
                if stato_B='0' then B_prossimo<=IDLE;
                else B_prossimo<=FINISH;
                end if;
       when FINISH=>
                stop_b<='1';
                if next_en='1' then 
                    B_prossimo<=IDLE;
                else B_prossimo<=FINISH;
                end if;
    end case;
   end process;

--------------------ELABORAZIONE C
 process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
               C_corrente <= IDLE;               
            else
                C_corrente <= C_prossimo;
            end if;
        end if;
    end process;
    
C_process:   process(C_corrente,stop_a,stop_b,stato_a,stato_comp)
        begin
        COUNT_C<='0';
        READ<='0';
        count_bc_tmp<='0';
        count_ac_tmp<='0';
        W_EQ<='0';
        next_en<='0';
        reset_count<='0';
    case C_corrente is
        when IDLE=>
                if stop_a='1' and stop_b='1' then
                    C_prossimo<=READING;
                else
                    C_prossimo<=IDLE;       
                end if;
            
        when READING=>
            read<='1';
            C_prossimo<=EQ;
       when EQ=>
            if stato_comp='1' then
                C_prossimo<=INC;
            else C_prossimo<=COUNT;
            end if;
       when COUNT=>
            count_aC_tmp<='1';
            count_bC_tmp<='1';
            if stato_a='0' then C_prossimo<=READING;
            else C_prossimo<=FINISH;
            end if;
       when INC=>
            count_C<='1';
            C_prossimo<=COUNT;
       when FINISH=>
            W_EQ<='1';
            next_en<='1';
            reset_count<='1';
            C_prossimo<=IDLE;
    end case;
   end process;
   
COUNT_A<=count_A_tmp OR count_aC_tmp;
COUNT_B<=count_B_tmp OR count_bC_tmp;

end Behavioral_v2;
