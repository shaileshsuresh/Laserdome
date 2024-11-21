
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Weapon is
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
end Weapon;

Architecture behaviour of Weapon is

component Send_ID 
Port(
	reset : in STD_LOGIC;
	clk : in STD_LOGIC;
	SW : in STD_LOGIC;
	shoot : in std_logic;
	weapon_off : in std_logic;
	Player_ID : in STD_LOGIC_VECTOR(3 downto 0);
	noise : out std_logic;
	Send : out STD_LOGIC
);
end component;

component Player_Switch
--generic( counter_1600 :integer); --10ns * 62499 = 1600Hz  
	-- counter_1600: integer );    --10ns * 5000 = 20000Hz This is used for simulation
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
	   go_Left : in STD_LOGIC;
  	   go_Right : in STD_LOGIC;
  	   select_player : in STD_LOGIC;
           SEG : out STD_LOGIC_VECTOR(7 downto 0);
           AN : out STD_LOGIC_VECTOR(7 downto 0);
	   player_ID : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

signal Player_ID_signal : STD_LOGIC_VECTOR(3 downto 0);
--signal debounced_shot_ext : STD_LOGIC;

--constant counter_1600 : integer := 62500;
--constant Hz_833 : integer := 120048;

begin

Inst_Player_Switch : Player_Switch
--generic map( counter_1600 => counter_1600) --10ns * 62499 = 1600Hz  
	-- counter_1600: integer );    --10ns * 5000 = 20000Hz This is used for simulation
    Port map( 
           clk => clk,
           reset => reset,
	   go_Left => go_Left,
  	   go_Right => go_Right,
  	   select_player => select_player,
           SEG => SEG,
           AN => AN,
	   player_ID => Player_ID_signal
);

Inst_message : Send_ID
Port map(
	reset => reset,
	clk => clk,
	SW => Activate,
	shoot => shoot,
	weapon_off => weapon_off,
	Player_ID => Player_ID_signal,
	noise => noise,
	Send => message_out
);

end behaviour;
