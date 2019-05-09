`timescale 1ns / 1ps

module propose_corner_point_edited
#(

parameter MAXIMUM_BIT_WIDTH_OF_COEFFICIENT = 8,
parameter MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX = 2,
parameter MAX_BIT_WIDTH_OF_INTEGER_VARIABLE=4,
parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=3
)
(
input in_clk,
input in_reset,
// for clause register setup
input [((2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]in_clause_coefficients,//coefficients of one clause only

input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,

input [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)-1:0]in_assignment_before_move,
input [MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX-1:0] in_variable_to_be_unchanced_index,

input [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]in_reduce_enable,

//this should be [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] but the new assignment here is one of the biases
//so we have to make MAXIMUM_BIT_WIDTH_OF_COEFFICIENT=MAX_BIT_WIDTH_OF_INTEGER_VARIABLE
output reg signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]new_assignmet_for_the_choosen_variable
);
wire [((2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]clauses_coefficients[0:(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1];


wire signed[MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]reduce_out_biases[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
wire reduce_out_activations[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
wire reduce_out_sign[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];//the clause is y+c>0 or y+c<0

wire signed[MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]tree_comparator_biases_for_c1[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
wire tree_comparator_activations_for_c1[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1]; 


wire signed[MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]tree_comparator_biases_for_c2[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
wire tree_comparator_activations_for_c2[0:((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1]; 

generate 
genvar i,j;
for(i=0;i<(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX);i=i+1)begin:generate_reduce

ClauseRegister_IntegerLiteral
#( 
 .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT),
 .NUMBER_OF_INTEGER_VARIABLES(2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX),
 .MODULE_IDENTIFIER(i),
 .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)
)
    clause_register_integer_literal(
         .in_clause_coefficients(in_clause_coefficients),
         .in_clause_index(in_clause_index),
         .in_reset(in_reset),
         .in_clk(in_clk),
         .out_clause_coefficients(clauses_coefficients[i])
        );

 ReduceClause
 #(
    .MAXIMUM_BIT_WIDTH_OF_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT),
    .MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)
  )
 reduce_clause 
(
    .in_coefficients(clauses_coefficients[i]),
    .in_current_assignment(in_assignment_before_move),
    .in_variable_to_be_unchanged_index(in_variable_to_be_unchanced_index),
    .in_clk(in_clk),
    .in_enable(in_reduce_enable[i]),
    .in_reset(in_reset),
    .out_Bias(reduce_out_biases[i]),
    .out_Variable_to_be_unchanged_sign(reduce_out_sign[i]),
    .out_Active(reduce_out_activations[i])
    ); 
end

for(i=0;i<(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX);i=i+2)begin:first_level_of_the_tree_comparator
MaximumC1
    #( .NUMBER_SIZE(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT) ) 
    
maxc1(
.first_number(reduce_out_biases[i]),
.first_number_activation(reduce_out_activations[i]),
.first_number_sign(reduce_out_sign[i]),

.second_number(reduce_out_biases[i+1]),
.second_number_activation(reduce_out_activations[i+1]),
.second_number_sign(reduce_out_sign[i+1]),

.maximum(tree_comparator_biases_for_c1[i/2]),
.maximum_activation(tree_comparator_activations_for_c1[i/2])
);

MaximumC2
    #( .NUMBER_SIZE(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT) ) 
    
maxc2(
.first_number(reduce_out_biases[i]),
.first_number_activation(reduce_out_activations[i]),
.first_number_sign(reduce_out_sign[i]),

.second_number(reduce_out_biases[i+1]),
.second_number_activation(reduce_out_activations[i+1]),
.second_number_sign(reduce_out_sign[i+1]),

.maximum(tree_comparator_biases_for_c2[i/2]),
.maximum_activation(tree_comparator_activations_for_c2[i/2])
);
end  
                                //  *
                               //  ***   
//total number of nodes in a tree ***** = 5+4 = 2*numberof nodes in last level -1 
//number of nodes in the last level of our tree = number of reduce blocks /2
for (i=0;i<2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1;i=(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1))begin :generate_secod_level_in_the_tree_for_c1
         for(j=i;j<(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)-1;j=j+2)begin : generate_ith_level
             Maximum_with_active_signal_only 
             #( .NUMBER_SIZE(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT))
             max_c1(
                 .first_number(tree_comparator_biases_for_c1[j]),
                 .first_number_activation(tree_comparator_activations_for_c1[j]),
                
                 
                 .second_number(tree_comparator_biases_for_c1[j+1]),
                 .second_number_activation(tree_comparator_activations_for_c1[j+1]),
                 
                 
                 .maximum(tree_comparator_biases_for_c1[(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)+((j-i)/2)]),
                 .maximum_activation(tree_comparator_activations_for_c1[(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)+((j-i)/2)])
                 );
            end
end

// for loops for c2 tree comparator

for (i=0;i<2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1;i=(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1))begin :generate_secod_level_in_the_tree_for_c2
         for(j=i;j<(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)-1;j=j+2)begin : generate_ith_level
             Maximum_with_active_signal_only 
             #( .NUMBER_SIZE(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT))
             max_c2(
                 .first_number(tree_comparator_biases_for_c2[j]),
                 .first_number_activation(tree_comparator_activations_for_c2[j]),
                
                 
                 .second_number(tree_comparator_biases_for_c2[j+1]),
                 .second_number_activation(tree_comparator_activations_for_c2[j+1]),
                 
                 
                 .maximum(tree_comparator_biases_for_c2[(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)+((j-i)/2)]),
                 .maximum_activation(tree_comparator_activations_for_c2[(i/2)+2**(MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1)+((j-i)/2)])
                 );
            end
end


endgenerate 


always@(posedge(in_clk))begin
//if state = propose 
// this state comes from the control unit
if(tree_comparator_activations_for_c1[((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1])
new_assignmet_for_the_choosen_variable<=tree_comparator_biases_for_c1[((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
else
new_assignmet_for_the_choosen_variable<=tree_comparator_biases_for_c2[((2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1)-1];
end


endmodule
