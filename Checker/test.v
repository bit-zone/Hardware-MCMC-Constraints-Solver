`include "headers.v"

module Checker_tb;
reg [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause1;//coefficients of integer variables a1*y1+a2*y2+..<=aN
reg [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause2;//coefficients of integer variables a1*y1+a2*y2+..<=aN
reg [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment;//the current value of integer variables y1,y2,...
reg in_reset;
reg in_enable;
wire clause1_flag;
wire clause2_flag;
checker mychecker(in_coefficients_clause1,in_coefficients_clause2,in_current_assignment,in_reset,in_enable,clause1_flag,clause2_flag); 
initial
    begin
       $monitor("flag1 =%b----flag2= %b",clause1_flag,clause2_flag );
        in_reset = 1;
        in_enable = 0;
        #10;
        in_reset = 0;
        in_enable = 1;
        #50;
        //flag1=0
	//flag2=0
        in_coefficients_clause1=24'h020101;
        in_coefficients_clause2=24'h010101;
        in_current_assignment=16'h0101;
        #50;
 	//flag1=1
	//flag2=1
        in_coefficients_clause1=24'h020101;
        in_coefficients_clause2=24'h010101;
        in_current_assignment=16'hffff;
	#50;
 	//flag1=1
	//flag2=0
        in_coefficients_clause1=24'h020101;
        in_coefficients_clause2=24'h030101;
        in_current_assignment=16'hffff;
	#50;
 	//flag1=0
	//flag2=1
        in_coefficients_clause1=24'h040101;
        in_coefficients_clause2=24'h010101;
        in_current_assignment=16'hffff;
   end
endmodule
//
