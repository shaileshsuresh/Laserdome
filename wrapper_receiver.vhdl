
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity wrapper_receiver is
    generic ( penalty : integer := 1000000000);
    port ( clk : in std_logic;
           reset : in std_logic;
           hit_voltage : in std_logic;
           crit_voltage : in std_logic;
           load_scores : in std_logic;
           tx : out std_logic;
           noise : out std_logic;
           weapon_off : out std_logic);
end ;

architecture arch of wrapper_receiver is

component square_wave_decoder is
    Port ( clk : in std_logic;
           reset : in std_logic;
           voltage : in std_logic;
           trigger_hit_noise : out std_logic;
           bitstream : out std_logic_vector (7 downto 0));
end component;

component uart_tx is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start_uart : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR(7 downto 0);
           tx : out STD_LOGIC);
end component;

component uart_decoder is
port ( bitstream : in std_logic_vector(7 downto 0);
       characters : out std_logic_vector(7 downto 0));

end component;

component hit_noise is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           hit : in std_logic;
           weapon_off : in std_logic;
           noise : out std_logic );
end component;

component store_hits is
	generic(hit_penalty : integer);
	port ( 	clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		hit : in STD_LOGIC_VECTOR(7 downto 0);
		critical_hit : in STD_LOGIC_VECTOR(7 downto 0);
		load : in std_logic;
		weapon_off : out std_logic;
		start_uart : out std_logic;
		to_uart_decoder : out std_logic_vector(7 downto 0));
end component;

--------- SIGNALS -------------------------
signal start_uart_wrapper : std_logic;
signal bitstream_wrapper : std_logic_vector(7 downto 0);
signal decoded_bitstream_wrapper : std_logic_vector(7 downto 0);
signal tx_wrapper : std_logic;
signal trigger_hit_noise_wrapper : std_logic;
signal to_uart_decoder_wrapper : std_logic_vector(7 downto 0);
signal critical_bitstream_wrapper : std_logic_vector(7 downto 0);
signal to_hit_noise : std_logic;
signal to_crit_noise : std_logic;
signal hit_voltage_sig : std_logic;
signal crit_voltage_sig : std_logic;
signal weapon_off_signal : std_logic;

begin

hit_voltage_sig <= hit_voltage;
crit_voltage_sig <= crit_voltage;
trigger_hit_noise_wrapper <= to_hit_noise xor to_crit_noise;

hit_square_wave_decoder_inst : 
component square_wave_decoder
port map (clk => clk,
          reset => reset,
          voltage => hit_voltage_sig,
          trigger_hit_noise => to_hit_noise,
          bitstream => bitstream_wrapper);
          
crit_square_wave_decoder_inst : 
component square_wave_decoder
port map (clk => clk,
          reset => reset,
          voltage => crit_voltage_sig,
          trigger_hit_noise => to_crit_noise,
          bitstream => critical_bitstream_wrapper);

uart_tx_inst : 
component uart_tx
port map (clk => clk,
          reset => reset,
          start_uart => start_uart_wrapper,
          data => decoded_bitstream_wrapper,
          tx => tx_wrapper);

uart_decoder_inst : 
component uart_decoder
port map (bitstream => to_uart_decoder_wrapper,
          characters => decoded_bitstream_wrapper);

hit_noise_inst : 
component hit_noise
port map (clk => clk,
          reset => reset,
          hit => trigger_hit_noise_wrapper,
          weapon_off => weapon_off_signal,
          noise => noise);

store_hits_inst : 
component store_hits
generic map (penalty)
port map (clk => clk,
          reset => reset,
          hit => bitstream_wrapper,
          critical_hit => critical_bitstream_wrapper,
          load => load_scores,
          weapon_off => weapon_off_signal,
          start_uart => start_uart_wrapper,
          to_uart_decoder => to_uart_decoder_wrapper);


--- signals ---
--- outputs ---
weapon_off <= weapon_off_signal;
tx <= tx_wrapper;

end arch;
