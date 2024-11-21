----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hit_noise is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           hit : in std_logic;
           weapon_off : in std_logic;
           noise : out std_logic );
end hit_noise;

architecture Behavioral of hit_noise is

constant countermax : integer :=150000;
signal slower_clk_enable : std_logic;
signal j : natural range 0 to 100000000 := 0;
signal no_sound : std_logic;

component slower_clk
generic(countermax : integer);
port( reset : in std_logic;
      clk : in std_logic;
      slower_clk_enable : out std_logic
);

end component;

begin

slower_clk_inst: slower_clk
generic map(countermax => countermax)
port map( reset => reset,
          clk => clk,
          slower_clk_enable => slower_clk_enable);



generate_noise:
   process(clk, reset)
   variable load_signal : NATURAL range 0 to 1 := 0;
   begin
   if reset = '0' then 
    load_signal := 0;
    j <= 0;
    noise <= '0';
    else
        if rising_edge(clk) then
            if weapon_off = '0' then
                no_sound <= '0';
            end if; 
                if no_sound = '0' then
                    if hit = '1' then
                        load_signal := 1;
                    end if;
                    if load_signal = 1 then
                        if j = 100000000 then
                            j <= 0;
                            load_signal := 0;
                            noise <= '0';
                            no_sound <= '1';
                        else 
                            noise <= slower_clk_enable;
                            j <= j + 1;
                        end if;   
                    end if;
                end if;
            end if;
        end if;
end process;


end Behavioral;
