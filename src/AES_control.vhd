library IEEE;
use IEEE.std_logic_1164.ALL;

library work;
 use work.MPC_globals.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity AES_control is 
	port (
	      clk : in std_logic;
	      rst : in std_logic;
	      load : in std_logic;
	      start : in std_logic;
	      done : out shared_bit_tag;
	      Rcon : out shared_value;
	      state_en : out shared_bit_tag;
	      shift_rows : out shared_bit_tag;
	      mix_col : out shared_bit_tag;
	      key_en 	: out shared_bit_tag;
	      rotate_key : out shared_bit_tag;
	      key_rcon : out shared_bit_tag;
	      sbox_to_state : out shared_bit_tag;
	      round0 	: out shared_bit_tag
	);
end AES_control;

architecture Behavioral of AES_control is 
	
	type shared_counter is array (0 to D-1) of unsigned(4 downto 0);
 	type shared_sel   is array (0 to D-1) of std_logic_vector (0 to 8);

	component RConst
  		port(	clk, rst, enable : in  std_logic; 
        		RCon : out std_logic_vector(7 downto 0)
        	); 
	end component;
	
	component control_counter
		 Port ( clk : in  std_logic;
				  en : in  std_logic;
				  rst : in  std_logic;
				  count_out : out  unsigned (4 downto 0)
			);
	end component;

	signal sel_v, sel_t	: shared_sel;

	signal const		: shared_value;
	signal round		: shared_bit; -- when one round complete
	signal skip_mix_col : shared_bit_tag; 
	signal rcon_rst 	: shared_bit;
	signal const_zero	: shared_bit;
	signal cntr_en		: shared_bit;
	signal cntr_rst		: shared_bit;
	signal done_load 	: shared_bit; 

	signal round10 		: shared_bit_tag;
	signal round0_dummy : shared_bit_tag;

  	signal done_dummy 	: shared_bit_tag;

  	signal cycle_cntr	: shared_counter;

