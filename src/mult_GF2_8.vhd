----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:14 11/24/2016 
-- Design Name: 
-- Module Name:    GF_mult - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Multiplyer in GF(2^8) using AES poly: x^8-x^4-x^3-x-1=0 (polunomial base)
entity GF_mult_8 is
	port(
		poly_a 	 : in  std_logic_vector(7 downto 0);
		poly_b 	 : in  std_logic_vector(7 downto 0);
		mult_poly : out std_logic_vector(7 downto 0)	
	);
end GF_mult_8;

architecture Behavioral of GF_mult_8 is

component mult_GF2_8
  port(
    A : in std_logic_vector(7 downto 0);
    B : in std_logic_vector(7 downto 0);
    C : out std_logic_vector(7 downto 0)
  );
end component;


begin 

	mult : mult_GF2_8 port map( A => poly_a, B => poly_b, C => mult_poly);
	--signal a1: std_logic_vector(7 downto 0);  
	--signal a2: std_logic_vector(7 downto 0);  
	--signal a3: std_logic_vector(7 downto 0);  
	--signal a4: std_logic_vector(7 downto 0);  
	--signal a5: std_logic_vector(7 downto 0);  
	--signal a6: std_logic_vector(7 downto 0);  
	--signal a7: std_logic_vector(7 downto 0);  
  
	--begin 
		
	--	a1 <= poly_a(6 downto 0) & '0' when (poly_a(7) = '0') else	--1st shift
	--			(poly_a(6 downto 0) & '0') xor "00011011";
		
	--	a2 <= a1(6 downto 0) & '0' when (a1(7) = '0') else   			--2nd shift
	--			(a1(6 downto 0) & '0') xor "00011011";
				
	--	a3 <= a2(6 downto 0) & '0' when (a2(7) = '0') else  			--3rd shift
	--			(a2(6 downto 0) & '0') xor "00011011";
				
	--	a4 <= a3(6 downto 0) & '0' when (a3(7) = '0') else   			--4th shift
	--			(a3(6 downto 0) & '0') xor "00011011";
				
	--	a5 <= a4(6 downto 0) & '0' when (a4(7) = '0') else   			--5th shift
	--			(a4(6 downto 0) & '0') xor "00011011";
				
	--	a6 <= a5(6 downto 0) & '0' when (a5(7) = '0') else   			--6th shift
	--			(a5(6 downto 0) & '0') xor "00011011";
				
	--	a7 <= a6(6 downto 0) & '0' when (a6(7) = '0') else   			--7th shift
	--			(a6(6 downto 0) & '0') xor "00011011";
				
	--	--Xor the shifts corresponding to the '1' bits of poly_b
		
	--	mult_poly(0) <= (poly_a(0) and poly_b(0)) xor (a1(0) and poly_b(1)) 
	--															xor (a2(0) and poly_b(2)) 
	--															xor (a3(0) and poly_b(3))
	--															xor (a4(0) and poly_b(4))
	--															xor (a5(0) and poly_b(5))
	--															xor (a6(0) and poly_b(6))
	--															xor (a7(0) and poly_b(7));
																
	--	mult_poly(1) <= (poly_a(1) and poly_b(0)) xor (a1(1) and poly_b(1)) 
	--															xor (a2(1) and poly_b(2)) 
	--															xor (a3(1) and poly_b(3))
	--															xor (a4(1) and poly_b(4))
	--															xor (a5(1) and poly_b(5))
	--															xor (a6(1) and poly_b(6))
	--															xor (a7(1) and poly_b(7));																
																
	--	mult_poly(2) <= (poly_a(2) and poly_b(0)) xor (a1(2) and poly_b(1)) 
	--															xor (a2(2) and poly_b(2)) 
	--															xor (a3(2) and poly_b(3))
	--															xor (a4(2) and poly_b(4))
	--															xor (a5(2) and poly_b(5))
	--															xor (a6(2) and poly_b(6))
	--															xor (a7(2) and poly_b(7));

	--	mult_poly(3) <= (poly_a(3) and poly_b(0)) xor (a1(3) and poly_b(1)) 
	--															xor (a2(3) and poly_b(2)) 
	--															xor (a3(3) and poly_b(3))
	--															xor (a4(3) and poly_b(4))
	--															xor (a5(3) and poly_b(5))
	--															xor (a6(3) and poly_b(6))
	--															xor (a7(3) and poly_b(7));

	--	mult_poly(4) <= (poly_a(4) and poly_b(0)) xor (a1(4) and poly_b(1)) 
	--															xor (a2(4) and poly_b(2)) 
	--															xor (a3(4) and poly_b(3))
	--															xor (a4(4) and poly_b(4))
	--															xor (a5(4) and poly_b(5))
	--															xor (a6(4) and poly_b(6))
	--															xor (a7(4) and poly_b(7));

	--	mult_poly(5) <= (poly_a(5) and poly_b(0)) xor (a1(5) and poly_b(1)) 
	--															xor (a2(5) and poly_b(2)) 
	--															xor (a3(5) and poly_b(3))
	--															xor (a4(5) and poly_b(4))
	--															xor (a5(5) and poly_b(5))
	--															xor (a6(5) and poly_b(6))
	--															xor (a7(5) and poly_b(7));

	--	mult_poly(6) <= (poly_a(6) and poly_b(0)) xor (a1(6) and poly_b(1)) 
	--															xor (a2(6) and poly_b(2)) 
	--															xor (a3(6) and poly_b(3))
	--															xor (a4(6) and poly_b(4))
	--															xor (a5(6) and poly_b(5))
	--															xor (a6(6) and poly_b(6))
	--															xor (a7(6) and poly_b(7));

	--	mult_poly(7) <= (poly_a(7) and poly_b(0)) xor (a1(7) and poly_b(1)) 
	--															xor (a2(7) and poly_b(2)) 
	--															xor (a3(7) and poly_b(3))
	--															xor (a4(7) and poly_b(4))
	--															xor (a5(7) and poly_b(5))
	--															xor (a6(7) and poly_b(6))
	--															xor (a7(7) and poly_b(7));

end Behavioral;

