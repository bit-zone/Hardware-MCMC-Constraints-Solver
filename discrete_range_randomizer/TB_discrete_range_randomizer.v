`timescale 1ns / 1ns


module TB_discrete_range_randomizer;

parameter WIDTH = 32;
 // Inputs
reg clock;
reg reset;
reg enable;
reg [WIDTH-1:0]seed;
reg signed[WIDTH-1:0]min;
reg signed[WIDTH-1:0]max;
 // Outputs
wire signed [WIDTH-1:0] rnd;
 

DiscreteRangeRandomizer 
#(
    .MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(2),
    .MAX_BIT_WIDTH_OF_VARIABLES_INDEX (2),
    .MAX_BIT_WIDTH_OF_DISCRETE_CHOICES (2)
 )
test_DiscreteRangeRandomizer
(
    .in_clock(clock),
    .in_enable(enable),
    .in_seed(seed),
    .in_reset(reset),
    .in_variable_index(),
  
    .out_start(),
    .out_end(),
    .out_equal()
);
endmodule
