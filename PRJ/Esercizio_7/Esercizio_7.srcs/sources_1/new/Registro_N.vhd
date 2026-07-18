----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2024 18:19:31
-- Design Name: 
-- Module Name: Registro_N - Behavioral
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

entity Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0));
end Registro_N;

architecture Behavioral of Registro_N is
signal temp_n: std_logic_vector(N-1 downto 0);

begin
	
	R_PP: process(clk)
		begin
		if(clk'event and clk='1') then
		  if(res='1') then
			 temp_n<= (others=>'0');		   
		  elsif(load='1') then
			   temp_n<=A;
		  else
	      end if;
	    end if;
	end process;
	B<=temp_n;

end Behavioral;
