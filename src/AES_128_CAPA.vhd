----------------------------------------------------------------------------------
-- Company: COSIC
-- Engineer: 
-- 
-- Create Date:    11:35:25 02/27/2017 
-- Design Name: 
-- Module Name:    AES_128_SPDZ - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_128_CAPA is
	port(
		clk,load	: in  std_logic; 
		rst,start 	: in  std_logic; 
		clk_prng 	: in  std_logic; 
		rst_prng 	: in  std_logic; 
		alpha		: in  shared_value;
    	alpha_inv 	: in  shared_value;
   		M_alpha 	: in  shared_matrix;
		data_in 	: in  shared_value_tag;
		key			: in  shared_value_tag;
    	PRNG_seed 	: in  STD_LOGIC_VECTOR (39 downto 0);
		data_out 	: out shared_value;
    	ready_bits 	: out shared_bit
		);
end AES_128_CAPA;

architecture Behavioral of AES_128_CAPA is

	--Components used
	component State_array
		 Port ( 
			clk 		  	: in  std_logic;
			en 				: in  shared_bit_tag;
        	shift_rows 		: in  shared_bit_tag;
        	mix_col			: in  shared_bit_tag;
			State_in 		: in  shared_value_tag;
			State_out		: out shared_value_tag
	  );
	end component;
	
	component Key_array
		Port ( 
			clk 			: in  std_logic;
			clk_en 			: in  shared_bit_tag;
        	rotate			: in  shared_bit_tag; 
			K_in	 		: in  shared_value_tag;
			key_to_SB 		: out shared_value_tag;
			K00 			: out shared_value_tag;
			K03 	 		: out shared_value_tag
	  );
	end component;

	component AES_box_CAPA3 
    Port ( clk : in  STD_LOGIC;
           S_in : in  shared_value_tag;
           alpha : in  shared_value;
           M_alpha : in shared_matrix;
           r : in box_random;
           S_out : out  shared_value_tag);
	end component;
	
	component AES_control 
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
	end component;
	
	component xor_GF8
		  port(
			 x : in shared_value_tag;
			 y : in shared_value_tag;
			 z : out shared_value_tag
		  );
	end component;

	component const_xor_GF8 
		port(
		    x : in shared_value_tag;
		    c : in shared_value;
		    alpha: in shared_value;
		    y : out shared_value_tag
  		);
	end component;

	component infect 
	  port ( clk : in std_logic;
	         ciphertext_in : in shared_value_tag;
	         alpha : in shared_value;
	         r : in infect_random;
	         ciphertext_out : out shared_value
	  ) ;
	end component ;
  
  --PRNG
  component Keccak_p800
		 Port ( start, clk, rst : in std_logic;
				  seed : in  STD_LOGIC_VECTOR (39 downto 0);
				  s_out_r : out  STD_LOGIC_VECTOR (799 downto 0)
				);
  end component;
		
	
	--Data path Signals
	signal state_in 	: shared_value_tag;
	signal state_out	: shared_value_tag;
	signal state_xor	: shared_value_tag;
	
	signal key_in		: shared_value_tag;
	signal key_out		: shared_value_tag;
	signal key_to_SB	: shared_value_tag;
	signal key03 		: shared_value_tag;
	signal key_xor_rcon : shared_value_tag;
	signal tmpxor 		: shared_value_tag;
	signal key_xor_03 	: shared_value_tag;

	signal RCon			: shared_value;
	
	signal Sbox_inp	: shared_value_tag;
	signal Sbox_out	: shared_value_tag;
		
	signal xor_buffer	: shared_value_tag;
  	--signal data_out_buffer_next, data_out_buffer_reg : shared_value_tag;
  	signal infected_out : shared_value;

  	signal random : box_random;
  	signal infrand : infect_random;
  	signal PRNG_out : STD_LOGIC_VECTOR (799 downto 0);
	
	--signal abortstatus: shared_bit;

	--Control signals
	signal done			: shared_bit_tag;
  	signal ready_buf_next, ready_buf_reg : shared_bit;
  	signal en_prng 		: std_logic;
	
	signal key_en 		: shared_bit_tag;
	signal rotate_key	: shared_bit_tag;
	signal key_rcon		: shared_bit_tag;
	
	signal shift_rows	: shared_bit_tag;
	signal mix_col		: shared_bit_tag;
	signal sbox_to_state : shared_bit_tag;
  	signal state_en 	: shared_bit_tag;

  	signal round0 : shared_bit_tag;
  	

