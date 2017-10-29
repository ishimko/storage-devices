library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity ram_tb is
		generic(
		word_size : INTEGER := 8;
		address_size : INTEGER := 2 );
end ram_tb;

architecture TB_ARCHITECTURE of ram_tb is
	component ram
		generic(
		word_size : INTEGER := 8;
		address_size : INTEGER := 2 );
	port(
		CLK : in STD_LOGIC;
		write_enable : in STD_LOGIC;
		address_bus : in STD_LOGIC_VECTOR(address_size-1 downto 0);
		data_bus : inout STD_LOGIC_VECTOR(word_size-1 downto 0) );
	end component;

	signal CLK : STD_LOGIC := '0';
	signal write_enable : STD_LOGIC;
	signal address_bus : STD_LOGIC_VECTOR(address_size-1 downto 0);
	signal data_bus : STD_LOGIC_VECTOR(word_size-1 downto 0);
	
	constant clock_period: time := 10 ns;
	constant tests_count: integer := 4;
	type words_array is array(0 to tests_count-1) of std_logic_vector(word_size-1 downto 0);
	type addresses_array is array(0 to tests_count-1) of std_logic_vector(address_size-1 downto 0);
	constant test_words: words_array := (x"FF", x"00", x"01", x"0A");							   
	constant test_addresses: addresses_array := ("00", "01", "10", "11");
begin
	UUT : entity ram(beh)
		generic map (
			word_size => word_size,
			address_size => address_size
		)

		port map (
			CLK => CLK,
			write_enable => write_enable,
			address_bus => address_bus,
			data_bus => data_bus
		);
	
	stimulate: process
	begin
		for i in 0 to tests_count-1	loop
			address_bus <= test_addresses(i);
			data_bus <= test_words(i);
			write_enable <= '1';
			wait for clock_period;
		end loop; 
		write_enable <= '0';		  
		data_bus <= (others => 'Z');
		for i in 0 to tests_count-1	loop	 
			address_bus <= test_addresses(i);
			wait for clock_period;
		end loop;
		assert (false) report "End of simulation" severity failure;
	end process;
	
	CLK <= not CLK after clock_period / 2;
end TB_ARCHITECTURE;