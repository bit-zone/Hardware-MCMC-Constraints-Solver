`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2019 07:24:39 PM
// Design Name: 
// Module Name: localMove_tb
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


module localMove_tb(
    );
    
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4;//gives us the maximum bitwidth of coefficients in integer literal
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2;//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1;//gives us the maximum number of integer variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1;//gives us the maximum number of boolean variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2;//gives us the maximum number of clauses
    parameter TOTAL_NUMBER_OF_VARIABLES = (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)+(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX);


///assignment before move
///
reg [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets;//the current assignment of all boolean variables in the formula 
reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets;//current assignment for all integer variables in the formula
/////


reg in_enable;//should be 1 for the module to start
reg in_clk;//general clk
reg in_reset;//at posedge of reset,all outputs and internal regs are down to zero


///for formula set up
////////
reg [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clauses_enable;//this enable is propagated to all internal modules except for the internal memory for clauses
// for clause register setup
reg [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer;//coefficients of integer literal for one clause only 
reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean;//coefficients of boolean literals for one clause only
reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index;//the number of the clause
//////////


//enable for active propose 
////
reg [2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX-1:0] in_boolean_propose_enable;
reg [2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_integer_propose_enable;
////
reg  in_find_best_gain_enable;
wire [((((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_boolean;
wire [((((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_integer;

wire [(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)*TOTAL_NUMBER_OF_VARIABLES-1:0] out_gains;
wire [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] out_bestgain;
wire [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE) -1:0] out_best_assignment_integer;
wire [(((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE) -1:0] out_best_assignment_boolean;
wire out_done;
 LocalMove
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
localMove_testbench
(
 .in_boolean_current_assigmnets(in_boolean_current_assigmnets),
.in_integer_current_assigmnets(in_integer_current_assigmnets),
.in_clk(in_clk),
.in_reset(in_reset),

.in_clauses_enable(in_clauses_enable),
.in_clause_coefficients_integer(in_clause_coefficients_integer),
.in_clause_coefficients_boolean(in_clause_coefficients_boolean),
.in_clause_index(in_clause_index),
.in_find_best_gain_enable(in_find_best_gain_enable),
.in_boolean_propose_enable(in_boolean_propose_enable),
.in_integer_propose_enable(in_integer_propose_enable),

 .out_new_assignments_boolean(out_new_assignments_boolean),
 .out_new_assignments_integer(out_new_assignments_integer),
.out_gains(out_gains),
 .out_bestgain(out_bestgain),
.out_best_assignment_integer(out_best_assignment_integer),
.out_best_assignment_boolean(out_best_assignment_boolean),
.out_done(out_done)
 );








initial
    begin
    in_clk=0;
    end
    
    
    initial
    begin
    //at first set up the module(set the formula) 
    ////
    in_reset = 0;
    in_integer_current_assigmnets=8'h11;
    in_boolean_current_assigmnets=2'b10;
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
    #300;
    in_enable=1;
    in_clauses_enable=4'b1111;
    in_integer_propose_enable=2'b11;
    in_boolean_propose_enable=2'b11;
    in_find_best_gain_enable = 1;
      

    end
    
    
    always
    begin
    #100;
    in_clk = ~in_clk;
    end




endmodule
