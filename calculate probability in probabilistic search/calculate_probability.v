// Description of the calculate probability module:
/*
    * calculate probability block is used in the probabilistic search block.
    * its goal is to calculate the probability which control the choice of  
       the proposed assignment from sample block.
    * p the probability is calculated by this equation :
                                                      u-v
                                                 100*2      , u-v < 0
                                           p=     
                                                 100      , otherwise
    * the output of this block is used by a multiplexer, so it must be 0 or 1 always.
    * for this reason, this module uses the random generator block to generate random 
      numbers between 0 and 100, then compare with p to output 0 or 1.
    * example:
      assume p = 25 , random generator output = 2 , is (2 < 25)? , yes,then the output = 1 .
      assume p = 25 , random generator output = 50 , is (50 < 25)? ,No,then the output = 0 .
      it's more likely for the random generator to produce a number that is > 25 so, it's more
       likely for p = 25 , the output = 0 .
*/

// Discussion for the used algorithm:
/*
  * Direct thinking leads to simply using the above equation ,but actually there is no need for that at all.
                             u-v      u-v
  * the origin of the term 2      is e    , and this is exponential term 
    ,so when the magnitude of u-v (the negative term) becomes smaller , the value of p decreases exponentially.
  * example:
    if u-v = -6 , then p = 1.5 % , so this can be approximated to 0 , this is very small probability.
  * so, no need for computations, or using floating point numbers.
 
*/

module calculateProbability(
    //inputs
    input wire in_clock, 
    // the main clock of the system.
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable,
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
    input wire [7:0] in_u,
    input wire [7:0] in_v,
  //ouputs
    output wire signed [7:0] out_p 
    // the random number 
    );

wire signed [7:0] random_number;
wire signed [7:0] u_minus_v;

assign u_minus_v = in_u-in_v;
assign out_p = ( u_minus_v >= 0 ) ? 8'd1 :
 ( u_minus_v == -8'd1 && random_number < 8'd50 ) ? 8'd1 :
 ( u_minus_v == -8'd2 && random_number < 8'd25 ) ? 8'd1 :
 ( u_minus_v == -8'd3 && random_number < 8'd13 ) ? 8'd1 :
 ( u_minus_v == -8'd4 && random_number < 8'd6 ) ? 8'd1 :
 ( u_minus_v == -8'd5 && random_number < 8'd3 ) ? 8'd1 :
 ( u_minus_v == -8'd6 && random_number < 8'd2 ) ? 8'd1 :
 ( u_minus_v <= -8'd7 ) ? 8'd0 : 8'd0; 

    RandomGenerator  randomize (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_min(8'd0),
  .in_max(8'd100),
  .in_seed(in_seed), 
  .out_random(random_number)
 );
endmodule
