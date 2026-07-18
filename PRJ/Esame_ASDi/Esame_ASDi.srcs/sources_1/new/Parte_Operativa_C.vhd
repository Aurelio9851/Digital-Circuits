----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 14:25:32
-- Design Name: 
-- Module Name: Parte_Operativa_C - Structural
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

entity Parte_Operativa_C is
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
end Parte_Operativa_C;

architecture Structural of Parte_Operativa_C is
component MEM is
    Generic(N: natural range 1 to 256:=3;
            M: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic:='0';
           data_in: in std_logic_vector(M-1 downto 0):=(others=>'0');
           read: in std_logic:='0';
           data_out: out std_logic_vector(M-1 downto 0)    
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

component Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0)
		);
end component;

component Comparatore is
generic (N: natural:=8);
Port (  A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic
);
end component;

signal addr_A: std_logic_vector(integer(ceil(log2(real(2*N))))-1 downto 0):=(others=>'0');
signal addr_B: std_logic_vector(integer(ceil(log2(real(N)))) downto 0):=(others=>'0');
signal str_A,str_B: std_logic_vector(dato_A'range):=(others=>'0');
signal final_result: std_logic_vector(integer(ceil(log2(real(N)))) downto 0):=(others=>'0');
signal rst_in: std_logic:='0';
begin

memA: MEM
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr_A(addr_B'high-1 downto 0),
        write=>write_A,
        read=>read,
        data_in=>dato_A,
        data_out=>str_A
    );
    
memB: MEM
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr_B(addr_B'high-1 downto 0),
        write=>write_B,
        read=>read,
        data_in=>dato_B,
        data_out=>str_B
    );
    
counter_A: Contatore_ModM 
   generic map(M=>2*N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count_A,
    out_p=>addr_A 
   );
   
   stato_A<=addr_A(addr_A'high);
   
counter_B: Contatore_ModM 
   generic map(M=>N+1)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count_B,
    out_p=> addr_B,
    out_c=>stato_B   
   );

comp: Comparatore
    generic map(N=>M)
    port map(
        A=>str_A,
        B=>str_B,
        Y=>stato_comp
    );


rst_in<=rst or reset_count;
counter_C: Contatore_ModM 
   generic map(M=>N+1)
   port map(
    clk=>clk,
    rst=>rst_in,
    en=> count_c,
    out_p=>final_result  
   );

 risultato : Registro_N
   generic map(N=>final_result'LENGTH)
   port map(
        clk=>clk,
        res=>rst,
        load=>W_EQ,
        A=>final_result,
        B=>eq
   );


end Structural;

architecture Structural_v2 of Parte_Operativa_C is
component MEM is
    Generic(N: natural range 1 to 256:=3;
            M: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic:='0';
           data_in: in std_logic_vector(M-1 downto 0):=(others=>'0');
           read: in std_logic:='0';
           data_out: out std_logic_vector(M-1 downto 0)    
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

component Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0)
		);
end component;

component Comparatore is
generic (N: natural:=8);
Port (  A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic
);
end component;

signal addr_A: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0):=(others=>'0');
signal addr_B: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0):=(others=>'0');
signal str_A,str_B: std_logic_vector(dato_A'range):=(others=>'0');
signal final_result: std_logic_vector(integer(ceil(log2(real(N)))) downto 0):=(others=>'0');
signal rst_in: std_logic:='0';
begin

memA: MEM
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr_A,
        write=>write_A,
        read=>read,
        data_in=>dato_A,
        data_out=>str_A
    );
    
memB: MEM
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr_B,
        write=>write_B,
        read=>read,
        data_in=>dato_B,
        data_out=>str_B
    );
    
counter_A: Contatore_ModM 
   generic map(M=>N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count_A,
    out_p=>addr_A,
    out_c=>stato_A
   );
      
counter_B: Contatore_ModM 
   generic map(M=>N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count_B,
    out_p=> addr_B,
    out_c=>stato_B   
   );

comp: Comparatore
    generic map(N=>M)
    port map(
        A=>str_A,
        B=>str_B,
        Y=>stato_comp
    );

rst_in<=rst or reset_count;
counter_C: Contatore_ModM 
   generic map(M=>N+1)
   port map(
    clk=>clk,
    rst=>rst_in,
    en=> count_c,
    out_p=>final_result  
   );

 risultato : Registro_N
   generic map(N=>final_result'LENGTH)
   port map(
        clk=>clk,
        res=>rst,
        load=>W_EQ,
        A=>final_result,
        B=>eq
   );


end Structural_v2;
