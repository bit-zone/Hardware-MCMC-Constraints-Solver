`include "headers.v"
module ProposeIntegerContinuous(
input in_clock,
////inputs to ReduceClause 1
input  [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] In_coefficients_ReduceClause1,
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] In_current_assignment_ReduceClause1,
input  [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] In_variable_to_be_unchanged_index_ReduceClause,
input in_enable_ReduceClause1,
input in_reset_ReduceClause1,
////inputs to ReduceClause 2
input  [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] In_coefficients_ReduceClause2,
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] In_current_assignment_ReduceClause2,
input in_enable_ReduceClause2,
input in_reset_ReduceClause2,
////inputs to SelectSegment
input wire in_reset_SelectSegment, 
input wire in_enable_SelectSegment,
input wire signed [7:0] in_seed_SelectSegment, 

////outputs from select segment
output  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] SelectSegment_start_Mux,
output  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] SelectSegment_end_Mux,
output [1:0] SelectSegment_type_Mux,
output [7:0]SelectSegment_weight_Mux
);
///outputs from ReduceClause1,2 & inputs to maximumC1,2
wire  signed [(`BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] ReduceClause1_Bias_MaximumC;
wire  signed [(`BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] ReduceClause2_Bias_MaximumC;
wire ReduceClause1_Variable_to_be_unchanged_sign_MaximumC;
wire ReduceClause2_Variable_to_be_unchanged_sign_MaximumC;
wire ReduceClause1_Active_MaximumC;
wire ReduceClause2_Active_MaximumC;

///outputs from MaximumC & inputs to SelectSegment
wire signed [7:0] MaximumC1_c_less_than_SelectSegment;
wire signed [7:0] MaximumC2_c_more_than_SelectSegment;
wire MaximumC1_activation ;
wire MaximumC2_activation;
wire [1:0] MaximumC_flag_SelectSegment;


assign MaximumC_flag_SelectSegment={MaximumC2_activation,MaximumC1_activation};


///instantiations


ReduceClause ReduceClause1(
.in_coefficients(In_coefficients_ReduceClause1),
.in_current_assignment(In_current_assignment_ReduceClause1),
.in_variable_to_be_unchanged_index(In_variable_to_be_unchanged_index_ReduceClause),
.in_enable(in_enable_ReduceClause1),
.in_reset(in_reset_ReduceClause1),
.out_Bias(ReduceClause1_Bias_MaximumC),
.out_Variable_to_be_unchanged_sign(ReduceClause1_Variable_to_be_unchanged_sign_MaximumC),
.out_Active(ReduceClause1_Active_MaximumC)
);

ReduceClause ReduceClause2(
.in_coefficients(In_coefficients_ReduceClause2),
.in_current_assignment(In_current_assignment_ReduceClause2),
.in_variable_to_be_unchanged_index(In_variable_to_be_unchanged_index_ReduceClause),
.in_enable(in_enable_ReduceClause2),
.in_reset(in_reset_ReduceClause2),
.out_Bias(ReduceClause2_Bias_MaximumC),
.out_Variable_to_be_unchanged_sign(ReduceClause2_Variable_to_be_unchanged_sign_MaximumC),
.out_Active(ReduceClause2_Active_MaximumC)
);


MaximumC1 C1(
.first_number(ReduceClause1_Bias_MaximumC),
.first_number_activation(ReduceClause1_Active_MaximumC),
.first_number_sign(ReduceClause1_Variable_to_be_unchanged_sign_MaximumC),
.second_number(ReduceClause2_Bias_MaximumC),
.second_number_activation(ReduceClause2_Active_MaximumC),
.second_number_sign(ReduceClause2_Variable_to_be_unchanged_sign_MaximumC),
.maximum(MaximumC1_c_less_than_SelectSegment),
.maximum_activation (MaximumC1_activation)
);

MaximumC2 C2(
.first_number(ReduceClause1_Bias_MaximumC),
.first_number_activation(ReduceClause1_Active_MaximumC),
.first_number_sign(ReduceClause1_Variable_to_be_unchanged_sign_MaximumC),
.second_number(ReduceClause2_Bias_MaximumC),
.second_number_activation(ReduceClause2_Active_MaximumC),
.second_number_sign(ReduceClause2_Variable_to_be_unchanged_sign_MaximumC),
.maximum(MaximumC2_c_more_than_SelectSegment),
.maximum_activation(MaximumC2_activation)
);



selectSegment Selector(
.in_clock(in_clock), 
.in_reset(in_reset_SelectSegment),
.in_enable(in_enable_SelectSegment),
.in_seed(in_seed_SelectSegment), 
.in_c_less_than(MaximumC1_c_less_than_SelectSegment),
.in_c_more_than(MaximumC2_c_more_than_SelectSegment),
.in_flag(MaximumC_flag_SelectSegment),
.out_chosen_segment_type(SelectSegment_type_Mux),
.out_chosen_segment_from(SelectSegment_start_Mux),
.out_chosen_segment_to(SelectSegment_end_Mux),
.out_chosen_segment_weight(SelectSegment_weight_Mux)
 );



endmodule
