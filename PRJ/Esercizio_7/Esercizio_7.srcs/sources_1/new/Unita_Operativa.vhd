----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2024 18:23:52
-- Design Name: 
-- Module Name: Unita_Operativa - Structural
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

entity Unita_Operativa is
Generic(N: natural range 1 to 256:=8);
Port (
    CLK: in std_logic;
    RST: in std_logic;
    SUBTRACT: in std_logic;
    SHIFT: in std_logic;
    COUNT_IN: in std_logic;
    SELECT_LOAD: in std_logic;
    LOAD_AQ,LOAD_M: in std_logic;
    X: in std_logic_vector(N-1 downto 0);
    M: in std_logic_vector(N-1 downto 0);
    COUNT_OUT: out std_logic;
    Q_1: out std_logic;
    RESULT: out std_logic_vector(2*N-1 downto 0)
 );
end Unita_Operativa;

architecture Structural of Unita_Operativa is

component reg_scorr is
    Generic(N: natural range 4 to 256:=4);
    Port ( input: in std_logic_vector(1 downto 0):=(others=>'0');
           mode: in std_logic:='0';
           n_bit: in std_logic:='0';
           load: in std_logic:='0';
           in_parallelo: in std_logic_vector(N-1 downto 0):=(others=>'0');
           out_seriale: out std_logic;
           out_parallelo: out std_logic_vector(N-1 downto 0);
           rst,clk: in std_logic;
           en: in std_logic
    );
end component;

component Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0));
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

component adder_sub is
    generic(N: natural range 2 to 256:=8);
	port( X, Y: in std_logic_vector(N-1 downto 0);
		  cin: in std_logic;
		  Z: out std_logic_vector(N-1 downto 0);
		  cout: out std_logic);		  
end component;

component mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;

component flip_flop is
    Port ( D: in std_logic;
           clk,rst,en: in std_logic;
           Q: out std_logic );
end component;


signal op1,mux_l: std_logic_vector(2*N-1 downto 0);
signal op2: std_logic_vector(N-1 downto 0);
signal A,P: std_logic_vector(N-1 downto 0):=(others=>'0');
signal AQ,sum_in: std_logic_vector(2*N-1 downto 0);
signal qmeno1,rst_ff: std_logic:='0';
begin

    mux_load: mux_2_1_generic
        generic map(N=>2*N)
        port map(
           a_0=>sum_in,
           a_1=>AQ,
           s=>SELECT_LOAD,
           y=>mux_l
        );
        
    reg_M: Registro_N
        generic map(N=>N)
        port map(
            a=>M,
            clk=>clk,
            res=>rst,
            load=>load_m,
            b=>op2
        );
        
    a_q: reg_scorr
        generic map(N=>2*N)
        port map(
            clk=>clk,
            rst=>rst,
            en=>shift,
            mode=>'1',
            load=>LOAD_AQ,
            input=>op1(op1'high downto op1'high-1),
            in_parallelo=>mux_l,
            out_seriale=>qmeno1,
            out_parallelo=>op1
        );
    
    add_sub: adder_sub
        generic map(N=>N)
        port map(
            x=>op1(2*N-1 downto N),
            y=>op2,
            cin=>subtract,
            z=>P
        );
    counter: Contatore_ModM
        generic map(M=>N)
        port map(
            clk=>clk,
            rst=>rst,
            en=>count_in,
            out_c=>COUNT_OUT
        );
        
    qmeno1_ff: flip_flop
        port map(
            clk=>clk,
            rst=>rst_ff,
            en=>shift,
            d=>op1(0),
            q=>Q_1
        );
    rst_ff<=rst or SELECT_LOAD;
    sum_in<=P&op1(N-1 downto 0);    
    A<=(others=>'0');    
    AQ<=A&X;  
    
    RESULT<=op1;    

end Structural;
