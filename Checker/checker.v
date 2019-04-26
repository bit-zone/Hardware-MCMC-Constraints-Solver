
//////////////////////////////////////////////////////////////////////////////////
//the checker module is a combinational module that check the satisfiability of the clauses
////////////////////////////////////////////////////////////////////////////////////

// Should Remain as define as they are constant


module OneClauseChecker #(
parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX = 7,// Max variables = 2**7 =  128 could be all int or bool
parameter BIT_WIDTH_OF_INTEGER = 8 // bit signed
)

(


//Binary
input [ (2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) - 1 : 0] in_boolean_current_assigmnets, // we could have all bool variables
input [( (2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) * 2 ) - 1: 0] in_boolean_coefficients,
    // 00 -> not Exist and zero
    // 01 -> not Exist and one
    // 10 // Exist and zero
    // 11 // Exist and 1     
    // Should be >= 2 to be Exist

  
 //Integer
input [(((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX))* BIT_WIDTH_OF_INTEGER )-1:0] in_integer_current_assigmnets,
input [(((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) + 1)* BIT_WIDTH_OF_INTEGER )-1:0] in_integer_coefficients,//coefficients of integer variables a1*y1+a2*y2+.. + bias <= 0


input in_enable,
input in_clk,
output reg out_clause_is_satisfied
); 

reg signed [7:0]  sum_values_integer = 0 ; // assume max will be 512
reg signed [7:0]  bias = 0 ; // assume max will be 512
integer i = 0;


reg integer_satisfied , boolean_satisfied; // flages for satisafibility
reg [ (2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) - 1 : 0] boolean_buffer ; // store the values which shows it's satisfied or not
reg  [1:0] exist_coeff;
initial 
begin
for(i = 0 ; i < (2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) ; i = i + 1  ) // i < number of varibles number
    
    begin
    sum_values_integer = sum_values_integer + (in_integer_coefficients[i*8 +: 8] * in_integer_current_assigmnets[i*8 +: 8]); 
    end

// add the bias 
bias =  in_integer_coefficients[(((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) + 1)* BIT_WIDTH_OF_INTEGER )-1: (((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) + 1)* BIT_WIDTH_OF_INTEGER ) - 8 ];
sum_values_integer = sum_values_integer + bias;




for(i = 0 ; i < (2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX) ; i = i + 1  ) // i < number of varibles number
begin
exist_coeff = in_boolean_coefficients[i*2 +: 2];

if(exist_coeff >= 2) // is exist?
    if(exist_coeff[0] == in_boolean_current_assigmnets[i])
        boolean_buffer[i] = 1;
 
     else
        boolean_buffer[i] = 0; //if exist but constraint not equal coeff
 
else
    boolean_buffer[i] = 0; // if not exist
                   
end



end

always @(posedge in_clk )
begin
    if(in_enable)
    begin
    if( $signed (sum_values_integer) <= 0)
    integer_satisfied = 1; // satisfied 
    else
    integer_satisfied = 0;
    
   if(boolean_buffer == 0)
   boolean_satisfied = 0;
   
   else
   boolean_satisfied = 1;
       
   out_clause_is_satisfied = integer_satisfied | boolean_satisfied;
    
   
    end

end


/*    
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
    reg flag_integer_clause1,flag_integer_clause2;
    wire flag_boolean_clause1, flag_boolean_clause2;

 
    // coeff bit stream for clause 1 ->  10 01
    // coeff bit stream for clause 2 ->  11 11
            
    // current Assignment -> 1 0  
   
                                                    
    assign flag_boolean_clause1 = (in_boolean_coefficients_clause1[1] & (in_boolean_coefficients_clause1[0] == in_current_assigmnets_boolean[0]))   // Exist Variable 1       
    & (in_boolean_coefficients_clause1[3] & (in_boolean_coefficients_clause1[2] == in_current_assigmnets_boolean[1]));   // Exist Variable 2   
    
    assign flag_boolean_clause2 = ( in_boolean_coefficients_clause2[1] &   (in_boolean_coefficients_clause2[0] == in_current_assigmnets_boolean[0])  )   // Exist Variable 1       
    & (in_boolean_coefficients_clause1[3] & (in_boolean_coefficients_clause2[2] == in_current_assigmnets_boolean[1]));   // Exist Variable 2   
    
    
    assign out_satisfied_flag={flag_integer_clause2  | flag_boolean_clause2   , flag_integer_clause1 |flag_boolean_clause2 };
    
    
    
    always@( in_current_assigmnets_boolean,   in_current_assigmnets_boolean, in_coefficients_clause1,in_coefficients_clause2,in_current_assignment,result1,result2,flag_integer_clause1,flag_integer_clause2,in_enable,in_reset)
    begin
    if((in_enable)&& !(in_reset))
    begin
        //computing the left handside of the clauses then comparing it with 0
    	result1 = in_coefficients_clause1_array[0]*in_current_assignment_array[0]+in_coefficients_clause1_array[1]*in_current_assignment_array[1]+in_coefficients_clause1_array[2];
    	result2 = in_coefficients_clause2_array[0]*in_current_assignment_array[0]+in_coefficients_clause2_array[1]*in_current_assignment_array[1]+in_coefficients_clause2_array[2];
    	//if the left handside is smaller than 0 then the clause is satisfied
	if(result1<=0)
     		flag_integer_clause1 = 1;
        else
                flag_integer_clause1 = 0;
        
    
     	if(result2<=0) 
       		 flag_integer_clause2 = 1; 
     	else 
      	 	 flag_integer_clause2 = 0; 
     
    end 
    else
    begin
    	flag_integer_clause1=0;
    	flag_integer_clause2=0;
    	result1=0;
    	result2=0;
    end

    end   
*/

endmodule

