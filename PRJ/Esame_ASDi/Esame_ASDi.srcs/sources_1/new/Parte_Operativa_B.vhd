----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 17:10:32
-- Design Name: 
-- Module Name: Parte_Operativa_B - Structural
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

entity Parte_Operativa_B is
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
end Parte_Operativa_B;

architecture Structural of Parte_Operativa_B is

component Rom_combinatoria_B is
     Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
    Port ( 
            addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            y: out std_logic_vector(M-1 downto 0)
         );
end component;

component Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0)
		);
end component;

component Contatore_ModM is
Generic(M: natural range 2 to 256:=8);
    Port (  clk: in std_logic;
            rst: in std_logic:='0';
            en,set: in std_logic:='0';
            data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0):=(others=>'0');
            out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_c: out std_logic
     );
end component;

signal addr: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0):=(others=>'0');
signal data_out: std_logic_vector(dato'RANGE);
begin

   counter: Contatore_ModM 
   generic map(M=>N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count,
    out_p=>addr,
    out_c=>stato   
   );
   
   rom: Rom_combinatoria_B
   generic map(N=>N, M=> M)
   port map(
    addr=>addr,
    y=>data_out
   );
   
   buffer_dato: Registro_N
   generic map(N=>data_out'LENGTH)
   port map(
        clk=>clk,
        res=>rst,
        load=>read,
        A=>data_out,
        B=>dato
   );

end Structural;

