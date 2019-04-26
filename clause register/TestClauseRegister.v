
`include "TopModuleHeaders.vh"

module TestClauseRegister(
    );
    
    
             reg [(`BIT_WIDTH_OF_INTEGER_VARIABLE * `NUMBER_OF_INTEGER_VARIABLES) -1 : 0 ] in_clause_coefficients;
             reg in_write_enable;
             reg in_clk;
             wire [(`BIT_WIDTH_OF_INTEGER_VARIABLE * `NUMBER_OF_INTEGER_VARIABLES) -1 : 0  ] out_clause_coefficients;
          
    
    
    
    
initial
 begin
in_clk = 0;
forever
 #50 in_clk = ~ in_clk;
end

initial
begin
           
in_write_enable = 0;
#100

in_write_enable = 1;
in_clause_coefficients = 7;
#100

in_write_enable = 0;
in_clause_coefficients = 8;
#100



in_write_enable = 1;
in_clause_coefficients = 9;
#100;


end

initial
begin
 $display("output of testing CluaseRegister : ");
 $monitor(" the output coeffs line = %d",  out_clause_coefficients);
 end
          
    
    
    
    ClauseRegister uut(
         .in_clause_coefficients(in_clause_coefficients),
         .in_write_enable(in_write_enable),
         .in_clk(in_clk),
         .out_clause_coefficients(out_clause_coefficients)
        );
        

    
endmodule
