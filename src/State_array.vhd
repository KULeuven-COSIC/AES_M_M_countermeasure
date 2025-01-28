----------------------------------------------------------------------------------
-- Company: 
-- Engineer:	COSIC
-- 
-- Create Date:    11:48:27 02/27/2017 
-- Design Name: 
-- Module Name:    State_array_SPDZ - Behavioral 
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

entity State_array is
    Port ( 
			clk 		  	: in  std_logic;
			en 				: in  shared_bit_tag;
        	shift_rows 		: in  shared_bit_tag;
        	mix_col			: in  shared_bit_tag;
			State_in 		: in shared_value_tag;
			State_out		: out shared_value_tag
	  );
end State_array;

architecture Behavioral of State_array is
	
	--Components
	component MixColumns
		 Port ( in_col  : in  mix_col_type;
				  out_col : out  mix_col_type);
	end component;
	
	
	--Scan flip flops
	signal state_regs : state;
	signal state_next : state;
	
	--Mix columns signals
	signal mixCol_in : mix_col_type;
	signal mixCol_out : mix_col_type;
	
begin

	--Output
	contrl_gen1 : for K in 0 to D-1 generate
		State_out.v(K) <= mixCol_out(0).v(K) when (mix_col.v(K)='1') else state_regs(0)(0).v(K);
		State_out.t(K) <= mixCol_out(0).t(K) when (mix_col.t(K)='1') else state_regs(0)(0).t(K);
	end generate;

	contrl_gen : for K in 0 to D-1 generate
	--VALUE
		--Regs wiring, including ShiftRows operation
		--Row 0
		state_next(0)(0).v(K) <= mixCol_out(1).v(K)		when (mix_col.v(K)='1')		else state_regs(1)(0).v(K);
		state_next(0)(1).v(K) <= state_regs(1)(1).v(K);
		state_next(0)(2).v(K) <= state_regs(1)(2).v(K);
		state_next(0)(3).v(K) <= state_regs(1)(3).v(K);

	    -- Row 1 
		state_next(1)(0).v(K) <= mixCol_out(2).v(K) 		when (mix_col.v(K)='1') 		else 
								state_regs(2)(1).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(2)(0).v(K);
		state_next(1)(1).v(K) <= state_regs(2)(2).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(2)(1).v(K);
		state_next(1)(2).v(K) <= state_regs(2)(3).v(K) 	when (shift_rows.v(K)='1')	else state_regs(2)(2).v(K);
		state_next(1)(3).v(K) <= state_regs(2)(0).v(K)	when (shift_rows.v(K)='1') 	else state_regs(2)(3).v(K);

		-- Row 2 
		state_next(2)(0).v(K) <= mixCol_out(3).v(K) 		when (mix_col.v(K)='1') 		else 
								state_regs(3)(2).v(K) 	when (shift_rows.v(K)='1')   else state_regs(3)(0).v(K);
		state_next(2)(1).v(K) <= state_regs(3)(3).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(3)(1).v(K);
		state_next(2)(2).v(K) <= state_regs(3)(0).v(K) 	when (shift_rows.v(K)='1')	else state_regs(3)(2).v(K);
		state_next(2)(3).v(K) <= state_regs(3)(1).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(3)(3).v(K);

		-- Row 3
		state_next(3)(0).v(K) <= State_in.v(K) 			when (shift_rows.v(K)='1') 	else state_regs(0)(1).v(K);
		state_next(3)(1).v(K) <= state_regs(0)(1).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(0)(2).v(K);
		state_next(3)(2).v(K) <= state_regs(0)(2).v(K) 	when (shift_rows.v(K)='1') 	else state_regs(0)(3).v(K);
		state_next(3)(3).v(K) <= state_regs(0)(3).v(K) 	when (shift_rows.v(K)='1') 	else State_in.v(K);

	--TAG
		state_next(0)(0).t(K) <= mixCol_out(1).t(K)		when (mix_col.t(K)='1')		else state_regs(1)(0).t(K);
		state_next(0)(1).t(K) <= state_regs(1)(1).t(K);
		state_next(0)(2).t(K) <= state_regs(1)(2).t(K);
		state_next(0)(3).t(K) <= state_regs(1)(3).t(K);

	    -- Row 1 
		state_next(1)(0).t(K) <= mixCol_out(2).t(K) 		when (mix_col.t(K)='1') 		else 
								state_regs(2)(1).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(2)(0).t(K);
		state_next(1)(1).t(K) <= state_regs(2)(2).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(2)(1).t(K);
		state_next(1)(2).t(K) <= state_regs(2)(3).t(K) 	when (shift_rows.t(K)='1')	else state_regs(2)(2).t(K);
		state_next(1)(3).t(K) <= state_regs(2)(0).t(K)	when (shift_rows.t(K)='1') 	else state_regs(2)(3).t(K);

		-- Row 2 
		state_next(2)(0).t(K) <= mixCol_out(3).t(K) 		when (mix_col.t(K)='1') 		else 
								state_regs(3)(2).t(K) 	when (shift_rows.t(K)='1')   else state_regs(3)(0).t(K);
		state_next(2)(1).t(K) <= state_regs(3)(3).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(3)(1).t(K);
		state_next(2)(2).t(K) <= state_regs(3)(0).t(K) 	when (shift_rows.t(K)='1')	else state_regs(3)(2).t(K);
		state_next(2)(3).t(K) <= state_regs(3)(1).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(3)(3).t(K);

		-- Row 3
		state_next(3)(0).t(K) <= State_in.t(K) 			when (shift_rows.t(K)='1') 	else state_regs(0)(1).t(K);
		state_next(3)(1).t(K) <= state_regs(0)(1).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(0)(2).t(K);
		state_next(3)(2).t(K) <= state_regs(0)(2).t(K) 	when (shift_rows.t(K)='1') 	else state_regs(0)(3).t(K);
		state_next(3)(3).t(K) <= state_regs(0)(3).t(K) 	when (shift_rows.t(K)='1') 	else State_in.t(K);

	end generate;
							  

	--Mix columns
	mixCol_in(0) <= state_regs(0)(0);
	mixCol_in(1) <= state_regs(1)(0);
	mixCol_in(2) <= state_regs(2)(0);
	mixCol_in(3) <= state_regs(3)(0);

	mc : MixColumns port map(in_col => mixCol_in, out_col => mixCol_out);
	
	
	
	
	--Sequential logic
	seq : process (clk)
	begin
		if (rising_edge(clk)) then
			for K in 0 to D-1 loop
				for I in 0 to 3 loop
					for J in 0 to 3 loop
						if(en.v(K) = '1') then 
							state_regs(I)(J).v(K) <= state_next(I)(J).v(K);
						end if;
						if(en.t(K) = '1') then 
							state_regs(I)(J).t(K) <= state_next(I)(J).t(K);
						end if;
					end loop;
				end loop;
			end loop;
		end if;
	end process;
							  
end Behavioral;



