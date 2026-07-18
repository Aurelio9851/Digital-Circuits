----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 19:26:57
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
Port ( clk,rst,set_in,start: in std_logic;
           view_in: in std_logic;
           laps: in std_logic;
           count_in: in std_logic;
           toggle,set_out,write_en,view_out,read_en: out std_logic ;    
           mux: out std_logic_vector(1 downto 0)        
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
type stato is (IDLE,RUNNING,SET1,SET2,SET,VIEW,READ,LASTW);
    
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

process(stato_corrente, set_in, start, view_in, laps, count_in)
begin
    toggle <= '0';
    set_out <= '0';
    write_en <= '0';
    mux <= "00";
    view_out<='0';
    read_en<='0';

    case stato_corrente is
        WHEN IDLE=>       --Cronometro off
            if start = '1' then
                stato_prossimo <= RUNNING;
                toggle <= '1';
            elsif set_in = '1' then
                stato_prossimo <= SET1;
                mux <= "10"; -- set1 
            else stato_prossimo <= IDLE;
            end if;
        when RUNNING =>       -- Cronometro in funzionamento
            if start = '1' then
                stato_prossimo <= RUNNING;
                toggle <= '1';
            elsif set_in = '1' then
                stato_prossimo <= SET1;
                toggle <= '1';
                mux <= "10"; -- set1
            elsif view_in = '1' then
                stato_prossimo <= READ;
                read_en<='1';
                mux <= "01"; -- view
            elsif laps='1' then
                write_en<='1';
                stato_prossimo <= RUNNING;
            else stato_prossimo <= RUNNING;
            end if;
            
        when SET1 =>       -- set prima parte
            if start = '1' then
                stato_prossimo <= RUNNING;
                toggle <= '1';
            elsif set_in = '1' then
                stato_prossimo <= SET;
                set_out <= '1'; -- set_enable   
                mux <= "10";             
            else stato_prossimo <= SET1;
                 mux<= "10";
            end if;

        when SET2 =>       -- set seconda parte
            if start = '1' then
                stato_prossimo <= RUNNING;
                toggle <= '1';
            elsif set_in = '1' then
                stato_prossimo <= SET;
                set_out <= '1'; -- set_enable
                mux <= "11";  
            else stato_prossimo <= SET2;
                 mux <= "11";
            end if;
        when SET =>
            stato_prossimo<=SET2;
            mux<="11";
            
        when VIEW =>       -- view
            if view_in = '1' then
                stato_prossimo <= READ;
                read_en<='1';
                mux <= "01"; -- view
            else stato_prossimo <= VIEW;
                 mux <= "01"; 
            end if;
        when READ=>    
            if(count_in='0') then
                stato_prossimo <= VIEW;
                view_out<='1';
                mux <= "01"; -- view
                else
                    stato_prossimo <= LASTW;
                    view_out<='1';
                    mux<= "01";
                end if;
        when LASTW=>
            if view_in='1' then
                    stato_prossimo <= RUNNING;
            else
                    stato_prossimo <= LASTW;
                    mux<= "01";
            end if;        
    end case;
end process;

end Behavioral;
