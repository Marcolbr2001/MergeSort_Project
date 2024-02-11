library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_FIFO is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		 --Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 64
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


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
		m00_axis_tready	: in std_logic
	);
end AXI_FIFO;

architecture arch_imp of AXI_FIFO is

signal stream_out, stream_in, stream_merge_out, stream_in_master, stream_out_master : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (Others => '0');
signal wr_en, wr_en_out, rd_en, rd_en_out, clk, clk_2, not_empty : std_logic := '0';
signal empty : std_logic := '1';
signal reset : std_logic := '1';

	-- component declaration
	component AXI_slave is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
		stream_out : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		wr_en : out std_logic;

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
		C_M_START_COUNT	: integer	:= 96
		);
		port (
		stream_in : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		rd_en : out std_logic;
		
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component AXI_master;

    component FIFO is
	Generic(
		FIFO_WIDTH : integer := 32;
		FIFO_DEPTH : integer := 8
	);
	Port(
		reset 	: in std_logic;
		clk 	: in std_logic;

		din 	: in std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
		dout 	: out std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);

		rd_en 	: in std_logic;
		wr_en 	: in std_logic;

		full 	: out std_logic;
		empty 	: out std_logic
	);
end component;


component Merge_Sort is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		-- Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		C_M_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here
		-- User ports ends
		-- Do not modify the ports beyond this line

		---------- SLAVE ports ---------- 

		-- AXI4Stream sink: Clock
		clk	: in std_logic;
		-- AXI4Stream sink: Reset
		reset	: in std_logic;
		-- Ready to accept data in
		--S_AXIS_TREADY	: out std_logic;
		-- Data in
		merge_stream_in	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- Byte qualifier
		--S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	: in std_logic;
		-- Data is in valid
		S_AXIS_TVALID	: in std_logic;
        rd_en : out std_logic;
        wr_en : out std_logic;

		---------- MASTER ports ---------- 

		-- Global ports
		--M_AXIS_ACLK	: in std_logic;
		-- 
		--M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		--M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		merge_stream_out	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		--M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		--M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
		
	);
end component;


begin

reset <= not s00_axis_aresetn;
clk <= s00_axis_aclk;
clk_2 <= not s00_axis_aclk;
not_empty <= not empty;
-- Instantiation of Axi Bus Interface S00_AXIS
myip_v1_0_S00_AXIS_inst : AXI_slave
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
	    stream_out => stream_out,
		wr_en => wr_en,
		
		S_AXIS_ACLK	=> s00_axis_aclk,
		S_AXIS_ARESETN	=> s00_axis_aresetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TSTRB	=> s00_axis_tstrb,
		S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid
	);



---- Instantiation of Axi Bus Interface S00_AXIS
--FIFO_inst : FIFO
--	--generic map (
--	--	C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
--	--)
--	port map (
--	   reset => reset,	
--		clk  => clk,
--		din  =>stream_out,
--		dout => stream_in,
--		rd_en => rd_en,
--		wr_en => wr_en,
--		--full 	: out std_logic;
--		empty  => empty
--	);
	
	-- Instantiation of Axi Bus Interface S00_AXIS
Merge_inst : Merge_Sort
	--generic map (
	--	C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	--)
	port map (
	    reset => reset,	
		clk  => clk,
		
		
		merge_stream_in	=> stream_out,--stream_in,
		-- Byte qualifier
		--S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	=> s00_axis_tlast,
		-- Data is in valid
		S_AXIS_TVALID	=> s00_axis_tvalid,--not_empty,--
        rd_en => rd_en,
        wr_en => wr_en_out,
		---------- MASTER ports ---------- 

		-- Global ports
		--M_AXIS_ACLK	: in std_logic;
		-- 
		--M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		--M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		merge_stream_out => stream_merge_out,
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		--M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		--M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	=> rd_en_out--m00_axis_tready
	);


-- Instantiation of Axi Bus Interface S00_AXIS
--FIFO_inst_2 : FIFO
--	--generic map (
--	--	C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
--	--)
--	port map (
--	   reset => reset,	
--		clk  => clk_2,
--		din  =>stream_merge_out,
--		dout => stream_in_master,
--		rd_en => rd_en_out,
--		wr_en => wr_en_out
--		--full 	: out std_logic;
--		--empty 	: out std_logic
--	);
	


-- Instantiation of Axi Bus Interface M00_AXIS
myip_v1_0_M00_AXIS_inst : AXI_master
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
	    stream_in => stream_merge_out,--stream_in_master,
		rd_en => rd_en_out,
		
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
