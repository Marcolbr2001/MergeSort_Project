library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Merge_Sort is
	generic (
		
		TDATA_WIDTH	: integer	:= 32
		
	);
	port (

		clk	  : in std_logic;
		reset : in std_logic;
		
		merge_stream_in	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic;
		
		transfer_enable	: in std_logic;
		
		merge_stream_out	: out std_logic_vector(TDATA_WIDTH-1 downto 0)
		
	);
end Merge_Sort;

architecture arch_imp of Merge_Sort is

    -- Total number of input and output data -------
    constant NUMBER_OF_INPUT_WORDS  : integer := 32;
    constant NUMBER_OF_OUTPUT_WORDS : integer := 32;                                   
    ------------------------------------------------

    type signal_register_my_type is array (integer range<>) of std_logic_vector(31 DOWNTO 0);

    signal SIPO_out: signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);

    --------------------- Merge Stages Register ----------------------
    signal reg_stage2, reg_stage2_out   : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);
    signal reg_stage4, reg_stage4_out   : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);
    signal reg_stage8, reg_stage8_out   : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);
    signal reg_stage16, reg_stage16_out : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);
    signal reg_stage32, reg_stage32_out : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);
    ------------------------------------------------------------------

    signal output_merge : std_logic_vector(TDATA_WIDTH-1 downto 0);  

    -------- Usefull signals ------
    signal shift : std_logic;
    signal started_conversion  : std_logic := '0';
    signal S_AXIS_TVALID_DELAY : std_logic := '0';
    signal counter_conversion  : integer := 0;
    -------------------------------


    component Rgstr is
    Port ( 
        clk: in std_logic;
        reset: in std_logic;
        d: in std_logic_vector(31 downto 0);
        q: out std_logic_vector(31 downto 0)
    );
    end component;

