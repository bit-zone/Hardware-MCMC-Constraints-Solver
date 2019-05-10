`timescale 1ns / 1ps
// Inputs
// 1) Clause coeffs
// 2) Write enable 
// 3) Clk

// Outputs
// New Clause coeff
module ClauseRegister_IntegerLiteral
#(
    parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT=2,
    parameter NUMBER_OF_INTEGER_VARIABLES=2,
    parameter MODULE_IDENTIFIER=1,
    parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=1
)(
     
     input [(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT * (NUMBER_OF_INTEGER_VARIABLES+1//for the bias
     )) -1 : 0 ] in_clause_coefficients,
     input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0]in_clause_index,
     input in_reset,
     input in_clk,                                                                    
     output reg [(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT * (NUMBER_OF_INTEGER_VARIABLES+1//for the bias
     )) -1 : 0  ] out_clause_coefficients
  
    );
    
        
    always @(posedge in_clk)
    begin
       if(in_reset)
        out_clause_coefficients <= {(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT * NUMBER_OF_INTEGER_VARIABLES)  {1'b0}};
        else begin
        
           if(in_clause_index==MODULE_IDENTIFIER)
            out_clause_coefficients <= in_clause_coefficients;
           else
            out_clause_coefficients<=out_clause_coefficients;
        end          
    end
 
endmodule

module ClauseRegister_BooleanLiteral
#(
 parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT=2,
 parameter NUMBER_OF_BOOLEAN_VARIABLES=2,
 parameter MODULE_IDENTIFIER=1,
 parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=1
)
(
input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*NUMBER_OF_BOOLEAN_VARIABLES)-1 : 0 ] in_clause_coefficients,
     input [MAX_BIT_WIDTH_OF_CLAUSES_INDEX-1:0]in_clause_index,
     input in_reset,
     input in_clk,
                                                                       
     output reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*NUMBER_OF_BOOLEAN_VARIABLES) -1 : 0  ] out_clause_coefficients
);
always @(posedge in_clk)
    begin
       if(in_reset)
        out_clause_coefficients <= {(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT * NUMBER_OF_BOOLEAN_VARIABLES)  {1'b0}};
        else begin
           if(in_clause_index==MODULE_IDENTIFIER)
            out_clause_coefficients <= in_clause_coefficients;
           else
            out_clause_coefficients<=out_clause_coefficients;
        end          
    end
endmodule
