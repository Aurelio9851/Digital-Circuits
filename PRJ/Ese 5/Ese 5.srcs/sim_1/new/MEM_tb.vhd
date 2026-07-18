----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.02.2024 12:34:06
-- Design Name: 
-- Module Name: MEM_tb - Behavioral
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

entity MEM_tb is
end MEM_tb;

architecture Behavioral of MEM_tb is
signal clk, rst, set,input : std_logic := '0';
signal addr: std_logic_vector(1 downto 0);
signal read,write: std_logic:= '0';
signal data_out,data_in: std_logic_vector(31 downto 0);
begin

    mem: entity work.MEM
        port map(
            clk=>clk,
            rst=>rst,
            addr=>addr,
            write=>write,
            data_in=>data_in,
            read=>read,
            data_out=>data_out
        );

    -- Clock process
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    process
    begin
        rst <= '1';  -- Reset initially
        addr<=(others=>'0');
        data_in<=(others=>'1');
        read<='0';
        wait for 10 ns;
        rst<='0';   -- Release reset
        write <= '1';  
  
        wait for 10 ns;
        write <= '0';
        
        wait for 20 ns;
        read<='1';
        
        wait;
        end process;
end Behavioral;
