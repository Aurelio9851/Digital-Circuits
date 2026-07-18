----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2024 15:33:12
-- Design Name: 
-- Module Name: Booth_on_Board - Structural
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

entity Booth_on_Board is
Port (
        CLK: in std_logic;
        RST: in std_logic;
        START: in std_logic;
        LOAD_X,LOAD_Y: in std_logic;
        SW: in std_logic_vector(7 downto 0);
        
        anodes_out : out  STD_LOGIC_VECTOR (7 downto 0); --anodi e catodi delle cifre, sono un output del topmodule
		cathodes_out : out  STD_LOGIC_VECTOR (7 downto 0)      
        );
end Booth_on_Board;

architecture Structural of Booth_on_Board is
component Top_Module is
Generic (N: natural range 1 to 256:=8);
Port (
        CLK: in std_logic;
        RST: in std_logic;
        START: in std_logic;
        STOP: out std_logic;
        X,Y: in std_logic_vector(7 downto 0);
        P: out std_logic_vector(15 downto 0)
         );
end component;

component mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;

component Seven_segment_manager is
Generic( 
				CLKIN_freq : integer := 100000000; 
				CLKOUT_freq : integer := 500
				);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           VALUE : in  STD_LOGIC_VECTOR (31 downto 0);
           ENABLE : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali cifre abilitare
           DOTS : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali punti visualizzare
           ANODES : out  STD_LOGIC_VECTOR (7 downto 0);
           CATHODES : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component Registro_N is
    generic( N: natural range 1 to 256:=1);
	port( A: in std_logic_vector(N-1 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(N-1 downto 0));
end component;

component ButtonDebouncer is
    generic (                       
        CLK_period: integer := 10;  -- periodo del clock (della board) in nanosecondi
        btn_noise_time: integer := 10000000 -- durata stimata dell'oscillazione del bottone in nanosecondi
                                            -- il valore di default è 10 millisecondi
    );
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
end component;

signal load1,load2,start_cln: std_logic:='0';
signal X_Out,Y_out: std_logic_vector(SW'range):=(others=>'0');
signal Result:std_logic_vector(31 downto 0):=(others=>'0');
signal stop_cu,display_enable,mux: std_logic:='0';
signal mux_out: std_logic_vector(7 downto 0):=(others=>'0');
begin
x_reg: Registro_N
    generic map(N=>SW'LENGTH)
    port map(
        clk=>clk,
        res=>rst,
        load=>load1,
        A=>SW,
        B=>X_out
    );
Y_reg: Registro_N
    generic map(N=>SW'LENGTH)
    port map(
        clk=>clk,
        res=>rst,
        load=>load2,
        A=>SW,
        B=>Y_out
    );
 
display_enable<=start_cln or stop_cu;
display_en: Registro_N
    generic map(N=>1)
    port map(
        clk=>clk,
        res=>rst,
        load=>display_enable,
        A(0)=>stop_cu,
        B(0)=>mux
   );
    
top_mod: Top_Module 
    port map(
        clk=>clk,
        rst=>rst,
        start=>start_cln,
        stop=>stop_cu,
        x=>x_out,
        y=>y_out,
        p=>Result(X_out'LENGTH+Y_out'LENGTH-1 downto 0)    
    );

mux_v: mux_2_1_generic
    generic map(N=>8)
    port map(
        a_0=>"00000000",
        a_1=>"11111111",
        s=>mux,
        y=>mux_out
    );
visore: Seven_segment_manager
    PORT MAP(
		CLK => clk,
		RST => rst,
		value => Result,
		enable => mux_out, 
		dots => "00000000",  
		anodes => anodes_out,
		cathodes => cathodes_out
    );



start_btn: ButtonDebouncer
    port map(
        clk=>clk,
        rst=>rst,
        btn=>start,
        cleared_btn=>start_cln
    );

l1: ButtonDebouncer
    port map(
        clk=>clk,
        rst=>rst,
        btn=>LOAD_X,
        cleared_btn=>load1
    );
    
l2: ButtonDebouncer
    port map(
        clk=>clk,
        rst=>rst,
        btn=>LOAD_Y,
        cleared_btn=>load2
    );

end Structural;
