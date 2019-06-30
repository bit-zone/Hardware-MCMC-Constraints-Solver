`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2019 01:29:51 PM
// Design Name: 
// Module Name: findNumberOfOnes
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//a simple module used to count the number of ones in a binary array

module findNumberOfOnes
#
  (
   parameter NUMBER_OF_CLAUSES =4,
   parameter MAXIMUM_BIT_WIDTH_OF_CLAUSE_INDEX=2
  )   
  ( 
    input in_enable, 
    input in_reset,//at posedge of the reset the module output is down to zero
    input in_clk,//general clk
    input [NUMBER_OF_CLAUSES-1:0] A,//the input array
    output reg [MAXIMUM_BIT_WIDTH_OF_CLAUSE_INDEX:0] ones//the output (number of ones at that binary array)
   );

integer i;//a reg for the for loop


//the sequential part of the circuit
//the output of the module is synced with the clock
always@(posedge in_clk )
begin
//at posedge clk assign the accumulator to the output
if(!in_reset && in_enable)
  begin
  ones = 0;
  for(i=0;i<NUMBER_OF_CLAUSES;i=i+1)   //for all the bits.
          ones = ones + A[i]; //Add the bit to the count.
  end
//at posedge reset assign zero to the output 
//if module is not enabled assign zero also  
else
  ones=0;  
end  
endmodule
   
    

