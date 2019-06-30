`timescale 1ns / 1ns

module DiscreteRangeRandomizer
#(
    parameter MAX_BIT_WIDTH_OF_INTEGER_VARIABLE =2,
    parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX =2,
    parameter MAX_BIT_WIDTH_OF_DISCRETE_CHOICES =2,
    
    parameter NUMBER_OF_DISCRETE_CHOICES_FILE_PATH="number_of_discrete_choices_of_each_variable.mem",//"D:\\projects\\0IMP_Projects\\GP\\Hardware-MCMC-Constraints-Solver\\input_text_files\\number_of_discrete_choices_of_each_variable.mem",
    parameter DISCRETE_VALUES_FILE_PATH="discrete_values.mem"//"D:\\projects\\0IMP_Projects\\GP\\Hardware-MCMC-Constraints-Solver\\input_text_files\\discrete_values.mem"//
    
)
(
    input wire in_clock,
//inputs for random generator
    input wire [7:0]in_seed,
    input wire in_reset,
    //this is for the random generator seed initialization
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning 
    
    input wire in_DiscreteVariablesSizes_enable,
    input wire in_random_enable,
    input wire in_DiscreteValuesTable_enable,
     
    input wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0 ]in_variable_index,
    
    output wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end,
    output wire out_equal
    );
    
    
    
  
    
    wire [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1:0] index_of_the_discrete_value;
    wire [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1:0] number_of_discrete_assignments; 
    
    assign out_equal=(out_start==out_end)?1'b1:1'b0;
    
    DiscreteVariablesSizes
    #(//module parameters
        .MAX_BIT_WIDTH_OF_VARIABLES_INDEX (MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
        .MAX_BIT_WIDTH_OF_DISCRETE_CHOICES (MAX_BIT_WIDTH_OF_DISCRETE_CHOICES),
        // for inside constraint we have 16 choice in it
        //for exampl x inside [1,3,5,7,9,0,12,34,76,65,56,77,88,99,[100:200],[40:60]]
        .FILE_PATH(NUMBER_OF_DISCRETE_CHOICES_FILE_PATH)
    )
    discrete_variables_sizes(
        .in_clock(in_clock),
        
        .in_enable(in_DiscreteVariablesSizes_enable),
        
        .in_variable_index(in_variable_index),
        .out_number_of_discrete_assignments(number_of_discrete_assignments)
    );
    
     RandomGenerator 
     #(//module parameters
        .WIDTH(MAX_BIT_WIDTH_OF_DISCRETE_CHOICES)
     )
     random_generator(
         .in_clock(in_clock), 
         .in_reset(in_reset),
         .in_enable(in_random_enable),
         
         .in_min(2'b0),
         .in_max(number_of_discrete_assignments),
         .in_seed(in_seed), 
         .out_random(index_of_the_discrete_value)
    );
    
    DiscreteValuesTable 
    #(//module parameters
        .MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE),
        .MAX_BIT_WIDTH_OF_VARIABLES_INDEX (MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
        .MAX_BIT_WIDTH_OF_DISCRETE_CHOICES (MAX_BIT_WIDTH_OF_DISCRETE_CHOICES),
        //for inside constraint we have 16 choice in it
       //for exampl x inside [1,3,5,7,9,0,12,34,76,65,56,77,88,99,[100:200],[40:60]]
       .FILE_PATH(DISCRETE_VALUES_FILE_PATH)
    ) 
    discrete_values_table
    (
    .in_clock(in_clock),
    
    .in_enable(in_DiscreteValuesTable_enable),
    .in_variable_index(in_variable_index),
    .in_index_of_the_discrete_value(index_of_the_discrete_value),
    
    .out_start(out_start),
    .out_end(out_end)
    );
    


    
initial begin 
        $monitor   ("time = %t +++ variable_index= %d number_of_discrete_assignments= %d +++ index_of_the_discrete_value= %d   start= %d end=%d",
        $realtime ,
        in_variable_index,
        number_of_discrete_assignments,
        index_of_the_discrete_value,out_start,out_end);

    end
endmodule
