# ddr_controller
the DDR controller module is made to interface with micron's DDR SDRAM MT46V32M8 – 8 Meg x 8 x 4 banks which is 256Mbit SDRAM @ 133MHz ,-75Z speed grading

operating mode is set to
CAS LATENCY = 2

BURST LENGTH = 8 (64 bits per burst)

BURST TYPE = sequential
                
                          
the module is not yet fully parameterized although it has seperate parameters file changing the parameters would cause it not to work so its made specifically to
work at 133 MHz and for the MT46V32M8 SDRAM module

the clk_nx , clk_2x are to be connected later on to a PLL but for the mean time for simulation purposes i just generate the clk_nx and clk_2x in the testbench file

the module is used to interface to a system with a 25 bit address bus [13 bit for the row to be accessed, 10 bits for the column and 2 bits for the bank] and a 16 bit data bus 
the way the system interfaces with the controller is that when the system wants to read or write some data it first needs pull the address_strobe signal low for 1 clock cycle 
and assert or de-assert the rd_wr_req signal depending on which operation you want to perform for reading the rd_wr_req should be pulled low while for writing it should be pulled high

the address should remain on the bus for 1 clock cycle after the address_strobe signal is pulled low
so essentially a read or a write request should look like something as follows
![image](https://user-images.githubusercontent.com/123260720/214121023-50b3ec9a-e7ae-4faa-a957-ef8abf931558.png)

here a write request is sent to the controller to the address 10f0f83h


