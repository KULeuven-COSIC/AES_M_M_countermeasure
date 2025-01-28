library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
 use work.MPC_globals.all;



entity alpha_constant is
  port ( alpha : in std_logic_vector(7 downto 0);
  		 const_tag : out  std_logic_vector(7 downto 0) 
  ) ;
end entity ;
 
architecture Behavioral of alpha_constant is
 


begin

	const_tag(0) <= alpha(0) xor alpha(2) xor alpha(3) xor alpha(6) xor alpha(7); 
	const_tag(1) <= alpha(0) xor alpha(1) xor alpha(2) xor alpha(4) xor alpha(6);
	const_tag(2) <= alpha(1) xor alpha(2) xor alpha(3) xor alpha(5) xor alpha(7); 
	const_tag(3) <= alpha(4) xor alpha(7);
	const_tag(4) <= alpha(2) xor alpha(3) xor alpha(5) xor alpha(6) xor alpha(7); 
	const_tag(5) <= alpha(0) xor alpha(3) xor alpha(4) xor alpha(6) xor alpha(7);  
	const_tag(6) <= alpha(0) xor alpha(1) xor alpha(4) xor alpha(5) xor alpha(7);  
	const_tag(7) <= alpha(1) xor alpha(2) xor alpha(5) xor alpha(6); 

end Behavioral ;