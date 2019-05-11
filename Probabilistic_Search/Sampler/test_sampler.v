`timescale 1ns/1ns




/*
test bench for testing sampler module
    parameter EXPUP = 2'd2 ;
    parameter EXPDOWN = 2'd1 ;
    parameter UNIFORM = 2'd3 ;
*/

module TestSampler ;
 
 // Inputs
 reg clock;
 reg reset;
 reg enable;
 reg [7:0]seed;
 reg signed[7:0]from;
 reg signed[7:0]to;
 reg [1:0] chosen_segment_type ;// (the choosing segment type) : 3 , 1 ,or 2 .
 reg signed [7:0] chosen_segment_weight;
 
 // Outputs
 wire signed [7:0] proposed_value;
 
 // Instantiate the Unit Under Test (UUT)
Sampler uut (
      //inputs
    .in_clock(clock), // the main clock of the system.
    .in_reset(reset),  // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    .in_enable(enable), // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    .in_seed(seed), // initial value  , CANNOT be zero or negative
    .in_from(from), // specifies the minimum value of the target range.
    .in_to(to), // specifies the maximum value of the target range. 
    .in_chosen_segment_type(chosen_segment_type) ,// (the choosing segment type) : 3 , 1 ,or 2 .
    .in_chosen_segment_weight(chosen_segment_weight),
    // should add the index of variable later
    
     //ouputs
     .out_proposed_value(proposed_value) // the new value
     );   
     
  
 initial begin  
  clock = 0;
  forever
   #50 clock = ~clock;

end
   
 initial begin
  // First try uniform segments
 chosen_segment_type = 1;
 chosen_segment_weight = 7;
  from = 8'd 0;
  to = 8'd 50;
  reset = 0;
  enable = 0;
  // Wait 100 ns for global reset to finish
  #100;
      seed = 8'd 4;
      reset = 1;
      enable=0;
  
  #100
  reset = 0;
  enable = 1;
  
  #100
  
    enable=0;
    #100
    enable=1;
    #100
    enable=0;
    #100
    enable=1;
  
 end
  
 initial begin
 $display("output of testing sampler");
 $monitor(" the new proposed value is %d",  proposed_value);
 end     

 always @(proposed_value) 
    begin
        if(proposed_value>to || proposed_value<from)
            begin
                $display("ERROR");
            end
    end
endmodule
