`timescale 1ns / 1ps
// Inputs
// 1) Clause coeffs
// 2) Write enable 
// 3) Clk

// Outputs
// New Clause coeff
module ClauseRegister
#(
    parameter BIT_WIDTH_OF_INTEGER_VARIABLE=2,
    parameter NUMBER_OF_INTEGER_VARIABLES=2,
    parameter MODULE_IDENTIFIER=1,
    parameter MAX_NUMBER_OF_CLAUSES=1
)(
     
     input [(BIT_WIDTH_OF_INTEGER_VARIABLE * NUMBER_OF_INTEGER_VARIABLES) -1 : 0 ] in_clause_coefficients,
     input [MAX_NUMBER_OF_CLAUSES-1:0]in_calause_index,
     input in_reset,
     input in_clk,
     
     output reg [(BIT_WIDTH_OF_INTEGER_VARIABLE * NUMBER_OF_INTEGER_VARIABLES) -1 : 0  ] out_clause_coefficients
  
    );
    
        
    always @(posedge in_clk)
    begin
       if(in_reset)
        out_clause_coefficients <= {(BIT_WIDTH_OF_INTEGER_VARIABLE * NUMBER_OF_INTEGER_VARIABLES)  {1'b0}};
        else begin
           if(in_calause_index==MODULE_IDENTIFIER)
            out_clause_coefficients <= in_clause_coefficients;
           else
            out_clause_coefficients<=out_clause_coefficients;
        end          
    end
 
endmodule