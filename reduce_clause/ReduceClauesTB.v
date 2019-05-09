`timescale 1ns/1ns
module ReduceClause_tb(
    );
   parameter MAXIMUM_BIT_WIDTH_OF_COEFFICIENT = 8;
   parameter MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX = 2;
   reg  [(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT*(2** MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX+1))-1:0] in_coefficients;//coefficients of integer variables a1*y1+a2*y2+..<=aN
   reg  [(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT*2** MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)-1:0] in_current_assignment;//the current value of integer variables y1,y2,...
   reg  [MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX-1:0] in_variable_to_be_unchanged_index;//the variable number
   reg in_clk;//the general clock
   reg in_enable;//the module only starts when the enable signal is 1
   reg in_reset;//if the reset is 1 all the modules signal are set to zero
   //the output of module is an equation (+/-)y1<=b
    wire signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0] out_Bias;//out_bias=b (in the above equation)
    wire out_Variable_to_be_unchanged_sign ;//the sign of  y1 (in the above equation)
   //1 if the sign is +ve
   //0 if the sign is -ve
    wire out_Active;//it says if the variable is on the clause or not
   ReduceClause#(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT,MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX) myReduceClause (in_coefficients,in_current_assignment,in_variable_to_be_unchanged_index,in_clk,in_enable,in_reset,out_Bias,out_Variable_to_be_unchanged_sign,out_Active);    
  
   always 
   begin
   #100;
   in_clk=~in_clk;
   end
   
   initial
    begin
       $monitor("out_bias =%d----the sign =%b----active_or_not = %b",out_Bias,out_Variable_to_be_unchanged_sign,out_Active );
        in_clk=0;
        in_reset = 0;
        in_enable = 1;
// test case1
//1*x0+1*x1+1<=0
//x0=1 , x1=1 
//choosen variable is x0
//output should be x0+2 <= 0
        
        in_coefficients = 24'h010101;
        in_current_assignment = 16'h0101;
        in_variable_to_be_unchanged_index=0;

// test case2
// -1*x0+1*x1+1<=0
//x0=1 , x1=1 
//choosen variable is x0
//output should be x0-2 >= 0
        #200;
        in_coefficients = 24'h0101ff;
        in_current_assignment = 16'h0101;
        in_variable_to_be_unchanged_index=0;
// test case3
// 1*x0+1*x1+1<=0
//x0=1 , x1=2 
//choosen variable is x0
//output should be x1+3 <= 0
        #200;
        in_coefficients = 24'h010101;
        in_current_assignment = 16'h0201;
        in_variable_to_be_unchanged_index=0;
//test case4
//all outputs should be unchanged
        #200;
        in_enable = 0;
//test case5
//all outputs should be zero
        #200;
        in_reset = 1;
        
    end
endmodule