
// inputs
// 1) Seed 
// 2) Pls
// 3) clk
// 4) reset
// 5) enable

// ------------------

// outputs
// is_local

module ProbabilityAdjustment(
    
    input wire [7:0] in_Pls,
    
    input wire in_clock, 
    // the main clock of the system.
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable,

    input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
    
    output out_is_local
    );
    
    
    
    wire signed [7:0] out_random;
    reg is_local;
    assign out_is_local = is_local;
    
    
        
    always @ (*)
    begin
    if(out_random <= in_Pls )
    is_local = 1;
    
    else
    is_local =0; 
   end
            
   
    RandomGenerator U1(
      //inputs
        .in_clock(in_clock), 
        // the main clock of the system.
        .in_reset(in_reset), 
        // if 1 , the module reads the seed value , 
        // it should be 1 only at beginning and 0 after beginning .
        .in_enable(in_enable),
        // it should be 1 if you want new numbers to be generated every posetive clock edge .
        // if 0 , the output remains like the previous one.
        .in_min(0),
        // specifies the minimum value of the target range.
        .in_max(100),
        // specifies the maximum value of the target range.
        .in_seed(in_seed), // initial value  , CANNOT be zero or negative
      //ouputs
        .out_random(out_random)
        // the random number 
        );

    
endmodule
