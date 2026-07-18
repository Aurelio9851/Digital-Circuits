----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.02.2024 22:10:10
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
signal clk, rst, set,input,output : std_logic := '0';
begin

process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    uut: entity work.Top_Module
        port map(
            clk=>clk,
            rst=>rst,
            start=>input,
            stop=>output
        );
    
    process
    begin
        rst <= '1';  -- Reset initially
        
        wait for 55 ns;
        rst <= '0';  -- Release reset
        input<='1';
        wait for 15 ms;
        input<='0';
        wait for 15 ms;
        input<='1';
        wait for 15 ms;
        input<='0';
        wait for 15 ms;
        input<='1';
        wait for 15 ms;
        input<='0';
        wait for 15 ms;
        input<='1';
        wait for 15 ms;
        input<='0';
        wait for 15 ms;
        input<='1';
        wait for 15 ms;
        input<='0';
        
        wait;
        
    end process;
        
        
end Behavioral;
