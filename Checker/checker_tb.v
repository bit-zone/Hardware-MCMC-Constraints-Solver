`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:10:26 AM
// Design Name: 
// Module Name: checker_tb
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


module checker_tb(
    );
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4;//gives us the maximum bitwidth of coefficients in integer literal
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2;//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1;//gives us the maximum number of integer variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1;//gives us the maximum number of boolean variables in clause
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1;//gives us the maximum bitwidth of the value assigned to an integer variable
    parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 3;//gives us the maximum number of clauses

    //Binary
reg [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets;//the current assignment of all boolean variables in the formula 
reg [( (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) * 2 ) - 1: 0] in_boolean_coefficients;//coefficients of boolean variables in the clause
    // 00 -> not Exist and zero
    // 01 -> not Exist and one
    // 10 // Exist and zero
    // 11 // Exist and 1     
    // Should be >= 2 to be Exist

  
 //Integer
reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets;//current assignment for all integer variables in the formula
reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX) + 1)* MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT )-1:0] in_integer_coefficients;//coefficients of integer variables a1*y1+a2*y2+.. + bias <= 0


reg in_enable;//should be 1 for the module to start
reg in_clk;//general clk
reg in_reset;//at posedge of reset,all outputs and internal regs are down to zero


//outputs
wire out_clause_is_satisfied;//if the clause satisfied it is up to 1

wire  ready_flag;//if module is done it is up to 1


OneClauseChecker #(
MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX
)
checker_testbench
(
in_boolean_current_assigmnets,
in_boolean_coefficients,
in_integer_current_assigmnets,
in_integer_coefficients,
in_enable,
in_clk,
in_reset,
out_clause_is_satisfied,
ready_flag
); 

  initial
  begin
       in_clk=0;
  end
  
  always
  begin
      #100;
      in_clk = ~in_clk;
  end
  
  initial
  begin
  in_boolean_current_assigmnets = 4'b01;
  in_integer_current_assigmnets = 8'h11;
  in_enable = 1;
  in_reset = 0;
  
      #200;
      
in_boolean_coefficients = 4'b1111;
in_integer_coefficients = 12'h411;

      #200;

in_boolean_coefficients = 4'b1011;
in_integer_coefficients = 12'h511;

      #200;

in_boolean_coefficients = 4'b1011;
in_integer_coefficients = 12'h611;

      #200;

in_boolean_coefficients = 4'b1111;
in_integer_coefficients = 12'h311;
  end

endmodule
