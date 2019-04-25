
//////////////////////////////////////////////////////////////////////////////////
//this module is used to reduce the clause by substituting with the current assignment of all values except for a specific variable
//////////////////////////////////////////////////////////////////////////////////

module ReduceClause
#(
parameter MAXIMUM_BIT_WIDTH_OF_COEFFICIENT = 8,
parameter MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX = 1
)
(
input  [(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT*(2** MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX+1))-1:0] in_coefficients,//coefficients of integer variables a1*y1+a2*y2+..<=aN
input  [(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT*2** MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)-1:0] in_current_assignment,//the current value of integer variables y1,y2,...
input  [MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX-1:0] in_variable_to_be_unchanged_index,//the variable number
input in_clk,//the general clock
input in_enable,//the module only starts when the enable signal is 1
input in_reset,//if the reset is 1 all the modules signal are set to zero
//the output of module is an equation (+/-)y1<=b
output wire signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0] out_Bias,//out_bias=b (in the above equation)
output wire out_Variable_to_be_unchanged_sign ,//the sign of  y1 (in the above equation)
//1 if the sign is +ve
//0 if the sign is -ve
output wire out_Active//it says if the variable is on the clause or not
    );
    
    //some internal reg
    //////
    reg signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0] out_bias;
    reg out_variable_to_be_unchanged_sign ;
    reg out_active;
    //////
    //assigning the wires to the internal reg
    /////
    assign out_Bias = out_bias; 
    assign out_Variable_to_be_unchanged_sign = out_variable_to_be_unchanged_sign;
    assign out_Active=out_active;
    ////////
    reg [MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX:0] i;//index used in the for loop
    //flatten the input 
    /////
    wire signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT -1:0] in_coefficients_array [0:2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX] ; // local 2d array for the coefficients
    wire signed [MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1:0] in_current_assignment_array[0:(2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)-1];// local 2d array for the current assignment
    /////	
    //the combinational circuit
    
    genvar j;//for loop variable
    //assigning the input to 2d array
    for( j=0;j<=2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX;j=j+1)
    begin
    if(j<2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX)
    begin
        assign in_current_assignment_array[j]=in_current_assignment[((MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1)+j*(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)):(j*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)];
        assign in_coefficients_array[j]=in_coefficients[((MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1)+j*(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)):(j*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)];
    end
    else
        assign in_coefficients_array[j]=in_coefficients[((MAXIMUM_BIT_WIDTH_OF_COEFFICIENT-1)+j*(MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)):(j*MAXIMUM_BIT_WIDTH_OF_COEFFICIENT)];
    end  
    
    //synchronous circuit 
    always @(posedge in_clk)
    begin
       if(in_enable && !in_reset)
       begin
       //if the variable does not exist ,enter here
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
               //accumulate the bias
               for(i=0; i<2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX;i=i+1)
               begin
                    if(i!=in_variable_to_be_unchanged_index)
                    begin
                        out_bias = out_bias+in_coefficients_array[i]*in_current_assignment_array[i]; 
                    end
               end
               out_bias = out_bias + in_coefficients_array[2**MAXIMUM_BIT_WIDTH_OF_VARIABLE_INDEX] ;
                 
                 //if the coefficient of the variable to be unchanged is +ve ,enter here 
               if(in_coefficients_array[in_variable_to_be_unchanged_index]>0)
               begin
                   out_bias = out_bias / in_coefficients_array[in_variable_to_be_unchanged_index];
                   out_variable_to_be_unchanged_sign = 1;//the variable sign is +ve
               end  
               //if the variable to be unchanged is -ve ,enter here  
               else
               begin
                   out_bias = out_bias / in_coefficients_array[in_variable_to_be_unchanged_index];
                   out_variable_to_be_unchanged_sign = 0; //the variable sign is -ve   
               end
           end     
       end
       //if the module is reseted ,enter here
       else if (in_reset)
       begin
             out_active =0;
             out_bias = 0;
             out_variable_to_be_unchanged_sign = 0;
       end
       //if the module isnt enabled, enter here
       else
       begin
           out_active =out_active;
           out_bias = out_bias;
           out_variable_to_be_unchanged_sign = out_variable_to_be_unchanged_sign;
       end
   end

endmodule
