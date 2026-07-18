----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2024 21:39:18
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
        CLK: in std_logic;
        RST: in std_logic;
        START: in std_logic;
        STATS: in std_logic;
        Q0Q1: in std_logic_vector(1 downto 0);
        SUBTRACT: out std_logic;
        SHIFT: out std_logic;
        SELECTOR: out std_logic;
        COUNT: out std_logic;
        STOP: out std_logic;
        LOAD_AQ,LOAD_M: out std_logic    
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
type stato is (IDLE, SCAN, OP, SH_CO);
signal stato_corrente,stato_prossimo: stato:=IDLE;

begin

reg_process:    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;               
            else
                stato_corrente <= stato_prossimo;  
            end if;
        end if;
    end process;
    
cu_process:   process(stato_corrente,start,stats,Q0Q1)
    begin
    load_aq<='0'; 
    load_m<='0';
    shift<='0';
    subtract<='0';
    selector<='0';
    count<='0';
    stop<='0';
    case stato_corrente is
        when IDLE=>
            if start='1' then
                stato_prossimo<=SCAN;
                selector<='1';
                load_aq<='1';
                load_m<='1';
            else
                stato_prossimo<=IDLE;       
            end if;
        when SCAN=>
            stato_prossimo<=OP;
            if Q0Q1= "01" then
                load_aq<='1'; 
            elsif Q0Q1="10" then
                load_aq<='1';
                subtract<='1';
            else 
                shift<='1';
                stato_prossimo<=SH_CO;
            end if;
        when OP=>
            shift<='1';
            stato_prossimo<=SH_CO;
        when SH_CO=>
            count<='1';
            if stats='0' then
                stato_prossimo<=SCAN;
            else 
                stato_prossimo<=IDLE;
                stop<='1';
            end if;
    end case;
   end process;


end Behavioral;
