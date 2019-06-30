`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2019 05:49:52 PM
// Design Name: 
// Module Name: formulaChecker_tb
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


module formulaChecker_tb(

    );

        parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4;//gives us the maximum bitwidth of coefficients in integer literal
        parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2;//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
        parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1;//gives us the maximum number of integer variables in clause
        parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1;//gives us the maximum number of boolean variables in clause
        parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4;//gives us the maximum bitwidth of the value assigned to an integer variable
        parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1;//gives us the maximum bitwidth of the value assigned to an integer variable
        parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2;//gives us the maximum number of clauses
    
        reg in_clk;
        reg in_reset;
        reg [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clause_enable;
        // for clause register setup
        reg [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
        )*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer;//coefficients of integer literal for one clause only 
        reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean;//coefficients of boolean literals for one clause only
        reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index;//the number of the clause
        //the assignment to check
        reg [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]in_integer_assignment_after_move;
        reg [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]in_boolean_assignment_after_move;
        reg in_enable;
        wire [2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] all_satisfied;
        wire  satisfied;
        
       formulaChecker
        #(
           MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT ,
           MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT ,
           MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
           MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
           MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
           MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
           MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX
        )
        formulaCheckerTB
        ( in_clk,
         in_reset,
         in_clause_enable,
         in_clause_coefficients_integer,
         in_clause_coefficients_boolean,
         in_clause_index,
         in_integer_assignment_after_move,
         in_boolean_assignment_after_move,
         in_enable,
         all_satisfied,
         satisfied
         );
        
        
        
        initial
        begin
        in_clk=0;
        end
        
        
        initial
        begin
        //at first set up the module(set the formula) 
        ////
        in_reset = 0;
        in_integer_assignment_after_move=8'h11;
        in_boolean_assignment_after_move=2'b10;
        in_clause_coefficients_integer =12'h411;
            in_clause_coefficients_boolean=4'b1111;
            in_clause_index=0;
            #200;
            in_clause_coefficients_integer =12'h511;
            in_clause_coefficients_boolean=4'b1011;
            in_clause_index=1;
            #200;
            in_clause_coefficients_integer =12'h611;
            in_clause_coefficients_boolean=4'b1011;
            in_clause_index=2;    
            #200;
            in_clause_coefficients_integer =12'h311;
            in_clause_coefficients_boolean=4'hf;
            in_clause_index=3;
        /////
        //after seting up the module ,enable it  
        #200;
        in_clause_enable=4'b1111;
        in_enable=1;  

        end
        
        
        always
        begin
        #100;
        in_clk = ~in_clk;
        end
        
        

    
    
endmodule
