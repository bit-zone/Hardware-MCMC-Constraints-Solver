`timescale 1ns/1ns


/*
test bench for testing random generator module
*/
module test ;
 
 // Inputs
 reg clock;
 reg reset;
 reg enable;
 reg [7:0]seed;
 reg signed[7:0]min;
 reg signed[7:0]max;
 // Outputs
 wire signed [7:0] rnd;
 
 // Instantiate the Unit Under Test (UUT)
 RandomGenerator  uut (
  .in_clock(clock), 
  .in_reset(reset),
  .in_enable(enable),
  .in_min(min),
  .in_max(max),
  .in_seed(seed), 
  .out_random(rnd)
 );
  
 initial begin
  clock = 0;
  forever
   #50 clock = ~clock;
  end
   
 initial begin
  // Initialize Inputs
  // min and max (range)
  // negative , negative
  min = -8'd 20;
  max = -8'd 10;
  // negative , positive
  //min = -8'd 20;
  //max = 8'd 2;
  // posotive , positive
  //min = 8'd 20;
  //max = 8'd 26;
  // negative , zero
  //min = -8'd 20;
  //max = 8'd 0;
  // zero , positive
  //min = 8'd 0;
  //max = 8'd 5;
  reset = 0;
  enable = 0;
  // Wait 100 ns for global reset to finish
  #100;
      seed = 8'd 1;
      reset = 1;
      enable=1;
  #200;
  reset = 0;
  #100
  enable=0;
  #200
  enable=1;
  #500
  enable=0;
  #300
  enable=1;
  // Add stimulus here
  
 end
  
 initial begin
 $display("clock rnd");
 $monitor("%b,%d", clock, rnd);
 end     
endmodule
