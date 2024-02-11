-- (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:AXI_FIFO:1.0
-- IP Revision: 2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_AXI_FIFO_0_0 IS
  PORT (
    s00_axis_aclk : IN STD_LOGIC;
    s00_axis_aresetn : IN STD_LOGIC;
    s00_axis_tready : OUT STD_LOGIC;
    s00_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axis_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s00_axis_tlast : IN STD_LOGIC;
    s00_axis_tvalid : IN STD_LOGIC;
    m00_axis_aclk : IN STD_LOGIC;
    m00_axis_aresetn : IN STD_LOGIC;
    m00_axis_tvalid : OUT STD_LOGIC;
    m00_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m00_axis_tstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m00_axis_tlast : OUT STD_LOGIC;
    m00_axis_tready : IN STD_LOGIC
  );
END design_1_AXI_FIFO_0_0;

ARCHITECTURE design_1_AXI_FIFO_0_0_arch OF design_1_AXI_FIFO_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_AXI_FIFO_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT AXI_FIFO IS
    GENERIC (
      C_S00_AXIS_TDATA_WIDTH : INTEGER;
      C_M00_AXIS_TDATA_WIDTH : INTEGER;
      C_M00_AXIS_START_COUNT : INTEGER
    );
    PORT (
      s00_axis_aclk : IN STD_LOGIC;
      s00_axis_aresetn : IN STD_LOGIC;
      s00_axis_tready : OUT STD_LOGIC;
      s00_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axis_tstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s00_axis_tlast : IN STD_LOGIC;
      s00_axis_tvalid : IN STD_LOGIC;
      m00_axis_aclk : IN STD_LOGIC;
      m00_axis_aresetn : IN STD_LOGIC;
      m00_axis_tvalid : OUT STD_LOGIC;
      m00_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m00_axis_tstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m00_axis_tlast : OUT STD_LOGIC;
      m00_axis_tready : IN STD_LOGIC
    );
  END COMPONENT AXI_FIFO;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_AXI_FIFO_0_0_arch: ARCHITECTURE IS "AXI_FIFO,Vivado 2023.1";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_AXI_FIFO_0_0_arch : ARCHITECTURE IS "design_1_AXI_FIFO_0_0,AXI_FIFO,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_AXI_FIFO_0_0_arch: ARCHITECTURE IS "design_1_AXI_FIFO_0_0,AXI_FIFO,{x_ipProduct=Vivado 2023.1,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=AXI_FIFO,x_ipVersion=1.0,x_ipCoreRevision=2,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_S00_AXIS_TDATA_WIDTH=32,C_M00_AXIS_TDATA_WIDTH=32,C_M00_AXIS_START_COUNT=64}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_AXI_FIFO_0_0_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF m00_axis_aclk: SIGNAL IS "XIL_INTERFACENAME m00_axis_aclk, ASSOCIATED_BUSIF m00_axis, ASSOCIATED_RESET m00_axis_aresetn, FREQ_HZ 193164, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 m00_axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF m00_axis_aresetn: SIGNAL IS "XIL_INTERFACENAME m00_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 m00_axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis TSTRB";
  ATTRIBUTE X_INTERFACE_PARAMETER OF m00_axis_tvalid: SIGNAL IS "XIL_INTERFACENAME m00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 193164, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF m00_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 m00_axis TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axis_aclk: SIGNAL IS "XIL_INTERFACENAME s00_axis_aclk, ASSOCIATED_BUSIF s00_axis, ASSOCIATED_RESET s00_axis_aresetn, FREQ_HZ 193164, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s00_axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axis_aresetn: SIGNAL IS "XIL_INTERFACENAME s00_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s00_axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis TLAST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axis_tready: SIGNAL IS "XIL_INTERFACENAME s00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 193164, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 s00_axis TVALID";
BEGIN
  U0 : AXI_FIFO
    GENERIC MAP (
      C_S00_AXIS_TDATA_WIDTH => 32,
      C_M00_AXIS_TDATA_WIDTH => 32,
      C_M00_AXIS_START_COUNT => 64
    )
    PORT MAP (
      s00_axis_aclk => s00_axis_aclk,
      s00_axis_aresetn => s00_axis_aresetn,
      s00_axis_tready => s00_axis_tready,
      s00_axis_tdata => s00_axis_tdata,
      s00_axis_tstrb => s00_axis_tstrb,
      s00_axis_tlast => s00_axis_tlast,
      s00_axis_tvalid => s00_axis_tvalid,
      m00_axis_aclk => m00_axis_aclk,
      m00_axis_aresetn => m00_axis_aresetn,
      m00_axis_tvalid => m00_axis_tvalid,
      m00_axis_tdata => m00_axis_tdata,
      m00_axis_tstrb => m00_axis_tstrb,
      m00_axis_tlast => m00_axis_tlast,
      m00_axis_tready => m00_axis_tready
    );
END design_1_AXI_FIFO_0_0_arch;
