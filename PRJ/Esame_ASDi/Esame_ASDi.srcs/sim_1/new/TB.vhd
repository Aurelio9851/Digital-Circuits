----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 15:50:36
-- Design Name: 
-- Module Name: TB - Behavioral
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

entity TB is
end TB;

architecture Behavioral of TB is
signal clk_a,clk_b,clk_c, rst, set,start_A,start_B,output_A,output_B : std_logic := '0';


begin

process
    begin
        wait for 8 ns;
        clk_a <= '1';
        wait for 10 ns;
        clk_a <= '0';
        wait for 8 ns;
    end process;

process
   
    begin
        wait for 5 ns; --sfasamento
        clk_b <= '1';
        wait for 15 ns;
        clk_b <= '0';
        wait for 10 ns;
    end process;

process
   
    begin
        wait for 0 ns; --sfasamento
        clk_c <= '1';
        wait for 5 ns;
        clk_c <= '0';
        wait for 5 ns;
    end process;
    
uut: entity work.Top_Module
    port map(
        clk_c=>clk_c,
        clk_a=>clk_b,
        clk_b=>clk_a,
        rst=>rst,
        start_A=>start_A,
        start_b=>start_b,
        stop_A=>output_A,
        stop_B=>output_B
    );



process
begin rst <= '1';  -- Reset initially

    wait for 55 ns;
    rst <= '0';  -- Release reset
    start_A<='1';
    start_B<='1';
    wait;
end process;


end Behavioral;
