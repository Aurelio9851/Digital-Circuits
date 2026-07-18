----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2023 16:31:59
-- Design Name: 
-- Module Name: mux_16_1_tb - Behavioral
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

entity mux_16_1_tb is
end mux_16_1_tb;

architecture mux_16_1 of mux_16_1_tb is
    component mux_16_1
        port (   b : in  STD_LOGIC_VECTOR (15 downto 0);
            s:  in  STD_LOGIC_VECTOR (3 downto 0);
            y:  out STD_LOGIC
    );
    end component;
    
    signal input 	: STD_LOGIC_VECTOR (0 to 1) := (others => 'U'); 
	signal control 	: STD_LOGIC 				:= 'U';
	signal output 	: STD_LOGIC 				:= 'U';
begin
    

end mux_16_1;
