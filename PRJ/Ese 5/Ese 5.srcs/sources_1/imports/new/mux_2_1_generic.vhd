----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 16:05:31
-- Design Name: 
-- Module Name: mux_2_1_generic - Dataflow
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

entity mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux_2_1_generic;

architecture Dataflow of mux_2_1_generic is

begin
    y   <=  a_0 when s='0' else
            a_1 when s='1' else
		    (others=>'-');

end Dataflow;