begin
	
    start_conversion : Process(clk, reset)
	begin
        if rising_edge(clk) then
        
            if(S_AXIS_TLAST ='1') then
                started_conversion <= '1';
            end if;
        
        end if;
	end process;
	
		 
    ----- Parallelized input (SIPO) to collect input data -----
    SIPO_GEN : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate 
    SIPO_if_init : if i = 0 generate

        Register_init: Rgstr
            Port Map(
                clk => clk,
                reset => reset,
                d => merge_stream_in,
                q => SIPO_out(i)
            );
        end generate;

    SIPO_if_other : if i /= 0 generate

        Register_others : Rgstr
            Port Map(
                clk => clk,
                reset => reset,
                d => SIPO_out(i-1),
                q => SIPO_out(i)
            );
        end generate;
    end generate;
    ----------------------- end SIPO  -------------------------	

	number_of_finished_conversion_counter : Process(clk, reset)
	begin
		
		if reset = '1' then

		else 
			if rising_edge(clk) then
                    if started_conversion = '1' then
                        if counter_conversion >= 10 then
                            shift <= '0';
                        else
                            shift <= '1';
                            counter_conversion <= counter_conversion + 1;
                        end if;
                    end if;
				end if;
			end if;
			
	end process;

    --------------------------- Merge Stage 2 ---------------------------
    Stage2 : Process(reset, S_AXIS_TLAST)
    begin
    
        if reset='1' then
            
            reg_stage2<=(Others=>(Others=>'0'));
        
        elsif(rising_edge(S_AXIS_TLAST)) then
            
            for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/2 loop
                if  (to_integer(unsigned(SIPO_out(2*i)))) < (to_integer(unsigned(SIPO_out(2*i+1)))) then
                    reg_stage2(2*i) <= SIPO_out(2*i);
                    reg_stage2(2*i+1) <= SIPO_out(2*i+1);
                else
                    reg_stage2(2*i) <= SIPO_out(2*i+1);
                    reg_stage2(2*i+1) <= SIPO_out(2*i);
                end if;
            end loop;

        end if;
        
    end process;

    
    Reg_Stage_2 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Stage_2 : Rgstr
        Port Map(
            clk => clk,
            reset => reset,
            d => reg_stage2(i),
            q => reg_stage2_out(i)
        );
    end generate;
    --------------------------------------------------------------------------


    --------------------------- Merge Stage 4 --------------------------------
    Stage4 : Process(reset, reg_stage2_out)
    variable a,b : integer;
    begin
        
        if reset='1' then
        reg_stage4<=(Others=>(Others=>'0'));
        else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/4 loop
            a := 0;
            b := 0;
            for j in 0 to 3 loop
                if b >= 2 then
                    reg_stage4(4*i+j) <= reg_stage2_out(4*i+j);
                elsif a >= 2 and j >= 2 then
                    reg_stage4(4*i+j) <= reg_stage2_out(4*i+j-2);
                elsif reg_stage2_out(4*i+j-a) <= reg_stage2_out(4*i+j+2-b) then
                    reg_stage4(4*i+j) <= reg_stage2_out(4*i+j-a);
                    b := b + 1;
                elsif reg_stage2_out(4*i+j-a) > reg_stage2_out(4*i+j+2-b) then
                    reg_stage4(4*i+j) <= reg_stage2_out(4*i+j+2-b);
                    a := a + 1;
                end if;
            end loop;
        end loop;
        end if;
    end process;

    Reg_Stage_4 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Stage_4 : Rgstr
        Port Map(
            clk => clk,
            reset => reset,
            d => reg_stage4(i),
            q => reg_stage4_out(i)
        );
    end generate;
    --------------------------------------------------------------------------
    
    
    --------------------------- Merge Stage 8 --------------------------------
    Stage8 : Process(reset, reg_stage4_out)
    variable a,b : integer;
    begin
        
        if reset='1' then
        reg_stage8<=(Others=>(Others=>'0'));
        else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/8 loop
            a:=0;
            b:=0;
            for j in 0 to 7 loop
            
                if b >= 4 and j >= 4 then
                    reg_stage8(8*i+j)<=reg_stage4_out(8*i+j);
                    
                elsif a >= 4 and j >= 4 then    --9fpi7
                    reg_stage8(8*i+j)<=reg_stage4_out(8*i+j-4);

                elsif reg_stage4_out(8*i+j-a) <= reg_stage4_out(8*i+j+4-b) then
                    reg_stage8(8*i+j)<=reg_stage4_out(8*i+j-a);
                    b := b + 1;
                    
                elsif reg_stage4_out(8*i+j-a) > reg_stage4_out(8*i+j+4-b) then
                    reg_stage8(8*i+j) <= reg_stage4_out(8*i+j+4-b);
                    a := a + 1;
                end if;
                
            end loop;
        end loop;
        end if;
    end process;

    Reg_Stage_8 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Stage_8 : Rgstr
        Port Map(
            clk => clk,
            reset => reset,
            d => reg_stage8(i),
            q => reg_stage8_out(i)
        );
    end generate;
    --------------------------------------------------------------------------               

    --------------------------- Merge Stage 16 --------------------------------
    Stage16 : Process(reset, reg_stage8_out)
    variable a,b : integer;
    begin
        
        if reset='1' then
        reg_stage16<=(Others=>(Others=>'0'));
        else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/16 loop
            a:=0;
            b:=0;
            for j in 0 to 15 loop
            
                if b >= 8 and j >= 8 then
                    reg_stage16(16*i+j) <= reg_stage8_out(16*i+j);
                    
                elsif a>=8 and j>=8 then    
                    reg_stage16(16*i+j) <= reg_stage8_out(16*i+j-8);

                elsif reg_stage8_out(16*i+j-a) <= reg_stage8_out(16*i+j+8-b) then
                    reg_stage16(16*i+j) <= reg_stage8_out(16*i+j-a);
                    b := b + 1;
                    
                elsif reg_stage8_out(16*i+j-a) > reg_stage8_out(16*i+j+8-b) then
                    reg_stage16(16*i+j) <= reg_stage8_out(16*i+j+8-b);
                    a := a + 1;
                end if;
                
            end loop;
        end loop;
        end if;
    end process;
 
    Reg_Stage_16 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Stage_16 : Rgstr
        Port Map(
            clk => clk,
            reset => reset,
            d => reg_stage16(i),
            q => reg_stage16_out(i)
        );
    end generate;
    --------------------------------------------------------------------------
    
    --------------------------- Merge Stage 32 --------------------------------
    Stage32:Process(reg_stage16_out,reset)
    variable a,b : integer;
    begin
        
        if reset = '1' then
        reg_stage32 <= (Others=>(Others=>'0'));
        else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/32 loop
            a := 0;
            b := 0;
            for j in 0 to 31 loop
            
                if b >= 16 and j >= 16 then
                    reg_stage32(32*i+j) <= reg_stage16_out(32*i+j);
                    
                elsif a>=16 and j>=16 then    
                    reg_stage32(32*i+j) <= reg_stage16_out(32*i+j-16);

                elsif reg_stage16_out(32*i+j-a) <= reg_stage16_out(32*i+j+16-b) then
                    reg_stage32(32*i+j) <= reg_stage16_out(32*i+j-a);
                    b := b + 1;
                    
                elsif reg_stage16_out(32*i+j-a) > reg_stage16_out(32*i+j+16-b) then
                    reg_stage32(32*i+j) <= reg_stage16_out(32*i+j+16-b);
                    a := a + 1;
                end if;
                
            end loop;
        end loop;
        end if;
    end process;

    Reg_Stage_32 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Stage_32 : Rgstr
        Port Map(
            clk => clk,
            reset => reset,
            d => reg_stage32(i),
            q => reg_stage32_out(i)
        );
    end generate;
    --------------------------------------------------------------------------

    -------- PISO shift register for serial Output --------
	process (clk, reset, shift, reg_stage32_out) is 

	    variable temp : signal_register_my_type(NUMBER_OF_INPUT_WORDS-1 downto 0);

	begin

		if (reset = '1') then
			    temp := (others=>(Others => '0'));
		elsif (shift = '1') then 
		        temp := reg_stage32_out;
		elsif (rising_edge(clk) and transfer_enable = '1') then 
			
            output_merge <= temp(NUMBER_OF_INPUT_WORDS-1);
		    temp := temp(NUMBER_OF_INPUT_WORDS - 2 downto 0) & "00000000000000000000000000000000";
		
            end if;
		
	end process;
	----------------------------------------------------------

	merge_stream_out <= output_merge; 

end arch_imp;
