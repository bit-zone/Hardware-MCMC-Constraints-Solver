`timescale 1ns / 1ps


module Propose
#(parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX=2)
(
input in_clock,
input in_reset,
input in_seed,
/////////////////////////////////////////////////////////////
//enables comes from main control_unit
input in_boolean_propose_enable,

input in_reduce_enable,
input in_select_segment_enable,


input in_DiscreteVariablesSizes_enable,
input in_random_enable,
input in_DiscreteValuesTable_enable,

input in_sampler_enable,
/////////////////////////////////////////////////////////////////
input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_variable_to_be_changed_index,
input [2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_boolean_assignment_before_move,

input in_integer_assignment_before_move,


//output
output [2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] out_boolean_assignment_proposed_move
);
    

BooleanPropose 
#(
.MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX(2)
)
boolean_propose
(
.in_clock(in_clock),
.in_enable(in_boolean_propose_enable),

.in_current_assignment_boolean(in_boolean_assignment_before_move),
.in_variable_to_be_changed_index(in_variable_to_be_changed_index),

.out_new_assignment_Boolean(out_boolean_assignment_proposed_move)
);

DiscreteRangeRandomizer 
#(
    .MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(2),
    .MAX_BIT_WIDTH_OF_VARIABLES_INDEX (2),
    .MAX_BIT_WIDTH_OF_DISCRETE_CHOICES (2)
 )
discrete_range_randomizer
(
    .in_clock(in_clock),
    
    .in_DiscreteVariablesSizes_enable(in_DiscreteVariablesSizes_enable),
    .in_random_enable(in_random_enable),
    .in_DiscreteValuesTable_enable(in_DiscreteValuesTable_enable),
    
    .in_seed(in_seed),
    .in_reset(in_reset),
    .in_variable_index(in_variable_to_be_changed_index),
  
    .out_start(out_start),
    .out_end(out_end),
    .out_equal(out_equal)
);


ProposeIntegerContinous
#(
.MAXIMUM_BIT_WIDTH_OF_COEFFICIENT (8),//= 8,
.MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX(2),// = 2,
//.MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT),//=MAXIMUM_BIT_WIDTH_OF_COEFFICIENT,
.MAX_BIT_WIDTH_OF_CLAUSES_INDEX(3)//=3
)
(
.in_clk(in_clock),
.in_reset(in_reset),
.in_seed(in_seed),
///////////
//enables 
.in_reduce_enable(in_reduce_enable),
////////////
.in_clause_coefficients(),
.in_clause_index(),
//outputs
.out_chosen_segment_type(),
.out_chosen_segment_from(),
.out_chosen_segment_to(),
.out_chosen_segment_weight()
);




Sampler 
#(.WIDTH(8))
sampler(
      //inputs
.in_clock(in_clock), // the main clock of the system.
.in_reset(in_reset),  // if 1 , the module reads the seed value , 
// it should be 1 only at beginning and 0 after beginning .
.in_enable(in_enable), // it should be 1 if you want new numbers to be generated every posetive clock edge .
// if 0 , the output remains like the previous one.
.in_seed(in_seed), // initial value  , CANNOT be zero or negative
.in_from(from), // specifies the minimum value of the target range.
.in_to(to), // specifies the maximum value of the target range. 
.in_chosen_segment_type(chosen_segment_type) ,// (the choosing segment type) : 3 , 1 ,or 2 .
.in_chosen_segment_weight(chosen_segment_weight),
// should add the index of variable later

 //ouputs
 .out_proposed_value(proposed_value) // the new value
 );   


endmodule
