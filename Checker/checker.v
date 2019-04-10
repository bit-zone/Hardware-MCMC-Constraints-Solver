//////////////////////////////////////////////////////////////////////////////////
//the checker module is a combinational module that check the satisfiability of the clauses
////////////////////////////////////////////////////////////////////////////////////
`include "headers.v"
module checker(
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause1,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients_clause2,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment,//the current value of integer variables y1,y2,...
input in_reset,//to erase all the internal registers
input in_enable,
output wire clause1_flag,//if 1 ,then clause 1 is satisfied
output wire clause2_flag//if 1 ,then clause 2 is satisfied
 
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
    assign clause1_flag=flag1;//assigning the value of reg to the output
    assign clause2_flag=flag2;//assigning the value of reg to the output


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

