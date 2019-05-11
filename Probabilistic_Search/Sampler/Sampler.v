`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2019 09:10:33 PM
// Design Name: 
// Module Name: Sampler
// Project Name: MCMC
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

// This module takes the from, to , type and weight from the Select Segment module as Input
// should take the variable index too
// and outputs a new proposed value for this variable

module Sampler(
     //inputs
   input wire in_clock, // the main clock of the system.
   input wire in_reset,  // if 1 , the module reads the seed value , 
   // it should be 1 only at beginning and 0 after beginning .
   input wire in_enable, // it should be 1 if you want new numbers to be generated every posetive clock edge .
   // if 0 , the output remains like the previous one.
   input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
   input wire signed [7:0] in_from, // specifies the minimum value of the target range.
   input wire signed[7:0] in_to, // specifies the maximum value of the target range. 
   input wire [1:0] in_chosen_segment_type ,// (the choosing segment type) : 3 , 1 ,or 2 .
   input wire signed [7:0] in_chosen_segment_weight,
   // should add the index of variable later
    
    //ouputs
    output wire signed [7:0] out_proposed_value  // the new value
    );   
    
    
    parameter EXPUP = 2'd2 ;
    parameter EXPDOWN = 2'd1 ;
    parameter UNIFORM = 2'd3 ;
    
    reg signed[7:0]min;
    reg signed[7:0]max;
    
    
    always @ (posedge in_clock)
    begin
    case (in_chosen_segment_type)
    
    UNIFORM:
        begin
        min <= in_from;
        max <= in_to;
        end
    
    // In case of Exp up or Down we will approxmiate the equation 
    // to only c + or - w because log calculation is not synth in verilog
    // and finding another solution to sample from exp dist is quit complex   
    // PS: it's tested in the software code and it works!
     
    EXPUP:
        begin
        // we first calculate the value (in_to - w) if it's small than the min range make it the minimum range
        // Else make it the new value (in_to - w)
        // and we want the propsed value to be the new value so we send the same min and max to the random generator 
        min <= (in_to - in_chosen_segment_weight <= in_from) ?   in_from : in_to - in_chosen_segment_weight;
        max <= (in_to - in_chosen_segment_weight <= in_from) ?   in_from :   in_to - in_chosen_segment_weight;       
        end
    
    EXPDOWN:
        begin
        
        // we first calculate the value (in_from + w) if it's larger than the max range make it the maximum range
        // Else make it the new value (in_from + w)
        // and we want the propsed value to be the new value so we send the same min and max to the random generator 
                
        
        min <= (in_from + in_chosen_segment_weight >= in_to) ?   in_to :   in_from + in_chosen_segment_weight;
        max <= (in_from + in_chosen_segment_weight >= in_to) ?   in_to :   in_from + in_chosen_segment_weight;       

        end
    
    
    
    endcase
    
    end
    

RandomGenerator  uut (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_min(min),
  .in_max(max),
  .in_seed(in_seed), 
  .out_random(out_proposed_value)
 );
 
endmodule
