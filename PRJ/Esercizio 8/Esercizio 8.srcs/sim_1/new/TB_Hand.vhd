----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 16:22:48
-- Design Name: 
-- Module Name: TB_Hand - Behavioral
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

entity TB_Hand is
end TB_Hand;

architecture Behavioral of TB_Hand is
signal clk_a,clk_b, rst, set,input,output_A,output_B : std_logic := '0';


begin

process
    begin
        clk_a <= '0';
        wait for 5 ns;
        clk_a <= '1';
        wait for 5 ns;
    end process;

process
   
    begin
        wait for 2 ns; --sfasamento
        clk_b <= '0';
        wait for 20 ns;
        clk_b <= '1';
        wait for 18 ns;
    end process;
    
    
uut: entity work.Top_Module
    port map(
        clk_a=>clk_b,
        clk_b=>clk_a,
        rst=>rst,
        run=>input,
        stop_A=>output_A,
        stop_B=>output_B
    );

process
    begin
        rst <= '1';  -- Reset initially
        
        wait for 55 ns;
        rst <= '0';  -- Release reset
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        
        --2
        wait for 500 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        
        --3
        wait for 500 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait for 250 ns;
        input<='1';
        wait for 25 ns;
        input<='0';
        wait;
        
    end process;
    
end Behavioral;
