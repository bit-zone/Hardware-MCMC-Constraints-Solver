`timescale 1ns / 1ps

module ProbabilisticSearchMove
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
input in_reset,//at posedge of reset all modules' outputs are down to zero
input [7:0]in_seed,

input [7:0]in_top_module_state,

input in_clause_registers_write_enable,                     
input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,

input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX:0] number_of_clauses,


input [(2*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX))-1 : 0 ] in_clause_coefficients_boolean,
input [(((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)+1//for the bias
)*MAX_BIT_WIDTH_OF_COEFFICIENT)-1:0]in_clause_coefficients,//integer coefficients of one clause only

input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_number_of_boolean_variables, 
input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_number_of_integer_variables,
// these discrete variables are used in regular constraints
input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] in_number_of_discrete_integer_variables,

input [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)-1:0] in_integer_assignment_before_move,
input [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] in_boolean_assignment_before_move,

output  [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)-1:0] out_integer_assignment_after_move,
output  [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] out_boolean_assignment_after_move
    );
parameter PROBABALISTIC=1;
parameter IDLE=2;
/******************control unit wires start*******************/

//outputs
wire [7:0]probabilistic_search_state;
wire boolean_propose_enable;
wire [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]reduce_enable;
wire select_segment_enable;

wire DiscreteVariablesSizes_enable;
wire random_enable;
wire DiscreteValuesTable_enable;

wire no_need_to_sample;
wire sampler_input_selector;//needed to decide the sampler source input
wire sampler_enable;

wire catch_U;//store number of unsatisfied claues for old assignment
wire calculate_probability_enable;
wire compute_for_proposed_value;
/******************control unit wires end*******************/
wire [1:0]choosen_variable_type;
wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] choosen_variable_index;
wire variable_choser_enable;

wire [MAX_BIT_WIDTH_OF_CLAUSES_INDEX:0]number_of_satisfied_clauses;
wire [MAX_BIT_WIDTH_OF_CLAUSES_INDEX:0]number_of_unsatisfied_clauses;

wire [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] proposed_assignments_boolean;
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)-1:0]  proposed_assignments_integer;

wire [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] gain_input_source_boolean;
wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)-1:0] gain_input_source_integer;

wire output_is_proposed_value;

wire [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] integer_proposed_move_for_one_variable;


reg [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] active_modules;//used to activate reduce modules as needed example 0011 -> we have two modules activated


reg [MAX_BIT_WIDTH_OF_CLAUSES_INDEX:0]number_of_unsatisfied_clauses_befor_move;

assign gain_input_source_boolean=(compute_for_proposed_value)?proposed_assignments_boolean:in_boolean_assignment_before_move;
assign gain_input_source_integer=(compute_for_proposed_value)?proposed_assignments_integer:in_integer_assignment_before_move;

assign number_of_unsatisfied_clauses=number_of_clauses-number_of_satisfied_clauses;
assign variable_choser_enable=((in_top_module_state==PROBABALISTIC)&&(probabilistic_search_state==IDLE))?1'b1:1'b0;


assign out_boolean_assignment_after_move=(output_is_proposed_value)?proposed_assignments_boolean:in_boolean_assignment_before_move;
assign out_integer_assignment_after_move=(output_is_proposed_value)?proposed_assignments_integer:in_integer_assignment_before_move;


integer i;
always@ *
begin
for(i=0;i<2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX;i=i+1)
    begin
        if(i<number_of_clauses)
            active_modules[i]=1;
        else
            active_modules[i]=0;
    end
end


always@(posedge in_clock)
begin
    if(catch_U)
        number_of_unsatisfied_clauses_befor_move<=number_of_unsatisfied_clauses;
    else
        number_of_unsatisfied_clauses_befor_move<=number_of_unsatisfied_clauses_befor_move;
end



ProbabilisticSearchControlUnit#(
.MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)
)
control_unit(
.in_clk(in_clock),
.in_reset(in_reset),
.in_top_module_state(in_top_module_state),


.in_choosen_variable_type(choosen_variable_type),
.no_need_to_sample(no_need_to_sample),

.in_active_modules(active_modules),//used to activate reduce modules as needed example 0011 -> we have two modules activated

.out_catch_U(catch_U),
.out_probabilistic_search_state(probabilistic_search_state),
.out_boolean_propose_enable(boolean_propose_enable),
.out_reduce_enable(reduce_enable),
.out_select_segment_enable(select_segment_enable),

.out_DiscreteVariablesSizes_enable(DiscreteVariablesSizes_enable),
.out_random_enable(random_enable),
.out_DiscreteValuesTable_enable(DiscreteValuesTable_enable),

.out_chosen_variable_is_discrete(sampler_input_selector),//needed to decide the sampler source input
.out_sampler_enable(sampler_enable),
.out_calculate_probability_enable(calculate_probability_enable),
.out_compute_for_proposed_value(compute_for_proposed_value)

);


VariableChooser #(.MAX_BIT_WIDTH_OF_VARIABLES_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX)) 
variable_chooser(
.in_clock(in_clock),
.in_reset(in_reset),
.in_enable(variable_choser_enable),
.in_seed(in_seed),

.number_of_boolean_variables(in_number_of_boolean_variables),
.number_of_integer_variables(in_number_of_integer_variables),
.number_of_discrete_integer_variables(in_number_of_discrete_integer_variables),

.out_choosen_type(choosen_variable_type),
.out_choosen_index(choosen_variable_index)
);

Propose 
#(
.MAX_BIT_WIDTH_OF_VARIABLES_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
.MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE),

.MAX_BIT_WIDTH_OF_DISCRETE_CHOICES (MAX_BIT_WIDTH_OF_DISCRETE_CHOICES),

.MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX),
.MAX_BIT_WIDTH_OF_COEFFICIENT(MAX_BIT_WIDTH_OF_COEFFICIENT)
)
propose_move
(
.in_clock(in_clock),
.in_reset(in_reset),
.in_seed(in_seed),

//control
.out_no_need_to_sample(no_need_to_sample),

.in_clause_registers_write_enable(in_clause_registers_write_enable),                     
.in_clause_index(in_clause_index),

.in_variable_to_be_changed_index(choosen_variable_index),

.in_boolean_propose_enable(boolean_propose_enable),
.in_reduce_enable(reduce_enable),
.in_select_segment_enable(select_segment_enable),
.in_DiscreteVariablesSizes_enable(DiscreteVariablesSizes_enable),
.in_random_enable(random_enable),
.in_DiscreteValuesTable_enable(DiscreteValuesTable_enable),
.chosen_variable_is_discrete(sampler_input_selector),
.in_sampler_enable(sampler_enable),
//data
.in_clause_coefficients(in_clause_coefficients),//coefficients of one clause only
.in_boolean_assignments_before_move(in_boolean_assignment_before_move),//the current values assigned to boolean variables x1,x2,...
.in_integer_assignments_before_move(in_integer_assignment_before_move),

.out_boolean_proposed_move(proposed_assignments_boolean),
.out_integer_proposed_move(integer_proposed_move_for_one_variable)

);




UpdateAssignment #(
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE)
) 
update_assignment(
.in_variable_type(choosen_variable_type),
.in_integer_variable_index(choosen_variable_index),
.in_new_assignment_for_integer_variable(integer_proposed_move_for_one_variable),
.in_integer_assignment_before_move(in_integer_assignment_before_move),
.out_integer_assignment_after_move(proposed_assignments_integer)
);



ComputeGain #(
.MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE),
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(2),
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX),
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE),
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(1),
.MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)
)
Number_of_satisfied_clauses(
.in_clk(in_clock),
//control
.in_reset(in_reset),
.in_gain_enable(1),//to enable the module itself
.in_clause_index(in_clause_index),//the number of the clause
.in_clause_registers_write_enable(in_clause_registers_write_enable),
.in_clause_enable(1),//to enable checker 

//data
.in_clause_coefficients_integer(in_clause_coefficients),//coefficients of integer literal for one clause only 
.in_clause_coefficients_boolean(in_clause_coefficients_boolean),//coefficients of boolean literals for one clause only

.in_integer_assignment_after_move(gain_input_source_integer),
.in_boolean_assignment_after_move(gain_input_source_boolean),

//output
.out_number_of_satisfied_clauses(number_of_satisfied_clauses)//the number of satisfied clauses for the entered assignment

);


calculateProbability #(.MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX))
 calculate_probability (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_seed(in_seed),
  .in_enable(calculate_probability_enable),
  .in_u(number_of_unsatisfied_clauses_befor_move),//number of failed clauses (before) the new proposed value.
  .in_v(number_of_unsatisfied_clauses),//number of failed clauses (after) the new proposed value.
  .out_p(output_is_proposed_value)
 );
endmodule
