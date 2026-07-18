----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.02.2024 00:37:37
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
    Generic(N: natural range 2 to 256:=3);
    Port ( clk,rst,set: in std_logic;
           start: in std_logic;
           value_in: in std_logic_vector(15 downto 0);
           mux_in: in std_logic_vector(1 downto 0); --mux visore
           view: in std_logic;
           read: in std_logic;
           mem_en: in std_logic; --mux addr
           cont_sts: out std_logic;   --contatore celle memoria visualizzazione
           anodes_out : out  STD_LOGIC_VECTOR (7 downto 0); --anodi e catodi delle cifre, sono un output del topmodule
		   cathodes_out : out  STD_LOGIC_VECTOR (7 downto 0)         
    );
end Unita_Operativa;

architecture Structural of Unita_Operativa is

    component Cronometro is
        Port ( clk,rst,set_in,en: in std_logic;
               value_in: in std_logic_vector(31 downto 0);
               orario : out std_logic_vector(31 downto 0)            
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
    
    component mux_4_1_generic is
        Generic(N: natural range 1 to 256:=1);
        port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                a_2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                a_3 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                s:  in  STD_LOGIC_VECTOR (1 downto 0);
                y:  out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;
    
    component Flip_FlopT is
        port( T: in std_logic;
            Clock,rst: in std_logic;
            set: in std_logic:='0';
            data_in: in std_logic:='0';
            Q: out std_logic);
    end component;
    
    component MEM is
        Generic(N: natural range 1 to 256:=3;   -- numero locazioni
                M: natural range 1 to 256:=32); -- dimensione locazioni
        Port ( clk,rst: in std_logic;
               addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
               write: in std_logic;
               data_in: in std_logic_vector(31 downto 0);
               read: in std_logic;
               data_out: out std_logic_vector(31 downto 0)    
        );
    end component;
    
    COMPONENT Contatore_ModM is
        Generic(M: natural range 2 to 256:=8);
        Port ( clk,rst: in std_logic;
                en,set: in std_logic:='0';
                data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0):=(others=>'0');
                out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
                out_c: out std_logic
         );
    END COMPONENT;
    
    component mux_2_1_generic is
        Generic(N: natural range 1 to 256:=1);
        port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
                s:  in  std_logic;
                y:  out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;
    
    
signal start_clock: std_logic:='0';
signal cr_out: std_logic_vector(31 downto 0):=(others=>'0');
signal mem_out: std_logic_vector(31 downto 0):=(others=>'0');
signal mux_out: std_logic_vector(31 downto 0):=(others=>'0');
signal temp_in1, temp_in2:  std_logic_vector(31 downto 0):=(others=>'0');
signal addr_w: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0):=(others=>'0');
signal addr_r: std_logic_vector(addr_w'range):=(others=>'0');
signal addr: std_logic_vector(addr_w'range):=(others=>'0');

begin
seven_segment_array: Seven_segment_manager GENERIC MAP(
	CLKIN_freq => 100000000, 
	CLKOUT_freq => 500 
	)
	PORT MAP(
		CLK => clk,
		RST => rst,
		value => mux_out,
		enable => "11111111", --stabilisco che tutti i display siano accesi 
		dots => "00000000",  --stabilisco che tutti i punti siano spenti
		anodes => anodes_out,
		cathodes => cathodes_out
    );
    
   orologio: Cronometro PORT MAP(
        CLK => clk,
		RST => rst,
		set_in=>set,  --start_out cu
		en=>start_clock, --start_out cu	
        value_in=>mux_out,
        orario=>cr_out
   );

    temp_in1<=cr_out(31 downto 16) & value_in;
    temp_in2<=value_in & cr_out(15 downto 0);
    mux_visore: mux_4_1_generic generic map( N=> 32)
        port map(
            a_0=>cr_out,   --orrolgoio
            a_1=>mem_out,   --view
            a_2=>temp_in1,  --set1
            a_3=>temp_in2,   --set2
            s=>mux_in,
            y=>mux_out
        );
     
     flip_flop: Flip_FlopT 
             port map(
                clock=>clk,
                rst=>rst,
                T=>start,
                Q=>start_clock
            );
    
    contatore_lettura: contatore_ModM
        generic map(M=>N)
        port map(
            clk=>clk,
            rst=>rst,
            data_in=>(others=>'1'),
            en=>view,
            out_p=> addr_r,
            out_c=>cont_sts
        );
        
        
    contatore_scrittura: contatore_ModM
        generic map(M=>N)
        port map(
            clk=>clk,
            rst=>rst,
            en=>mem_en,
            out_p=> addr_w
        );
        
        
    mux_addr: mux_2_1_generic
        generic map(N=>2)
        port map(
            a_0=>addr_r,
            a_1=>addr_w,
            s=>mem_en,
            y=>addr
        );
    
    memoriaN: mem
        generic map(N=>N)
        port map(
            clk=>clk,
            rst=>rst,
            addr=>addr,
            write=>mem_en,
            read=>read,
            data_in=>cr_out,
            data_out=>mem_out
        );


end Structural;
