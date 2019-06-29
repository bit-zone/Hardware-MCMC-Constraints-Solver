`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2019 06:54:24 PM
// Design Name: 
// Module Name: stochastic_tb
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


module stochastic_tb(

    );
    
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4;//gives us the maximum bitwidth of coefficients in integer literal
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2;//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1;//gives us the maximum number of integer variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1;//gives us the maximum number of boolean variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2;//gives us the maximum number of clauses
    parameter TOTAL_NUMBER_OF_VARIABLES = (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)+(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX);
    
    
    reg in_current_state;
    reg in_clk;
    reg in_reset;//always = 0
    reg [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets;//the current assignment of all boolean variables in the formula 
    reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets;//current assignment for all integer variables in the formula
    
    //inputs for setting up the formula
    //////////
    reg [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_existing_clauses;//to tell us which clauses exist
    reg [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
    )*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer;//coefficients of integer literal for one clause only 
    reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean;//coefficients of boolean literals for one clause only
    reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index;//the number of the clause
    /////////
    
    //outputs 
    wire [((((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_boolean;
    wire [((((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_integer;
    wire [((MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)*TOTAL_NUMBER_OF_VARIABLES)-1:0] out_gains;
    wire [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] out_bestgain;
    wire [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE) -1:0] out_best_assignment_integer;
    wire [(((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE) -1:0] out_best_assignment_boolean;
    wire  out_ready;

    StochasticSearch
#
(
  MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
  MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
  MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
  MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX,
  TOTAL_NUMBER_OF_VARIABLES
)
testbench
(
in_current_state,
in_clk,
in_reset,
in_boolean_current_assigmnets,
in_integer_current_assigmnets,
in_existing_clauses,
in_clause_coefficients_integer,
in_clause_coefficients_boolean,
in_clause_index,
out_new_assignments_boolean,
out_new_assignments_integer,
out_gains,
out_bestgain,
out_best_assignment_integer,
out_best_assignment_boolean,
out_ready
);


initial
 begin
 in_clk=0;
 end
    
    
    initial
    begin
    //at first set up the module(set the formula) 
    ////
    in_existing_clauses=4'b1111;
    in_reset = 0;
    in_current_state=0;
    in_clause_coefficients_integer =12'h411;
    in_clause_coefficients_boolean=4'b1111;
    in_clause_index=0;
    #200;
    in_clause_coefficients_integer =12'h511;
    in_clause_coefficients_boolean=4'b1011;
    in_clause_index=1;
    #200;
    in_clause_coefficients_integer =12'h611;
    in_clause_coefficients_boolean=4'b1011;
    in_clause_index=2;    
    #200;
    in_clause_coefficients_integer =12'h311;
    in_clause_coefficients_boolean=4'hf;
    in_clause_index=3;
    /////
    //after seting up the module ,enable it  
    #200;
    in_current_state=1;
    in_integer_current_assigmnets=8'h11;
    in_boolean_current_assigmnets=2'b10;
    

    

      

    end
    
    
    always
    begin
    #100;
    in_clk = ~in_clk;
    end

    
    
    
    
    
endmodule
