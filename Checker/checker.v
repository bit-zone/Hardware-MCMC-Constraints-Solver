//////////////////////////////////////////////////////////////////////////////////
//the checker module is a combinational module that check the satisfiability of the clauses
////////////////////////////////////////////////////////////////////////////////////

// set this file as a global include
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_CLAUSES_BIT_WIDTH 2 // assuming 3 Clauses 
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 8
`define BIT_WIDTH_OF_INTEGER_COEFFICIENTS 8 // bit signed                                                                      this | 8 is for the bias
`define CLAUSE_BIT_WIDTH (( 2 * `NUMBER_OF_BOOLEAN_VARIABLES )+(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_COEFFICIENTS )+8) //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT  1

`define BOOLEAN_COEFFICIENTS_END `CLAUSE_BIT_WIDTH-(`NUMBER_OF_BOOLEAN_VARIABLES*2)
`define INTEGER_COEFFICIENTS_START `BOOLEAN_COEFFICIENTS_END-1
// clause form with 2 boolean variables and one integer
  //00         00          00000000        00000000
//bool var 1 bool var2     integer coeff     bias


//defines for DiscreteRangeRandomizer
///////////////////////////////////////////////////////////////////////
`define NUMBER_OF_DISCRETE_VARIABLES 4
`define DISCRETE_VARIABLE_INDEX_BIT_WIDTH 2 //4 discrete variabeles

`define NUMBER_OF_DISCRETE_VALUES_FOR_ONE_VARIABLE 4 
`define DISCRETE_VALUES_NUMBER_BIT_WIDTH 2
///////////////////////////////////////////



/////// MANAR Headers ///////////
`define NUMBER_OF_CLAUSES  3 // does not include "inside" constraint
`define NUMBER_OF_INTEGER_VARIABLES 2
`define NUMBER_OF_BOOLEAN_VARIABLES 2
`define BIT_WIDTH_OF_INTEGER_VARIABLE 8
`define BIT_WIDTH_OF_INTEGER_COEFFICIENTS 8 // bit signed                                                                      this | 8 is for the bias
`define CLAUSE_BIT_WIDTH (( 2 * `NUMBER_OF_BOOLEAN_VARIABLES )+(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_COEFFICIENTS )+8) //(2*NUMBER_OF_BOOLEAN_VARIABLES) 1 bit to indicate whether is exist or not and the other bit is a the constraint (x or !x)
`define NUMBER_OF_VARIABLES_WITH_INSIDE_CONSTRAINT  1
`define BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX 1
`define BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX 1
`define BIT_WIDTH_OF_GENERAL_VARIABLE_INDEX 2




module checker(
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause1,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause2,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment,//the current value of integer variables y1,y2,...
input in_reset,//to erase all the internal registers
input in_enable,
output wire [`NUMBER_OF_CLAUSES_BIT_WIDTH-1:0]out_satisfied_flag
//if out_satisfied_flag[0]=1 ,then clause 1 is satisfied
//if out_satisfied_flag[1]=1 ,then clause 2 is satisfied
 
    ); 
    
/// flatenning the input
//////////
    wire signed [`BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] in_coefficients_clause1_array [0:`NUMBER_OF_INTEGER_VARIABLES] ; // local 2d array for the coefficients
    wire signed [`BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] in_coefficients_clause2_array [0:`NUMBER_OF_INTEGER_VARIABLES] ; // local 2d array for the coefficients
    wire signed [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] in_current_assignment_array[0:`NUMBER_OF_INTEGER_VARIABLES-1];// local 2d array for the current assignment
    assign {in_coefficients_clause1_array[2],in_coefficients_clause1_array[1],in_coefficients_clause1_array[0]} = in_coefficients_clause1;
    assign {in_coefficients_clause2_array[2],in_coefficients_clause2_array[1],in_coefficients_clause2_array[0]} = in_coefficients_clause2; 
    assign {in_current_assignment_array[1],in_current_assignment_array[0]} = in_current_assignment;
///////// 
///some internal registers  
    reg signed [`BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] result1;
    reg signed [`BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] result2;
    reg flag1,flag2;
    assign out_satisfied_flag={flag2,flag1};
 


    always@(in_coefficients_clause1,in_coefficients_clause2,in_current_assignment,result1,result2,flag1,flag2,in_enable,in_reset)
    begin
    if((in_enable)&& !(in_reset))
    begin
        //computing the left handside of the clauses then comparing it with 0
    	result1 = in_coefficients_clause1_array[0]*in_current_assignment_array[0]+in_coefficients_clause1_array[1]*in_current_assignment_array[1]+in_coefficients_clause1_array[2];
    	result2 = in_coefficients_clause2_array[0]*in_current_assignment_array[0]+in_coefficients_clause2_array[1]*in_current_assignment_array[1]+in_coefficients_clause2_array[2];
    	//if the left handside is smaller than 0 then the clause is satisfied
	if(result1<=0)
     		flag1 = 1;
        else
                flag1 = 0;
        
    
     	if(result2<=0) 
       		 flag2 = 1; 
     	else 
      	 	 flag2 = 0; 
     
    end 
    else
    begin
    	flag1=0;
    	flag2=0;
    	result1=0;
    	result2=0;
    end

    end   
endmodule