begin 

	contrl_gen : for K in 0 to D-1 generate
	-- Redundacy in the control
		shift_rows.v(K) <= sel_v(K)(0); 
		shift_rows.t(K) <= sel_t(K)(0); 

		mix_col.v(K) <= sel_v(K)(1) and (not skip_mix_col.v(K)); 
		mix_col.t(K) <= sel_t(K)(1) and (not skip_mix_col.t(K)); 

		key_en.v(K) 	<= (start or load) and sel_v(K)(2);
		key_en.t(K) 	<= (start or load) and sel_t(K)(2);
	
		state_en.v(K) <= start or load;
		state_en.t(K) <= start or load;

		rotate_key.v(K) <= sel_v(K)(3);
		rotate_key.t(K) <= sel_t(K)(3);

		key_rcon.v(K) <= sel_v(K)(4);
		key_rcon.t(K) <= sel_t(K)(4);

		sbox_to_state.v(K) <= sel_v(K)(5);  
		sbox_to_state.t(K) <= sel_t(K)(5);  

		const_zero(K) <= sel_v(K)(6); -- 1 in cycle 0 ( xor rcon cycle)
		round(K) <= sel_v(K)(7); -- last cycle: 21
		done_load(K) <= sel_v(K)(8); -- cycle 15
		rcon_rst(K) <= rst or load;

		round10.v(K) <= (const(K)(1) and const(K)(2)); -- round constant = 0x36
		round0_dummy.v(K) <= (const(K)(2) and const(K)(3)); -- round constant = 0x8d
		round0.v(K) <= round0_dummy.v(K);
		round10.t(K) <= (const(K)(1) and const(K)(2)); -- round constant = 0x36
		round0_dummy.t(K) <= (const(K)(2) and const(K)(3)); -- round constant = 0x8d
		round0.t(K) <= round0_dummy.t(K);

	-- round constant
		Rcon(K) <= const(K) and (7 downto 0 => const_zero(K));

		skip_mix_col.v(K) <= round10.v(K) or round0_dummy.v(K) or load;
		skip_mix_col.t(K) <= round10.t(K) or round0_dummy.t(K) or load;

		cntr_en(K) <= start or load;

		cntr_rst(K) <= rst or (done_dummy.v(K) and (not start)) or round(K) or (load and done_load(K));

		done_dummy.v(K) <= round10.v(K) and (not load);
		done.v(K) <= done_dummy.v(K);
		done_dummy.t(K) <= round10.t(K) and (not load);
		done.t(K) <= done_dummy.t(K);

	    Constt: RConst
			 Port map( 
				clk => clk,
	      		rst => rcon_rst(K),
	      		enable => round(K), --When using the constant, choose the next one
				RCon => const(K)
			  );

		Control: control_counter 
			 Port map(
				clk => clk,
				en => cntr_en(K),
				rst => cntr_rst(K),
				count_out => cycle_cntr(K)
			  );
	end generate;


	lut : process(cycle_cntr)
	begin  
		contrl_gen14 : for K in 0 to D-1 loop
		--DATA
			case to_integer(cycle_cntr(K)) is 	   -- STATE:					KEY:
				when 0 	=> sel_v(K) <= "011011100"; -- s1, mixcol 				xor k00 with rcon and sbout
				when 1 	=> sel_v(K) <= "001011000"; -- s2 						xor k00 with sbout 
				when 2 	=> sel_v(K) <= "001011000"; -- s3 						xor k00 with sbout
				when 3 	=> sel_v(K) <= "001011000"; -- s4 						xor k00 with sbout
				when 4 	=> sel_v(K) <= "011001000"; -- s5, mixcol 				xor k00 with k03
				when 5 	=> sel_v(K) <= "001001000"; -- s6 						xor k00 with k03 
				when 6 	=> sel_v(K) <= "001001000"; -- s7, s1 ready 				xor k00 with k03
				when 7 	=> sel_v(K) <= "001001000"; -- s8						xor k00 with k03
				when 8 	=> sel_v(K) <= "011001000"; -- s9, mixcol				xor k00 with k03
				when 9 	=> sel_v(K) <= "001001000"; -- s10 						xor k00 with k03
				when 10 => sel_v(K) <= "001001000"; -- s11 						xor k00 with k03
				when 11 => sel_v(K) <= "001001000"; -- s12 						xor k00 with k03 
				when 12 => sel_v(K) <= "011001000"; -- s13, mixcol				xor k00 with k03
				when 13 => sel_v(K) <= "001001000"; -- s14 						xor k00 with k03
				when 14 => sel_v(K) <= "001001000"; -- s15 						xor k00 with k03
				when 15 => sel_v(K) <= "001001001"; -- s16 						xor k00 with k03
				when 16 => sel_v(K) <= "0011-0000"; -- s11 ready 				rotate, s1 
				when 17 => sel_v(K) <= "0011-0000"; -- s12 ready 				rotate, s2 
				when 18 => sel_v(K) <= "0011-0000"; -- s13 ready 				rotate, s3 
				when 19 => sel_v(K) <= "0011-0000"; -- s14 ready 				rotate, s4 
				when 20 => sel_v(K) <= "000---000"; -- s15 ready 				wait
				when 21 => sel_v(K) <= "100---010"; -- s16 ready, shiftrows  	wait
				when others => sel_v(K) <= "---------";
			end case;
		--TAG
			case to_integer(cycle_cntr(K)) is 	   -- STATE:					KEY:
				when 0 	=> sel_t(K) <= "011011100"; -- s1, mixcol 				xor k00 with rcon and sbout
				when 1 	=> sel_t(K) <= "001011000"; -- s2 						xor k00 with sbout 
				when 2 	=> sel_t(K) <= "001011000"; -- s3 						xor k00 with sbout
				when 3 	=> sel_t(K) <= "001011000"; -- s4 						xor k00 with sbout
				when 4 	=> sel_t(K) <= "011001000"; -- s5, mixcol 				xor k00 with k03
				when 5 	=> sel_t(K) <= "001001000"; -- s6 						xor k00 with k03 
				when 6 	=> sel_t(K) <= "001001000"; -- s7, s1 ready 				xor k00 with k03
				when 7 	=> sel_t(K) <= "001001000"; -- s8						xor k00 with k03
				when 8 	=> sel_t(K) <= "011001000"; -- s9, mixcol				xor k00 with k03
				when 9 	=> sel_t(K) <= "001001000"; -- s10 						xor k00 with k03
				when 10 => sel_t(K) <= "001001000"; -- s11 						xor k00 with k03
				when 11 => sel_t(K) <= "001001000"; -- s12 						xor k00 with k03 
				when 12 => sel_t(K) <= "011001000"; -- s13, mixcol				xor k00 with k03
				when 13 => sel_t(K) <= "001001000"; -- s14 						xor k00 with k03
				when 14 => sel_t(K) <= "001001000"; -- s15 						xor k00 with k03
				when 15 => sel_t(K) <= "001001001"; -- s16 						xor k00 with k03
				when 16 => sel_t(K) <= "0011-0000"; -- s11 ready 				rotate, s1 
				when 17 => sel_t(K) <= "0011-0000"; -- s12 ready 				rotate, s2 
				when 18 => sel_t(K) <= "0011-0000"; -- s13 ready 				rotate, s3 
				when 19 => sel_t(K) <= "0011-0000"; -- s14 ready 				rotate, s4 
				when 20 => sel_t(K) <= "000---000"; -- s15 ready 				wait
				when 21 => sel_t(K) <= "100---010"; -- s16 ready, shiftrows  	wait
				when others => sel_t(K) <= "---------";
			end case;
		end loop;
	end process;


end Behavioral;