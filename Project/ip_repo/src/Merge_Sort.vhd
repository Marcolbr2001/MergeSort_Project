library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Merge_Sort is
	generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_START_COUNT	: integer	:= 64
	);
	port (

		clk	: in std_logic;
		reset	: in std_logic;
		merge_stream_in	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic;
        rd_en : out std_logic;
        wr_en : out std_logic;
		merge_stream_out	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TREADY	: in std_logic
		
	);
end Merge_Sort;

architecture arch_imp of Merge_Sort is


constant NUMBER_OF_INPUT_WORDS  : integer := 32;
constant NUMBER_OF_OUTPUT_WORDS : integer := 32;                                   


type MyNestedArray is array (integer range<>) of std_logic_vector(31 DOWNTO 0);
signal sipo_reg: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf2: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf2q: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf4: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf4q: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf8: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf8q: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf16: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf16q: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);                   
signal conf32: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);
signal conf32q: MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);








type signal_register_my_type is array (NUMBER_OF_INPUT_WORDS-1 DOWNTO 0) of std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 DOWNTO 0); -- Declaring my own type to deal with multiple data of 32 bit each
signal started_conversion : std_logic := '0';
signal start_conversion : std_logic := '0';
signal shift : std_logic;
signal S_AXIS_TVALID_DELAY	: std_logic := '0';
signal counter_shift, counter_conversion : integer := 0;
signal SIPO_out : signal_register_my_type;
signal wr_en_delay, wr_en_signal : std_logic := '0';
signal input_done : std_logic_vector(0 to NUMBER_OF_INPUT_WORDS-1) := (Others => '0');
signal output_merge : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);  



component Reg_no_on is
  Port ( 
    clk: in std_logic;
    reset: in std_logic;
    d: in std_logic_vector(31 downto 0);
    q: out std_logic_vector(31 downto 0)
  );
end component;


	begin
	
