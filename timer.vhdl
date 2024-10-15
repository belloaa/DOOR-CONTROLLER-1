library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk     : in  std_logic;       
        reset   : in  std_logic;       
        done    : out std_logic        -- done signal that goes high after the set time is reached
    );
end entity timer;

architecture Behavioral of timer is
    constant CLK_FREQ : integer := 125_000_000;  -- zybo Z7 clock freq
    signal counter    : integer := 0;           -- internal counter
    signal cycles_required : integer := 0;      -- the number of clock cycles required for the desired time

    -- signal to control the desired time in seconds
    signal time_s : unsigned(31 downto 0) := to_unsigned(5, 32);  -- default time set to 5 seconds
    
begin
    process(clk, reset, time_s)
    begin
        if reset = '1' then
            counter <= 0;
            done <= '0';
            cycles_required <= to_integer(time_s) * CLK_FREQ;  -- calculate required clock cycles based on signal
        elsif rising_edge(clk) then
            if counter < cycles_required then
                counter <= counter + 1;
                done <= '0';
            else
                done <= '1';  -- signal that the timer is done
            end if;
        end if;
    end process;

    

end architecture Behavioral;
