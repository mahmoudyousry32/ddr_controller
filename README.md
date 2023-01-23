
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

# The DDR Controller
the DDR controller module is made to interface with micron's DDR SDRAM MT46V32M8 – 8 Meg x 8 x 4 banks which is 256Mbit SDRAM @ 133MHz ,-75Z speed grading

operating mode is set to
CAS LATENCY = 2

BURST LENGTH = 8 (64 bits per burst)

BURST TYPE = sequential
                
                          
the module is not yet fully parameterized although it has seperate parameters file changing the parameters would cause it not to work so its made specifically to
work at 133 MHz and for the MT46V32M8 SDRAM module 
for more info on micron's SDRAM you can check out the datasheet over here

https://media-www.micron.com/-/media/client/global/documents/products/data-sheet/dram/ddr1/256mb_ddr.pdf?rev=7d969af24d6d4b74a34e427f350b1c77

This is a full block diagram of the system 
![DDR_CONTROLLER_TOP](https://user-images.githubusercontent.com/123260720/214126050-9e1c775e-7a10-48d1-822a-012cb23a1fec.jpg)

in the files provided the clk_nx and the clk_x and the clk_2x signals are all generated from the testbench for simulation purposes the PLL is only added later when the design is synthesized 

the module is used to interface to a system with a 25 bit address bus [13 bit for the row to be accessed, 10 bits for the column and 2 bits for the bank] and a 16 bit data bus 
the way the system interfaces with the controller is that when the system wants to read or write some data it first needs pull the address_strobe signal low for 1 clock cycle 
and assert or de-assert the rd_wr_req signal depending on which operation you want to perform for reading the rd_wr_req should be pulled low while for writing it should be pulled high

the address should remain on the bus for 1 clock cycle after the address_strobe signal is pulled low
so essentially a read or a write request should look like something as follows
![image](https://user-images.githubusercontent.com/123260720/214121023-50b3ec9a-e7ae-4faa-a957-ef8abf931558.png)

here a write request is sent to the controller to the address 10f0f83h


