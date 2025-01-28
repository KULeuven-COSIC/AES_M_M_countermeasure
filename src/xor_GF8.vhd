----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:22:30 12/06/2016 
-- Design Name: 
-- Module Name:    AES_box_GF8 - Behavioral 
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

entity xor_GF8 is
  port(
    x : in shared_value_tag;
    y : in shared_value_tag;
    z : out shared_value_tag
  );
end xor_GF8; 

architecture Behavioral of xor_GF8 is
  
  begin 
  
  z.v(0) <= x.v(0) xor y.v(0);
  z.v(1) <= x.v(1) xor y.v(1);
  z.v(2) <= x.v(2) xor y.v(2);
  
  z.t(0) <= x.t(0) xor y.t(0);
  z.t(1) <= x.t(1) xor y.t(1);
  z.t(2) <= x.t(2) xor y.t(2);


end Behavioral;


