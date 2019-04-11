//`include "headers.v"
//`include "TopModuleHeaders.v"


// set this file as a global include
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_CLAUSES_BIT_WIDTH 2 // assuming 3 Clauses 
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



/////// MANAR Headers ///////////
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 8
`define BIT_WIDTH_OF_INTEGER_COEFFICIENTS 8 // bit signed                                                                      this | 8 is for the bias
`define CLAUSE_BIT_WIDTH (( 2 * `NUMBER_OF_BOOLEAN_VARIABLES )+(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_COEFFICIENTS )+8) //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT  1
`define BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX 1
`define BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX 1
`define BIT_WIDTH_OF_GENERAL_VARIABLE_INDEX 2



//Inputs
// 1) Clause 1 coeff
// 2) Clause 2 coeff
// 3) Current Assignmemnts
// 4) Reset
// 5) enable 

//Outputs 
// Number of Unsatisfied Clauses 


module NumberOfUClauses(
    
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause1,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause2,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment,//the current value of integer variables y1,y2,...
input in_reset,//to erase all the internal registers
input in_enable,
    
output [(`NUMBER_OF_CLAUSES_BIT_WIDTH - 1) : 0 ] no_unsatisfied 
);
    
    
    
wire [`NUMBER_OF_CLAUSES_BIT_WIDTH:0] out_satisfied_flag;
reg [(`NUMBER_OF_CLAUSES_BIT_WIDTH - 1) : 0 ] counter = 0;

reg [(`NUMBER_OF_CLAUSES_BIT_WIDTH - 1) : 0 ] i;
 
always @ (*)
begin
for (i = 0 ; i <  `NUMBER_OF_CLAUSES ; i = i+1)
    begin
    
    if(out_satisfied_flag[i] == 1) // if it's unsatisfied clause
        counter = counter + 1; 
    
    end
   
 end
    
assign no_unsatisfied = counter;
    
// Checker Module Instantiation 
checker checker_1(
.in_coefficients_clause1(in_coefficients_clause1),//coefficients of integer variables a1*y1+a2*y2+..<=aN
.in_coefficients_clause2(in_coefficients_clause2),//coefficients of integer variables a1*y1+a2*y2+..<=aN
.in_current_assignment(in_current_assignment),//the current value of integer variables y1,y2,...
.in_reset(in_reset),//to erase all the internal registers
.in_enable(in_enable),
.out_satisfied_flag(out_satisfied_flag)
);
 
 
 
 
 
endmodule
