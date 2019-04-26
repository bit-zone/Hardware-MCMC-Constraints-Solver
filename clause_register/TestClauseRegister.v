`timescale 1ns / 1ps
module TestClauseRegister(
    );
    parameter BIT_WIDTH_OF_INTEGER_VARIABLE=2;
    parameter NUMBER_OF_INTEGER_VARIABLES=2;
    parameter MODULE_IDENTIFIER=1;
    
    reg [(BIT_WIDTH_OF_INTEGER_VARIABLE * NUMBER_OF_INTEGER_VARIABLES) -1 : 0 ] in_clause_coefficients;
    reg in_calause_index;
    reg in_reset;
    reg in_clk;
    wire [(BIT_WIDTH_OF_INTEGER_VARIABLE * NUMBER_OF_INTEGER_VARIABLES) -1 : 0  ] out_clause_coefficients;
initial
 begin
in_clk = 0;
in_reset=1;
in_calause_index = 1;
forever
 #50
 in_clk = ~ in_clk;
end

initial
begin
 $monitor("Time=%t ++ the input coeffs line=%d  ++ clock=%b ++ the output coeffs line = %d  reset=%b",$realtime,in_clause_coefficients, in_clk, out_clause_coefficients,in_reset);           
//in_calause_index = 1;
#100
in_reset=0;
in_clause_coefficients = 1;

#100

//in_calause_index = 1;
in_clause_coefficients = 7;
#100

//in_calause_index = 1;
in_clause_coefficients = 8;
#100



in_calause_index = 0;
in_clause_coefficients = 9;
#100;


end
/*
initial
begin
 $display("output of testing CluaseRegister : ");

 end*/
    ClauseRegister
    uut(
         .in_clause_coefficients(in_clause_coefficients),
         .in_calause_index(in_calause_index),
         .in_reset(in_reset),
         .in_clk(in_clk),
         .out_clause_coefficients(out_clause_coefficients)
        );
        

    
endmodule
