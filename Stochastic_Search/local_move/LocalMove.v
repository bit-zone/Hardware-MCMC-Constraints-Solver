`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2019 11:06:55 AM
// Design Name: 
// Module Name: LocalMove
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


module LocalMove
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
//general inputs 
//////////
input [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets,//the current assignment of all boolean variables in the formula 
input [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets,//current assignment for all integer variables in the formula
input in_clk,//general clk
input in_reset,//at posedge of reset,all outputs and internal regs are down to zero
//////////

//inputs for setting up the formula
//////////
input [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clauses_write_enable,//this enable for the clauses registers to write in the setup state
input [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer,//coefficients of integer literal for one clause only 
input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean,//coefficients of boolean literals for one clause only
input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,//the number of the clause
/////////

//inputs for internal modules
////////////////////////////
//the module consists of number of paths equals the maximum number of variables
//this enable for enabling the paths of active variables only  
input [2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX-1:0] in_boolean_propose_enable,//it enables active paths
input [2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_integer_propose_enable,//it enables active paths
input [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clauses_enable,// for indicating which clauses are active in the formula
//(as there is registers equals the maximum number of registers so we need enable for the existing ones)
input in_find_best_gain_enable,
////////////////////////////


//outputs 
output [((((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_boolean,
output [((((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)*TOTAL_NUMBER_OF_VARIABLES )-1:0] out_new_assignments_integer,
output [((MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)*TOTAL_NUMBER_OF_VARIABLES)-1:0] out_gains,
output [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] out_bestgain,
output [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE) -1:0] out_best_assignment_integer,
output [(((2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE) -1:0] out_best_assignment_boolean,
output reg out_done
    );
    
    //internal parameters
    parameter MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES = 2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX;
    parameter MAXIMUM_NUMBER_OF_INTEGER_VARIABLES = 2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX;   
    //internal wires
    /////////////////////////
    wire  [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] propose_out_new_assigmnet_boolean[0:MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+MAXIMUM_NUMBER_OF_INTEGER_VARIABLES-1];
    wire  [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] propose_out_new_assigmnet_integer[0:MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+MAXIMUM_NUMBER_OF_INTEGER_VARIABLES-1]; 
    wire [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] integer_assignment_for_one_variable[0:MAXIMUM_NUMBER_OF_INTEGER_VARIABLES-1]; 
    wire [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] propose_out_gain[0:MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+MAXIMUM_NUMBER_OF_INTEGER_VARIABLES-1];
    /////////////////////////

   generate
       genvar i; 
       genvar j; 
       //boolean paths
       //////////////////////
        for (i=0;i<MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES;i=i+1)begin :generate_boolean_path
        //first stage (boolean propose and get a new assignment)
             BooleanPropose
             #
             (
             MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
             MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
             MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
             MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX
             )
             propose_boolean_for_active_variables
             (
             .in_clk(in_clk),
             .in_current_assignment_boolean(in_boolean_current_assigmnets),
             .in_variable_to_be_changed_index(i),
             .in_enable(in_boolean_propose_enable[i]),
             .out_new_assignment_Boolean(propose_out_new_assigmnet_boolean[i])
                 );
             assign propose_out_new_assigmnet_integer[i]=in_integer_current_assigmnets;
             assign out_new_assignments_boolean[((i+1)*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1:i*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)]= propose_out_new_assigmnet_boolean[i]; 
             assign out_new_assignments_integer[((i+1)*(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE ))-1:i*(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )]= propose_out_new_assigmnet_integer[i]; 
          
          
             //second stage (evaluate the new assignment generated)     
             ComputeGain
             #(
             .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
             .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),
             .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
             .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
             .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),
             .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE),
             .MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
             )
             compute_gain_for_each_boolean_proposed_assignment
             (
             .in_clk(in_clk),
             .in_reset(in_reset),
             .in_clause_enable(in_clauses_enable),
             .in_clause_coefficients_integer(in_clause_coefficients_integer),
             .in_clause_coefficients_boolean(in_clause_coefficients_boolean),
             .in_clause_index(in_clause_index),
             .in_integer_assignment_after_move(propose_out_new_assigmnet_integer[i]),
             .in_boolean_assignment_after_move(propose_out_new_assigmnet_boolean[i]),
             .in_enable(in_boolean_propose_enable[i]),
             .out_number_of_satisfied_clauses(propose_out_gain[i])
              );
              assign out_gains[((i+1)*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1))-1:i*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)]= propose_out_gain[i];
        end
       //////////////////////
       
       
       //integer paths
       //////////////////////
       // first stage(generate new assignment for the specific choosen variable)
        for (i=0;i<MAXIMUM_NUMBER_OF_INTEGER_VARIABLES;i=i+1)begin :generate_integer_propose
             propose_corner_point_edited
           #(
           .MAXIMUM_BIT_WIDTH_OF_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
           .MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
           .MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),
           .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
           )
           propose_integer_for_each_active_variable
           (
           .in_enable(in_integer_propose_enable[i]),
           .in_clk(in_clk),
           .in_reset(in_reset),
           .in_clause_coefficients(in_clause_coefficients_integer),
           .in_clause_index(in_clause_index),
           .in_assignment_before_move(in_integer_current_assigmnets),
           .in_variable_to_be_unchanced_index(i),
           .in_reduce_enable(in_clauses_enable),
           .new_assignmet_for_the_choosen_variable(integer_assignment_for_one_variable[i])
           );
            
        // second stage(combine the new assignment for the specific variable with the rest assignments)          
            UpdateAssignment
           #(
           .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
           .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
           .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),
           . MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE)
           )
           update_assignment
           (
           .in_boolean_variable_index(0),//dont care as it is always integer
           .in_integer_variable_index(i),
           .in_new_assignment_for_integer_variable(integer_assignment_for_one_variable[i]),
           .in_new_assignment_for_boolean_variable(0),
           .in_boolean_or_integer(0),//always integer
           .in_integer_assignment_before_move(in_integer_current_assigmnets),
           .in_boolean_assignment_before_move(in_boolean_current_assigmnets),
           .out_integer_assignment_after_move(propose_out_new_assigmnet_integer[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i]),
           .out_boolean_assignment_after_move(propose_out_new_assigmnet_boolean[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i])
           
               );
             assign out_new_assignments_boolean[((i+1+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1:(i+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)]= propose_out_new_assigmnet_boolean[i+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES]; 
             assign out_new_assignments_integer[((i+1+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE ))-1:(i+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )]= propose_out_new_assigmnet_integer[i+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES]; 
                      
        // third stage(evaluate the new assignment)           
           ComputeGain
                 #(
                 .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
                 .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),
                 .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
                 .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
                 .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),
                 .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE),
                 .MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
                 )
                 compute_gain_for_each_integer_proposed_assignment
                 (
                 .in_clk(in_clk),
                 .in_reset(in_reset),
                 .in_clause_enable(in_clauses_enable),
                 .in_clause_coefficients_integer(in_clause_coefficients_integer),
                 .in_clause_coefficients_boolean(in_clause_coefficients_boolean),
                 .in_clause_index(in_clause_index),
                 .in_integer_assignment_after_move(propose_out_new_assigmnet_integer[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i]),
                 .in_boolean_assignment_after_move(propose_out_new_assigmnet_boolean[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i]),
                 .in_enable(in_integer_propose_enable[i]),
                 .out_number_of_satisfied_clauses(propose_out_gain[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i])
                  );
                  assign out_gains[((i+1+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1))-1:((i+MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES)*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1))]= propose_out_gain[MAXIMUM_NUMBER_OF_BOOLEAN_VARIABLES+i];
        end  
       //////////////////////

                   
  endgenerate  
  
  
  //finding the final new assignment
  //////////////////////

   find_best_gain
  #
  (
  MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT ,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
  MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
  MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
  MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
  MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX ,
  TOTAL_NUMBER_OF_VARIABLES
  )
  find_gain
  (
 .in_enable(in_find_best_gain_enable),
 .in_clk(in_clk),
 .in_reset(in_reset), 
 .in_boolean_assignments(out_new_assignments_boolean),
 .in_integer_assignments(out_new_assignments_integer),
 .in_gains(out_gains),
 .out_best_gain(out_bestgain), 
 .out_best_integer_assignment(out_best_assignment_integer),
 .out_best_boolean_assignment(out_best_assignment_boolean)
     
  
    );   
 
  //////////////////////
      
always @(posedge in_clk)
begin
    if(out_bestgain)
        out_done<=1;
    else
        out_done<=0;    
 end    
    
endmodule

