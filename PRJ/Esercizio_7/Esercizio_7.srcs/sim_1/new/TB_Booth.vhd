----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2024 13:31:38
-- Design Name: 
-- Module Name: TB_Booth - Behavioral
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

entity TB_Booth is
end TB_Booth;

architecture Behavioral of TB_Booth is
signal inputx, inputy: std_logic_vector(7 downto 0);
	signal prod: std_logic_vector(15 downto 0);
	signal clk, res, start: std_logic;
	signal t_stop_cu: std_logic;
    constant clk_period : time := 10 ns;
    
    signal end_sim : std_logic := '0';


begin

uut: entity work.Top_Module port map(clk,res,start,t_stop_cu,inputx,inputy,prod);




clk_process : process
     begin
        while (end_sim = '0') loop
            clk<= '1';
            wait for clk_period/2;
            clk <= '0';
            wait for clk_period/2;
        end loop;
        wait;
     end process;
   
	 

-- SIMULARE PER 9000 NS

	
	sim: process
		 begin
		 
		 wait for 300 ns;
		
		 res<='1';
		 wait for 20 ns;
		 res<='0';
		
		 -- -------------------------------------   operazione numero 1:
         -- 15*3=45 (002D)
		 inputx<="00001111";  
		 inputy<="00000011";  
		 	 
		 
		 wait for 40 ns;
		 start<='1';
		 wait for 30 ns;
		 start<='0';
		 -- aspetto fine operazione, ci vogliono circa 500ns
		 wait for 600ns;
		 
		 assert prod = x"002D" report "Test nr. 1 Failed" severity error;
         assert prod /= x"002D" report"Test nr. 1 Passed"  severity note;
         
     
		 
		 res<='1';
		 wait for 20 ns;
		 res<='0';
		 wait for 20 ns;
		 
		 -- -------------------------------------------operazione numero 2:

		 -- -5*3=-15 (FFF1)		 
		 inputy<="11111011";  -- -5
		 inputx<="00000011";  -- +3
		 wait for 40 ns;
		 -- start
		 start<='1';
		 wait for 20 ns;
		 start<='0';
		 -- aspetto fine operazione
		 wait for 600 ns;
		 
		 assert prod = x"FFF1" report "Test nr. 2 Failed" severity error;
         assert prod /= x"FFF1" report "Test nr. 2 Passed"  severity note;
         
		 res<='1';
		 wait for 20 ns;
		 res<='0';
		 wait for 20 ns;
		 
		 -- -------------------------------------------operazione numero 3:
		-- -3*3=-9 (FFF7)
		 inputx<="11111101"; -- -3
		 inputy<="00000011"; -- +3
		
		 wait for 40 ns;
		 -- start
		 start<='1';
		 wait for 20 ns;
		 start<='0';
		 -- aspetto fine operazione
		 wait for 600 ns;
		 
		 assert prod = x"FFF7" report "Test nr. 3 Failed" severity error;
		 assert prod /= x"FFF7" report "Test nr. 3 Passed"  severity note;

		 res<='1';
		 wait for 20 ns;
		 res<='0';
		 wait for 20 ns;
		 
		 -- ------------------------------------------operazione numero 4:
		 -- -3*-5=+15 (000F)
		 inputx<="11111101"; 
		 inputy<="11111011";
		
		 wait for 40 ns;
		 -- start
		 start<='1';
		 wait for 20 ns;
		 start<='0';
		 wait for 600 ns;
		 
		 assert prod = x"000F" report "Test nr. 4 Failed" severity error;
         assert prod /= x"000F" report "Test nr. 4 Passed"  severity note;

		 
		 res<='1';
		 wait for 20 ns;
		 res<='0';
		 wait for 20 ns;
		 
		 -- ------------------------------------------operazione numero 5:
		 
		 -- -128*-128=16384 (4000)
		 inputx<="10000000"; 
		 inputy<="10000000";
		
		 wait for 40 ns;
		 -- start
		 start<='1';
		 wait for 20 ns;
		 start<='0';
		 wait for 600 ns;
		
		 assert prod = x"4000" report "Test nr. 5 Failed" severity error;
		 assert prod /= x"4000" report "Test nr. 5 Passed"  severity note;
		
		 end_sim <= '1';
		 wait;
		 end process;

end Behavioral;
