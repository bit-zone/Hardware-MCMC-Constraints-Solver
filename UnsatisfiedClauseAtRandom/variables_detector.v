module VariablesDetector#(

parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1, //gives us the maximum number of boolean variables in clause

parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)

)
(
input [(2**(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT -1 :0] in_integer_coefficients,
input [(2**(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))*MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT-1:0] in_boolean_coefficients,

output [2**(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0] out_integer_variables,
output [2**(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0] out_boolean_variables


);


//flatenning
/////

    genvar i,j;//for loop variable

    
    // integer part 
    for( i=0;i<=(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1;i=i+1)
    
        begin  
  
   assign out_integer_variables[i] = in_integer_coefficients[((MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1)+i*(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)):(i*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT)] ? 1'b1 : 1'b0;    
   end
    
      
    
    // boolean part 
        //assigning the input to 2d array
    for( j=0;j<=(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1;j=j+1)
    begin

   assign out_boolean_variables[j] = in_boolean_coefficients[(2*j)+1] ? 1'b1 : 1'b0;
      end
  



 
   
endmodule