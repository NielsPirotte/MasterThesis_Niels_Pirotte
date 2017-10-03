library ieee;
use ieee.std_logic_1164.all;

entity tb_MMALU is
    generic(d: integer := 1; -- Word size
            q: integer := 4 -- Datapath size
           );
end tb_MMALU;

architecture tb of tb_MMALU is
    component MMALU
        port (rst  : in std_logic;
              clk  : in std_logic;
              load : in std_logic;
              x    : in std_logic_vector (q-1+d downto 0);
              y    : in std_logic_vector (q-1+d downto 0);
              t    : out std_logic_vector (q-1+d downto 0);
	debugx: out std_logic_vector(q-1+d downto 0);
	debugy: out std_logic_vector(q-1+d downto 0);
              en   : in std_logic;
              cmd  : in std_logic);
    end component;

    signal rst  : std_logic;
    signal clk  : std_logic := '0';
    signal load : std_logic;
    signal x    : std_logic_vector (q-1+d downto 0);
    signal y    : std_logic_vector (q-1+d downto 0);
    signal t    : std_logic_vector (q-1+d downto 0);
	signal debugx: std_logic_vector(q-1+d downto 0);
	signal debugy: std_logic_vector(q-1+d downto 0);
    signal en   : std_logic;
    signal cmd  : std_logic;

    constant clk_period : time := 1000 us; -- EDIT Put right period here
    signal TbSimEnded : std_logic := '0';

begin

    dut : MMALU
    port map (rst  => rst,
              clk  => clk,
              load => load,
              x    => x,
              y    => y,
              t    => t,
		debugx => debugx,
		debugy => debugy,
              en   => en,
              cmd  => cmd);

    -- Clock generation
    clk <= not clk after clk_period/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        rst <= '0';
        load <= '0';
        
        --x<= "01100"; --12
        --y <= "00100"; --4
	x<= "00011"; --3
        Y <= "00111"; --7
        
        en <= '0';
        cmd <= '0';

        -- EDIT Add stimuli here
        wait for 10 * clk_period;
        
        	rst <= '1';
		load <= '1';
		wait for clk_period;
		load <= '0';
		wait for clk_period*10;
		
		
		
		en <= '1';
	-- From n-1 to 0 
		wait for clk_period*5;
		
		en <= '0';

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
