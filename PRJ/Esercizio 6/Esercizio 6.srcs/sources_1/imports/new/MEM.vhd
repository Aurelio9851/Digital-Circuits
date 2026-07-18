----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2024 23:09:08
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.math_real.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Generic(N: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic:='0';
           data_in: in std_logic_vector(3 downto 0):=(others=>'0');
           read: in std_logic:='0';
           data_out: out std_logic_vector(3 downto 0)    
    );
end MEM;

architecture Behavioral of MEM is
type mem is array (N-1 downto 0) of std_logic_vector(3 downto 0);
signal temp: mem;
signal mem_out: std_logic_vector(3 downto 0):=(others=>'0');
begin
    process(clk)
        begin
            if rising_edge(clk) then
                if rst='1' then
                    temp<=(others=>(others=>'0'));
                elsif write='1' then
                    temp(conv_integer(addr))<=data_in;
                elsif read='1' then
                    data_out<=temp(conv_integer(addr));
                end if;
            end if;
    end process;
    
  --  data_out<=mem_out;

end Behavioral;
