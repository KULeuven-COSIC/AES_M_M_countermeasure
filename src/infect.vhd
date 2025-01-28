----------------------------------------------------------------------------------
-- Company: boe
-- Engineer: 
-- 
-- Create Date:    11:35:25 02/27/2017 
-- Design Name: 
-- Module Name:    AES_128_SPDZ - Behavioral 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity infect is
  port ( clk : in std_logic;
         ciphertext_in : in shared_value_tag;
         alpha : in shared_value;
         r : in infect_random;
         ciphertext_out : out shared_value
  ) ;
end entity ;
 
architecture Behavioral of infect is
 
	component shared_mult_3 
		  port ( clk : in std_logic;
		           x : in  shared_value;
		           y : in  shared_value;
		           r : in  random;
		           z : out shared_value 
		  ) ;
	end component ;

	component shared_reg 
	   port ( clk : in std_logic;
	         d : in shared_value;
	         q : out shared_value
	   ) ;
 	end component ;

 	component GF_mult_8
	    port(
	      poly_a   : in  std_logic_vector(7 downto 0);
	      poly_b   : in  std_logic_vector(7 downto 0);
	      mult_poly : out std_logic_vector(7 downto 0)  
	    );
  	end component;

  	signal mult_rand : random;

	signal alpha_c : shared_value;
	signal tag 	   : shared_value;
	signal value   : shared_value;
	signal tag_diff : shared_value;
	signal masked_tag_diff : shared_value;

begin

	-- cycle 0:
	get_mult_rand : for I in 0 to 2 generate 
		mult_rand(I) <= r(I);
	end generate;
	get_alpha_c : shared_mult_3 port map(clk => clk, x => ciphertext_in.v, y => alpha, r => mult_rand, z => alpha_c);
	-- takes one cycle so need buffer reg for ciphertext_in
	buffer_tag : shared_reg port map(clk => clk, d => ciphertext_in.t, q => tag);
	buffer_value : shared_reg port map(clk => clk, d => ciphertext_in.v, q => value);

	-- cycle 1:

	compute_tag_diff : for I in 0 to D-1 generate 
		tag_diff(I) <= tag(I) xor alpha_c(I);
	end generate;

	mult_mask : for I in 0 to D-1 generate
		mult_i : GF_mult_8 port map(poly_a => tag_diff(I), poly_b => r(3), mult_poly => masked_tag_diff(I));
	end generate;

	compute_shares : for I in 0 to D-1 generate
		ciphertext_out(I) <= value(I) xor masked_tag_diff(I);
	end generate;

end Behavioral ;