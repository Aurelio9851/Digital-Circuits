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
        START: in std_logic;
        TBE: in std_logic;
        WR: out std_logic;
        COUNT: out std_logic
     );
end Control_Unit_A;


architecture Behavioral_Moore of Control_Unit_A is
type stato is (IDLE,WRITE,WAITING,COUNT_INC);

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
    
cu_process:   process(stato_corrente,start,tbe)
        begin
    wr<='0';
    count<='0';
    case stato_corrente is
        when IDLE=>
                if start='1' then
                    stato_prossimo<=WRITE;
                else
                    stato_prossimo<=IDLE;       
                end if;
            
        when WRITE=>
            wr<='1';
            stato_prossimo<=WAITING;
            
        when WAITING=>
            if tbe='0' then
                stato_prossimo<=WAITING;
            else
                stato_prossimo<=COUNT_INC;

            end if;
       when COUNT_INC=>
                count<='1';
                stato_prossimo<=IDLE;
    end case;
   end process;

end Behavioral_Moore;

