
`include "headers.v"
module VariableChooser_tb(
    );
   
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
     wire out_boolean_or_integer;
    //if 1 the choosen variable is boolean
    //if 0 the choosen variable is integer
     wire [`BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX-1:0] out_choosen_index;
    //the index of the choosen variable
   VariableChooser myVariableChooser(in_clock,in_reset,in_enable,in_seed,out_boolean_or_integer,out_choosen_index);    
   initial begin
   in_clock = 0;
   forever
   #50 in_clock = ~in_clock;
    end
   initial
    begin
       $monitor("type of variable =%b----index of variable =%b",out_boolean_or_integer,out_choosen_index);
        in_reset = 0;
        in_enable = 0;
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
endmodule