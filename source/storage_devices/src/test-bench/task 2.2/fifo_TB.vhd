library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity fifo_tb is
		generic(
		word_size : INTEGER := 8;
		address_size : INTEGER := 2 );
end fifo_tb;

architecture TB_ARCHITECTURE of fifo_tb is
	component fifo
		generic(
		word_size : INTEGER := 8;
		address_size : INTEGER := 2 );
	port(
		CLK : in STD_LOGIC;
		write_enable : in STD_LOGIC;
		data_bus : inout STD_LOGIC_VECTOR(word_size-1 downto 0);
		empty : out STD_LOGIC;
		full : out STD_LOGIC );
	end component;

	signal CLK : STD_LOGIC := '0';
	signal write_enable : STD_LOGIC;
	signal data_bus : STD_LOGIC_VECTOR(word_size-1 downto 0);

	signal empty : STD_LOGIC;
	signal full : STD_LOGIC;
	
	constant clock_period: time := 10 ns;
	constant tests_count: integer := 4;
	type words_array is array(0 to tests_count-1) of std_logic_vector(word_size-1 downto 0);
	constant test_words: words_array := (x"FF", x"00", x"01", x"0A");
begin
	UUT : entity fifo(beh)
		generic map (
			word_size => word_size,
			address_size => address_size
		)

		port map (
			CLK => CLK,
			write_enable => write_enable,
			data_bus => data_bus,
			empty => empty,
			full => full
		);

	stimulate: process
	begin							  
		write_enable <= '1';
		for i in 0 to tests_count-1	loop
			data_bus <= test_words(i);
			wait for clock_period;
		end loop;			
		data_bus <= (others => 'Z');
		write_enable <= '0';
		wait for clock_period*(tests_count);
		assert (false) report "End of simulation" severity failure;
	end process;
	
	CLK <= not CLK after clock_period / 2;

end TB_ARCHITECTURE;

