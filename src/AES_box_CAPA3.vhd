----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:14 05/03/2017 
-- Design Name: 
-- Module Name:    AES_box_CAPA3 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_box_CAPA3 is
	Port ( clk : in  STD_LOGIC;
		  S_in : in  shared_value_tag;
		  alpha : in  shared_value;
		  M_alpha : in shared_matrix;
		  r : in box_random;
		  S_out : out  shared_value_tag
	);
end AES_box_CAPA3;

architecture Behavioral of AES_box_CAPA3 is
	
	--Block to calculate the inverse
	COMPONENT S_box_AES_3_9
		Port (	clk : in std_logic;
					Randomness : in std_logic_vector(161 downto 0);
					Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
					Os1, Os2, Os3 : out std_logic_vector(7 downto 0)
		);
	end COMPONENT;
	
	COMPONENT square_GF8
		PORT(
				poly : IN  std_logic_vector(7 downto 0);
				square_poly : OUT  std_logic_vector(7 downto 0)
			  );
	end COMPONENT;
	
	component shared_mult_3 
		  port ( clk : in std_logic;
		           x : in  shared_value;
		           y : in  shared_value;
		           r : in  random;
		           z : out shared_value 
		  ) ;
	end component ;

	COMPONENT Aff_with_tag
	  port (
		 clk : in std_logic;
		 x : in shared_value_tag;
		 alpha : in shared_value;
		 M : in shared_matrix;
		 r : in random;
		 x_Aff : out shared_value_tag
	  );
	end COMPONENT;
	
	signal Sin_inv : shared_value_tag;
	
	signal rands_val : std_logic_vector(161 downto 0);
	signal rands_tag : std_logic_vector(161 downto 0);
	signal r_Af : random;

begin
	------------
	--Randomness
	------------
	r_Af <= r.af;
	rands_val <= r.inv1;
	rands_tag <= r.inv2;
	---------
	--Inverse
	---------
	--CYCLE 1->5
	--Inverse of the Values
	val_inv : S_box_AES_3_9
		port map(clk => clk, Randomness => rands_val, 
					Is1 => S_in.v(0), Is2 => S_in.v(1), Is3 => S_in.v(2),
					Os1 => Sin_inv.v(0), Os2 => Sin_inv.v(1), Os3 => Sin_inv.v(2)
					);
	--Inverse of the Tags, need to multiply by alpha square to correct
	tag_inv_pre : S_box_AES_3_9
		port map(clk => clk, Randomness => rands_tag, 
					Is1 => S_in.t(0), Is2 => S_in.t(1), Is3 => S_in.t(2),
					Os1 => Sin_inv.t(0), Os2 => Sin_inv.t(1), Os3 => Sin_inv.t(2)
					);
		--Alpha square
	--square0 : square_GF8
	--	PORT map(poly =>  alpha(0), square_poly => alpha_2(0));
	--square1 : square_GF8
	--	PORT map(poly =>  alpha(1), square_poly => alpha_2(1));
	--square2 : square_GF8
	--	PORT map(poly =>  alpha(2), square_poly => alpha_2(2));
	--CYCLE 6
	--Tags delayed 1 cycle by TI mult with alpha_2
	--tag_inv_fin : shared_mult_3
	--	Port map(clk => clk, x => alpha_x_inverse, y => alpha_2, r => r_TI, z => tags_inv);
	
	--------
	--Affine
	--------
	Affffine : Aff_with_tag
		port map(clk => clk, x => Sin_inv, alpha => alpha, M => M_alpha, r => r_Af, x_Aff => S_out);


end Behavioral;

