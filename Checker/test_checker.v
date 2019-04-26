`timescale 1ns / 1ps





module test_checker;


reg [ (2**2) - 1 : 0] in_boolean_current_assigmnets = 0101 ; 
reg [( (2**2) * 2 ) - 1: 0] in_boolean_coefficients =8'h4E ;
// current bool assignment =  0    1    0    1
// coeffs register         =  01   00   11   10




reg [(((2**1))* 8 )-1:0] in_integer_current_assigmnets = 16'h02_01 ; // x1 =1 , x2 = 2
reg [(((2**1) + 1)* 8 )-1:0] in_integer_coefficients = 24'hFE0A07 ;//coefficients x1 = 7 , x2 = 10 , bias = -2


/*
Make integer buffers values like this to make it satisfied
reg [(((2**1))* 8 )-1:0] in_integer_current_assigmnets = 16'hFE_01 ; // x1 =1 , x2 = -2
reg [(((2**1) + 1)* 8 )-1:0] in_integer_coefficients = 24'hFE0A07 ;//coefficients x1 = 7 , x2 = 10 , bias = 2
*/

/*
// 7x1 + 10x2 <= 2
// x1 = 1
// x2 = -2
// 7 -2(10) -2 = -15
*/


reg in_enable;
reg in_clk;
wire out_clause_is_satisfied;


 initial begin
 
 in_clk = 0;
  forever
   #50 in_clk = ~in_clk;
 end
   


initial 
begin
#10 in_enable = 1;
end



  initial
  begin
   $display("output of testing the checker");
   $monitor(" the clause is : %d", out_clause_is_satisfied );
    end
    





OneClauseChecker #(1) uut ( // 2 variables only  


//Binary
.in_boolean_current_assigmnets(in_boolean_current_assigmnets), 
.in_boolean_coefficients(in_boolean_coefficients),
  
 //Integer
.in_integer_current_assigmnets(in_integer_current_assigmnets),
.in_integer_coefficients(in_integer_coefficients),//coefficients of integer variables a1*y1+a2*y2+.. + bias <= 0

.in_enable(in_enable),
.in_clk(in_clk),
.out_clause_is_satisfied(out_clause_is_satisfied)
);


endmodule



