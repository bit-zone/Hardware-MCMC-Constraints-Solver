`define NUMBER_OF_CLAUSES 3 // does not include "inside" constraint
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 32
`define CLAUSE_BIT_WIDTH ((NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_COEFFICIENTS)+(2*NUMBER_OF_BOOLEAN_VARIABLES))//(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define BIT_WIDTH_OF_COEFFICIENTS 16 // bit signed
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT 1
module TopModule;
    reg [CLAUSE_BIT_WIDTH-1:0] formula [NUMBER_OF_CLAUSES]
    reg [(NUMBER_OF_BOOLEAN_VARIABL+(NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_INTEGER_VARIABLE))-1:0] initial_assigmnets 
    // sizes buffer
    Solver solver(formula[1],pls0,temperature,initial_assigmnets);

endmodule