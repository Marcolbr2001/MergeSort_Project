library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Merge_1 is
  Generic(
    Word : integer := 32
  );
  Port (
        
        reset : in std_logic;
        
        start_conversion : in std_logic;
        
        in_1 : in std_logic_vector(Word-1 DOWNTO 0);
        in_2 : in std_logic_vector(Word-1 DOWNTO 0);
        
        out_1 : out std_logic_vector(Word-1 DOWNTO 0);
        out_2 : out std_logic_vector(Word-1 DOWNTO 0)
        
        );
end Merge_1;

architecture Behavioral of Merge_1 is

begin

process (start_conversion, reset)
begin
    if reset = '1' then
        out_1 <= (Others => '0');
        out_2 <= (Others => '0');
    elsif rising_edge(start_conversion) then
        if (in_1 <= in_2) then
            out_1 <= in_1;
            out_2 <= in_2;
        else
            out_1 <= in_2;
            out_2 <= in_1;
        end if;
    end if;
end process;

end Behavioral;
