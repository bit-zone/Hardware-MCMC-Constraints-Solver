

module testVariables
#(

parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1, //gives us the maximum number of boolean variables in clause

parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)

);
    
reg [(2**(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT -1 :0] in_integer_coefficients = 12'b0011_0001_0001  ;
reg [(2**(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))*MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT -1:0] in_boolean_coefficients = 4'b01_11;

wire [2**(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0] out_integer_variables;
wire [2**(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0] out_boolean_variables;




  
 initial begin
 $display("output of testing variables checker");
 $monitor(" the output integer is %b , boolean is %b",  out_integer_variables,out_boolean_variables);
 end     



    
     VariablesDetector uut
    (
     .in_integer_coefficients(in_integer_coefficients),
     .in_boolean_coefficients(in_boolean_coefficients),
     .out_integer_variables(out_integer_variables),
     .out_boolean_variables(out_boolean_variables)
    );
endmodule
