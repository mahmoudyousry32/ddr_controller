
# DDR SDRAM
DDR SDRAM is a stack of acronyms. Double Data Rate (DDR) Synchronous Dynamic Random Access Memory (SDRAM) is a common type of memory used as RAM for most every modern processor , SDRAM is synchronous, and therefore relies on a clock to synchronize signals unlike its predecssor the DRAM which operated asynchronously from the processor DDR SDRAM means that this type of SDRAM fetches data on both the rising edge and the falling edge of the clock signal that  thus the name “Double Data Rate."


![image](https://user-images.githubusercontent.com/123260720/214134208-320f0c0d-467c-4afa-b370-136df7ff616c.png)
<p align="center"> <sub>Fig Data transfer at both edges</sub>
</p>


# Micron's DDR SDRAM 256Mbit
## Features
*  Bidirectional data strobe (DQS) transmitted/received with data, that is, source-synchronous data capture (x16 has two – one per byte)
*  Internal, pipelined double data rate (DDR) architecture; two data accesses per clock cycle
*  Differential clock inputs (CK and CK#)
*  Commands entered on each positive CK edge
*  DQS edge-aligned with data for READs; center- aligned with data for WRITEs
*  DLL to align DQ and DQS transitions with CK
*  Four internal banks for concurrent operation
*  Data mask (DM) for masking write data (x16 has two – one per byte)
*  Programmable burst lengths (BL): 2, 4, or 8
*  Auto refresh

The DDR SDRAM uses a double data rate architecture to achieve high-speed operation. 
The double data rate architecture is essentially a 2n-prefetch architecture with an inter- 
face designed to transfer two data words per clock cycle at the I/O pins. 

A single read or write access for the DDR SDRAM effectively consists of a single 2n-bit-wide, one-clock- 
cycle data transfer at the internal DRAM core and two corresponding n-bit-wide, one- 
half-clock-cycle data transfers at the I/O pins.

A bidirectional data strobe (DQS) is transmitted externally, along with data, for use in 
data capture at the receiver. DQS is a strobe transmitted by the DDR SDRAM during 
READs and by the memory controller during WRITEs. DQS is edge-aligned with data for 
READs and center-aligned with data for WRITEs. The x16 offering has two data strobes, 
one for the lower byte and one for the upper byte.


The DDR SDRAM operates from a differential clock (CK and CK#); the crossing of CK 
going HIGH and CK# going LOW will be referred to as the positive edge of CK. 
Commands (address and control signals) are registered at every positive edge of CK. 
Input data is registered on both edges of DQS, and output data is referenced to both 
edges of DQS, as well as to both edges of CK.


Read and write accesses to the DDR SDRAM are burst oriented; accesses start at a 
selected location and continue for a programmed number of locations in a programmed 
sequence. Accesses begin with the registration of an ACTIVE command, which may then 
be followed by a READ or WRITE command. The address bits registered coincident with 
the ACTIVE command are used to select the bank and row to be accessed. The address 
bits registered coincident with the READ or WRITE command are used to select the bank 
and the starting column location for the burst access.


The DDR SDRAM provides for programmable READ or WRITE burst lengths of 2, 4, or 8 
locations. An auto precharge function may be enabled to provide a self-timed row 
precharge that is initiated at the end of the burst access.
As with standard SDR SDRAMs, the pipelined, multibank architecture of DDR SDRAMs 
allows for concurrent operation, thereby providing high effective bandwidth by hiding 
row precharge and activation time.

commands are sent using the CSE,RASN,CASN,WEN pins, a full list of commands are provided in the next figure
![image](https://user-images.githubusercontent.com/123260720/214142485-51f03e56-0cd9-4260-860c-74b17a21843c.png) 

for more info on Micron's DDR SDRAM check out the datasheet [here](https://media-www.micron.com/-/media/client/global/documents/products/data-sheet/dram/ddr1/256mb_ddr.pdf?rev=7d969af24d6d4b74a34e427f350b1c77).

## DDR SDRAM Operation and initilization sequence 
Reading  and  writing  to  and  from  the  RAM  module  is  burst  oriented.  A 
location for reading or writing is selected via commands sent to the DDR RAM 
controller on the module.   Once the appropriate commands have been received 
and the appropriate signals asserted, data is transferred via a bi-directional bus data bus.For proper 
operation the device must initialized and specific electrical requirements must 
be met: 
* VDD and VDDQ are driven by a single output at 2.5V ± .2 V 
* VTT is limited to 1.35 V 
* VREF tracks VDDQ/2
### Initialization
Prior to normal operation, DDR SDRAMs must be powered up and initialized in a 
predefined manner. Operational procedures, other than those specified, may result in 
undefined operation.
To ensure device operation, the DRAM must be initialized as described in the following 
steps:
1.  Simultaneously apply power to VDD and VDDQ.
2. Apply VREF and then VTT power. VTT must be applied after VDDQ to avoid device latch- 
up, which may cause permanent damage to the device. Except for CKE, inputs are not 
recognized as valid until after VREF is applied.
3.  Assert and hold CKE at a LVCMOS logic LOW. Maintaining an LVCMOS LOW level on 
CKE during power-up is required to ensure that the DQ and DQS outputs will be in 
the High-Z state, where they will remain until driven in normal operation (by a read 
access).
4.  Provide stable clock signals.
5.  Wait at least 200μs.
6.  Bring CKE HIGH, and provide at least one NOP or DESELECT command. At this 
point, the CKE input changes from a LVCMOS input to a SSTL_2 input only and will 
remain a SSTL_2 input unless a power cycle occurs.
7.  Perform a PRECHARGE ALL command.
8.  Wait at least tRP time; during this time NOPs or DESELECT commands must be given.
9. Using the LMR command, program the extended mode register (E0 = 0 to enable the 
DLL and E1 = 0 for normal drive; or E1 = 1 for reduced drive and E2–En must be set to 
0 [where n = most significant bit]).
10.  Wait at least tMRD time; only NOPs or DESELECT commands are allowed.
11.  Using the LMR command, program the mode register to set operating parameters 
and to reset the DLL. At least 200 clock cycles are required between a DLL reset and 
any READ command.
12.  Wait at least tMRD time; only NOPs or DESELECT commands are allowed.
13.  Issue a PRECHARGE ALL command.
14.  Wait at least tRP time; only NOPs or DESELECT commands are allowed.
15.  Issue an AUTO REFRESH command. This may be moved prior to step 13.
16.  Wait at least tRFC time; only NOPs or DESELECT commands are allowed.
17.  Issue an AUTO REFRESH command. This may be moved prior to step 13.
18.  Wait at least tRFC time; only NOPs or DESELECT commands are allowed.
19.  Although not required by the Micron device, JEDEC requires an LMR command to 
clear the DLL bit (set M8 = 0). If an LMR command is issued, the same operating 
parameters should be utilized as in step 11.
20.  Wait at least tMRD time; only NOPs or DESELECT commands are supported.
21.  At this point the DRAM is ready for any valid command. At least 200 clock cycles with 
CKE HIGH are required between step 11 (DLL RESET ) and any READ command.

# The DDR Controller
the DDR controller module is made to interface with micron's DDR SDRAM MT46V32M8 – 8 Meg x 8 x 4 banks which is 256Mbit SDRAM @ 133MHz ,-75Z speed grading

operating mode is set to
CAS LATENCY = 2

BURST LENGTH = 8 (64 bits per burst)

BURST TYPE = sequential
                
                          
the module is not yet fully parameterized although it has seperate parameters file changing the parameters would cause it not to work so its made specifically to
work at 133 MHz and for the MT46V32M8 SDRAM module 
for more info on micron's SDRAM you can check out the datasheet over [here](https://media-www.micron.com/-/media/client/global/documents/products/data-sheet/dram/ddr1/256mb_ddr.pdf?rev=7d969af24d6d4b74a34e427f350b1c77)


The DDR controller consists of 6 modules
1. **DDR_ctrl** : which is basically just a big state machine that drives the command generation module and the read and write datapaths
2. **DDR_cmd_gen** : this module generates command signals (CSE,RASN,CASN,WEN) to the DDR module based on the control signals generated by the DDR_ctrl module
3. **DDR_read_datapath** : this module is the datapath for sampling the data sent from the DDR memory to the controller when a read command is issued to the DDR module
4. **DDR_write_datapath** : this module is the datapath for when a write command is issued its responsible for sampling the data from the main system and sending this data to the DDR memory at both edges of the clock its also responsible for generating the data strobe signal (DQS) 
5. **DDR_bus_ctrl** : it essentially generates the enable signals for the I/O ports (DQ,DQS,sys_data)
6. **PLL_ddr** : PLL core generated by the altera megafunction wizard in quartus its responsible for generating the necessary clock signals for the modules 


This is a full block diagram of the system 
![DDR_CONTROLLER_TOP](https://user-images.githubusercontent.com/123260720/214126050-9e1c775e-7a10-48d1-822a-012cb23a1fec.jpg)

in the files provided the clk_nx and the clk_x and the clk_2x signals are all generated from the testbench for simulation purposes the PLL is only added later when the design is synthesized 

the module is used to interface to a system with a 25 bit address bus [13 bit for the row to be accessed, 10 bits for the column and 2 bits for the bank] and a 16 bit data bus 
the way the system interfaces with the controller is that when the system wants to read or write some data it first needs pull the address_strobe signal low for 1 clock cycle 
and assert or de-assert the rd_wr_req signal depending on which operation you want to perform for reading the rd_wr_req should be pulled low while for writing it should be pulled high

the address should remain on the bus for 1 clock cycle after the address_strobe signal is pulled low
so essentially a read or a write request should look like something as follows
![image](https://user-images.githubusercontent.com/123260720/214121023-50b3ec9a-e7ae-4faa-a957-ef8abf931558.png)

here a write request is sent to the controller to the address 0x10f0f83

## DDR_ctrl module
The DDR_ctrl module consists of 2 FSMs 
1. the initilization state machine which is responsible for initializing the DDR SDRAM module in a predefined sequence , the state machine generates the necessary commands for initilization and going through the predefined initilization sequence mentioned before
2. The command state machine which is responsible for issuing read/write commands based on the system request and its also responsible for automatically refreshing the DDR SDRAM module by issuing an AUTOREFRESH command every 996 clock cycles as The 256Mb DDR SDRAM requires Auto Refresh cycles at an average periodic interval of 7.8us , 996 clock cycles at 133MHz equals 7.47 us

![DDR_STATE_MACHINE_init_state](https://user-images.githubusercontent.com/123260720/214649980-a8e7c1c5-c8c3-4f6c-a66c-8cd2b49b01ac.jpg)
<p align="center"> <sub>Initilization state machine</sub>
</p>

![DDR_STATE_MACHINE_cmd_state](https://user-images.githubusercontent.com/123260720/214651678-77529d40-6136-4967-add7-49120e8e6ee2.jpg)
<p align="center"> <sub>commands state machine</sub>
</p>

the DDR_ctrl module contains also an automatic refresh counter that issues a refresh request to the command state machine every 996 clock cycles
the cmd state machine prioritizes the refresh request over a read/write request meaning that if a read or write request is issued by the system and a refresh request is issued at the same clock cycle the cmd state machine will issue the refresh command first and then it will service the read/write request 
which is stored to be serviced later after the refresh 

## DDR_command_gen module

This module is responsbile for generating the command signals [CSN,RASN,CASN,WEN] and address signals for the DDR SDRAM module depending on the current state of the init_state and cmd_state in the DDR_ctrl module

## DDR_read_datapath module

This module is responsible for latching data from the DDR SDRAM module when a read command is issued , it basically samples the data received at the dq data bus and then it concatenates every 2 bytes of data then sends them to the sys_data bus to be received by the system at the positive edge of the clock

## DDR_write_datapath module








