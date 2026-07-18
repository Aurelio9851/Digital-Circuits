----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 14:20:00
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        WRITE: out std_logic;
        COUNT: out std_logic
     );
end Control_Unit;

architecture Behavioral of Control_Unit is
type stato is (IDLE,READING,FINISH);

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
    
cu_process:   process(stato_corrente,run,stop_count)
        begin
        count<='0';
        write<='0';
        read<='0';
        stop<='0';
    case stato_corrente is
        when IDLE=>
            if run='1' then
                stato_prossimo<=READING;
                read<='1';
            else
                stato_prossimo<=IDLE;       
            end if;
        when READING=>
            write<='1';
            count<='1';
            if(stop_count='0') then
                stato_prossimo<=IDLE;
            else 
                stato_prossimo<=FINISH;
                stop<='1';
            end if;
        when FINISH=>
            stop<='1';
            stato_prossimo<=FINISH;
    end case;
   end process;

end Behavioral;
