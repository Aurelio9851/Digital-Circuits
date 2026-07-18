----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 14:54:29
-- Design Name: 
-- Module Name: Top_Module - Structural
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

entity Top_Module is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic
     );
end Top_Module;

architecture Structural of Top_Module is

component Nodo_A is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        TXD 	: out std_logic 
     );
end component;


component Nodo_B is
generic (N: natural:=3;
         M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RXD: in std_logic
     );
end component;
signal trasmission: std_logic:='0';
begin

A: Nodo_A
    generic map(N=>8,M=>8)
    port map(
        clk=>clk,
        rst=>rst,
        run=>run,
        txd=>trasmission
    );
    
B: Nodo_B
    GENERIC MAP(N=>8,
                M=>8)
    PORT MAP(
        clk=>clk,
        rst=>rst,
        rxd=>trasmission 
    );
end Structural;
