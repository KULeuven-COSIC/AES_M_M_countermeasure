----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  COSIC
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: GF4_Mult_Y1
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

-- unsigned datatype is not used
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF4_Mult_Y1 is
	port(	
		A, B :in std_logic_vector(1 downto 0);
		Y :	out std_logic_vector(1 downto 0)
	);
end GF4_Mult_Y1;

architecture Behavioral of GF4_Mult_Y1 is

begin
	
	Y(1) <= ((A(1) xor A(0)) and (B(1) xor B(0)))
			xor	(A(1) and B(1));

	Y(0) <= ((A(1) xor A(0)) and (B(1) xor B(0)))
			xor	(A(0) and B(0));
		
end Behavioral;
