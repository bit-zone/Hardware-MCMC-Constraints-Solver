
//////////////////////////////////////////////////////////////////////////////////
//this module is used to reduce the clause by substituting with the current assignment of all values except for a specific variable
//////////////////////////////////////////////////////////////////////////////////

`include "headers.v"

module ReduceClause(input  [((`NUMBER_OF_INTEGER_VARIABLES+1)*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_coefficients,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input  [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_VARIABLE )-1:0] in_current_assignment,//the current value of integer variables y1,y2,...
input  [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] in_variable_to_be_unchanged_index,//the variable number
input in_enable,//the module only starts when the enable signal is 1
input in_reset,//if the reset is 1 all the modules signal are set to zero
//the output of module is an equation (+/-)y1<=b
output wire signed [(`BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] out_Bias,//out_bias=b (in the above equation)
output wire out_Variable_to_be_unchanged_sign ,//the sign of  y1 (in the above equation)
//1 if the sign is +ve
//0 if the sign is -ve
output wire out_Active//it says if the variable is on the clause or not
    );
    
    //some internal reg
    //////
    reg signed [(`BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] out_bias;
    reg out_variable_to_be_unchanged_sign ;
    reg out_active;
    //////
    //assigning the wires to the internal reg
    /////
    assign out_Bias = out_bias; 
    assign out_Variable_to_be_unchanged_sign = out_variable_to_be_unchanged_sign;
    assign out_Active=out_active;
    ////////
    reg [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX:0] i;//index used in the for loop

    //flatten the input 
    /////
    wire signed [`BIT_WIDTH_OF_INTEGER_VARIABLE -1:0] in_coefficients_array [0:`NUMBER_OF_INTEGER_VARIABLES] ; // local 2d array for the coefficients
    wire signed [`BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] in_current_assignment_array[0:`NUMBER_OF_INTEGER_VARIABLES-1];// local 2d array for the current assignment
    assign {in_coefficients_array[2],in_coefficients_array[1],in_coefficients_array[0]} = in_coefficients; 
    assign {in_current_assignment_array[1],in_current_assignment_array[0]} = in_current_assignment;
    /////	

    //the combinational circuit
    always @(*)
    begin
        if(in_enable && !in_reset)
        begin
        //if the variable does not exist , enter here
        if(in_coefficients_array[in_variable_to_be_unchanged_index] == 0 )
        begin
            out_active =0;//the clause doesnot have the variable
            out_bias = 0;
            out_variable_to_be_unchanged_sign = 0;
        end
        //if the variable exists ,enter here
        else
        begin
            out_active =1;//the clause has the variable in it so it is active
            out_bias=0;//initialize the bias to zero
            //substitute with the current assignment of the variables except for the variable to be unchanged
           
            /////////
            for(i=0; i<`NUMBER_OF_INTEGER_VARIABLES;i=i+1)
            begin
                if(i!=in_variable_to_be_unchanged_index)
		begin
                	out_bias = out_bias+in_coefficients_array[i]*in_current_assignment_array[i]; 
                end 
            end    
            out_bias = out_bias + in_coefficients_array[`NUMBER_OF_INTEGER_VARIABLES] ;
            ////////
           
           //if the coefficient of the variable to be unchanged is +ve ,enter here 
            if(in_coefficients_array[in_variable_to_be_unchanged_index]>0)
            begin
                out_bias = out_bias / in_coefficients_array[in_variable_to_be_unchanged_index];
                out_variable_to_be_unchanged_sign = 1;//the variable sign is +ve
            end  
            //if the variable to be unchanged is -ve ,enter here  
            else
            begin
                out_bias = out_bias / -in_coefficients_array[in_variable_to_be_unchanged_index];
                out_variable_to_be_unchanged_sign = 0; //the variable sign is -ve   
            end
        end
        end
        else
        begin
            out_active =0;
            out_bias = 0;
            out_variable_to_be_unchanged_sign = 0;
         end
    end
    
endmodule
