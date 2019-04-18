/*
the RandomChoose module chooses an item from a list contain 4 items , based on their weights 
this is similar to for example numpy.random.choice() method in numpy python package .
the used algorithm (weights approach):
 - calculate the sum of all the weights.
 - pick a random number that is 0 or greater and is less than the sum of the weights.
  - go through the items one at a time, subtracting their weight from your random number, 
  until you get the item where the random number is less than that item's weight.


*/

module RandomChoose(in_clock,in_reset,in_enable,in_weight0,in_weight1,in_weight2,in_weight3,in_seed,out_segment_number);

// thw weight width may be more than the maximum of the variable by one , so its width will defined by one more bit
    parameter WIDTH = 7; // default value is 7
//inputs
    input wire in_clock; 
    // the main clock of the system.
    input wire in_reset; 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable;
    // enable signal for random generator
    // the 4 weights of the segments , if you want only 2 segments , you can put the other as zeros.
    input wire  [WIDTH:0] in_weight0;
    input wire  [WIDTH:0] in_weight1;
    input wire  [WIDTH:0] in_weight2;
    input wire  [WIDTH:0] in_weight3;
    input wire  [WIDTH:0] in_seed; // initial value  , CANNOT be zero or negative
  //ouputs
    output wire  [1:0] out_segment_number; // (the choosing segment number) : 0 , 1 , 2 ,or 3 . 
    
    


wire [WIDTH:0] sum_weights,sum_weights_minus_one;
wire signed [WIDTH:0] random , random_minus_weight0 , random_minus_weight1 , random_minus_weight2;

assign sum_weights = in_weight0 + in_weight1 + in_weight2 + in_weight3;
assign sum_weights_minus_one = sum_weights-1;

assign random_minus_weight0 = random - in_weight0;
assign random_minus_weight1 = random_minus_weight0 - in_weight1;
assign random_minus_weight2 = random_minus_weight1 - in_weight2;

assign out_segment_number = 
(random < in_weight0)? 2'd0 :
(
    (random_minus_weight0 < in_weight1)? 2'd1:
    (
        (random_minus_weight1 < in_weight2)? 2'd2:
        (random_minus_weight2 < in_weight3)? 2'd3:2'd3 //shouldn't reach this last else.
    )
); 
// width+1 , because we want to randomize for weights that is may have need size 
  RandomGenerator #(.WIDTH(WIDTH+1)) randomize ( 
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_min(0),
  .in_max(sum_weights_minus_one),
  .in_seed(in_seed), 
  .out_random(random)
 );
endmodule
