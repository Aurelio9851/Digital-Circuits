----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 14:25:32
-- Design Name: 
-- Module Name: Nodo_C - Structural
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

entity Nodo_C is
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
end Nodo_C;

architecture Structural of Nodo_C is
component Control_Unit_C is
    Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        STATO_A: in std_logic;
        STATO_B: in std_logic;
        STATO_COMP: in std_logic;
        READY_A: in std_logic;
        READY_B: in std_logic;
        WRITE_A: out std_logic;
        WRITE_B: out std_logic;
        W_EQ: out std_logic; 
        READ: out std_logic;
        ACK_A: out std_logic;
        ACK_B: out std_logic;
        COUNT_A: out std_logic;
        COUNT_B: out std_logic;
        COUNT_C: out std_logic;
        RESET_COUNT: out std_logic
     );
end component;

component Parte_Operativa_C is
generic (N: natural:=16;
         M: natural range 1 to 256:=8);
Port ( clk: in std_logic;
        rst: in std_logic; 
        read: in std_logic;
        write_A: in std_logic;
        write_B: in std_logic;
        COUNT_A: in std_logic;
        COUNT_B: in std_logic;
        COUNT_C: in std_logic;
        W_EQ: in std_logic;
        RESET_COUNT: in std_logic;
        dato_A:  in std_logic_vector(M-1 downto 0);
        dato_B:  in std_logic_vector(M-1 downto 0);
        eq:     out std_logic_vector(integer(ceil(log2(real(N)))) downto 0);
        stato_B: out std_logic;        
        stato_A: out std_logic;
        stato_comp: out std_logic    
        );
end component;

signal stato_A,stato_B,stato_comp: std_logic:='0';
signal write_A,write_B,read,write_EQ: std_logic:='0';
signal count_A,count_B,count_C: std_logic:='0';
signal rst_count: std_logic:='0';

begin

cu: Control_Unit_C
    port map(
        clk=>clk,
        rst=>rst,
        stato_A=>stato_A,
        stato_B=>stato_B,
        stato_comp=>stato_comp, 
        write_A=>write_A,
        write_B=>write_B,
        w_EQ=>write_EQ, 
        reset_count=>rst_count,
        read=>read,
        count_A=>count_A,
        count_B=>count_B,
        count_C=>count_C,
        ready_A=>ready_A,
        ready_B=>ready_B,
        ack_A=>ack_A,
        ack_B=>ack_B
    );

po: Parte_Operativa_C
    generic map(N=>N,M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        stato_A=>stato_A,
        stato_B=>stato_B,
        stato_comp=>stato_comp, 
        write_A=>write_A,
        write_B=>write_B,
        w_EQ=>write_EQ, 
        read=>read,
        reset_count=>rst_count,
        eq=>eq,
        count_A=>count_A,
        count_B=>count_B,
        count_C=>count_C,
        dato_A=>dato_A,
        dato_B=>dato_B
    );


end Structural;

