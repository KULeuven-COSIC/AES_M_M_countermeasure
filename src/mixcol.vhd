
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

entity col_SPDZ is
    Port ( in_col  : in  mix_col_type;
           out_col : out  shared_value_tag);
end col_SPDZ;

architecture Behavioral of col_SPDZ is
	
	signal s0, s1, s2, s3 : shared_value_tag;
  signal s0_2, s1_3 : shared_value_tag;

	signal s01_x, S23_x : shared_value_tag;
	
	
begin
	
	--Distribute bytes
	s0 <= in_col(0);
	s1 <= in_col(1);
	s2 <= in_col(2);
	s3 <= in_col(3);

  Mul2 : for I in 0 to D-1 generate 
    s0_2.v(I) <= s0.v(I)(6) & s0.v(I)(5) & s0.v(I)(4) & ( s0.v(I)(3) xor s0.v(I)(7) ) & ( s0.v(I)(2) xor s0.v(I)(7) ) & s0.v(I)(1) & ( s0.v(I)(0) xor s0.v(I)(7) ) & s0.v(I)(7);
    s0_2.t(I) <= s0.t(I)(6) & s0.t(I)(5) & s0.t(I)(4) & ( s0.t(I)(3) xor s0.t(I)(7) ) & ( s0.t(I)(2) xor s0.t(I)(7) ) & s0.t(I)(1) & ( s0.t(I)(0) xor s0.t(I)(7) ) & s0.t(I)(7);
  end generate;

  Mul3 : for I in 0 to D-1 generate 
    s1_3.v(I) <= ( s1.v(I)(7) xor s1.v(I)(6) ) & ( s1.v(I)(6) xor s1.v(I)(5) ) & ( s1.v(I)(5) xor s1.v(I)(4) ) & ( s1.v(I)(4) xor s1.v(I)(3) xor s1.v(I)(7) ) & 
              ( s1.v(I)(3) xor s1.v(I)(2) xor s1.v(I)(7) ) & ( s1.v(I)(2) xor s1.v(I)(1) ) & ( s1.v(I)(1) xor s1.v(I)(0) xor s1.v(I)(7) ) & ( s1.v(I)(0) xor s1.v(I)(7) );
    s1_3.t(I) <= ( s1.t(I)(7) xor s1.t(I)(6) ) & ( s1.t(I)(6) xor s1.t(I)(5) ) & ( s1.t(I)(5) xor s1.t(I)(4) ) & ( s1.t(I)(4) xor s1.t(I)(3) xor s1.t(I)(7) ) & 
              ( s1.t(I)(3) xor s1.t(I)(2) xor s1.t(I)(7) ) & ( s1.t(I)(2) xor s1.t(I)(1) ) & ( s1.t(I)(1) xor s1.t(I)(0) xor s1.t(I)(7) ) & ( s1.t(I)(0) xor s1.t(I)(7) );
  end generate;
	

	
	
	--Output byte
  
  xors : for I in 0 to D-1 generate 
    s01_x.v(I) <= s0_2.v(I) xor s1_3.v(I);
    s01_x.t(I) <= s0_2.t(I) xor s1_3.t(I);
    s23_x.v(I) <= s2.v(I) xor s3.v(I);
    s23_x.t(I) <= s2.t(I) xor s3.t(I);
  end generate;
	
  ouut : for I in 0 to D-1 generate
    out_col.v(I) <= s01_x.v(I) xor s23_x.v(I);
    out_col.t(I) <= s01_x.t(I) xor s23_x.t(I);
  end generate;
		

end Behavioral;

