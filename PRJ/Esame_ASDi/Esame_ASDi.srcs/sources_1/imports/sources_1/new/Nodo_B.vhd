----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 12:14:09
-- Design Name: 
-- Module Name: Nodo_B - Structural
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

entity Nodo_B is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        START_B: in std_logic;
        ACK: in std_logic;
        STOP: out std_logic;
        READY: out std_logic;
        DATO: out std_logic_vector(M-1 downto 0)
     );
end Nodo_B;

architecture Structural of Nodo_B is

component Control_Unit_A is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        ACK: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        READY: out std_logic;
        COUNT: out std_logic
     );
end component;


component Parte_Operativa_B is
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
        run=>START_B,
        stop_count=>stats,
        ack=>ack,
        stop=>stop,
        read=>read,
        count=>count,
        ready=>ready    
    );

po: Parte_Operativa_B
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