Process(clk, reset)
	begin
	if rising_edge(clk) then
	
	if(S_AXIS_TLAST ='1') then
	   started_conversion <= '1';
	end if;
	
	end if;
	end process;
	
		 

	SIPO_GEN : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate 

  SIPO_if_init : if i = 0 generate

    Register_init: Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => merge_stream_in,
            q => sipo_reg(i)
        );
    end generate;

  SIPO_if_other : if i /= 0 generate

    Register_others : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => sipo_reg(i-1),
            q => sipo_reg(i)
        );
    end generate;
 end generate;
	

	Process(clk, reset)
	begin
		
		if reset='1' then

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

	Cond2:Process(reset,S_AXIS_TLAST)
 begin
 
     if reset='1' then
     conf2<=(Others=>(Others=>'0'));
     
     elsif(rising_edge(S_AXIS_TLAST)) then
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/2 loop
            if  (to_integer(unsigned(sipo_reg(2*i))))<(to_integer(unsigned(sipo_reg(2*i+1)))) then
            conf2(2*i)<=sipo_reg(2*i);
            conf2(2*i+1)<=sipo_reg(2*i+1);
            else
            conf2(2*i)<=sipo_reg(2*i+1);
            conf2(2*i+1)<=sipo_reg(2*i);
            end if;
        end loop;
     end if;
     
   
 end process;

 Reg_Cond_2 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Cond_2 : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => conf2(i),
            q => conf2q(i)
        );
    end generate;
    
 Cond4:Process(reset,conf2q)
 variable a,b : integer;
 begin
     
     if reset='1' then
     conf4<=(Others=>(Others=>'0'));
     else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/4 loop
            a:=0;
            b:=0;
            for j in 0 to 3 loop
				if b>=2 then
					conf4(4*i+j)<=conf2q(4*i+j);
					--//b++;
				elsif a>=2 and j>=2 then
					conf4(4*i+j)<=conf2q(4*i+j-2);
					--//a++;
				elsif conf2q(4*i+j-a)<=conf2q(4*i+j+2-b) then
					conf4(4*i+j)<=conf2q(4*i+j-a);
					b:=b+1;
				elsif conf2q(4*i+j-a)>conf2q(4*i+j+2-b) then
					conf4(4*i+j)<=conf2q(4*i+j+2-b);
					a:=a+1;
				end if;
			end loop;
		end loop;
     end if;
 end process;
 
  Reg_Cond_4 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Cond_4 : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => conf4(i),
            q => conf4q(i)
        );
    end generate;
    
    
    
    
 Cond8:Process(conf4q,reset)
 variable a,b : integer;
 begin
     
     if reset='1' then
     conf8<=(Others=>(Others=>'0'));
     else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/8 loop
            a:=0;
            b:=0;
            for j in 0 to 7 loop
            
				if b>=4 and j>=4 then
					conf8(8*i+j)<=conf4q(8*i+j);
					
				elsif a>=4 and j>=4 then    --9fpi7
					conf8(8*i+j)<=conf4q(8*i+j-4);

				elsif conf4q(8*i+j-a)<=conf4q(8*i+j+4-b) then
					conf8(8*i+j)<=conf4q(8*i+j-a);
					b:=b+1;
					
				elsif conf4q(8*i+j-a)>conf4q(8*i+j+4-b) then
					conf8(8*i+j)<=conf4q(8*i+j+4-b);
					a:=a+1;
				end if;
				
			end loop;
		end loop;
     end if;
 end process;
 
  Reg_Cond_8 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Cond_8 : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => conf8(i),
            q => conf8q(i)
        );
    end generate;
    
 Cond16:Process(conf8q,reset)
 variable a,b : integer;
 begin
     
     if reset='1' then
     conf16<=(Others=>(Others=>'0'));
     else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/16 loop
            a:=0;
            b:=0;
            for j in 0 to 15 loop
            
				if b>=8 and j>=8 then
					conf16(16*i+j)<=conf8q(16*i+j);
					
				elsif a>=8 and j>=8 then    
					conf16(16*i+j)<=conf8q(16*i+j-8);

				elsif conf8q(16*i+j-a)<=conf8q(16*i+j+8-b) then
					conf16(16*i+j)<=conf8q(16*i+j-a);
					b:=b+1;
					
				elsif conf8q(16*i+j-a)>conf8q(16*i+j+8-b) then
					conf16(16*i+j)<=conf8q(16*i+j+8-b);
					a:=a+1;
				end if;
				
			end loop;
		end loop;
     end if;
 end process;
 
  Reg_Cond_16 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Cond_16 : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => conf16(i),
            q => conf16q(i)
        );
    end generate;
    
    
    
 Cond32:Process(conf16q,reset)
 variable a,b : integer;
 begin
     
     if reset='1' then
     conf32<=(Others=>(Others=>'0'));
     else
        for i in 0 to (NUMBER_OF_INPUT_WORDS-1)/32 loop
            a:=0;
            b:=0;
            for j in 0 to 31 loop
            
				if b>=16 and j>=16 then
					conf32(32*i+j)<=conf16q(32*i+j);
					
				elsif a>=16 and j>=16 then    
					conf32(32*i+j)<=conf16q(32*i+j-16);

				elsif conf16q(32*i+j-a)<=conf16q(32*i+j+16-b) then
					conf32(32*i+j)<=conf16q(32*i+j-a);
					b:=b+1;
					
				elsif conf16q(32*i+j-a)>conf16q(32*i+j+16-b) then
					conf32(32*i+j)<=conf16q(32*i+j+16-b);
					a:=a+1;
				end if;
				
			end loop;
		end loop;
     end if;
 end process;
 
  Reg_Cond_32 : for i in 0 to NUMBER_OF_INPUT_WORDS-1 generate
        Register_Cond_32 : Reg_no_on
        Port Map(
            clk => clk,
            reset => reset,
            d => conf32(i),
            q => conf32q(i)
        );
    end generate;
    
	process (clk, reset, shift, conf32q) is 

	variable piso : MyNestedArray(NUMBER_OF_INPUT_WORDS-1 downto 0);

	begin

		if (reset='1') then
			piso := (others=>(Others => '0'));
		elsif (shift='1') then 
		    piso := conf32q;
			wr_en_signal <= '0';
		elsif (rising_edge(clk) and M_AXIS_TREADY = '1') then 
			output_merge <= piso(NUMBER_OF_INPUT_WORDS-1);
			wr_en_signal <= '1';
			piso := piso(NUMBER_OF_INPUT_WORDS-2 downto 0) & "00000000000000000000000000000000";
		end if;
		
	end process;
	
    
	
	wr_en <= wr_en_signal;
	rd_en <= S_AXIS_TVALID;
	merge_stream_out <= output_merge; 


end arch_imp;
