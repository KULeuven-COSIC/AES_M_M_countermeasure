
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


library work;
 use work.MPC_globals.all;

entity MatMult is 
  port (
    v : in std_logic_vector(7 downto 0);
    M : in matrix;
    Mv : out std_logic_vector(7 downto 0)
  );
end MatMult; 

architecture Behavioral of MatMult is
  
  begin 
  
   genloop : for I in 0 to 7 generate 
      Mv(I) <= (v(0)and M(0)(I)) xor (v(1)and M(1)(I)) xor (v(2)and M(2)(I)) xor (v(3)and M(3)(I)) 
      xor (v(4)and M(4)(I)) xor (v(5)and M(5)(I)) xor (v(6)and M(6)(I)) xor (v(7)and M(7)(I));
   end generate ;

end Behavioral;
 