`timescale 1ns / 1ps


module Propose
#(
parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX=2,
parameter MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX = MAX_BIT_WIDTH_OF_VARIABLES_INDEX,
parameter MAX_BIT_WIDTH_OF_INTEGER_VARIABLE=8,

parameter MAX_BIT_WIDTH_OF_DISCRETE_CHOICES =2,

parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=3,
parameter MAX_BIT_WIDTH_OF_COEFFICIENT=8
)
(

input in_clock,
input in_reset,
input [7:0]in_seed,
input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_variable_to_be_changed_index,//shared between all different propose modules


/***************boolean propose signals start****************/
//control
input in_boolean_propose_enable,
//data
input [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] in_boolean_assignments_before_move,//the current values assigned to boolean variables x1,x2,...
/***************boolean propose signals end****************/


/***************continous propose signals start****************/
//control
//// for clause register setup comes from main control unit////
input in_clause_registers_write_enable,                     
input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,
////enables comes from ProbabalisticSearch control_unit//
input [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]in_reduce_enable,
input in_select_segment_enable,

// data 
input [(((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)+1//for the bias
)*MAX_BIT_WIDTH_OF_COEFFICIENT)-1:0]in_clause_coefficients,//coefficients of one clause only
input [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)-1:0]in_integer_assignments_before_move,
/***************continous propose signals end****************/


/***************discrete propose signals starts****************/
//control
input in_DiscreteVariablesSizes_enable,
input in_random_enable,
input in_DiscreteValuesTable_enable,
/***************discrete propose signals end****************/


/***************sampler signals start*********************/
//control
input chosen_variable_is_discrete,//needed to decide the sampler source input
input in_sampler_enable,
/***************sampler signals end*********************/


/***************outputs starrt*********************/
output out_no_need_to_sample,
output [2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] out_boolean_proposed_move,
output [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_integer_proposed_move
/***************outputs end*********************/
);
    
parameter UNIFORM = 2'd3 ;


/*******discrete propose output wires start********/
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] start_discrete ;
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] end_discrete; 
wire  start_discrete_equals_end_discrete;
/*******discrete propose output wires start********/

/*******continuous propose output wires start********/
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] start_continuous; 
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] end_continuous;
wire [1:0]continuous_segment_type; 
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] continuous_segment_weight;
/*******continuous propose output wires end********/

/***************sampler input wires start****************/
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] sampler_input_start;
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] sampler_input_end;
wire [1:0] sampler_input_segment_type;
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] sampler_input_segment_wight; 
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] sampler_out_integer_proposed_move;
/***************sampler input wires end****************/

/***************sampler input decision start*****************/
assign sampler_input_start=(chosen_variable_is_discrete)?start_discrete:start_continuous;
assign sampler_input_end=(chosen_variable_is_discrete)?end_discrete:end_continuous;
assign sampler_input_segment_type=(chosen_variable_is_discrete)? UNIFORM:continuous_segment_type;
assign sampler_input_segment_wight=(chosen_variable_is_discrete)? 0:continuous_segment_weight;
/***************sampler input decision end*****************/




/********************module's output assignment********************/
assign out_no_need_to_sample=start_discrete_equals_end_discrete;
assign out_integer_proposed_move=(chosen_variable_is_discrete&start_discrete_equals_end_discrete)?start_discrete:sampler_out_integer_proposed_move;



BooleanPropose 
#(
.MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX(2)
)
boolean_propose
(
.in_clock(in_clock),
.in_enable(in_boolean_propose_enable),

.in_current_assignment_boolean(in_boolean_assignments_before_move),
.in_variable_to_be_changed_index(in_variable_to_be_changed_index),

.out_new_assignment_Boolean(out_boolean_proposed_move)
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
  
    .out_start(start_discrete),
    .out_end(end_discrete),
    .out_equal(start_discrete_equals_end_discrete)
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
//enables 
.in_reduce_enable(in_reduce_enable),
.in_clause_index(in_clause_index),
.in_select_segment_enable(in_select_segment_enable),
.in_clause_registers_write_enable(in_clause_registers_write_enable),
//data
.in_clause_coefficients(in_clause_coefficients),
.in_variable_to_be_unreduced_index(in_variable_to_be_changed_index),//in_variable_to_be_changed_index means the variable that we will propose a value for it
.in_assignment_before_move(in_integer_assignments_before_move), 
//outputs
.out_chosen_segment_type(continuous_segment_type),
.out_chosen_segment_from(start_continuous),
.out_chosen_segment_to(end_continuous),
.out_chosen_segment_weight(continuous_segment_weight)
);


Sampler 
#(.WIDTH(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE))
sampler(
      //inputs
.in_clock(in_clock), // the main clock of the system.
.in_reset(in_reset),  // if 1 , the module reads the seed value , 
// it should be 1 only at beginning and 0 after beginning .
.in_enable(in_sampler_enable), // it should be 1 if you want new numbers to be generated every posetive clock edge .
// if 0 , the output remains like the previous one.
.in_seed(in_seed), // initial value  , CANNOT be zero or negative
.in_from(sampler_input_start), // specifies the minimum value of the target range.
.in_to(sampler_input_end), // specifies the maximum value of the target range. 
.in_chosen_segment_type(sampler_input_segment_type) ,// (the choosing segment type) : 3 , 1 ,or 2 .
.in_chosen_segment_weight(sampler_input_segment_wight),
// should add the index of variable later

 //ouputs
 .out_proposed_value(sampler_out_integer_proposed_move) // the new value
 );   


endmodule
