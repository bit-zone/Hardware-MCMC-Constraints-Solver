`timescale 1ns / 1ps


`include "TopModuleHeaders.vh"
///////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2019 11:40:55 AM
// Design Name: 
// Module Name: DiscreteValuesTable
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


module DiscreteValuesTable(
    input [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH-1:0 ]in_variable_index,
    input [`DISCRETE_VALUES_NUMBER_BIT_WIDTH-1:0]in_index_of_the_discrete_value,
    
    output [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end
    );
    wire [(`DISCRETE_VARIABLE_INDEX_BIT_WIDTH-1)+(`DISCRETE_VALUES_NUMBER_BIT_WIDTH-1):0] discrete_value_address={in_variable_index,in_index_of_the_discrete_value};                      
endmodule
