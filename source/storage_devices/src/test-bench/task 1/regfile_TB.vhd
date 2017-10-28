library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity regfile_tb is
		generic(
		reg_size : INTEGER := 4;
		address_size : INTEGER := 2 );
end regfile_tb;

architecture TB_ARCHITECTURE of regfile_tb is
	component regfile
		generic(
		reg_size : INTEGER := 4;
		address_size : INTEGER := 2 );
	port(
		init : in STD_LOGIC;
		write_port : in STD_LOGIC_VECTOR(reg_size-1 downto 0);
		read_port : out STD_LOGIC_VECTOR(reg_size-1 downto 0);
		write_address : in STD_LOGIC_VECTOR(address_size-1 downto 0);
		read_address : in STD_LOGIC_VECTOR(address_size-1 downto 0);
		CLK : in STD_LOGIC );
	end component;

	signal init : STD_LOGIC;
	signal write_port : STD_LOGIC_VECTOR(reg_size-1 downto 0);
	signal write_address : STD_LOGIC_VECTOR(address_size-1 downto 0);
	signal read_address : STD_LOGIC_VECTOR(address_size-1 downto 0);
	signal CLK : STD_LOGIC := '0';

	signal read_port : STD_LOGIC_VECTOR(reg_size-1 downto 0);

	constant clock_period: time := 10 ns;
	constant tests_count: integer := 4;
	type words_array is array(0 to tests_count-1) of std_logic_vector(reg_size-1 downto 0);
	type addresses_array is array(0 to tests_count-1) of std_logic_vector(address_size-1 downto 0);
	constant test_words: words_array := ("1111", "0001", "1101", "0100");							   
	constant test_addresses: addresses_array := ("00", "01", "10", "11");

begin

	-- Unit Under Test port map
	UUT : entity regfile(beh)
		generic map (
			reg_size => reg_size,
			address_size => address_size
		)

		port map (
			init => init,
			write_port => write_port,
			read_port => read_port,
			write_address => write_address,
			read_address => read_address,
			CLK => CLK
		);

	stimulate: process
	begin
		init <= '1';
		wait for clock_period;
		init <= '0';
		for i in 0 to tests_count-1	loop
			write_address <= test_addresses(i);
			write_port <= test_words(i);
			wait for clock_period;
			read_address <= test_addresses(i);
			wait for clock_period;
		end loop;
		assert (false) report "End of simulation" severity failure;
	end process;
	
	CLK <= not CLK after clock_period / 2;

end TB_ARCHITECTURE;