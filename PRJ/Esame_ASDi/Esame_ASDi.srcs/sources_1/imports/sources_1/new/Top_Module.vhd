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
use IEEE.math_real.ALL;

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
        CLK_C:  in std_logic;
        RST:  in std_logic;
        START_B,START_A: in std_logic;
        EQ:    out std_logic_vector(3 downto 0);
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
        START_A: in std_logic;
        ACK: in std_logic;
        STOP: out std_logic;
        READY: out std_logic;
        DATO: out std_logic_vector(M-1 downto 0)
     );
end component;


component Nodo_B is
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
end component;

component Nodo_C is
Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        READY_A: in std_logic;
        READY_B: in std_logic;
        ACK_A: out std_logic;
        ACK_B: out std_logic;
        EQ:    out std_logic_vector(integer(ceil(log2(real(N)))) downto 0);
        dato_A:  in std_logic_vector(M-1 downto 0);
        dato_B:  in std_logic_vector(M-1 downto 0)
     );
end component;

signal ready_A,ready_B,ack_A,ack_B: std_logic:='0';
signal dato_A,dato_B: std_logic_vector(7 downto 0);
begin

A: Nodo_A
    generic map(N=>16,M=>8)
    port map(
        clk=>clk_A,
        rst=>rst,
        start_A=>start_A,
        ack=>ack_A,
        stop=>stop_A,
        ready=>ready_A,
        dato=>dato_A
    );
    
B: Nodo_B
    GENERIC MAP(N=>16,
                M=>8)
    PORT MAP(
        clk=>clk_B,
        rst=>rst,
        start_B=>start_B,
        ack=>ack_B,
        stop=>stop_B,
        ready=>ready_B,
        dato=>dato_B  
    );
    
C: Nodo_C
    GENERIC MAP(N=>8,
                M=>8)
    PORT MAP(
        clk=>clk_C,
        rst=>rst,
        dato_A=>dato_A,
        dato_B=>dato_B,
        ready_A=>ready_A,
        ready_B=>ready_B,
        eq=>eq,
        ack_A=>ack_A,
        ack_B=>ack_B
    );
end Structural;
