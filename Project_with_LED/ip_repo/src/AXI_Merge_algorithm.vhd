library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_Merge_algorithm is
	generic (
	   
	    --Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 64
		
	);
	port (

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic;
		
		end_conversion : out std_logic
		
	);
end AXI_Merge_algorithm;

architecture arch_imp of AXI_Merge_algorithm is

signal stream_out, stream_in, stream_merge_out, stream_in_master, stream_out_master : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (Others => '0');
signal tranfer_enable_signal, end_conversion_signal : std_logic := '0';

signal clk   : std_logic := '0';
signal reset : std_logic := '1';

	-- component declaration
	component AXI_slave is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
		stream_out : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);

		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic
		);
	end component AXI_slave;

	component AXI_master is
		generic (
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_START_COUNT	: integer	:= 64
		);
		port (
		stream_in : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		transfer_enable : out std_logic;
		end_conversion  : out std_logic;
		
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component AXI_master;

component Merge_Sort is
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
end component;


begin

reset <= not s00_axis_aresetn;
clk <= s00_axis_aclk;

-- Instantiation of Axi Bus Interface S00_AXIS
myip_v1_0_S00_AXIS_inst : AXI_slave
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
	    stream_out => stream_out,
		
		S_AXIS_ACLK	=> s00_axis_aclk,
		S_AXIS_ARESETN	=> s00_axis_aresetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TSTRB	=> s00_axis_tstrb,
		S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid
	);
	
	-- Instantiation of Axi Bus Interface S00_AXIS
    Merge_inst : Merge_Sort
	generic map (
		TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
	    clk  => clk,
	    reset => reset,	
			
		merge_stream_in	=> stream_out,
	        
        S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid,
		transfer_enable	=> tranfer_enable_signal,
		
	    merge_stream_out => stream_merge_out
	);

-- Instantiation of Axi Bus Interface M00_AXIS
myip_v1_0_M00_AXIS_inst : AXI_master
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
	    stream_in => stream_merge_out,
		transfer_enable => tranfer_enable_signal,
		end_conversion => end_conversion_signal,
		
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready
	);

    end_conversion <= end_conversion_signal;

end arch_imp;
