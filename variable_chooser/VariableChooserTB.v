

module VariableChooser_tb;
    
    parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX=8;   
     reg in_clock;
   //the general clock 
     reg in_reset; 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
     reg in_enable;
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    reg [7:0] in_seed;
    // initial value  , CANNOT be zero or negative
     wire [1:0]out_choosen_type;
    //if 0 the choosen variable is boolean
    //if 1 the choosen variable is integer
    //if 2 the choosen variable is descrete
     wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] out_choosen_index;
    //the index of the choosen variable
     
     reg [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_boolean_variables;
     reg [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_integer_variables;
        // these discrete variables are used in regular constraints
     reg [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_discrete_integer_variables;
 
   initial begin
   in_clock = 0;
   forever
   #50 in_clock = ~in_clock;
    end
   initial
    begin
       $monitor("type of variable =%d----index of variable =%d",out_choosen_type,out_choosen_index);
        in_reset = 0;
        in_enable = 0;
        number_of_boolean_variables=5;
        number_of_integer_variables=10;
        number_of_discrete_integer_variables=5;
      // Wait 100 ns for global reset to finish
      #100;
      in_seed = 1;
      in_reset = 1;
      in_enable=1;
      #200;
      in_reset = 0;
      #200;
      in_enable=0;
      #200;
      in_enable=1;
    end
    VariableChooser testVariableChooser(
    .in_clock(in_clock),
    .in_reset(in_reset),
    .in_enable(in_enable),
    .in_seed(in_seed),
    
    .number_of_boolean_variables(number_of_boolean_variables),
    .number_of_integer_variables(number_of_integer_variables),
    .number_of_discrete_integer_variables(number_of_discrete_integer_variables),
    
    .out_choosen_type(out_choosen_type),
    .out_choosen_index(out_choosen_index)
    );
endmodule