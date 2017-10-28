library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RegFile is
	generic (
		reg_size : integer := 4;
		address_size : integer := 2
		);
	port (
		init : in std_logic;
		write_port : in std_logic_vector(reg_size-1 downto 0);
		read_port : out std_logic_vector(reg_size-1 downto 0);				   
		write_address : in std_logic_vector(address_size-1 downto 0);
		read_address : in std_logic_vector(address_size-1 downto 0);
		CLK : in std_logic 
		);
end RegFile;

architecture beh of RegFile is
	component SRegN is
		generic (
			n : integer := reg_size
			);
		port (
			Din : in std_logic_vector(reg_size-1 downto 0);
			EN : in std_logic;
			INIT : in std_logic;
			CLK : in std_logic;
			OE : in std_logic;
			Dout : out std_logic_vector(reg_size-1 downto 0)
			);
	end component;
	
	function decode (
		address_vector : in std_logic_vector(address_size-1 downto 0)
		) return std_logic_vector is 
		variable result : std_logic_vector(2**address_size-1 downto 0);
	begin		
		result := (others => '0');
		result(CONV_INTEGER(address_vector)) := '1';
		return result;
	end function;
	
	signal write_enable : std_logic_vector(2**address_size-1 downto 0);
	signal read_enable : std_logic_vector(2**address_size-1 downto 0);
	signal read_data : std_logic_vector(reg_size-1 downto 0);
begin
	decode_write_address: process(write_address)
	begin
		write_enable <= decode(write_address);
	end process;
	
	decode_read_address: process(read_address)
	begin
		read_enable <= decode(read_address);
	end process;
	
	REGS: for i in 2**address_size-1 downto 0 generate
		REGi: SRegN generic map(reg_size)
		port map(
			Din => write_port,
			EN => write_enable(i),
			INIT => init,
			CLK => CLK,
			OE => read_enable(i),
			Dout => read_data
			);
	end generate;	 
	
	read_port <= read_data;
end;
