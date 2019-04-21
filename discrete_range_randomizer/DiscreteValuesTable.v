`timescale 1ns / 1ns

module DiscreteValuesTable
#(
    parameter MAX_BIT_WIDTH_OF_INTEGER_VARIABLE=8,
    parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX =8,
    parameter MAX_BIT_WIDTH_OF_DISCRETE_CHOICES =4,
    //for inside constraint we have 16 choice in it
   //for exampl x inside [1,3,5,7,9,0,12,34,76,65,56,77,88,99,[100:200],[40:60]]
     parameter FILE_PATH = "discrete_values.mem"
)
(
    input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0 ]in_variable_index,
    input [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1:0]in_index_of_the_discrete_value,
    
    
    
    output reg [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_start,
    output reg [MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1:0] out_end
    
    );
    wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX+MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1:0] discrete_value_address= {in_variable_index,in_index_of_the_discrete_value};  
     
    reg [(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*2)-1:0]discrete_values[0:((2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX )*(2** MAX_BIT_WIDTH_OF_DISCRETE_CHOICES))-1];
    
    always @(discrete_value_address)
    begin
        out_start<= discrete_values [discrete_value_address][(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE*2)-1:MAX_BIT_WIDTH_OF_INTEGER_VARIABLE] ;
        out_end<= discrete_values [discrete_value_address][(MAX_BIT_WIDTH_OF_INTEGER_VARIABLE-1):0] ;
    end  
    initial 
        begin
             $readmemb(FILE_PATH,discrete_values);
        end 
        
                                          
endmodule
