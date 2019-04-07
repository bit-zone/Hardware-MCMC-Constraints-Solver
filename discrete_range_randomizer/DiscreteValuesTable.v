`timescale 1ns / 1ps

// set this file as a global include
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 8
`define BIT_WIDTH_OF_INTEGER_COEFFICIENTS 8 // bit signed                                                                      this | 8 is for the bias
`define CLAUSE_BIT_WIDTH (( 2 * `NUMBER_OF_BOOLEAN_VARIABLES )+(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_COEFFICIENTS )+8) //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT  1

`define BOOLEAN_COEFFICIENTS_END `CLAUSE_BIT_WIDTH-(`NUMBER_OF_BOOLEAN_VARIABLES*2)
`define INTEGER_COEFFICIENTS_START `BOOLEAN_COEFFICIENTS_END-1
// clause form with 2 boolean variables and one integer
  //00         00          00000000        00000000
//bool var 1 bool var2     integer coeff     bias


//defines for DiscreteRangeRandomizer
///////////////////////////////////////////////////////////////////////
`define NUMBER_OF_DISCRETE_VARIABLES 4
`define DISCRETE_VARIABLE_INDEX_BIT_WIDTH 2 //4 discrete variabeles

`define NUMBER_OF_DISCRETE_VALUES_FOR_ONE_VARIABLE 4 
`define DISCRETE_VALUES_NUMBER_BIT_WIDTH 2
///////////////////////////////////////////

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
    
    
    output wire equal,
    output reg [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output reg [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end
    
    );
    wire [(`DISCRETE_VARIABLE_INDEX_BIT_WIDTH-1)+(`DISCRETE_VALUES_NUMBER_BIT_WIDTH-1):0] discrete_value_address= {in_variable_index,in_index_of_the_discrete_value};  
     
    reg [(`BIT_WIDTH_OF_INTEGER_VARIABLE*2)-1:0]discrete_values[0:(`NUMBER_OF_DISCRETE_VARIABLES * `NUMBER_OF_DISCRETE_VALUES_FOR_ONE_VARIABLE)];
    
    assign equal=(out_start==out_end)?1:0;
    
    always @(discrete_value_address)
    begin
        out_start<= discrete_values [discrete_value_address][(`BIT_WIDTH_OF_INTEGER_VARIABLE*2)-1:`BIT_WIDTH_OF_INTEGER_VARIABLE] ;
        out_start<= discrete_values [discrete_value_address][(`BIT_WIDTH_OF_INTEGER_VARIABLE-1):0] ;
    end                                       
endmodule
