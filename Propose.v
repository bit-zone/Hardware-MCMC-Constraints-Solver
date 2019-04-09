`timescale 1ns / 1ps
`include "TopModuleHeaders.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2019 07:39:57 PM
// Design Name: 
// Module Name: Propose
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

// Inputs 
// 1) SEED
// 2) Selected Variable Index for Random Chooser 
// 3) Clock 
// 4) Enable 
// 5) Current Assignment 
// 6) Coeff's


// Outputs
// New Assignment for the Selected Variable 


module Propose(
// To be Edited yest After Liverpool match

       // Current Assignment and Coeff's
      input  [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] VariableChooser_coefficients_ReduceClause1,
      input [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] VariableChooser_current_assignment_ReduceClause1,
         
      input wire signed [7:0] in_seed,
      input wire [2:0] in_enable_flag, // 00 -> Boolean propose
                                    // 01 -> Continous propose
                                    // 11 ->  Discrete propose
     
      input wire in_clock,
      
      input wire [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_choosen_index,
      output reg [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_variable_assignment
    );



// Instantiation
ProposeIntegerContinuous continuous1(
.in_clock(in_clock),
.VariableChooser_coefficients_ReduceClause1(VariableChooser_coefficients_ReduceClause1),
.VariableChooser_variable_to_be_unchanged_index_ReduceClause1(),
.VariableChooser_coefficients_ReduceClause2(),
.VariableChooser_variable_to_be_unchanged_index_ReduceClause1(),
.VariableChooser_variable_to_be_unchanged_index_ReduceClause2(),
.in_enable_ReduceClause1(),
.in_reset_ReduceClause1(),
.in_enable_ReduceClause2(),
.in_reset_ReduceClause2(),

////inputs to SelectSegment
.in_reset_SelectSegment(), 
.in_enable_SelectSegment(),
.in_seed_SelectSegment(), 

////outputs from select segment
.SelectSegment_start_Mux(),
.SelectSegment_end_Mux(),
.SelectSegment_type_Mux(),
.SelectSegment_weight_Mux()
);

endmodule