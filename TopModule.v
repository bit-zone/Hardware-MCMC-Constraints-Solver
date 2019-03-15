parameter NUMBER_OF_CLAUSES = 3; // does not include "inside" constraint
parameter NUMBER_OF_INTEGER_VARIABLES = 2;
parameter NUMBER_OF_BOOLEAN_VARIABLES = 2;
parameter BIT_WIDTH_OF_INTEGER_VARIABLE = 16;
parameter BIT_WIDTH_OF_COEFFICIENTS = 16; // bit signed
parameter CLAUSE_BIT_WIDTH = (( NUMBER_OF_INTEGER_VARIABLES * BIT_WIDTH_OF_COEFFICIENTS )+(2 * NUMBER_OF_BOOLEAN_VARIABLES )) ; //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
parameter NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT = 1;

// GENERAL NOTE -> any probability will deal with it as an integer from 0->100 instead of 0 ->1

module TopModule(
input [7:0] in_pls0, // probability of local search move
input [7:0] in_temperature // Hyper Parameter for tuning 
);
    reg [CLAUSE_BIT_WIDTH - 1:0] formula [NUMBER_OF_CLAUSES : 0 ] ; // contains all the coeffiecient 
    reg [(NUMBER_OF_BOOLEAN_VARIABLES+(NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_INTEGER_VARIABLE))-1:0] initial_assigmnets;
 
    // sizes buffer will determine the parameter (constants values later)
   
    // read the formula from the text file generated from the pre-processing 
    initial
    begin
     $fread(testfile,"pre_processing.txt");
    end
    
    // control unit here to pass different clauses for the solver instances at every clock cycle     
    Solver solver(formula[i],in_pls0,in_temperature,initial_assigmnets);
endmodule