// this module is a memory that store for each variable used with inside constraint
module DiscreteVariablesSizes
#( 
    parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX =2,
    parameter MAX_BIT_WIDTH_OF_DISCRETE_CHOICES =2,
    // for inside constraint we have 16 choice in it
    //for exampl x inside [1,3,5,7,9,0,12,34,76,65,56,77,88,99,[100:200],[40:60]]
    parameter FILE_PATH="number_of_discrete_choices_of_each_variable.mem"
)
(   
    input wire in_clock,
    input wire in_enable,
    
    input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX - 1 : 0] in_variable_index,
    
    output wire [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES - 1:0] out_number_of_discrete_assignments    
   );
  
    reg [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1 :0] number_of_discrete_assignments;
    reg [MAX_BIT_WIDTH_OF_DISCRETE_CHOICES-1 : 0] number_of_discrete_variables_table[0:(2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX)- 1]; 
     
     assign out_number_of_discrete_assignments=number_of_discrete_assignments;
     
     always @(posedge(in_clock))
     begin
     if (in_enable)
        number_of_discrete_assignments <= number_of_discrete_variables_table[in_variable_index];
     else
        number_of_discrete_assignments <=number_of_discrete_assignments; 
     end
              
    initial
        begin
        // this file should contain the max index of inside choice not their actual number
            $readmemb(FILE_PATH,number_of_discrete_variables_table);
        end
    
endmodule






