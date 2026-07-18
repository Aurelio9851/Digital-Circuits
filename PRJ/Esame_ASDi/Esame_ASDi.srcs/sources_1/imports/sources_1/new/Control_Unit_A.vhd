----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 14:14:13
-- Design Name: 
-- Module Name: Control_Unit_B - Behavioral
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

entity Control_Unit_A is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        ACK: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        READY: out std_logic;
        COUNT: out std_logic
     );
end Control_Unit_A;


architecture Behavioral_Moore of Control_Unit_A is
type stato is (IDLE,READING,WAITING_1,WAITING_0,COUNT_INC,FINISH);

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
    
cu_process:   process(stato_corrente,run,stop_count,ack)
        begin
    read<='0';
    ready<='0';
    count<='0';
    stop<='0';
    case stato_corrente is
        when IDLE=>
                if run='1' then
                    stato_prossimo<=READING;
                else
                    stato_prossimo<=IDLE;       
                end if;
            
        when READING=>
            read<='1';
            stato_prossimo<=WAITING_1;
            
        when WAITING_1=>
            ready<='1';    --req to send
            if ack='0' then
                stato_prossimo<=WAITING_1;
            else
                stato_prossimo<=WAITING_0;

            end if;
        when WAITING_0=>
            if ack='1' then
                stato_prossimo<=WAITING_0;
            else
                if stop_count='1' then
                   stato_prossimo<=FINISH;
                else  stato_prossimo<=COUNT_INC;
                end if;
            end if;
       when COUNT_INC=>
                count<='1';
                stato_prossimo<=IDLE;
       when FINISH=>
                count<='1';
                stato_prossimo<=IDLE;
                stop<='1';
    end case;
   end process;

end Behavioral_Moore;




