`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//the checker module is a combinational module that check the satisfiability of the clauses
////////////////////////////////////////////////////////////////////////////////////

// Should Remain as define as they are constant


module OneClauseChecker #(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 3//gives us the maximum number of clauses

)

(


//Binary
input [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] in_boolean_current_assigmnets,//the current assignment of all boolean variables in the formula 
input [( (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) * 2 ) - 1: 0] in_boolean_coefficients,//coefficients of boolean variables in the clause
    // 00 -> not Exist and zero
    // 01 -> not Exist and one
    // 10 // Exist and zero
    // 11 // Exist and 1     
    // Should be >= 2 to be Exist

  
 //Integer
input [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))* MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_integer_current_assigmnets,//current assignment for all integer variables in the formula
input [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX) + 1)* MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT )-1:0] in_integer_coefficients,//coefficients of integer variables a1*y1+a2*y2+.. + bias <= 0


input in_enable,//should be 1 for the module to start
input in_clk,//general clk
input in_reset,//at posedge of reset,all outputs and internal regs are down to zero


//outputs
output reg out_clause_is_satisfied,//if the clause satisfied it is up to 1

output reg ready_flag//if module is done it is up to 1
); 
// some internal regs
////// 
reg signed [7:0]  sum_values_integer = 0 ; //to substitute in the integer clause with the assignment 
integer i = 0;//for the for loop
reg integer_satisfied , boolean_satisfied; // flages for satisafibility
reg [ (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) - 1 : 0] boolean_buffer ; // store the values which shows it's satisfied or not
reg  [1:0] exist_coeff;
//////


//wires used to flattening the clause coefficients
////
wire signed [MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT -1:0] in_integer_coefficients_array [0:2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX] ; // local 2d array for the coefficients
wire signed [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] in_integer_current_assignment_array[0:(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1];// local 2d array for the current assignment
////


//clause flatenning
/////

    genvar j;//for loop variable
    //assigning the input to 2d array
    for( j=0;j<=2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX;j=j+1)
    begin
    if(j<2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)
    begin
        assign in_integer_current_assignment_array[j]=in_integer_current_assigmnets[((MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE-1)+j*(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)):(j*MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE)];
        assign in_integer_coefficients_array[j]=in_integer_coefficients[((MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1)+j*(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)):(j*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)];
    end
    else
        assign in_integer_coefficients_array[j]=in_integer_coefficients[((MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1)+j*(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)):(j*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)];
    end  
/////



//sequential part of the circuit
always @(posedge in_clk)
    begin
        //at posedge of clk enter here
        if(!in_reset)
            begin
            if(in_enable)
            begin
                sum_values_integer = 0;//initialize the counter
                for(i = 0 ; i < (2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX) ; i = i + 1  ) //substitute on the integer literal with the assignment  
                    begin   
                        sum_values_integer = sum_values_integer + in_integer_current_assignment_array[i] * in_integer_coefficients_array[i]; 
                    end
                
                // add the bias 
                sum_values_integer = sum_values_integer + in_integer_coefficients_array[(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)];
                if( $signed (sum_values_integer) <= 0)
                    integer_satisfied = 1; // satisfied               
                else
                    integer_satisfied = 0;
                
                
                for(i = 0 ; i < (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX) ; i = i + 1  ) // check the satisfiability of the boolean literals and put the result in buffer
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
                    if(boolean_buffer == 0)
                            boolean_satisfied = 0;    
                    else
                            boolean_satisfied = 1;
           

               out_clause_is_satisfied = integer_satisfied | boolean_satisfied;
               ready_flag=1; 
               end
            else//if it is not enabled
            begin
                      ready_flag=0;
                      out_clause_is_satisfied=0;
            end     
            end
        //if the module is reseted enter here
        //reset all module internal regs
        //reset the module output    
        else
            begin
                ready_flag=0;
                out_clause_is_satisfied=0;
                integer_satisfied=0;
                boolean_satisfied=0;
                boolean_buffer=0;
                exist_coeff=0;
            end
    end

endmodule

