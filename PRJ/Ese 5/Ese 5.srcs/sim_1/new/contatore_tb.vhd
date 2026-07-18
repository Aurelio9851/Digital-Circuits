----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2024 17:27:13
-- Design Name: 
-- Module Name: contatore_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contatore_tb is
end contatore_tb;

architecture tb of contatore_tb is
    signal clk_tb : std_logic;
    signal input ,set : std_logic :='0';
    signal outputB,outputS  : std_logic;
    signal rst : std_logic;
    signal data_in,out_p1,out_p2: std_logic_vector(31 downto 0);
    constant clk_period : time := 10 ns; 
    
    
begin
   
    Structural : entity work.contatore_modM(Structural)
    generic map(M=>7)
    port map (CLK => clk_tb,
              RST => rst,
              en  => input,
              set=>set,
              data_in=>data_in(2 downto 0),
              out_c  => outputS
             );


    Behav : entity work.contatore_modM(Behavioral)
    generic map(M=>8)
    port map (CLK => clk_tb,
              RST => rst,
              en  => input,
              set=>set,
              data_in=>data_in(2 downto 0),
              out_c  => outputB
             );

--    orologio: entity work.Cronometro
--        port map(
--            clk=>clk_tb,
--            rst=>rst,
--            set_in=>set,
--            en=>input,
--            value_in=>data_in
           
--        );
 
    stimuli : process
    begin
        
        rst <= '1';
        wait for 55ns;  --global reset
       rst<='0';
--        rst <='0';
        input<='1';

--        wait for 18ns;
--        for i in 0 to 7 loop
--        input <= '1';
--        wait for 10ns;
--        input <= '0';
--        wait for 10ns;
--        end loop;

        wait for 200ms;
    end process;

 -- Clock generation
   clk_process : process
   begin
		clk_tb <= '0';
		wait for clk_period/2;
		clk_tb <= '1';
		wait for clk_period/2;
   end process;
end tb;

