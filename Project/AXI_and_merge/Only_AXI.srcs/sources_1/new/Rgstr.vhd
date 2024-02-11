library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Rgstr is
  Generic (
    NUMBER_OF_INPUT_WORDS  : integer := 8
  );
  Port ( 
    clk: in std_logic;
    reset: in std_logic;
    done : out std_logic;
    t_valid : in std_logic;
    d: in std_logic_vector(31 downto 0);
    q: out std_logic_vector(31 downto 0)
  );
end Rgstr;

architecture Behavioral of Rgstr is

signal counter: integer := 0;
signal done_delay  : std_logic := '0';

begin

Process(clk, reset)
begin

if reset = '1' then

    q <= (Others => '0');
    counter <= 0;
    done_delay <= '0';

elsif rising_edge(clk) then

    q <= d;
    done <= done_delay;
    
    if t_valid = '1' then
        counter <= counter + 1;
    end if;
    
    if counter >= NUMBER_OF_INPUT_WORDS then
        done_delay <= '1';
    else 
        done_delay <= '0';
    end if;

end if;

end process;


end Behavioral;