
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