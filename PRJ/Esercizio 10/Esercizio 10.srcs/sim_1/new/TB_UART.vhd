----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2024 14:32:48
-- Design Name: 
-- Module Name: TB_UART - Behavioral
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

entity TB_UART is

end TB_UART;

architecture Behavioral of TB_UART is
signal clk,rst,input: std_logic:='0';
begin

uut: entity work.Top_Module
    port map(
        clk=>clk,
        rst=>rst,
        run=>input
    );

process
    begin
        clk <= '0';
        wait for 10 ns;
        clk<= '1';
        wait for 10 ns;
    end process;
process
    begin
        rst <= '1';  -- Reset initially
        
        wait for 55 ns;
        rst <= '0';  -- Release reset
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 2 ms;
        wait;
    end process;
    

end Behavioral;
