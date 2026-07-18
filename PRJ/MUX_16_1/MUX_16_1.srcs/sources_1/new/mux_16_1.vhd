library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Definizione dell'interfaccia del modulo mux_16_1.

entity mux_16_1 is

    port(   b : in  STD_LOGIC_VECTOR (15 downto 0);
            s:  in  STD_LOGIC_VECTOR (3 downto 0);
            y:  out STD_LOGIC
    );
end mux_16_1;

architecture structural of mux_16_1 is
    signal u0 : STD_LOGIC := '0';
    signal u1 : STD_LOGIC := '0';
    signal u2 : STD_LOGIC := '0';
	signal u3 : STD_LOGIC := '0';

    component mux_4_1    
        port(   a : in  STD_LOGIC_VECTOR (3 downto 0);
                s:  in  STD_LOGIC_VECTOR (1 downto 0);
                y:  out STD_LOGIC
        ); 
    end component;

    begin
        mux0: mux_4_1
            port map(
                a => b (3 downto 0),
                s => s (1 downto 0),
                y => u0
            );
        
        mux1: mux_4_1
        port map(
            a => b (7 downto 4),
            s => s (1 downto 0),
            y => u1
        );

        mux2: mux_4_1
            port map(
                a => b (11 downto 8),
                s => s (1 downto 0),
                y => u2
            );

        mux3: mux_4_1
        port map(
            a => b (15 downto 12),
            s => s (1 downto 0),
            y => u3
        );

        mux4: mux_4_1
        port map(
            a(0) => u0,
            a(1) => u1,
            a(2) => u2,
            a(3) => u3,
            s => s (3 downto 2),
            y => y
        );          
end structural;

