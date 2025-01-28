----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  COSIC
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: ConcAdd_Rand_St5
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

entity ConcAdd_Rand_St5 is
port(	
	mult2_4, mult2_3 : in std_logic_vector(3 downto 0);
	Randomness1, Randomness2 : in std_logic_vector(7 downto 0);
	out2 : out std_logic_vector(7 downto 0)
);
end ConcAdd_Rand_St5;

architecture behavior of ConcAdd_Rand_St5 is
begin

	out2 <= (mult2_4 & mult2_3) 	
			xor Randomness1
			xor Randomness2;

end behavior;
