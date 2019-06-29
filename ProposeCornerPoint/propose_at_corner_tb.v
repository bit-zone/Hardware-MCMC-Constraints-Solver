`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2019 01:15:36 PM
// Design Name: 
// Module Name: propose_at_corner_tb
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


module propose_at_corner_tb(

    );
       parameter MAXIMUM_BIT_WIDTH_OF_COEFFICIENT = 4;
       parameter MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX = 1;
      parameter MAX_BIT_WIDTH_OF_INTEGER_VARIABLE=4;
       parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=2;
    
        reg in_clk;
        reg in_reset;
        reg in_enable;
        // for clause register setup
        reg [((2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)+1//for the bias
        )*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]in_clause_coefficients_integer;//coefficients of integer literal for one clause only 
        
        reg [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index;//the number of the clause
         reg [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] in_variable_to_be_unchanced_index;
        //the assignment to check
        reg [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)-1:0]in_integer_assignment_before_move;
        
        reg [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]in_reduce_enable;
        wire [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0]new_assignmet_for_the_choosen_variable;
        
        
        propose_corner_point_edited#(
        .MAXIMUM_BIT_WIDTH_OF_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT),
        .MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX),
        .MAX_BIT_WIDTH_OF_INTEGER_VARIABLE(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE),
        .MAX_BIT_WIDTH_OF_CLAUSES_INDEX(MAX_BIT_WIDTH_OF_CLAUSES_INDEX)
        ) 
        TB(in_clk,
        in_reset,
        in_clause_coefficients_integer,
        in_clause_index,
        in_integer_assignment_before_move,
        in_variable_to_be_unchanced_index,
        in_reduce_enable,
        new_assignmet_for_the_choosen_variable
        );
        
            initial
            begin
            in_clk=0;
            end
            
            
            initial
            begin
            //at first set up the module(set the formula) 
            ////
            in_reset=1;
            #400;
            in_reset = 0;
            in_variable_to_be_unchanced_index=0;
            in_integer_assignment_before_move=8'h11;
            in_clause_coefficients_integer =12'h111;
            in_clause_index=0;
            #400;
            in_clause_coefficients_integer =12'h121;
            in_clause_index=1;
            #400;
            in_clause_coefficients_integer =12'h131;
            in_clause_index=2;    
            #400;
            in_clause_coefficients_integer =12'h141;
            in_clause_index=3;
            /////
            //after seting up the module ,enable it  
            #800;
            in_reduce_enable=4'b1111;
              
            //#400;
            //in_reset=1; 
            end
            
            
            always
            begin
            #200;
            in_clk = ~in_clk;
            end
        
        
        
endmodule
