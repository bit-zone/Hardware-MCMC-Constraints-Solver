`timescale 1ns / 1ps
`define DISCRETE_VARIABLE_INDEX_BIT_WIDTH 2 //4 discrete variabeles
`include "TopModuleHeaders.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2019 05:17:25 PM
// Design Name: 
// Module Name: discrete range randomizer
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
module DiscreteRangeRandomizer(
    input wire in_clock,
    input wire in_enable,
    input wire [7:0]in_seed,
    
    input wire [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH-1:0 ]in_variable_index,
    
    output wire [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output wire [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end,
    output wire out_equal
    );
    
    
    reg reset;
    reg index_of_the_discrete_value;
    wire [7:0] number_of_discrete_assignments; 
    
    assign out_equal=(out_start==out_end)?1:0;
    
    
    DiscreteVariablesSizes discrete_variables_sizes(
        in_variable_index,
        number_of_discrete_assignments
    );
    
     RandomGenerator  random_generator(
     .in_clock(in_clock), 
     .in_reset(reset),
     .in_enable(in_enable),
     .in_min(0),
     .in_max(number_of_discrete_assignments),
     .in_seed(in_seed), 
     .out_random(index_of_the_discrete_value)
    );
    DiscreteValuesTable discrete_values_table(
    in_variable_index,
    index_of_the_discrete_value,
    
    out_start,
    out_end,
    );
endmodule
