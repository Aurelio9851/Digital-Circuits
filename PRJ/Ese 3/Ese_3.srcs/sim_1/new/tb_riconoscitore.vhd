----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2022 15:16:10
-- Design Name: 
-- Module Name: Riconoscitore_Mealy_TB - Behavioral
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

entity tb_riconoscitore is
end tb_riconoscitore;

architecture Behavioral of tb_riconoscitore is

COMPONENT Riconoscitore
    PORT(
            d: in std_logic;
           rst,clk,en: in std_logic;
           m: in std_logic;
           y: out std_logic
        );
    END COMPONENT;
    
--Inputs
   signal i : std_logic := '0';
   signal e: std_logic:='0';
   signal in_i,in_e: std_logic;
   signal mode : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0'; 

 	--Outputs
   signal Y : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	-- qui specifico quale architecture simulare di quelle definite
--   uut: Riconoscitore port map(
--          d => i,
--          m => mode,
--          CLK => CLK,
--          RST => RST,
--          en=>e,
--          Y => Y
--        );

    utt: entity work.Riconoscitore_manager port map(i,rst,clk,mode,in_i,in_e,y);

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

        in_e<='1';
        in_i<='0';
      -- insert stimulus here 
		i<='0';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='1';
		in_i<='1';
        wait for 20 ms;
        in_i<='0';
		wait for 20 ms;
		i<='0';
		in_i<='1';
        wait for 20 ms;
        in_i<='0';
		wait for 20 ms;
		i<='1';
		in_i<='1';
        wait for 20ms;
        in_i<='0';
		wait for 20 ms;
		i<='0';
		in_i<='1';
        wait for 20ms;
        in_i<='0';
		i<='1';
		in_i<='1';
        wait for 20ms;
        in_i<='0';
		i<='0';
		in_i<='1';
        wait for 20ms;
        in_i<='0';
		i<='1';
		
      mode <= NOT mode;
        i<='0';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='0';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='1';
		wait for 10 ns;
		i<='0';
		wait for 10 ns;
		i<='1';
      wait;
   end process;

END;