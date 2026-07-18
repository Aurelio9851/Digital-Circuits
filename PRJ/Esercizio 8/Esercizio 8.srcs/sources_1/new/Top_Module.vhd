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
        CLK_A:  in std_logic;
        CLK_B:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_A,STOP_B: out std_logic
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
        PRELEVATO: in std_logic;
        STOP: out std_logic;
        PRONTO: out std_logic;
        DATO: out std_logic_vector(M-1 downto 0)
     );
end component;


component Nodo_B is
generic (N: natural:=3;
         M: natural range 1 to 256:=8);
Port(
        CLK:  in std_logic;
        RST:  in std_logic;
        PRONTO: in std_logic;
        DATO: in std_logic_vector(M-1 downto 0);
        PRELEVATO: out std_logic;
        STOP: out std_logic
     );
end component;
signal prelevato,pronto,ack: std_logic:='0';
signal dato: std_logic_vector(7 downto 0);
begin

A: Nodo_A
    generic map(N=>8,M=>8)
    port map(
        clk=>clk_A,
        rst=>rst,
        run=>run,
        prelevato=>prelevato,
        stop=>stop_A,
        pronto=>pronto,
        dato=>dato
    );
    
B: Nodo_B
    GENERIC MAP(N=>8,
                M=>8)
    PORT MAP(
        clk=>clk_B,
        rst=>rst,
        pronto=>pronto,
        prelevato=>prelevato,
        dato=>dato,
        stop=>stop_B    
    );
end Structural;
