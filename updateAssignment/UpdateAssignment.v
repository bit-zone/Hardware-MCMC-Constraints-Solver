`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2019 12:46:46 AM
// Design Name: 
// Module Name: UpdateAssignment
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


module UpdateAssignment
#(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 2,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 2,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=2//gives us the maximum bitwidth of the value assigned to an integer variable
)
(
input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0]in_variable_index,
input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0]in_new_assignment_for_variable,
input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment_before_move,
input [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment_before_move,
output [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]out_integer_assignment_after_move,
output [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]out_boolean_assignment_after_move

    );
  assign out_boolean_assignment_after_move =in_boolean_assignment_before_move;//pass boolean assignment as it is
 
 wire signed [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] in_current_assignment_array[0:2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1];// local 2d array for the current assignment
 reg signed [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] out_current_assignment_array[0:2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1];// local 2d array for the current assignment

      generate
      genvar j;
       for( j=0;j<2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX;j=j+1)
         begin:input_flatenning
             assign in_current_assignment_array[j] =in_integer_assignment_before_move[((MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1)+j*(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)):(j*MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)];
             assign out_integer_assignment_after_move[((MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1)+j*(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)):(j*MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)]= out_current_assignment_array[j] ;
         end    
       endgenerate
       integer i;
    always@(*)
    begin
    for(i=0;i<2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX;i=i+1)
    begin
    if(i!=in_variable_index)
        out_current_assignment_array[i]=in_current_assignment_array[i];
    else
        out_current_assignment_array[i]=in_new_assignment_for_variable;
    end
    end
endmodule
