----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 	COSIC
-- 
-- Create Date:    11:50:18 02/27/2017 
-- Design Name: 
-- Module Name:    Key_array_SPDZ - Behavioral 
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

entity Key_array is
	Port ( 
			clk 			: in  std_logic;
			clk_en 			: in  shared_bit_tag;
        	rotate			: in  shared_bit_tag; 
			K_in	 		: in  shared_value_tag;
			key_to_SB 		: out shared_value_tag;
			K00 			: out shared_value_tag;
			K03 	 		: out shared_value_tag
	  );
end Key_array;

architecture Behavioral of Key_array is
	 

	--Registers
	signal key_regs	: state;
	signal key_next	: state;

	signal clk_gate : std_logic;
	
	
begin

	--Outputs
	key_to_SB <= key_regs(1)(3);
	
	K00 <= key_regs(0)(0);

	K03 <= key_regs(0)(3);

	
	

	
	--Regs wiring
	-- Row 0: shift up 
	key_next(0)(0) <= key_regs(1)(0);
	key_next(0)(1) <= key_regs(1)(1);
	key_next(0)(2) <= key_regs(1)(2);
	key_next(0)(3) <= key_regs(1)(3);

	--Row 1: shift up 
	key_next(1)(0) <= key_regs(2)(0);
	key_next(1)(1) <= key_regs(2)(1);
	key_next(1)(2) <= key_regs(2)(2);
	key_next(1)(3) <= key_regs(2)(3);

	-- Row2 : shift up
	key_next(2)(0) <= key_regs(3)(0);
	key_next(2)(1) <= key_regs(3)(1);
	key_next(2)(2) <= key_regs(3)(2);
	key_next(2)(3) <= key_regs(3)(3);

	contrl_gen : for K in 0 to D-1 generate -- Only here coz in the previous ones there are no control signals
	--VALUE	
		-- Row 3 : meander or rotate 
		key_next(3)(0).v(K) <= key_regs(0)(0).v(K) when (rotate.v(K) = '1') else key_regs(0)(1).v(K);
		key_next(3)(1).v(K) <= key_regs(0)(1).v(K) when (rotate.v(K) = '1') else key_regs(0)(2).v(K);
		key_next(3)(2).v(K) <= key_regs(0)(2).v(K) when (rotate.v(K) = '1') else key_regs(0)(3).v(K);
		key_next(3)(3).v(K) <= key_regs(0)(3).v(K) when (rotate.v(K) = '1') else K_in.v(K);
	--TAG
		-- Row 3 : meander or rotate 
		key_next(3)(0).t(K) <= key_regs(0)(0).t(K) when (rotate.t(K) = '1') else key_regs(0)(1).t(K);
		key_next(3)(1).t(K) <= key_regs(0)(1).t(K) when (rotate.t(K) = '1') else key_regs(0)(2).t(K);
		key_next(3)(2).t(K) <= key_regs(0)(2).t(K) when (rotate.t(K) = '1') else key_regs(0)(3).t(K);
		key_next(3)(3).t(K) <= key_regs(0)(3).t(K) when (rotate.t(K) = '1') else K_in.t(K);
	end generate;


--	--Sequential logic for area
--	clk_gate <= clk and clk_en; 
--	seq : process(clk_gate)
--	begin  
--		if (rising_edge(clk_gate)) then
--			key_regs <= key_next;
--		end if;
--	end process;

--	Sequential logic for fpga 
	seq : process(clk)
	begin  
		if (rising_edge(clk)) then
			for K in 0 to D-1 loop
				for I in 0 to 3 loop
					for J in 0 to 3 loop
						if(clk_en.v(K) = '1') then 
							key_regs(I)(J).v(K) <= key_next(I)(J).v(K);
						end if;
						if(clk_en.t(K) = '1') then 
							key_regs(I)(J).t(K) <= key_next(I)(J).t(K);
						end if;
					end loop;
				end loop;
			end loop;
		end if;
	end process;

end Behavioral;



