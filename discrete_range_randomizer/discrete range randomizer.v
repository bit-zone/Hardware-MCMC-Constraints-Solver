`timescale 1ns / 1ps
`define DISCRETE_VARIABLE_INDEX_BIT_WIDTH 2 //4 discrete variabeles
`include "TopModuleHeaders.vh"

// set this file as a global include
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 8
`define BIT_WIDTH_OF_INTEGER_COEFFICIENTS 8 // bit signed                                                                      this | 8 is for the bias
`define CLAUSE_BIT_WIDTH (( 2 * `NUMBER_OF_BOOLEAN_VARIABLES )+(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_COEFFICIENTS )+8) //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT  1

`define BOOLEAN_COEFFICIENTS_END `CLAUSE_BIT_WIDTH-(`NUMBER_OF_BOOLEAN_VARIABLES*2)
`define INTEGER_COEFFICIENTS_START `BOOLEAN_COEFFICIENTS_END-1
// clause form with 2 boolean variables and one integer
  //00         00          00000000        00000000
//bool var 1 bool var2     integer coeff     bias


//defines for DiscreteRangeRandomizer
///////////////////////////////////////////////////////////////////////
`define NUMBER_OF_DISCRETE_VARIABLES 4
`define DISCRETE_VARIABLE_INDEX_BIT_WIDTH 2 //4 discrete variabeles

`define NUMBER_OF_DISCRETE_VALUES_FOR_ONE_VARIABLE 4 
`define DISCRETE_VALUES_NUMBER_BIT_WIDTH 2
///////////////////////////////////////////


module DiscreteRangeRandomizer(
    input wire in_clock,
    input wire in_enable,
    input wire [7:0]in_seed,
    
    input wire [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH-1:0 ]in_variable_index,
    
    output wire [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output wire [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end,
    output wire out_equal
    );
    
    
    reg reset;
    wire [`DISCRETE_VALUES_NUMBER_BIT_WIDTH-1:0] index_of_the_discrete_value;
    wire [`DISCRETE_VALUES_NUMBER_BIT_WIDTH-1:0] number_of_discrete_assignments; 
    
    assign out_equal=(out_start==out_end)?1:0;
    
    
    DiscreteVariablesSizes discrete_variables_sizes(
        .in_variable_index(in_variable_index),
        .out_number_of_discrete_assignments(number_of_discrete_assignments)
    );
    
     RandomGenerator  random_generator(
     .in_clock(in_clock), 
     .in_reset(reset),
     .in_enable(in_enable),
     .in_min(0),
     .in_max(number_of_discrete_assignments),
     .in_seed(in_seed), 
     .out_random(index_of_the_discrete_value)
    );
    
    DiscreteValuesTable discrete_values_table(
    .in_variable_index(in_variable_index),
    .in_index_of_the_discrete_value(index_of_the_discrete_value),
    
    .out_start(out_start),
    .out_end(out_end)
    );
endmodule
