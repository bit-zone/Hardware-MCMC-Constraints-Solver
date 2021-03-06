`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2019 05:20:30 PM
// Design Name: 
// Module Name: formulaChecker
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


module formulaChecker
#(

parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2//gives us the maximum number of clauses
)
(
input in_clk,//general clock
input in_reset,//at posedge of reset all modules' outputs are down to zero
input [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clause_enable,//this enable is propagated to all internal modules except for the internal memory for clauses



// for clause register setup
input [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer,//coefficients of integer literal for one clause only 
input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean,//coefficients of boolean literals for one clause only
input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,//the number of the clause

//the assignment to check
input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment_after_move,
input [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment_after_move,

input in_enable,
output wire [2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] all_satisfied,
output  satisfied

 
 );
 
 //input to clause registers
 wire [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
 )*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]clauses_coefficients_integer[0:(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1];
 wire [(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)*MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT-1:0]clauses_coefficients_boolean[0:(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1];

//outputs of checker module
 wire [2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] clause_satisfied ;
 wire checker_ready_flag[0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];
 
 
 integer k;//reg for the for loop

 
assign satisfied =(clause_satisfied | ~(in_clause_enable))==  {2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX{1'b1}}? 1:0;
 assign all_satisfied = clause_satisfied;

generate 
 genvar i,j;
 
 //this for loop used to load the formula during the setup state 
 for(i=0;i<(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX);i=i+1)begin:generate_formula_and_check_satisfiability
 //the integer part of the clause
 ClauseRegister_IntegerLiteral
 #( 
 .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
 .NUMBER_OF_INTEGER_VARIABLES(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
 .MODULE_IDENTIFIER(i),
 .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
 )
     clause_register_integer(
          .in_clause_coefficients(in_clause_coefficients_integer),
          .in_clause_index(in_clause_index),
          .in_reset(in_reset),
          .in_clk(in_clk),
          .out_clause_coefficients(clauses_coefficients_integer[i])
         );
         
 //the boolean part of the clause        
  ClauseRegister_BooleanLiteral
          #( 
          .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),
          .NUMBER_OF_BOOLEAN_VARIABLES(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
          .MODULE_IDENTIFIER(i),
          .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
          )
              clause_register_boolean(
                   .in_clause_coefficients(in_clause_coefficients_boolean),
                   .in_clause_index(in_clause_index),
                   .in_reset(in_reset),
                   .in_clk(in_clk),
                   .out_clause_coefficients(clauses_coefficients_boolean[i])
                  );   
                  
     //check on each clause with the current assignment                 
       OneClauseChecker #(
                  .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
                  .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),
                  .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
                  .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
                  .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),
                  .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE),
                  .MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
                  )
                  check_on_clause 
                  (
                    .in_boolean_current_assigmnets(in_boolean_assignment_after_move),
                    .in_boolean_coefficients(clauses_coefficients_boolean[i]),          
                    .in_integer_current_assigmnets(in_integer_assignment_after_move),
                    .in_integer_coefficients(clauses_coefficients_integer[i]),  
                    .in_enable(in_clause_enable[i]&in_enable),
                    //this enable is responsible for activating the checker of formula clauses only
                    .in_clk(in_clk),
                    .in_reset(in_reset),
                    .out_clause_is_satisfied(clause_satisfied[i]),
                    .ready_flag(checker_ready_flag[i])
                  ); 
     
end
endgenerate



endmodule
