

/*
test bench for testing choose segment
*/
module test ;

 // Inputs
 reg clock;
 reg reset;
 reg enable;
 reg signed [7:0] c_less_than;
 reg signed [7:0] c_more_than;
 reg [1:0] flag;
 reg [7:0]seed;
 
 // Outputs
 wire  [1:0] chosen_segment_type ;
 wire signed [7:0] chosen_segment_from;
 wire signed [7:0] chosen_segment_to;
 wire signed [7:0] chosen_segment_weight;
 
 // Instantiate the Unit Under Test (UUT)
 selectSegment  uut (
  .in_clock(clock), 
  .in_reset(reset),
  .in_enable(enable),
  .in_seed(seed), 
  .in_c_less_than(c_less_than),
  .in_c_more_than(c_more_than),
  .in_flag(flag),
  .out_chosen_segment_type(chosen_segment_type),
  .out_chosen_segment_from(chosen_segment_from),
  .out_chosen_segment_to(chosen_segment_to),
  .out_chosen_segment_weight(chosen_segment_weight)
 );
  
 initial begin
  clock = 0;
  forever
   #50 clock = ~clock;
  end
   
 initial begin
  // Initialize Inputs
  ////////////////
  //normal case  +ve +ve
  c_less_than=8'd10;
  c_more_than=8'd2;
  flag=3 ; 
  //normal case  -ve -ve
  //c_less_than = -8'd2;
  //c_more_than = -8'd10;
  //flag=3 ; 
  //normal case  +ve -ve
  //c_less_than = 8'd10;
  //c_more_than = -8'd2;
  //flag=3 ; 
  //normal case  +ve zero
  //c_less_than = 8'd10;
  //c_more_than = 8'd0;
  //flag=3 ; 
  //normal case  zero -ve
  //c_less_than = 8'd0;
  //c_more_than = -8'd8;
  //flag=3 ; 
  /*****************************************************/
  //case 2 (expup-expdown) +ve +ve
  //c_less_than = 8'd1;
  //c_more_than = 8'd8;
  //flag=3 ; 
  /******************************************************/
  //case greater than only 
  //c_less_than = 8'd1; //don't care
  //c_more_than = 8'd8;
  //flag=2 ;
  //case less than only
  //c_less_than = 8'd1; 
  //c_more_than = 8'dx;  //don't care
  //flag=1 ;
  
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
  
 initial begin
 $display("chosen segment: ");
 
 end     



 always @(*)
 begin
    $display("chosen_segment_type is %d",chosen_segment_type);
    $display("chosen_segment_from is %d",chosen_segment_from);
    $display("chosen_segment_to is %d",chosen_segment_to);
    $display("chosen_segment_weight is %d",chosen_segment_weight);

   
 end
endmodule

