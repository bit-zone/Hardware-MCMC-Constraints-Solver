///////////
// the variableChooser module is used to choose a variable randomly
// the variable can be integer or boolean also in a random way
///////////



`include "headers.v"

module VariableChooser(
    input wire in_clock,
   //the general clock 
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable, 
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    input wire [7:0] in_seed,
    // initial value  , CANNOT be zero or negative
    output wire out_boolean_or_integer,
    //if 1 the choosen variable is boolean
    //if 0 the choosen variable is integer
    output wire [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] out_choosen_index
    //the index of the choosen variable
);

        reg out_boolean_or_integer_reg;//internal reg to compute the output
        reg [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] out_choosen_index_reg;//internal reg to compute the output
        assign out_boolean_or_integer = out_boolean_or_integer_reg;// just assign the value of reg to wire 
        assign out_choosen_index = out_choosen_index_reg;// just assign the value of reg to wire 
        
        //in this module we use a random generator to choose a variable from the formula variables
        //first we pass the range to the random generator
        //this range is from (0) to (the total number of variables boolean and integer together-1)
        //for example boolean_variables_number=2,integer_variables_number=3,then the range is from 0 to 4(2+5-1)
        //the random generator would choose a number in that range thats called a general_index
	reg signed [7:0] min =0; 
	reg signed [7:0] max =`NUMBER_OF_BOOLEAN_VARIABLES+`NUMBER_OF_INTEGER_VARIABLES-1;
	wire signed [7:0] general_index;
	RandomGenerator myRandom( in_clock,in_reset,in_enable,min,max,in_seed,general_index);

        //a combinational circuit to recognize the type of the choosen variable
     
	always@(general_index)
	begin
                //if the random choosen index is from 0 to the number of boolean variables-1
                //then it is boolean
		if(general_index<= `NUMBER_OF_BOOLEAN_VARIABLES-1)
		begin
			out_boolean_or_integer_reg=1;
			out_choosen_index_reg=general_index;
		end
                //if greater than that
                //then it is integer
		else
		begin
			out_boolean_or_integer_reg=0;
			out_choosen_index_reg=general_index-`NUMBER_OF_BOOLEAN_VARIABLES;
		end
	end
   


endmodule
