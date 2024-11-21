library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;

entity store_hits is
	generic(hit_penalty : integer);
	port ( 	clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		hit : in STD_LOGIC_VECTOR(7 downto 0);
		critical_hit : in STD_LOGIC_VECTOR(7 downto 0);
		load : in std_logic;
		weapon_off : out std_logic;
		start_uart : out std_logic;
		to_uart_decoder : out std_logic_vector(7 downto 0));
end store_hits;

architecture arch_store_hits of store_hits is

--- SIGNALS ----
----------------
signal hit_signal : STD_LOGIC_VECTOR(7 downto 0);
signal crit_signal : STD_LOGIC_VECTOR(7 downto 0);
signal clk_signal : STD_LOGIC;
signal hit_weapon_off_signal : STD_LOGIC:='0';
signal crit_weapon_off_signal : STD_LOGIC:='0';
signal weapon_off_signal : STD_LOGIC:='0';
type hit_array is array(0 to 15) of NATURAL range 0 to 600;
signal hit_results_sig : hit_array;
signal crit_results_sig : hit_array;
signal points_sig : hit_array;
signal to_uart_decoder_signal : std_logic_vector(7 downto 0);


signal points_tmp : hit_array;
signal k : integer range 1 to 16:= 1;
signal l : integer range 0 to 17:= 1;
signal m : integer range 0 to 105000:= 0;
signal o : integer range 0 to 600:= 0;



begin
weapon_off <= weapon_off_signal;
weapon_off_signal <= hit_weapon_off_signal or crit_weapon_off_signal;
hit_signal <= hit;
crit_signal <= critical_hit;
clk_signal <= clk;
to_uart_decoder <= to_uart_decoder_signal;

-- PROCESSES --
---------------

--- notes ---


store_hits: PROCESS(clk,hit_signal,crit_signal,reset)
  variable hits : hit_array;
  variable crits : hit_array;
  variable i : integer range 0 to 1000010000:= 0;
  variable j : integer range 0 to 2000010000:= 0;

  BEGIN
  if reset = '0' then
		hits := (others => 0); 
		crits := (others => 0); 
  elsif rising_edge(clk) then
	if or_reduce(hit_signal) = '1' and or_reduce(crit_signal) = '0' and weapon_off_signal = '0' then
			hits(to_integer(unsigned(hit_signal))) := hits(to_integer(unsigned(hit_signal))) + 1;
			hit_weapon_off_signal <= '1';
	elsif or_reduce(crit_signal) = '1' and or_reduce(hit_signal) = '0' and weapon_off_signal = '0' then
			crits(to_integer(unsigned(crit_signal))) := crits(to_integer(unsigned(crit_signal))) + 1;
			crit_weapon_off_signal <= '1';						
	elsif weapon_off_signal = '1' then
			if hit_weapon_off_signal = '1' then
				i := i + 1;
				if i = hit_penalty then
					hit_weapon_off_signal <='0';
					crit_weapon_off_signal <='0';
					i := 0;
				end if;
			elsif crit_weapon_off_signal = '1' then
				j := j + 1;
				if j = 2*hit_penalty then
					hit_weapon_off_signal <='0';
					crit_weapon_off_signal <='0';
					j := 0;
				end if;
			end if;
	end if;
  end if; -- rising_edge(clk) // reset
hit_results_sig <= hits;
crit_results_sig <= crits;
END PROCESS store_hits;

load_proc: PROCESS(clk,load,reset)
--  variable points_tmp : hit_array;
--  variable k : integer range 1 to 16:= 1;
--  variable l : integer range 0 to 17:= 1;
--  variable m : integer range 0 to 105000:= 0;
--  variable o : integer range 0 to 600:= 0;

begin
--  if rising_edge(clk) then
    if rising_edge(clk) then
	   if k < 16 then
	  	    points_tmp(k) <= hit_results_sig(k) + 2*crit_results_sig(k);
	  	    k <= k + 1;
	   elsif k = 16 then
	        k <= 1;
	   end if; -- k < 16
	end if; -- rising edge
  	points_sig <= points_tmp;
	if reset = '0' then
		l <= 1;
		m <= 0;	
		points_tmp <= (others => 0); 
	else
	 if rising_edge(clk) then
  	  if load = '1' then
		if l < 17 and l > 0 then -- player
		   if o < points_tmp(l) then  -- number of points
			if m < 105000 then
				if m < 655 and l /= 16 then
					to_uart_decoder_signal <= std_logic_vector(to_unsigned((l),to_uart_decoder'length));
					m <= m + 1;
					start_uart <= '1';
				else
					to_uart_decoder_signal <= std_logic_vector(to_unsigned((l),to_uart_decoder'length));
					m <= m + 1;
					start_uart <= '0';
				end if; --m < 655
			else
				o <= o + 1;
				m <= 0;
			end if; -- m<105000
		   else
			o <= 0;
			l <= l + 1;
			if l >= 16 then
				l <= 0;
			end if; -- l = 16
		   end if; -- number of points
		end if; -- l < 17
  	  end if; -- load = 1
	 end if; --rising edge
	end if; --reset
END PROCESS load_proc;
end arch_store_hits;
