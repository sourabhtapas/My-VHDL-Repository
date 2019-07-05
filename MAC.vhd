----------------------------------------------------------------------------------
-- Create Date                       : 04/08/2016 12:49:20 PM
-- Module Name                       : Mul_Acc
-- Description                       : Multiplier and Accumulator component for "Digital Pulse Compression Block (DPC)"
-- company                           : Airbus Group India Pvt.Ltd
-- Engineer                          : Vishal Goyal, Sourabh Tapas
-- Development Platform              : Vivado 2016.1
-- Testing and Verification Platform : Vivado 2016.1
----------------------------------------------------------------------------------

library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use unisim.vcomponents.all;
use work.all;
use work.Mydatatype_pkg.all;                             -- To load P2 code and P4 code coefficients


entity Mul_Acc is
Port ( CLK          : in  std_logic;                       -- clock input
       coef         : in  aslv98X17;                       -- input memory array of size: width = 17 and depth = 98 
       pair         : in  aslv98X18;                       -- input memory array of size: width = 18 and depth = 98
       reset        : in  std_logic;                       -- active high reset - synchronous to clock
       A_out0       : out std_logic_vector (35 downto 0);  
       A_out1       : out std_logic_vector (35 downto 0);
       A_out2       : out std_logic_vector (35 downto 0);
       A_out3       : out std_logic_vector (35 downto 0);
       A_out4       : out std_logic_vector (35 downto 0);
       A_out5       : out std_logic_vector (35 downto 0));
end Mul_Acc;


architecture Behavioral of Mul_Acc is

-- creating memory of size: width = 35 and depth = 98
 
Type sr98X35 is array (0 to 97) of std_logic_vector (32 downto 0);
signal k  : sr98X35 := (others =>(others=> '0'));

-- creating memory of size: width = 42 and depth = 99 

type sr99X42_signed is array ( 0 to 98 ) of signed (35 downto 0);
signal k_temp :  sr99X42_signed;

-- internal signals

signal CS        : std_logic_vector(2 downto 0);           -- channel select (CS) 3 bit counter signal.
signal not_reset : std_logic;                              -- inverted reset signal.


-- component Declaration of Multiplier IP - generated by multiplier IP

component Multi17X18
  port ( CLK  : in  std_logic;
         SCLR : in  std_logic;
         CE   : in  std_logic;
         A    : in  std_logic_vector (16 downto 0);
         B    : in  std_logic_vector (17 downto 0);
         P    : out std_logic_vector (32 downto 0));
end component;


begin

not_reset <= not reset;     -- generating enable signal to activate Multiplier IP.


-- Always initialising first location k_temp memory with all zeros to remove any garbage data before accumulator starts adding meaningful data. 

process (reset)
begin
    if reset = '1' then 
        k_temp(0) <= (others=> '0');
    else
        k_temp(0) <= (others=> '0'); --null;
    end if;
end process;


--free running counter of decimal 6 to detect rising edge of 30 MHz clock

ch_select: process(CLK)
begin
    if rising_edge(CLK) then               -- synchronous event test
        if( reset = '1') then              -- active high reset - synchronous to clock
            CS  <= "000";                  -- reset the counter
            elsif (not_reset = '1') then   -- non-reset behavior
                if (CS = "101") then       -- Is count equal to "101"?
                    CS <= "000";           -- Yes, then reset the count to all zero
                else                       -- No, 
                    CS  <= CS + 1;         -- then Increment the count by 1
                end if;                    -- end of counter condition
        end if;                            -- end of reset/normal operation
    end if;                                -- end of synchronous events
end process ch_select;


-- Instantiating 98 copies of Multiplier IP.
 
Multiplier:  for i in 0 to 97 generate
             begin
             stage : Multi17X18 port map (CLK => CLK, SCLR => reset, CE => not_reset, A => Coef(i), B => pair(i), P => k(i));
             end generate;

-- Accumulating (adding) 98 product values of Multiplier IP output into 98th memory location of k_temp

Accumulator: for i in 0 to 97 generate
             begin
             k_temp(i+1) <= k_temp(i) + (resize(signed(k(i)), k_temp(i)'length));  -- adding new product data of multiplier to previously accumulated data.
             end generate;


-- Sending Accumulator output to corresponding output port at each CS count transition
-- - and holding (latching) that value till same count arrives again (i.e latching data for one period of 5MHz clock = 200 ns) . 

Channel_wheel: process(CS,k_temp)
    begin
        case CS is
                when "000" =>
                            A_out0 <= std_logic_vector (k_temp(98));
                when "001" =>
                            A_out1 <= std_logic_vector (k_temp(98));
                when "010" =>
                            A_out2 <= std_logic_vector (k_temp(98));
                when "011" =>
                            A_out3 <= std_logic_vector (k_temp(98));
                when "100" =>
                            A_out4 <= std_logic_vector (k_temp(98));
                when "101" =>
                            A_out5 <= std_logic_vector (k_temp(98));
                when others =>
                            A_out0 <= (others => '0'); A_out1 <= (others => '0');
                            A_out2 <= (others => '0'); A_out3 <= (others => '0');
                            A_out4 <= (others => '0'); A_out5 <= (others => '0');
        end case;
    end process;
end Behavioral;