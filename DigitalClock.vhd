library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DigitalClock is
    Port ( clk : in  STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an  : out STD_LOGIC_VECTOR (3 downto 0));
end DigitalClock;

architecture Behavioral of DigitalClock is
    signal counter_1Hz : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
    signal tick : STD_LOGIC := '0';

    signal sec_ones : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal sec_tens : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal min_ones : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal min_tens : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

    signal mux_count : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
    signal MUX   : STD_LOGIC_VECTOR (1 downto 0);
    signal digit : STD_LOGIC_VECTOR (3 downto 0);
begin

    -- 1 Hz
    process(clk)
    begin
        if rising_edge(clk) then
            if (counter_1Hz = 99999999) then
                counter_1Hz <= (others => '0');
                tick <= '1';
            else
                counter_1Hz <= counter_1Hz + 1;
                tick <= '0';
            end if;
        end if;
    end process;

    -- Time keeping
    process(clk)
    begin
        if rising_edge(clk) then
            if (tick = '1') then
                sec_ones <= sec_ones + 1;
                if (sec_ones = "1001") then
                    sec_ones <= "0000";
                    sec_tens <= sec_tens + 1;
                end if;
                if (sec_ones = "1001" and sec_tens = "0101") then
                    sec_tens <= "0000";
                    min_ones <= min_ones + 1;
                end if;
                if (sec_ones = "1001" and sec_tens = "0101" and min_ones = "1001") then
                    min_ones <= "0000";
                    min_tens <= min_tens + 1;
                end if;
                if (sec_ones = "1001" and sec_tens = "0101" and min_ones = "1001" and min_tens = "0101") then
                    min_tens <= "0000";
                end if;
            end if;
        end if;
    end process;

    -- Display multiplexer
    process(clk)
    begin
        if rising_edge(clk) then
            mux_count <= mux_count + 1;
        end if;
    end process;

    MUX <= mux_count(17) & mux_count(16);

    process(MUX, sec_tens, sec_ones, min_tens, min_ones)
    begin
        case MUX is
            when "00" =>
                an <= "0111";
                digit <= sec_tens;
            when "01" =>
                an <= "1011";
                digit <= sec_ones;
            when "10" =>
                an <= "1101";
                digit <= min_tens;
            when "11" =>
                an <= "1110";
                digit <= min_ones;
            when others =>
                an <= "1111";
                digit <= "0000";
        end case;
    end process;

    -- Hex decoder
    process(digit)
    begin
        if    (digit = "0000") then seg <= "1000000";
        elsif (digit = "0001") then seg <= "1111001";
        elsif (digit = "0010") then seg <= "0100100";
        elsif (digit = "0011") then seg <= "0110000";
        elsif (digit = "0100") then seg <= "0011001";
        elsif (digit = "0101") then seg <= "0010010";
        elsif (digit = "0110") then seg <= "0000010";
        elsif (digit = "0111") then seg <= "1111000";
        elsif (digit = "1000") then seg <= "0000000";
        elsif (digit = "1001") then seg <= "0010000";
        else  seg <= "1111111";
        end if;
    end process;

end Behavioral;
