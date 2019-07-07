----------------------------------------------------------------------------------
-- Create Date: 09/07/2016 01:08:10 PM
-- Module Name: fft_engine_tb - Behavioral
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity fft_engine_tb is
--  Port ( );
end fft_engine_tb;

architecture Behavioral of fft_engine_tb is

component fft_engine
  port (
  clk_primary_p       : in std_logic;
  clk_primary_n       : in std_logic;
  rst                 : in std_logic;
  m_axis_data_tdata   : out std_logic_vector(31 downto 0);
  m_axis_data_tuser   : out std_logic_vector(7 downto 0);
  m_axis_data_tvalid  : out std_logic;
  m_axis_data_tlast   : out std_logic);

end component;

signal clk_primary_p_s       : std_logic;                                             
signal clk_primary_n_s       : std_logic;
signal rst_s                 : std_logic;
signal m_axis_data_tdata_s   : std_logic_vector(31 downto 0);
signal m_axis_data_tuser_s   : std_logic_vector(7 downto 0);
signal m_axis_data_tvalid_s  : std_logic;
signal m_axis_data_tlast_s   : std_logic;

constant clk_primary_p_s_period : time := 5 ns;
constant clk_primary_n_s_period : time := 5 ns;

begin

uut:  fft_engine port map( 
  clk_primary_p       => clk_primary_p_s,
  clk_primary_n       => clk_primary_n_s,
  rst                 => rst_s,
  m_axis_data_tdata   => m_axis_data_tdata_s,
  m_axis_data_tuser   => m_axis_data_tuser_s,
  m_axis_data_tvalid  => m_axis_data_tvalid_s,   
  m_axis_data_tlast   => m_axis_data_tlast_s);

clk_p : process
begin
    clk_primary_p_s  <= '0';	    wait for clk_primary_p_s_period/2;
    clk_primary_p_s  <= '1';	    wait for clk_primary_p_s_period/2;
end process;

clk_n : process
begin
    clk_primary_n_s  <= '1';	    wait for clk_primary_n_s_period/2;
    clk_primary_n_s  <= '0';  	    wait for clk_primary_n_s_period/2;
end process;

RESET : process
begin 
	rst_s <= '1'; wait for 7 us;
	rst_s <= '0'; wait;
end process ;

end Behavioral;