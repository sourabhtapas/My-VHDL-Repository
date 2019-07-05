----------------------------------------------------------------------------------
-- Create Date                       : 04/08/2016 12:23:28 PM
-- Module Name                       : hw_dpc_env_tb
-- Description                       : test bench for hw_dpc_env
-- company                           : Airbus Group India Pvt.Ltd
-- Engineer                          : Vishal Goyal, Sourabh Tapas
-- Development Platform              : Vivado 2016.1
-- Testing and Verification Platform : Vivado 2016.1
----------------------------------------------------------------------------------
library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all; 
use unisim.vcomponents.all; 

entity hw_dpc_env_tb is
--  Port ( );
end hw_dpc_env_tb;

architecture Behavioral of hw_dpc_env_tb is

component hw_dpc_env 

port( hw_clk_pin_p : in STD_LOGIC;
      hw_clk_pin_n : in STD_LOGIC;
      hw_rst       : in std_logic;
      hw_outImain  : out std_logic_vector (15 downto 0);
      hw_outQmain  : out std_logic_vector (15 downto 0);
      hw_outIaux   : out std_logic_vector (15 downto 0);
      hw_outQaux   : out std_logic_vector (15 downto 0));
end component;

signal hw_rst_s       :  std_logic;
signal hw_outImain_s  :  std_logic_vector (15 downto 0);
signal hw_outQmain_s  :  std_logic_vector (15 downto 0);
signal hw_outIaux_s   :  std_logic_vector (15 downto 0);
signal hw_outQaux_s   :  std_logic_vector (15 downto 0);
signal hw_clk_pin_p_s :  STD_LOGIC;
signal hw_clk_pin_n_s :  STD_LOGIC;
constant hw_clk_pin_p_s_period : time := 5 ns ;
constant hw_clk_pin_n_s_period : time := 5 ns ;


begin

uut : hw_dpc_env port map (hw_clk_pin_p              => hw_clk_pin_p_s,
                           hw_clk_pin_n              => hw_clk_pin_n_s, 
                           hw_rst                    => hw_rst_s,
                           hw_outImain               => hw_outImain_s,
                           hw_outQmain               => hw_outQmain_s, 
                           hw_outIaux                => hw_outIaux_s,
                           hw_outQaux                => hw_outQaux_s);


clk_p : process
begin
    hw_clk_pin_p_s  <= '0';	    wait for hw_clk_pin_p_s_period/2;
    hw_clk_pin_p_s  <= '1';	    wait for hw_clk_pin_p_s_period/2;
end process;

clk_n : process
begin
    hw_clk_pin_n_s  <= '1';	    wait for hw_clk_pin_n_s_period/2;
    hw_clk_pin_n_s  <= '0';  	wait for hw_clk_pin_n_s_period/2;
end process;


RESET : process
begin 
	hw_rst_s <= '1'; wait for 5 us;
	hw_rst_s <= '0'; wait;
end process ;
end Behavioral;