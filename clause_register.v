
`include "TopModuleHeaders.vh"


// Inputs
// 1) Clause coeffs
// 2) Write enable 
// 3) Clk

// Outputs
// New Clause coeff


module ClauseRegister(
     
     input [(`BIT_WIDTH_OF_INTEGER_VARIABLE * `NUMBER_OF_INTEGER_VARIABLES) -1 : 0 ] in_clause_coefficients,
     input in_write_enable,
     input in_clk,
     output reg [(`BIT_WIDTH_OF_INTEGER_VARIABLE * `NUMBER_OF_INTEGER_VARIABLES) -1 : 0  ] out_clause_coefficients
  
    );
    
        
    always @(posedge in_clk)
    begin
       
       if(in_write_enable)
        out_clause_coefficients = in_clause_coefficients;       
    end
 
endmodule