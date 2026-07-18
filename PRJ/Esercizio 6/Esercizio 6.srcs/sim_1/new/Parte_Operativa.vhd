----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.02.2024 17:22:53
-- Design Name: 
-- Module Name: Parte_Operativa - Structural
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

entity Parte_Operativa is
     Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
     Port (CLK:   in std_logic;
           RST:   in std_logic;
           START: in std_logic;
           READ:  in std_logic;
           WRITE: in std_logic;
           STOP:  out std_logic;
           DATA:  out std_logic_vector(3 downto 0)
      );
end Parte_Operativa;

architecture Structural of Parte_Operativa is

    component ROM is
    Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
    Port ( 
    CLK:  in std_logic;
    RST:  in std_logic;
    READ: in std_logic;  
    ADDR : in  std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);                                           
    DATA : out std_logic_vector(M-1 downto 0) 
    );
    end component;
    
    component Macchina_M is
    Port ( input : in std_logic_vector(7 downto 0);
           y : out std_logic_vector(3 downto 0));
    end component;
    
    component MEM is
    Generic(N: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic:='0';
           data_in: in std_logic_vector(3 downto 0):=(others=>'0');
           read: in std_logic:='0';
           data_out: out std_logic_vector(3 downto 0)    
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
signal rom2M: std_logic_vector(7 downto 0):=(others=>'0');
signal M2mem: std_logic_vector(3 downto 0):=(others=>'0');

begin
    memoria_rom: ROM
    generic map(N=> N, M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        read=>read,
        addr=>addr,
        data=>rom2M
    );
    
    M_comb: Macchina_M port map(
        input=>rom2M,
        y=>M2mem
    );
    
    memoria: MEM 
    generic map(N=>N)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr,
        data_in=>M2mem,
        write=>write
        );
   
   counter: Contatore_ModM 
   generic map(M=>N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> start,
    out_p=>addr,
    out_c=>stop   
   );
     
    DATA<=M2mem;
end Structural;
