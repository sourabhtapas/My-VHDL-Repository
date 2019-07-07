----------------------------------------------------------------------------------
-- Create Date                       : 09/19/2016 10:30:22 AM
-- Module Name                       : hw_env_fft_tb - Behavioral
-- company                           : Airbus Group India Pvt.Ltd
-- Engineer                          : Vishal Goyal, Sourabh Tapas
-- Development Platform              : Vivado 2016.1
-- Testing and Verification Platform : Vivado 2016.1
-- Target Devices                    : KC705 Evaluation Board for the Kintex-7 FPGA
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity hw_env_fft_tb is
--  Port ( );
end hw_env_fft_tb;


architecture Behavioral of hw_env_fft_tb is

component hw_env_fft is
port ( clk_primary_p           : in  std_logic;                                                            -- primary system clock input
       clk_primary_n           : in  std_logic;                                                            -- - LVDS
       hw_rst                  : in  std_logic;                                                            -- active high reset - synchronous to clock
       hw_fft_cfar_Im          : out std_logic_vector(15 downto 0);                                        -- Inphase/real part of fft engine's output channel.Carries the processed sample data: XK_RE.
       hw_fft_cfar_Qm          : out std_logic_vector(15 downto 0));                                        -- Quadraturephase/imaginary part of fft engine's output channel.Carries the processed sample data: XK_IM.
end component;

signal clk_primary_p_s           : std_logic;                                             
signal clk_primary_n_s           : std_logic;
signal hw_rst_s                  : std_logic;
signal hw_fft_cfar_Im_s          : std_logic_vector(15 downto 0);
signal hw_fft_cfar_Qm_s          : std_logic_vector(15 downto 0);


constant clk_primary_p_s_period : time := 5 ns;
constant clk_primary_n_s_period : time := 5 ns;

begin

uut:  hw_env_fft port map( 
  clk_primary_p           => clk_primary_p_s,
  clk_primary_n           => clk_primary_n_s,
  hw_rst                  => hw_rst_s,
  hw_fft_cfar_Im          => hw_fft_cfar_Im_s,
  hw_fft_cfar_Qm          => hw_fft_cfar_Qm_s);


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
	hw_rst_s <= '1'; wait for 7 us;
	hw_rst_s <= '0'; wait;
end process ;

end Behavioral;