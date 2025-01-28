----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:22:30 12/06/2016 
-- Design Name: 
-- Module Name:    AES_box_GF8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
 use work.MPC_globals.all;

entity const_xor_GF8 is
  port(
    x : in shared_value_tag;
    c : in shared_value;
    alpha: in shared_value;
    y : out shared_value_tag
  );
end const_xor_GF8; 

architecture Behavioral of const_xor_GF8 is

  component GF_mult_8
  	port(
  		poly_a 	 : in  std_logic_vector(7 downto 0);
  		poly_b 	 : in  std_logic_vector(7 downto 0);
  		mult_poly : out std_logic_vector(7 downto 0)	
  	);
  end component;
  
  signal alph_c : shared_value;
  
  begin 
  
  	GF_mult_8_1: GF_mult_8 port map(poly_a => c(0), poly_b => alpha(0), mult_poly => alph_c(0));
  	GF_mult_8_2: GF_mult_8 port map(poly_a => c(1), poly_b => alpha(1), mult_poly => alph_c(1));
  	GF_mult_8_3: GF_mult_8 port map(poly_a => c(2), poly_b => alpha(2), mult_poly => alph_c(2));

  y.v(0) <= x.v(0) xor c(0);
  y.v(1) <= x.v(1);
  y.v(2) <= x.v(2);
  
  y.t(0) <= x.t(0) xor alph_c(0);
  y.t(1) <= x.t(1) xor alph_c(1);
  y.t(2) <= x.t(2) xor alph_c(2);


end Behavioral;


