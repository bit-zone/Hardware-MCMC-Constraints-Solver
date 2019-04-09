`include "TopModuleHeaders.vh"
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


// the number of elements inside the "insside constraints"
module DiscreteVariablesSizes(
    input [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH - 1 : 0] in_variable_index,
    output reg [`DISCRETE_VALUES_NUMBER_BIT_WIDTH - 1:0] out_number_of_discrete_assignments    
   );
    
    
    reg [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH - 1 : 0] number_of_discrete_variables_table [0:`DISCRETE_VALUES_NUMBER_BIT_WIDTH - 1]; // we have maximum 4 variables and maximum 4 elements inside
    always @(in_variable_index)
    begin
        out_number_of_discrete_assignments <= number_of_discrete_variables_table[in_variable_index];
    end
    initial
        begin
        // before you start simulation you just put your input files path
            $readmemb("D:\\projects\\0IMP_Projects\\GP\\tables.txt",number_of_discrete_variables_table);
             /* the loaded example
                 011
                 010
                 000
                 100
                 000
                 010
                 010
                 000
                  */
                  
            $display("Who Cares? ");
            $display("%b",number_of_discrete_variables_table[0]);
        end
            
endmodule






