-- The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
-- Michaël Peeters and Gilles Van Assche. For more information, feedback or
-- questions, please refer to our website: http://keccak.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
library STD;
 use STD.textio.all;
library ieee;
use ieee.std_logic_1164.all;
    

library work;


package keccak_globals is


constant num_plane : integer := 5;
constant num_sheet : integer := 5;
constant logD : integer :=4;
constant N : integer := 32;



--types
 type k_lane        is  array ((N-1) downto 0)  of std_logic;    
 type k_plane        is array (0 to (num_sheet-1))  of k_lane;    
 type k_state        is array (0 to (num_plane-1))  of k_plane;  

end package;
