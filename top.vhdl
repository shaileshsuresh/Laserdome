
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity top is
    Port ( 
           clk : in STD_LOGIC; --both
           reset : in STD_LOGIC; --both
	   go_Left : in STD_LOGIC; --Weapon
  	   go_Right : in STD_LOGIC; --Weapon
	   shoot : in std_logic; --Weapon
	   Activate : in STD_LOGIC; --Weapon
	   select_player : in STD_LOGIC; --Weapon
	   hit_voltage : in std_logic; --Receiver
	   crit_voltage : in std_logic; --Receiver
	   load_scores : in std_logic; --Receiver
	   weapon_off : out std_logic; --Receiver remove later, only for debugging
           SEG : out STD_LOGIC_VECTOR(7 downto 0); --Weapon
           AN : out STD_LOGIC_VECTOR(7 downto 0); --Weapon
	   message_out : out STD_LOGIC; --Weapon
	   tx : out std_logic; --Receiver
	   noise : out STD_logic --both
);
end top;

Architecture behaviour of top is

component Weapon
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
	   go_Left : in STD_LOGIC;
  	   go_Right : in STD_LOGIC;
	   shoot : in std_logic;
	   weapon_off : in std_logic;
	   Activate : in STD_LOGIC;
	   select_player : in STD_LOGIC;
           SEG : out STD_LOGIC_VECTOR(7 downto 0);
           AN : out STD_LOGIC_VECTOR(7 downto 0);
	   message_out : out STD_LOGIC;
	   noise : out STD_logic
);
end component;
component wrapper_receiver
    generic ( penalty : integer);
    port ( clk : in std_logic;
           reset : in std_logic;
           hit_voltage : in std_logic;
	   crit_voltage : in std_logic;
           load_scores : in std_logic;
           tx : out std_logic;
           noise : out std_logic;
	   weapon_off : out std_logic
);
end component ;

signal noise_weapon : std_logic;
signal noise_receiver : std_logic;
signal weapon_off_signal : std_logic;

begin

Inst_Receiver : wrapper_receiver
    generic map ( penalty => 1000000000)
    port map( clk => clk,
           reset => reset,
           hit_voltage => hit_voltage,
	   crit_voltage => crit_voltage,
           load_scores => load_scores,
           tx => tx, 
           noise => noise_receiver,
	   weapon_off => weapon_off_signal
);

Inst_Weapon : Weapon
    port map( clk => clk,
           reset => reset,
           go_Left => go_Left,
	   go_Right => go_Right,
           shoot => shoot,
           weapon_off => weapon_off_signal,
	   Activate => Activate,
	   select_player => select_player,
	   SEG => SEG,
	   AN => AN,
	   message_out => message_out, 
           noise => noise_weapon
);

weapon_off <= weapon_off_signal;
noise <= noise_weapon or noise_receiver;

end behaviour;
