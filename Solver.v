`include "TopModuleHeaders.vh"

module Solver(

input wire [(`NUMBER_OF_BOOLEAN_VARIABLES*2)-1:0] in_boolean_coefficients,
input wire [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_COEFFICIENTS)-1:0] in_integer_coefficients,

input wire  [`NUMBER_OF_BOOLEAN_VARIABLES-1:0] in_initial_boolean_assigmnets,
input wire  [(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] in_initial_integer_assigmnets,

input wire [7:0] in_pls0,
input wire [7:0] in_temperature,
input wire clk,

output reg [`NUMBER_OF_BOOLEAN_VARIABLES-1:0] out_boolean_valid_solution,
output reg  [(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] out_integer_valid_solution
);

reg  [`NUMBER_OF_BOOLEAN_VARIABLES-1:0] boolean_storage;
reg  [(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] integer_storage;
integer i=0;
//assign boolean_current_assignment
//assign
//MUX mux(boolean_old_assignment/*in*/,integer_old_assignments/*in*/,in_initial_boolean_assigmnets,in_initial_integer_assigmnets,assignment_selector,boolean_current_assignment);//choose  

//ProbabilisticSearch probabilisticsearch (); 




endmodule