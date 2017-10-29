library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RAM_Hamming is
	generic (
		word_size: integer := 4;
		address_size: integer := 2
		);
	port (
		CLK: in std_logic;
		write_enable: in std_logic;
		address_bus: in std_logic_vector(address_size-1 downto 0);
		data_bus: inout std_logic_vector(word_size-1 downto 0);
		error: out std_logic
		);
end RAM_Hamming;

architecture beh of RAM_Hamming is	 
	type RAM is array(0 to 2**address_size-1) of std_logic_vector(word_size+2 downto 0);
	
	signal ram_storage: RAM;
	signal address_value: integer range 0 to 2**address_size-1;
begin
	address_value <= conv_integer(address_bus);
	
	write_data: process(CLK, data_bus, ram_storage, address_value, write_enable)
		variable r1, r2, r3: std_logic;
	begin	
		if write_enable = '1' then	
			if rising_edge(CLK) then   
				r1 := data_bus(0) xor data_bus(1) xor data_bus(2);
				r2 := data_bus(1) xor data_bus(2) xor data_bus(3);
				r3 := data_bus(0) xor data_bus(1) xor data_bus(3);
				ram_storage(address_value) <= r3 & r2 & r1 & data_bus;
			end if;
		end if;
	end process;
	
	read_data: process(CLK, data_bus, ram_storage, address_value, write_enable)
		variable S1, S2, S3: std_logic;
		variable tmp: std_logic_vector(word_size+2 downto 0);
	begin
		if write_enable = '0' then
			if rising_edge(CLK) then   
				tmp := ram_storage(address_value);
				S1 := tmp(0) xor tmp(1) xor tmp(2) xor tmp(word_size);
				S2 := tmp(1) xor tmp(2) xor tmp(3) xor tmp(word_size + 1);
				S3 := tmp(0) xor tmp(1) xor tmp(3) xor tmp(word_size + 2);
				error <= S1 or S2 or S3;
				data_bus <= tmp(word_size-1 downto 0);
			end if;
		else
			data_bus <= (others => 'Z');
		end if;
	end process;
end beh;

