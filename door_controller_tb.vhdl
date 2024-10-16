library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity door_cont_tb is
end entity door_cont_tb;

architecture BEHAV of door_cont_tb is
    component door_cont is
        port(
            clk           : in  std_logic;
            motion_sensor : in  std_logic;
            reset         : in  std_logic;
            fully_open    : in  std_logic;
            fully_closed  : in  std_logic;
            door_rgb      : out std_logic_vector(2 downto 0);
            motor         : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Signals to connect to 'door_cont'
    signal clk           : std_logic := '0';
    signal motion_sensor : std_logic := '0';
    signal reset         : std_logic := '1';
    signal fully_open    : std_logic := '0';
    signal fully_closed  : std_logic := '1';  -- Initially, door is fully closed
    signal door_rgb      : std_logic_vector(2 downto 0);
    signal motor         : std_logic_vector(1 downto 0);

    -- clock for simulation
    constant CLK_PERIOD : time := 8 ns;

begin

    UUT: door_cont
        port map (
            clk           => clk,
            motion_sensor => motion_sensor,
            reset         => reset,
            fully_open    => fully_open,
            fully_closed  => fully_closed,
            door_rgb      => door_rgb,
            motor         => motor
        );
    
    -- clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_process;

    process
    begin
        -- reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 50 ns;

        -- simulate motion detected (motion_sensor = '1')
        motion_sensor <= '1';
        wait for 20 ns;

        -- simulate door opening until fully open
        wait for 100 ns;  -- timme it takes to open the door
        fully_open <= '1';
        fully_closed <= '0';

        -- door is fully open; timer should start
        -- wait for timer to complete 
        wait for 500 ns;  

        -- timer should signal done; door should start closing
        fully_open <= '0';
        fully_closed <= '1';

        -- no motion
        motion_sensor <= '0';
        wait for 100 ns;
        wait;
    end process;

end architecture BEHAV;
