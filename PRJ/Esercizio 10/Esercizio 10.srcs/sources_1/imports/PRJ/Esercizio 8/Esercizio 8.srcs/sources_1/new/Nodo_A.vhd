----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 12:14:09
-- Design Name: 
-- Module Name: Nodo_A - Structural
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nodo_A is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        TXD 	: out std_logic 
     );
end Nodo_A;

architecture Structural of Nodo_A is
component Control_Unit_A is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        START: in std_logic;
        TBE: in std_logic;
        WR: out std_logic;
        COUNT: out std_logic
     );
end component;


component Parte_Operativa_A is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (  clk: in std_logic;
        rst: in std_logic; 
        WR: in std_logic;
        count: in std_logic;
        TXD: out std_logic;
        TBE: inout std_logic 
        );
end component;
signal tbe,wr,count: std_logic:='0';
begin

cu: Control_Unit_A
    port map(
        clk=>clk,
        rst=>rst,
        start=>run,
        tbe=>tbe,
        wr=>wr,
        count=>count
    );

po: Parte_Operativa_A
    generic map(N=>N, M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        wr=>wr,
        tbe=>tbe,
        count=>count,
        txd=>txd         
    );

end Structural;
