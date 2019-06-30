`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2019 04:32:51 PM
// Design Name: 
// Module Name: StochasticSearch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module StochasticSearch
#
(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2,//gives us the maximum number of clauses
parameter TOTAL_NUMBER_OF_VARIABLES = (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)+(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)
)
(
input [7:0] in_current_state,
input in_clk,
input in_reset,//always = 0
input [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets,//the current assignment of all boolean variables in the formula 
input [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets,//current assignment for all integer variables in the formula

//inputs for setting up the formula
//////////
input [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_existing_clauses,//to tell us which clauses exist
input [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer,//coefficients of integer literal for one clause only 
input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean,//coefficients of boolean literals for one clause only
input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,//the number of the clause
/////////

//outputs 
output [((((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_boolean,
output [((((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_integer,
output [((MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)*TOTAL_NUMBER_OF_VARIABLES)-1:0] out_gains,
output [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] out_bestgain,
output [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE) -1:0] out_best_assignment_integer,
output [(((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE) -1:0] out_best_assignment_boolean,
output   out_ready


);

//finding un satisfied clause
//////////
wire [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]  out_clause_coefficients_integer; // the integer literal of the unsatisfied clause

wire [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] out_clause_coefficients_boolean; // the bool literal of the unsatisfied clause
//////////  

//local move
//////
//the module consists of number of paths equals the maximum number of variables
//this enable for enabling the paths of active variables only  
wire [2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX-1:0] in_boolean_propose_enable;//it enables active paths
wire [2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_integer_propose_enable;//it enables active paths
wire [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clauses_enable;// for indicating which clauses are active in the formula
//(as there is registers equals the maximum number of registers so we need enable for the existing ones)
wire in_find_best_gain_enable;
//////  

wire local_move_done;
    UnsatisfiedClauses
    #(
    MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
    MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
    MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
    MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX ,
    MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
    MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
    MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX
     ) 
     U1  
    (
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_checker_enable(in_clauses_enable),//from control unit
    .in_clause_coefficients_integer(in_clause_coefficients_integer),
    .in_clause_coefficients_boolean(in_clause_coefficients_boolean),
    .in_clause_index(in_clause_index),
    .in_integer_assignment(in_integer_current_assigmnets),
    .in_boolean_assignment(in_boolean_current_assigmnets),
    .out_clause_coefficients_integer(out_clause_coefficients_integer), 
    .out_clause_coefficients_boolean(out_clause_coefficients_boolean), 
    .out_satisfied()
    );
    
   VariablesDetector#(
    
    MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
    MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
    MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
    MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT
    )
    U2
    (
     .in_integer_coefficients(out_clause_coefficients_integer),
     .in_boolean_coefficients(out_clause_coefficients_boolean),
     .out_integer_variables(in_integer_propose_enable),
     .out_boolean_variables(in_boolean_propose_enable)
    );
    
    
     LocalMove
   #
   (
   MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
   MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
   MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
   MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX ,
   MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
   MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
   MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX,
   TOTAL_NUMBER_OF_VARIABLES
   )
   U3
   (
   .in_boolean_current_assigmnets(in_boolean_current_assigmnets),
   .in_integer_current_assigmnets(in_integer_current_assigmnets),
   .in_clk(in_clk),
   .in_reset(in_reset),
   .in_clause_coefficients_integer(in_clause_coefficients_integer),
   .in_clause_coefficients_boolean(in_clause_coefficients_boolean), 
   .in_clause_index(in_clause_index),
   .in_boolean_propose_enable(in_boolean_propose_enable),
   .in_integer_propose_enable(in_integer_propose_enable),
   .in_clauses_enable(in_clauses_enable),//internal control unit
   .in_find_best_gain_enable(in_find_best_gain_enable),//internal control unit
   .out_new_assignments_boolean(out_new_assignments_boolean),
   .out_new_assignments_integer(out_new_assignments_integer),
   .out_gains(out_gains),
   .out_bestgain(out_bestgain),
   .out_best_assignment_integer(out_best_assignment_integer),
   .out_best_assignment_boolean(out_best_assignment_boolean),
   .out_done(local_move_done)
       );
       
       stochasticControlUnit#
       (
      MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX
       )
       U4
       (
       .in_current_state(in_current_state),
       .in_clk(in_clk),
       .in_local_done(local_move_done),
       .in_clauses_enble(in_existing_clauses),
       .out_clauses_enble(in_clauses_enable),
       .out_find_best_gain_enable(in_find_best_gain_enable),
       .out_ready(out_ready)
       );
endmodule
