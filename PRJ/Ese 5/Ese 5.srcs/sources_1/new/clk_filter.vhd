----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2024 15:58:56
-- Design Name: 
-- Module Name: clk_filter - Behavioral
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

entity clk_filter is
    generic(
			CLKIN_freq : integer := 100000000; --clock board 100MHz
			CLKOUT_freq : integer := 500       --frequenza desiderata 500Hz
				);
    Port ( 
           clock_in : in  STD_LOGIC;
		   reset : in STD_LOGIC;
           clock_out : out  STD_LOGIC 
    ); 
end clk_filter;

architecture Behavioral of clk_filter is
signal clockfx : std_logic := '0';

constant count_max_value : integer := CLKIN_freq/(CLKOUT_freq)-1;
begin

    process(clock_in)
    variable count: integer:=0;
    begin
        if rising_edge(clock_in) then
            if reset='1' then 
                count:=0;
                clockfx <=  '0';
            else
                if count=count_max_value then
                    clockfx <=  '1';
			        count := 0;
		        else
			         clockfx <=  '0';
			         count := count + 1;
		        end if;
            end if;
        end if;
    end process;

clock_out<=clockfx;

end Behavioral;
