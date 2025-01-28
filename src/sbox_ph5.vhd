----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  COSIC
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: sbox_ph5
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
library ieee;
use ieee.std_logic_1164.all;

entity sbox_ph5 is
   port(	
		Randomness : in std_logic_vector(71 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(7 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(7 downto 0)
);
end entity;

architecture behavior of sbox_ph5 is
	signal p1, p2, p3, p4, p5, p6, p7, p8, p9 : std_logic_vector(3 downto 0);
	signal q1, q2, q3, q4, q5, q6, q7, q8, q9 : std_logic_vector(3 downto 0);
	
	component GF16_Multiplier_3_9 
			port(		Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
						Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
			);
	end component GF16_Multiplier_3_9;

	component ConcAdd_Rand_St5
		port(	mult2_4, mult2_3 :	in std_logic_vector(3 downto 0);
				Randomness1, Randomness2 :	in std_logic_vector(7 downto 0);
				out2 :	out std_logic_vector(7 downto 0)
		);
	end component ConcAdd_Rand_St5;
	
begin
	
	Top_Multiplier: GF16_Multiplier_3_9
		port map( 	Is1_Top, Is2_Top, Is3_Top,
					   q1, q2, q3, q4, q5, q6, q7, q8, q9 );
	
	Bottom_Multiplier: GF16_multiplier_3_9
		port map( 	Is1_Bot, Is2_Bot, Is3_Bot,
					   p1, p2, p3, p4, p5, p6, p7, p8, p9	);


	ConcAdd1 : ConcAdd_Rand_St5
		port map(p1, q1, Randomness(15 downto  8), Randomness( 7 downto  0), Os1);
	ConcAdd2 : ConcAdd_Rand_St5
		port map(p2, q2, Randomness(23 downto 16), Randomness(15 downto  8), Os2);
	ConcAdd3 : ConcAdd_Rand_St5
		port map(p3, q3, Randomness(31 downto 24), Randomness(23 downto 16), Os3);
	ConcAdd4 : ConcAdd_Rand_St5
		port map(p4, q4, Randomness(39 downto 32), Randomness(31 downto 24), Os4);
	ConcAdd5 : ConcAdd_Rand_St5
		port map(p5, q5, Randomness(47 downto 40), Randomness(39 downto 32), Os5);
	ConcAdd6 : ConcAdd_Rand_St5
		port map(p6, q6, Randomness(55 downto 48), Randomness(47 downto 40), Os6);
	ConcAdd7 : ConcAdd_Rand_St5
		port map(p7, q7, Randomness(63 downto 56), Randomness(55 downto 48), Os7);
	ConcAdd8 : ConcAdd_Rand_St5
		port map(p8, q8, Randomness(71 downto 64), Randomness(63 downto 56), Os8);
	ConcAdd9 : ConcAdd_Rand_St5
		port map(p9, q9, Randomness( 7 downto  0), Randomness(71 downto 64), Os9);
	

end architecture;
