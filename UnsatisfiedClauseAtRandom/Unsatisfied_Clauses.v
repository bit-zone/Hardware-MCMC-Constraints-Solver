// This module collect the unsatisfied clauses in one memory 
//input 
//one clause per cycle
//index of the clause
//reset
//clk


//for boolean
// 00 -> not Exist and zero
// 01 -> not Exist and one
// 10 // Exist and zero
// 11 // Exist and 1     
// Should be >= 2 to be Exist

// hint any Index in parameter -> use it with 2**

module UnsatisfiedClauses
#(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to a bool variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 3//gives us the maximum number of clauses
)

(
input in_clk,
input in_reset,
input in_read_enable,
input [2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0]in_checker_enable,

// ----- For the Coeffs

// for clause register setup
input [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer,//coefficients of integer literal for one clause only 

input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean,//coefficients of boolean literals for one clause only

input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,//the number of the clause


// ------ the assignment to check
input [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment,
input [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment,

output [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]  out_clause_coefficients_integer, // the integer literal of the unsatisfied clause

output [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] out_clause_coefficients_boolean, // the bool literal of the unsatisfied clause

output out_satisfied 
);
 
  
 //all the clauses in registers one for integer one for bool
  wire [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1) * MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]
  clauses_coefficients_integer
  [0:(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1];
  
  wire [(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)*MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT-1:0]
  clauses_coefficients_boolean
  [0:(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1];



   //outputs of checker module
   // we added one to the power for the memory of the tree 
 wire clause_satisfied  [0:(2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1) -1  )  -1] ;
 

// this for the index of the clauses 
 wire  [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0]  unsatisfied_clauses_index [0:(2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1) -1  )  -1]  ;


 wire checker_ready_flag[0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];
 


generate 
 genvar i;
 //this for loop used to load the formula during the setup state 
 for(i=0;i<(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX);i=i+1)begin:generate_formula_and_check_satisfiability
 //the integer part of the clause
 ClauseRegister_IntegerLiteral
 #( 
 .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),
 .NUMBER_OF_INTEGER_VARIABLES(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),
 .MODULE_IDENTIFIER(i),
 .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
 )
     clause_register_integer(
          .in_clause_coefficients(in_clause_coefficients_integer),
          .in_clause_index(in_clause_index),
          .in_reset(in_reset),
          .in_clk(in_clk),
          .out_clause_coefficients(clauses_coefficients_integer[i])
         );
         
 //the boolean part of the clause        
  ClauseRegister_BooleanLiteral
          #( 
          .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),
          .NUMBER_OF_BOOLEAN_VARIABLES(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),
          .MODULE_IDENTIFIER(i),
          .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)
          )
              clause_register_boolean(
                   .in_clause_coefficients(in_clause_coefficients_boolean),
                   .in_clause_index(in_clause_index),
                   .in_reset(in_reset),
                   .in_clk(in_clk),
                   .out_clause_coefficients(clauses_coefficients_boolean[i])
                  );   
                  


 //check on each clause with the current assignment                 
       OneClauseChecker

                   #(
                    .MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT),//gives us the maximum bitwidth of coefficients in integer literal
                    .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
                    .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),//gives us the maximum number of integer variables in clause
                    .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),//gives us the maximum number of boolean variables in clause
                    .MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),//gives us the maximum bitwidth of the value assigned to an integer variable
                    .MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE),//gives us the maximum bitwidth of the value assigned to an integer variable
                    .MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)//gives us the maximum number of clauses                   
                   )
       
                  check_on_clause 
                  (
                    .in_boolean_current_assigmnets(in_boolean_assignment),
                    .in_boolean_coefficients(clauses_coefficients_boolean[i]),          
                    .in_integer_current_assigmnets(in_integer_assignment),
                    .in_integer_coefficients(clauses_coefficients_integer[i]),  
                    .in_enable(in_checker_enable[i]),
                    .in_clk(in_clk),
                    .in_reset(in_reset),
                    .out_clause_is_satisfied(clause_satisfied[i]),
                    .ready_flag(checker_ready_flag[i])
                  ); 
 
 
 // for the indexes memory 
assign unsatisfied_clauses_index[i] = i; 
   
   
end




//the tree for comparing two clauses 
genvar j;
for (i=0;i<2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)-1;i=(i/2)+2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX))begin :generate_secod_level_in_the_tree_for_c1
         for(j=i;j<(i/2)+2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1;j=j+2)begin : generate_ith_level
           CompareTwoChecker
                         #(
                   .MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)//gives us the maximum number of clauses
                           )
           
           uut
           (
          .in_clause_1_index(unsatisfied_clauses_index[j]),
          .in_clause_1_satisfied(clause_satisfied[j]), 
          .in_clause_2_index(unsatisfied_clauses_index[j+1]),
          .in_clause_2_satisfied(clause_satisfied[j+1]),
          .in_setting(1'b1),
          .out_clause_index(unsatisfied_clauses_index[(i/2)+2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)+((j-i)/2)]),
          .out_clause_satisfied(clause_satisfied[(i/2)+2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)+((j-i)/2)])
         );
         
            end
end


endgenerate



// this output is for the clause is satisfied or not 
// if it's satisfied i.e = 1 this means thats all the formula is satisfied
// and we have a valid solution!


// last element in the memory is the output of the tree
assign out_satisfied = clause_satisfied  [(2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1) -1  )  -1];




// Memory instance
// outputs the bool and int coeff of the unsatisfied clause choosen at random

/*
FormulaModule formula1
(
    .in_clause_index(unsatisfied_clauses_index [(2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1) -1  )  -1]), //the number of the clause is the last element
    .in_read_enable(in_read_enable),
    .in_clk(in_clk),
    .out_clause_coefficients_integer(out_clause_coefficients_integer),
    .out_clause_coefficients_boolean(out_clause_coefficients_boolean)//coefficients of boolean literals for one clause only
);
*/

wire index_of_the_clause;

assign index_of_the_clause = unsatisfied_clauses_index[(2**(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1) -1  )  -1];
assign out_clause_coefficients_integer = clauses_coefficients_integer[index_of_the_clause];
assign out_clause_coefficients_boolean = clauses_coefficients_boolean[index_of_the_clause];

endmodule 
