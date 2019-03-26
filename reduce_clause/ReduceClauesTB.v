
`include "headers.v"
module ReduceClause_tb(
    );
   
   reg  [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients;//coefficients of integer variables a1*y1+a2*y2+..<=aN
   reg  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment;//the current value of integer variables y1,y2,...
   reg  [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_variable_to_be_unchanged_index;//the variable number
   reg in_enable;//the module only starts when the enable signal is 1
   reg in_reset;//if the reset is 1 all the modules signal are set to zero
   //the output of module is an equation (+/-)y1<=b
   wire signed [(`BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] out_bias;//out_bias=b (in the above equation)
   wire  out_variable_to_be_unchanged_sign ;//the sign of  y1 (in the above equation)
   wire out_active;//it says if the variable is on the clause or not

   ReduceClause myReduceClause(in_coefficients,in_current_assignment,in_variable_to_be_unchanged_index,in_enable,in_reset,out_bias,out_variable_to_be_unchanged_sign,out_active);    
   initial
    begin
       $monitor("out_bias =%d----the sign =%b----active_or_not = %b",out_bias,out_variable_to_be_unchanged_sign,out_active );
        in_reset = 1;
        in_enable = 0;
        #100;
        in_reset = 0;
        in_enable = 1;
// test case1
//1*x0+1*x1<=1
//x0=1 , x1=1
//choosen variable is x0
        #100;
        in_coefficients = 24'h010101;
        in_current_assignment = 16'h0101;
        in_variable_to_be_unchanged_index=0;

// test case2
// -1*x0+1*x1<=0
//x0=1 , x1=1
//choosen variable is x0
        #100;
        in_coefficients = 24'h0001ff;
        in_current_assignment = 16'h0101;
        in_variable_to_be_unchanged_index=0;
// test case3
//2*x0+1*x1<= 4
//x0=2 , x1=1
//choosen variable is x1
        #100;
        in_coefficients = 24'h040102;
        in_current_assignment = 16'h0102;
        in_variable_to_be_unchanged_index=1;
// test case4
//1*x1<= 4
//x0=2 , x1=1
//choosen variable is x1
        #100;
        in_coefficients = 24'h040100;
        in_current_assignment = 16'h0102;
        in_variable_to_be_unchanged_index=1;
// test case4
//1*x1<= 4
//x0=2 , x1=1
//choosen variable is x0
        #100;
        in_coefficients = 24'h040100;
        in_current_assignment = 16'h0102;
        in_variable_to_be_unchanged_index=0;

        
    end
endmodule