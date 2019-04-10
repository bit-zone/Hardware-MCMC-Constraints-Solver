`timescale 1ns/1ns


/*
test bench for testing calculate probability module
*/
module test ;
 
 // Inputs
 reg clock;
 reg reset;
 reg enable;
 reg [7:0]seed;
 reg [7:0]u,v;

 // Outputs
 wire  [7:0] p;
 
 // Instantiate the Unit Under Test (UUT)
 calculateProbability  uut (
  .in_clock(clock), 
  .in_reset(reset),
  .in_enable(enable),
  .in_seed(seed), 
  .in_u(u),
  .in_v(v),
  .out_p(p)
 );
  
 initial begin
  clock = 0;
  forever
   #50 clock = ~clock;
  end
   
 initial begin
  // Initialize Inputs
  ////////////////
  u=5;
  v=6;
  ////////////////
  //u=6;
  //v=4;
  ////////////////
  //u=5;
  //v=5;
  ///////////////
  //u=1;
  //v=10;

  ///////////////
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
 
  
 end

integer count_p_0=0;
integer count_p_1=0;
 always @(posedge clock)
 begin

    $monitor("count of p=0 is %d",count_p_0);
    $monitor("count of p=1 is %d",count_p_1);
if(p==0)
   begin
     count_p_0=count_p_0+1;
   end
   if(p==1)
   begin
     count_p_1=count_p_1+1;
   end
 end
endmodule
