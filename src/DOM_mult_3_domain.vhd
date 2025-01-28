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

entity DOM_mult_3_domain is
    Port ( clk : in std_logic;
           x0 : in  std_logic_vector(7 downto 0);
           y0 : in  std_logic_vector(7 downto 0);
           y1 : in std_logic_vector(7 downto 0);
           y2 : in std_logic_vector(7 downto 0);
           r0 : in std_logic_vector(7 downto 0);
           r1 : in std_logic_vector(7 downto 0);
           z0 : out  std_logic_vector(7 downto 0)
           );
end DOM_mult_3_domain;

architecture Behavioral of DOM_mult_3_domain is
	
  component andxor_reg
    port ( clk : in std_logic;
          x : in std_logic_vector(7 downto 0);
          y : in std_logic_vector(7 downto 0);
          r : in std_logic_vector(7 downto 0);
          z : out std_logic_vector(7 downto 0)
      ) ;
  end component;

  signal x1y1, x1y2, x1y3 : std_logic_vector(7 downto 0);

begin
  

  get_x1y1 : andxor_reg port map(clk => clk, x => x0, y => y0, r => (others => '0'), z => x1y1);
  get_x1y2 : andxor_reg port map(clk => clk, x => x0, y => y1, r => r0, z => x1y2);
  get_x1y3 : andxor_reg port map(clk => clk, x => x0, y => y2, r => r1, z => x1y3);

  z0 <= x1y1 xor x1y2 xor x1y3;
	

	
end Behavioral;

