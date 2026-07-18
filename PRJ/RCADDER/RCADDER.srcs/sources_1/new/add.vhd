----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2023 13:43:53
-- Design Name: 
-- Module Name: add - Behavioral
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

entity add is
    Port (  a : in STD_LOGIC_VECTOR (1 downto 0);
			c : in STD_LOGIC;
			cout: out STD_LOGIC;
			sum : out STD_LOGIC );
end add;

architecture dataflow of add is
begin
    sum <= (a(1) xor a(2) xor c);
    cout <= ((a(1) and a(2)) or (c and (a(1) or a(2))));
end dataflow;


