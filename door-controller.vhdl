library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity door_cont is
    port(
        clk           : in  std_logic;
        motion_sensor : in  std_logic;
        reset         : in  std_logic;
        fully_open    : in  std_logic;
        fully_closed  : in  std_logic;
        timer_done    : in std_logic;
        door_rgb      : out std_logic_vector(2 downto 0);
        motor         : out std_logic_vector(1 downto 0)
    );
end entity door_cont;

architecture BEHAV of door_cont is

    type state_type is (door_closed, door_opening, door_open, door_closing);
    signal current_state, next_state : state_type;

begin

    timer: entity work.timer
        port map (
            clk    => clk,
            reset  => reset,
            done   => timer_done
        );

    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;


    process(current_state, fully_closed, fully_open, motion_sensor, timer_done)
    begin
        case current_state is
            when door_closed =>

                -- red led on
                door_rgb(2) <= '1';
                door_rgb(1 downto 0) <= "00";

                motor <= "00";

                if motion_sensor = '1' then
                    next_state <= door_opening;
                else
                    next_state <= door_closed;
                end if;

            when door_opening =>

                -- blue led on
                door_rgb(0) <= '1';
                door_rgb(2 downto 1) <= "00";

                motor <= "01";

                if fully_open = '1' then
                    next_state <= door_open;
                else
                    next_state <= door_opening;
                end if;

            when door_open =>

                -- green led on
                door_rgb(0) <= '0';
                door_rgb(1) <= '1';
                door_rgb(2) <= '0';

                motor <= "00";

                
                if timer_done = '1' or motion_sensor = '0' then
                    next_state <= door_closing;
                else
                    next_state <= door_open;
                end if;

            when door_closing =>

                -- yellow led on
                door_rgb(2 downto 1) <= "11";
                door_rgb(0) <= '0';

                motor <= "10";

                if fully_closed = '1' then
                    next_state <= door_closed;
                elsif motion_sensor = '1' then
                    next_state <= door_opening;
                else
                    next_state <= door_closing;
                end if;
        end case;
    end process;

end architecture BEHAV;