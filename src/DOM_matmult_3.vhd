----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:53:42 02/13/2017 
-- Design Name: 
-- Module Name:    TI_mult_3 - Behavioral 
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

--DOM multiplier
--z = (x1+x2+x3)(y1+y2+y3) = x1y1 + x1y2 + x1y3 + x2y1 + x2y2 + x2y3 + x3y1 + x3y2 + x3y3
--z1 = x1y1 + x1y2 + x1y3
--z2 = x2y1 + x2y2 + x2y3
--z3 = x3y1 + x3y2 + x3y3

entity DOM_matmult_3 is
    Port ( clk : in std_logic;
           x : in  shared_value;
           M : in  shared_matrix;
           r : in random;
           z : out  shared_value 
           );
end DOM_matmult_3;

architecture Behavioral of DOM_matmult_3 is
	
    component DOM_matmult_3_domain 
      Port ( clk : in std_logic;
           v0 : in  std_logic_vector(7 downto 0);
           M0 : in matrix;
           M1 : in matrix;
           M2 : in matrix;
           r0 : in std_logic_vector(7 downto 0);
           r1 : in std_logic_vector(7 downto 0);
           z0 : out  std_logic_vector(7 downto 0)
           );
    end component;
  
begin

  dom1 : DOM_matmult_3_domain port map(clk => clk, v0 => x(0), M0 => M(0), M1 => M(1), M2 => M(2), r0 => r(0), r1 => r(1), z0 => z(0));
  dom2 : DOM_matmult_3_domain port map(clk => clk, v0 => x(1), M0 => M(1), M1 => M(2), M2 => M(0), r0 => r(2), r1 => r(0), z0 => z(1));
  dom3 : DOM_matmult_3_domain port map(clk => clk, v0 => x(2), M0 => M(2), M1 => M(0), M2 => M(1), r0 => r(1), r1 => r(2), z0 => z(2));

	
end Behavioral;

