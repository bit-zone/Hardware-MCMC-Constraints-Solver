`timescale 1ns/1ns
///////////
// the variableChooser module is used to choose a variable randomly
// the variable can be integer or boolean also in a random way
///////////
    //in this module we use a random generator to choose a variable from the formula variables
    //first we pass the range to the random generator
    //this range is from (0) to (the total number of variables boolean and integer together-1)
    //for example boolean_variables_number=2,integer_variables_number=3,then the range is from 0 to 4(2+5-1)
    //the random generator would choose a number in that range thats called a general_index
    //then we map this general_index to separated index for boolean and integer variables


module VariableChooser
#(
parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX= 8//256 total number of variables boolean or integer
)
(   //inputs for random genertor
    input wire in_clock, //the general clock 
    input wire in_reset, // if 1 , the module reads the seed value ,it should be 1 only at beginning and 0 after beginning .
    input wire in_enable, 
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
    
    //inputs for addresses mapping
    //making the bit width for all types of variables equals MAX_BIT_WIDTH_OF_VARIABLES_INDEX,
    // allows some flexibility  for the number of each type
    input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_boolean_variables, 
    input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_integer_variables,
    // these discrete variables are used in regular constraints
    input [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] number_of_discrete_integer_variables,
    // outputs
    output wire [1:0]out_choosen_type,
    //if 0 the choosen variable is boolean
    //if 1 the choosen variable is integer
    //if 2  the choosen variable is discrete
    output wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] out_choosen_index
    //the index of the choosen variable
);
wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] total_number_of_variables;
//this vector should be 8 bits as it is used an input to a random generator that requires an 8-bit input


wire [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] general_index;

reg [1:0] out_choosen_type_reg;//internal reg to compute the output
reg [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] out_choosen_index_reg;


assign total_number_of_variables=number_of_boolean_variables+number_of_integer_variables-1;
//the random generator generates number from 0 to the total_number_of_variables

assign out_choosen_index=(general_index<number_of_boolean_variables)? general_index: 
                            (general_index - number_of_boolean_variables);
                            
assign out_choosen_type=(general_index<number_of_boolean_variables)?2'b00:
                       ((out_choosen_index < number_of_discrete_integer_variables)?2'b10:2'b01);                        


        
RandomGenerator 
#(.WIDTH(MAX_BIT_WIDTH_OF_VARIABLES_INDEX)) 
chooser (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_min(7'b0),
  .in_max(total_number_of_variables),
  .in_seed(in_seed), 
  .out_random(general_index)
  );

endmodule












