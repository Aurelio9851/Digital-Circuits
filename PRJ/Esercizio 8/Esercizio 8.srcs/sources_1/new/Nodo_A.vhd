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
        PRELEVATO: in std_logic;
        STOP: out std_logic;
        PRONTO: out std_logic;
        DATO: out std_logic_vector(M-1 downto 0)
     );
end Nodo_A;

architecture Structural of Nodo_A is
component Control_Unit_A is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        PRELEVATO: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        PRONTO: out std_logic;
        COUNT: out std_logic
     );
end component;


component Parte_Operativa_A is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (  clk: in std_logic;
        rst: in std_logic; 
        read: in std_logic;
        count: in std_logic;
        stato: out std_logic;
        dato:  out std_logic_vector(M-1 downto 0)
        );
end component;
signal stats,read,count: std_logic:='0';
begin

cu: Control_Unit_A
    port map(
        clk=>clk,
        rst=>rst,
        run=>run,
        stop_count=>stats,
        prelevato=>prelevato,
        stop=>stop,
        read=>read,
        count=>count,
        pronto=>pronto    
    );

po: Parte_Operativa_A
    generic map(N=>N, M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        read=>read,
        count=>count,
        stato=>stats,
        dato=>dato    
    );

end Structural;
