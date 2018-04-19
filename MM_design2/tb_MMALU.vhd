library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity tb_MMALU is
end tb_MMALU;

architecture tb of tb_MMALU is
    component MMALU
        port (rst  :     in  std_logic;
              clk  :     in  std_logic;
              load :     in  std_logic;
              x    :     in  std_logic_vector (log2primeM+1 downto 0);
              y    :     in  std_logic_vector (log2primeM+1 downto 0);
              t    :     out std_logic_vector (log2primeM+1 downto 0);
	      done :     out std_logic;
              en   :     in  std_logic;
              cmd  :     in  std_logic;
	      sub  :     in  std_logic);
    end component;

    signal rst      : std_logic;
    signal clk      : std_logic := '0';
    signal load     : std_logic;
    signal x        : std_logic_vector (log2primeM+1 downto 0);
    signal y        : std_logic_vector (log2primeM+1 downto 0);
    signal t        : std_logic_vector (log2primeM+1 downto 0);
    signal done     : std_logic;
    signal en       : std_logic;
    signal cmd      : std_logic;
    signal sub      : std_logic;

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
	      done => done,
              en   => en,
              cmd  => cmd, 
	      sub  => sub);

    -- Clock generation
    clk <= not clk after clk_period/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        rst <= '0';
        load <= '0';

	en <= '0';
        cmd <= '1';
        sub <= '0';
        
	-- General test

        -- Test for prime M = 7
	-- 16M < R => R > 112 => R = 128 (7 bits) => datapath of MMALU becomes 7-1 = 6 bits
	-- RR' - MM' = 1 => R' = 4 and M' = 73
	--x <= "11000"; --24
        --Y <= "10010"; --18 (24*18*4 mod 7 = 6 mod 7 = 13 mod7 --> "00110" = "01101")
	x <= "10" & x"0107a786ed2271bfaf288e7b3c5937044c3bdf866bd01449b1a192682f361140";
	y <= "01" & x"0083d3c3769138dfd794473d9e2c9b82261defc335e80a24d8d0c934179b08a0";

	-- EDIT Add stimuli here
        wait for 10 * clk_period;
        
        	rst <= '1';
		load <= '1';
		wait for clk_period;
		load <= '0';
		wait for clk_period*10;
		en <= '1';

		wait for clk_period*1000;

	-- Test adder
		--wait for clk_period;
		--rst <= '1';
		----x <= "01000"; --8
		----y <= "01101"; --13 (8 + 13 = 21 --> "10101")
		--x <= "00101";
		--y <= "00011";

		--cmd <= '1';
		--load <= '1';
		--wait for clk_period;
		--load <= '0';

	--wait for clk_period*10;

	--Test subtraction
		--sub <= '1';
		--load <= '1';
		--wait for clk_period;
		--load <= '0'; -- (8 - 13 + [2*7] = 9) 

	--wait for clk_period*10;	
		en <= '0';
		
	
        -- Stop the clock and hence terminate the simulation
	TbSimEnded <= '1';
	
    end process;

end tb;