begin
	
  --PRNG
	PRNG : Keccak_p800
		 Port map(
				start => en_prng,
				clk => clk_prng, 
				rst => rst_prng,
				seed => PRNG_seed,
				s_out_r => PRNG_out
				);
  
	--Component instantiation
	State	:	State_array
		 Port map( 
				  clk => clk,
				  en => state_en,
				  shift_rows => shift_rows,
				  mix_col => mix_col,
				  State_in => state_in,
				  State_out => state_out
		  );
		  
	Key_ar:	Key_array
		 Port map( 
				  clk => clk,
				  clk_en => key_en, 
				  rotate => rotate_key,
				  K_in => key_in,
				  key_to_SB => key_to_SB,
				  K00	=> key_out,
				  K03 => key03
		  );
		  
	SBox	:	AES_box_CAPA3
			 Port map(
				clk => clk,
				S_in => Sbox_inp,
				alpha => alpha,
	      		M_alpha => M_alpha,
	      		r => random,
				S_out => Sbox_out
			  );
		  
	control : AES_control 
		Port map(
		    clk => clk,
		    rst => rst,
		    load => load,
		    start => start,
		    done => done,
		    Rcon => RCon,
		    state_en => state_en,
		    shift_rows => shift_rows,
		    mix_col => mix_col,
		    key_en => key_en,
		    rotate_key => rotate_key,
		    key_rcon => key_rcon,
		    sbox_to_state => sbox_to_state,
		    round0 => round0
         );

	inf : infect
		Port map(
		    clk => clk,
		    ciphertext_in => xor_buffer,
		    alpha => alpha,
		    r => infrand,
		    ciphertext_out => infected_out
		);
	
	-- Wiring 
--
	-- Sbox input 
	contrl_gen7 : for K in 0 to D-1 generate
		Sbox_inp.v(K) <= xor_buffer.v(K) when (sbox_to_state.v(K)='1') else key_to_SB.v(K);
		Sbox_inp.t(K) <= xor_buffer.t(K) when (sbox_to_state.t(K)='1') else key_to_SB.t(K);
	end generate;

	-- Key input 
	-- Key type 1: xor with sbout and rcon 
	xorsbox : xor_GF8 port map(x => key_out, y => Sbox_out, z => tmpxor);
	xorconst : const_xor_GF8 port map(x => tmpxor, c => RCon, alpha => alpha, y => key_xor_rcon);

	-- Key type 2: xor with key03 (previous column)
	xor03 : xor_GF8 port map( x=> key_out, y => key03, z => key_xor_03);

	-- Multiplexer Keys 
	contrl_gen6 : for K in 0 to D-1 generate
		key_in.v(K) <= 	key.v(K) when (load='1') else 
					key_out.v(K) when (round0.v(K)='1') else 
					key_xor_rcon.v(K) when (key_rcon.v(K)='1') else 
					key_xor_03.v(K);
		key_in.t(K) <= 	key.t(K) when (load='1') else 
					key_out.t(K) when (round0.t(K)='1') else 
					key_xor_rcon.t(K) when (key_rcon.t(K)='1') else 
					key_xor_03.t(K);
	end generate;


	-- State xor key 
	--state_xor <= 	data_in when (load='1') else state_out;
	statexorkey : xor_GF8 port map (x => state_out, y => key_in, z => xor_buffer);

	-- State input 
	state_in <= data_in when (load='1') else Sbox_out;

        


	--Outputs
	contrl_gen9 : for K in 0 to D-1 generate
  		ready_buf_next(K) <= done.v(K);
  	end generate;

  	getready : for I in 0 to D-1 generate 
		ready_bits(I) <= ready_buf_reg(I) or done.v(I);
	end generate; 

	--data_out_buffer_next <= xor_buffer when done = '1' else state_zeros;
  	--data_out <= data_out_buffer_reg;
  	contrl_gen10 : for K in 0 to D-1 generate
  		data_out(K) <= infected_out(K) when (done.v(K)='1') else (others => '0');
  	end generate;
	
    -- Randomness 
	genrands : for I in 0 to 2 generate 
		random.af(I) <= PRNG_out(8*I+7 downto 8*I);
	end generate;
	random.inv1 <= PRNG_out(185 downto 24);
	random.inv2 <= PRNG_out(347 downto 186);

	gen_inf_rand : for I in 0 to 3 generate 
		infrand(I) <= PRNG_out(799-8*I downto 799-8*I-7);
	end generate;
	
	--Sequential logic
	regs: process (clk)
	begin
		if (rising_edge(clk)) then  
	      --data_out_buffer_reg <= data_out_buffer_next;
	      ready_buf_reg <= ready_buf_next;
		end if;
	end process;
  
	  en : process(clk)
	  begin 
	    if rising_edge(clk) then 
	      if load = '1' then 
				en_prng <= '1';
			end if;
			if done.v(0)='1' then 
				en_prng <= '0';
			end if;
		 end if;
	  end process;

end Behavioral;

