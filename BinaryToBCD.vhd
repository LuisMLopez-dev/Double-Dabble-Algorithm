library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BinaryToBCD is
    generic( n: integer := 8; --Number of bits in the binary input
            digits: integer := 2); --Number of BCD digits in the output
    Port (
        binary : in STD_LOGIC_VECTOR (n - 1 downto 0); -- n-bit binay input
        bcd : out STD_LOGIC_VECTOR (4 * digits - 1 downto 0) -- BCD output (4 bits per digit)
    );
end BinaryToBCD;

architecture Behavioral of BinaryToBCD is
    begin
    process(binary)
        variable temp : UNSIGNED(n - 1 downto 0); -- Stores the binary input
        variable bcdTemp : UNSIGNED(4 * digits - 1 downto 0) := (others => '0'); --Holds the BCD values and all values are initialized to zero
    begin
        temp := UNSIGNED(binary); -- Convert input to UNSIGNED
        bcdTemp := (others => '0'); 

        -- Double Dabble algorithm
        for i in 0 to n - 1 loop
            -- For each BCD digit, add 3 if the digit is greatern than 0100, or 4
            for j in 0 to digits - 1 loop
                if bcdTemp((j+1)*4-1 downto j*4) > "0100" then
                    bcdTemp((j+1)*4-1 downto j*4) := bcdTemp((j+1)*4-1 downto j*4) + 3;
                end if;
            end loop;

            -- Shift left: Move temp into bcdTemp
            bcdTemp := bcdTemp(4 * digits - 2 downto 0) & temp(n - 1);
            temp := temp(n - 2 downto 0) & '0';
        end loop;

        bcd <= STD_LOGIC_VECTOR(bcdTemp); -- Convert output back to STD_LOGIC_VECTOR
    end process;
end Behavioral;
