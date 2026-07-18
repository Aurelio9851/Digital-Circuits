----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2024 15:58:56
-- Design Name: 
-- Module Name: Cronometro - Structural
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cronometro is
    Port ( clk,rst,set_in,en: in std_logic;
           value_in: in std_logic_vector(31 downto 0);
           orario : out std_logic_vector(31 downto 0)            
    );
end Cronometro;

architecture Structural of Cronometro is

COMPONENT clk_filter
	GENERIC(
				CLKIN_freq : integer := 100000000;
				CLKOUT_freq : integer := 500
				);
	PORT(
		clock_in : IN std_logic; 
        reset : in  STD_LOGIC;		
		clock_out : OUT std_logic
		);
END COMPONENT;

COMPONENT Contatore_ModM is
    Generic(M: natural range 2 to 256:=8);
    Port ( clk,rst: in std_logic;
            en,set: in std_logic;
            data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_c: out std_logic
     );
END COMPONENT;


signal cr: std_logic_vector(31 downto 0):=(others=>'0');
signal clock_filter_out,en1 : std_logic := '0';
signal enable_in: std_logic_vector(7 downto 0):=(others=>'0');
signal rst_in: std_logic:='0';
signal out_in: std_logic_vector(7 downto 0):=(others=>'0');

begin

clock_filter: clk_filter GENERIC MAP(
	CLKIN_freq => 100000000,
	CLKOUT_freq => 100
	)
	PORT MAP(
		clock_in => CLK,
		reset => RST,
		clock_out => clock_filter_out
	);


centi_Sec1: Contatore_ModM
    generic map(M=>10)
    port map(
	clk => CLK,
	en => enable_in(0),
	rst => rst,
	set=>set_in,
	data_in=>value_in(3 downto 0),
	out_c => out_in(0),
	out_p=>cr(3 downto 0)
);

cenit_Sec2: Contatore_ModM
    generic map(M=>10)
    port map(
	clk => CLK,
	en => enable_in(1),
	rst => rst,
	set=>set_in,
	data_in=>value_in(7 downto 4),
	out_c => out_in(1),
	out_p=>cr(7 downto 4)
);

Sec1: Contatore_ModM
    generic map(M=>10)
    port map(
	clk => CLK,
	en => enable_in(2),
	rst => rst,
	set=>set_in,
	data_in=>value_in(11 downto 8),
	out_c => out_in(2),
	out_p=>cr(11 downto 8)
);

Sec2: Contatore_ModM
    generic map(M=>6)
    port map(
	clk => CLK,
	en => enable_in(3),
	rst => rst,
	set=>set_in,
	data_in=>value_in(14 downto 12),
	out_c => out_in(3),
	out_p=>cr(14 downto 12)
);

Min1: Contatore_ModM
    generic map(M=>10)
    port map(
	clk => CLK,
	en => enable_in(4),
	rst => rst,
	set=>set_in,
	data_in=>value_in(19 downto 16),
	out_c => out_in(4),
	out_p=>cr(19 downto 16)
);

Min2: Contatore_ModM
    generic map(M=>6)
    port map(
	clk => CLK,
	en => enable_in(5),
	rst => rst,
	set=>set_in,
	data_in=>value_in(22 downto 20),
	out_c => out_in(5),
	out_p=>cr(22 downto 20)
);

H1: Contatore_ModM
    generic map(M=>10)
    port map(
	clk => CLK,
	en => enable_in(6),
	rst => rst_in,
	set=>set_in,
	data_in=>value_in(27 downto 24),
	out_c => out_in(6),
	out_p=>cr(27 downto 24)
);

H2: Contatore_ModM
    generic map(M=>3)
    port map(
	clk => CLK,
	en => enable_in(7),
	rst => rst_in,
	set=>set_in,
	data_in=>value_in(29 downto 28),
	out_c => out_in(7),
	out_p=>cr(29 downto 28)
);

-- and di abilitazione del primo contatore
enable_in(0)<=clock_filter_out and en;
--and bit a bit del vettore di enable -> enable(i) è il risultato della and tra enable(i-1) e out_in(i-1) con out_in(i) alto quando l'iesimo contatore conta M-1
enable_in(enable_in'high downto 1)<= enable_in(enable_in'high-1 downto 0) and out_in(out_in'high-1 downto 0);
        

orario<= cr;
--segnale di reset per i contatori delle ore ->23:59:59:99
-- impulso sul primo contatore alto, out_in di tutti i contatori alti tranne H1 che deve segnare 3
rst_in<='1' when ((TO_INTEGER(Unsigned(cr(27 downto 24)))=(3)) and ((out_in(7)&out_in(5 downto 0))="1111111") and enable_in(0)='1') else rst;


end Structural;
