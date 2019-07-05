----------------------------------------------------------------------------------
-- Create Date                       : 07/01/2016 12:49:20 PM
-- Module Name                       : meta_harden
-- Description                       : metastability hardener for the incoming reset
-- Development Platform              : Vivado 2016.1
-- Testing and Verification Platform : Vivado 2016.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity meta_harden is
    Port ( clk_dst          : in  std_logic;
            rst_dst         : in  std_logic;
           signal_src       : in  std_logic;
           signal_dst       : out std_logic);
end meta_harden;


architecture Behavioral of meta_harden is
       signal signal_meta : std_logic := 'U';    -- this signal is more likely to be meta-stable
    begin

       -- behaviorally coded meta-hardener
       getHard: process (clk_dst)             
          begin
             if rising_edge(clk_dst) then        -- detect synchronous events
                if (rst_dst = '1') then          -- if reset is asserted
                   signal_meta <= '0';           -- clear the output of the first flip-flop
                   signal_dst  <= '0';           -- clear the output of the second and final flip-flop
                else                             -- do non-reset activities
                   signal_meta <= signal_src;    -- capture the arriving signal - higher probability of being meta-stable
                   signal_dst  <= signal_meta;   -- resample the potentially meta-stable signal, lowering the probability of meta-stability
                end if;                          -- end of reset/non-reset activities
             end if;                             -- end of synchronous event check
          end process getHard;

    end Behavioral;
