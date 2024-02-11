Description
This project contains three files essential for implementing a merge algorithm with AXI interface on a Zynq SoC, 
utilizing Direct Memory Access (DMA) for efficient data transfer. The files are structured as follows:

Files
"AXI_Merge_algorithm" - Merge Algorithm with AXI Interface: This file contains the implementation of the merge algorithm with AXI interface. The main file is called "Only_AXI".

"Bitstream_Files" - Bitstream Files: This folder contains the .bit, .tcl and .hwh files necessary for configuring the FPGA fabric with the implemented design.

"Block_Design" - Block Design: This file contains the block design schematic that integrates the merge algorithm with the Zynq SoC and DMA. 
			   It illustrates the connections and configurations required for seamless operation.

"ip_repo -> src" - source files: This contains all core files to build up the project. Going thorugh it, you will find an other README file.

"Jupiter_Examples" -> It contains some example with python code, one of them is the output with the error. 