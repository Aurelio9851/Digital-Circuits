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

entity Control_Unit_B is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RDA: in std_logic;
        RD: out std_logic;
        WRITE: out std_logic;
        COUNT: out std_logic
    );
end Control_Unit_B;


architecture Behavioral_Moore of Control_Unit_B is
type stato is (IDLE,READ,WRITE_MEM,COUNT_INC);

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
    
cu_process:   process(stato_corrente,RDA)
        begin
    rd<='0';
    count<='0';
    write<='0';
    case stato_corrente is
        when IDLE=>
                if rda='1' then
                    stato_prossimo<=READ;
                else
                    stato_prossimo<=IDLE;       
                end if;     
        when READ=>
            rd<='1';
            stato_prossimo<=WRITE_MEM;
            
        when WRITE_MEM=>
            write<='1';
            stato_prossimo<=COUNT_INC;
       when COUNT_INC=>
                count<='1';
                stato_prossimo<=IDLE;
    end case;
   end process;

end Behavioral_Moore;