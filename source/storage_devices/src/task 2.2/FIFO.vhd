library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity FIFO is
	generic(
		word_size: integer := 8;
		address_size: integer := 2
		);
	port (
		CLK: in std_logic;
		write_enable: in std_logic;
		data_bus: inout std_logic_vector(word_size-1 downto 0);
		empty: out std_logic;
		full: out std_logic
		);
end FIFO;

architecture beh of FIFO is
	constant max_index: integer := 2**address_size-1;
	type RAM is array(0 to max_index) of std_logic_vector(word_size-1 downto 0);
	
	signal ram_storage: RAM;
	signal head: integer := 0;
	signal tail: integer := 0;
	signal is_full: std_logic := '0';
	signal is_empty: std_logic := '1';
	signal is_looped: boolean :=  false;
begin
	update_pointers: process(CLK)
	begin		
		if rising_edge(CLK) then
			if write_enable = '1' then
				if (is_looped = false) or (head /= tail) then
					if (head = max_index) then
						head <= 0;
						is_looped <= true;
					else
						head <= head + 1;
					end if;
				end if;
			else
				if (is_looped = true) or (head /= tail) then
					if (tail = max_index) then
						tail <= 0;
						is_looped <= false;
					else 
						tail <= tail + 1;
					end if;
				end if;
			end if;
		end if;		
	end process;
	
	update_flags: process(head, tail, is_looped)
	begin
		if (head = tail) then
			if is_looped then
				is_full <= '1';
			else
				is_empty <= '1';
			end if;
		else
			is_empty <= '0';
			is_full <= '0';
		end if;
	end process;
	
	write_data: process(head)
	begin
		if write_enable = '1' then	
			if is_full = '0' then
				ram_storage(head) <= data_bus;
			end if;
		end if;
	end process;
	
	read_data: process(tail)
	begin
		if write_enable = '0' then
			if is_empty = '0' then
				data_bus <= ram_storage(tail);
			end if;
		else 
			data_bus <= (others => 'Z');
		end if;
	end process;
	
	empty <= is_empty;
	full <= is_full;
end beh;
