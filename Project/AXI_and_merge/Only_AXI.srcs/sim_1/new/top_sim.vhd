library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_sim is

end top_sim;

architecture arch_imp of top_sim is

constant C_S00_AXIS_TDATA_WIDTH : integer := 32;
constant C_M00_AXIS_TDATA_WIDTH : integer := 32;
constant C_M00_START_COUNT : integer := 32;


	-- component declaration
	component AXI_FIFO is
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
		m00_axis_tready	: in std_logic
		);
	end component AXI_FIFO;

signal s00_axis_aclk, m00_axis_aclk : std_logic := '0';
signal s00_axis_aresetn, m00_axis_aresetn : std_logic := '0';
signal s00_axis_tdata : std_logic_vector(31 downto 0):=(Others=>'0');
signal m00_axis_tdata : std_logic_vector(31 downto 0);
signal s00_axis_tlast, m00_axis_tlast : std_logic := '0';
signal s00_axis_tready, m00_axis_tready : std_logic := '0';
signal s00_axis_tvalid, m00_axis_tvalid : std_logic :='0';
signal s00_axis_tstrb, m00_axis_tstrb : std_logic_vector(3 downto 0);



begin

-- Instantiation of Axi Bus Interface S00_AXIS
myip_v1_0_inst : AXI_FIFO
	port map (
		s00_axis_aclk	=> s00_axis_aclk,
		s00_axis_aresetn	=> s00_axis_aresetn,
		s00_axis_tready	=> s00_axis_tready,
		s00_axis_tdata	=> s00_axis_tdata,
		s00_axis_tstrb	=> s00_axis_tstrb,
		s00_axis_tlast	=> s00_axis_tlast,
		s00_axis_tvalid	=> s00_axis_tvalid,

		m00_axis_aclk	=> m00_axis_aclk,
		m00_axis_aresetn	=> m00_axis_aresetn,
		m00_axis_tvalid	=> m00_axis_tvalid,
		m00_axis_tdata	=> m00_axis_tdata,
		m00_axis_tstrb	=> m00_axis_tstrb,
		m00_axis_tlast	=> m00_axis_tlast,
		m00_axis_tready	=> m00_axis_tready
	);

    s00_axis_aclk <= not s00_axis_aclk after 10 ns;
    m00_axis_aclk <= not m00_axis_aclk after 10 ns;

    
    process
	begin

        
		s00_axis_aresetn 		<= '0';
		m00_axis_aresetn 		<= '0';

		s00_axis_tdata 	<= (Others=>'0');
		wait for 30 ns;
        --s00_axis_tvalid<='1';
		s00_axis_aresetn 		<= '1';
		m00_axis_aresetn 		<= '1';

		wait until rising_edge(s00_axis_aclk);
				s00_axis_tvalid<='1';

		s00_axis_tdata <= (Others=>'0');
		wait until rising_edge(s00_axis_aclk);

		--wait until rising_edge(s00_axis_aclk);
		--wait until rising_edge(s00_axis_aclk);
		--wait until rising_edge(s00_axis_aclk);







s00_axis_tdata<=std_logic_vector(to_unsigned(45,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(123,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(78,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(256,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(199,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(300,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(159,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(37,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);

s00_axis_tdata<=std_logic_vector(to_unsigned(3,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(27,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(9,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(100,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(19,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(303,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(270,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(692,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);

s00_axis_tdata<=std_logic_vector(to_unsigned(1,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(853,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(38,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(16,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(201,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(145,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(46,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(54,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);

s00_axis_tdata<=std_logic_vector(to_unsigned(400,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(114,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(678,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(30,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(324,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(311,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(90,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);
s00_axis_tdata<=std_logic_vector(to_unsigned(85,s00_axis_tdata'LENGTH));
wait until rising_edge(s00_axis_aclk);





----- 32 -----






--s00_axis_tdata<=std_logic_vector(to_unsigned(455,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(139,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(75,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(26,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(189,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(370,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(177,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(143,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);

--s00_axis_tdata<=std_logic_vector(to_unsigned(3,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(27,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(9,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(100,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(19,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(333,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(730,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(102,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);

--s00_axis_tdata<=std_logic_vector(to_unsigned(104,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(420,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(10,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(76,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(281,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(105,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(589,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(540,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);

--s00_axis_tdata<=std_logic_vector(to_unsigned(458,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(554,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(672,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(31,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(537,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(315,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(24,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);
--s00_axis_tdata<=std_logic_vector(to_unsigned(480,s00_axis_tdata'LENGTH));
--wait until rising_edge(s00_axis_aclk);


------- 64 --------




        m00_axis_tready<='1';



        s00_axis_tlast<='1';
        wait until rising_edge(s00_axis_aclk);
        s00_axis_tlast<='0';
        s00_axis_tvalid<='0';
        wait until rising_edge(s00_axis_aclk);
        m00_axis_tready<='1';


	-- Add user logic here

	-- User logic ends

		wait;
	end process;
end arch_imp;
