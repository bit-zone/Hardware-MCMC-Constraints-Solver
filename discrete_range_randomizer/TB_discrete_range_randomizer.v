`timescale 1ns / 1ns


module TB_discrete_range_randomizer;


 // Inputs
reg clock;
reg reset;
reg enable;
reg [1:0]seed;
reg [1:0] variable_index;
 // Outputs
wire [1:0] out_start;
wire [1:0] out_end;
wire out_equal;
integer i;

 initial begin
 clock = 0;
 forever
  #50 clock = ~clock;
 end
initial
begin
$monitor ("Clk = %d", clock);
    seed = 2;
    reset = 0;
    enable = 0;
    variable_index=0;
    // Wait 100 ns for global reset to 
    #10
    reset = 1;
    enable = 1;
    #50
    reset = 0;
    for(i=1;i<4;i=i+1)begin
    #100
    variable_index=i;
    end
   
end

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
    .in_variable_index(variable_index),
  
    .out_start(out_start),
    .out_end(out_end),
    .out_equal(out_equal)
);
endmodule
