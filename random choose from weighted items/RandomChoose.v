/*
the RandomChoose module chooses an item from a list contain 4 items , based on their weights 
this is similar to for example numpy.random.choice() method in numpy python package .
the used algorithm (weights approach):
 - calculate the sum of all the weights.
 - pick a random number that is 0 or greater and is less than the sum of the weights.
  - go through the items one at a time, subtracting their weight from your random number, 
  until you get the item where the random number is less than that item's weight.


*/

module RandomChoose(
//inputs
    input wire in_clock, 
    // the main clock of the system.
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable,
    // the 4 weights of the segments , if you want only 2 segments , you can put the other as zeros.
    input wire  [7:0] in_weight0,
    input wire  [7:0] in_weight1,
    input wire  [7:0] in_weight2,
    input wire  [7:0] in_weight3,
    input wire signed [7:0] in_seed, // initial value  , CANNOT be zero or negative
  //ouputs
    output reg  [1:0] out_segment_number // (the choosing segment number) : 0 , 1 , 2 ,or 3 . 
    
    );

reg signed [7:0] random,seed; // temporary variables 
wire [7:0]sum_weights,sum_weights_minus_one;
wire signed [7:0]random_from_randomize;
assign sum_weights = in_weight0 + in_weight1 + in_weight2 + in_weight3;
assign sum_weights_minus_one = sum_weights-1;

always @ (posedge in_clock)
begin

    
// it should be 1 if you want new numbers to be generated every posetive clock edge .
// if 0 , the output remains like the previous one.
    if(in_enable) 
    begin
    // get the random value from RandomGenerator module 
        random = random_from_randomize;
        if ( random < in_weight0 )
        begin
            out_segment_number = 0;
        end
        else 
        begin
            random = random - in_weight0;
            if ( random < in_weight1 )
            begin
                out_segment_number = 1;
            end
            else 
            begin
                random = random - in_weight1;
                if ( random < in_weight2 ) 
                begin
                    out_segment_number = 2;
                end
                else  
                begin
                    random = random - in_weight2;
                    if ( random < in_weight3 )
                    begin
                        out_segment_number = 3;
                    end
                end
            end
        end
    end
end

  RandomGenerator  randomize (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_min(8'd0),
  .in_max(sum_weights_minus_one),
  .in_seed(in_seed), 
  .out_random(random_from_randomize)
 );
endmodule
