`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2019 04:39:24 AM
// Design Name: 
// Module Name: compare_two_gains
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


module compare_two_gains
#
(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2//gives us the maximum number of clauses

)
(
input [ MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0]in_gain1,
input [ MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0]in_gain2,

input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment1,
input [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment1,

input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment2,
input [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment2,

output reg [ MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0]out_best_gain,
output reg[MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0] out_best_integer_assignment,
output reg [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]out_best_boolean_assignment

    );
    always@(*)
    begin
    if(in_gain1>in_gain2)
    begin
    out_best_gain=in_gain1;
    out_best_integer_assignment=in_integer_assignment1;
    out_best_boolean_assignment=in_boolean_assignment1;
    end
    else
    begin
        out_best_gain=in_gain2;
        out_best_integer_assignment=in_integer_assignment2;
        out_best_boolean_assignment=in_boolean_assignment2;
    end
    end
endmodule
