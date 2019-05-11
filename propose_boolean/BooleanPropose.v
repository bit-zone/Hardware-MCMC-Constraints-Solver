`timescale 1ns / 1ps

module BooleanPropose
#(
// this mainly is = MAX_BIT_WIDTH_OF_ALL_VARIABLES_INDEX
    parameter MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX =2
)
(   
    input  in_clock,
    input in_enable,
    input [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] in_current_assignment_boolean,//the current values assigned to boolean variables x1,x2,...
    
    
    input [MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0] in_variable_to_be_changed_index,//the number of variable to be flipped
    
    output reg [2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX-1:0]  out_new_assignment_Boolean//the new values assigned to the boolean variables
    );

    integer i ;//index used in the for loop
    
    always @(posedge (in_clock))
    begin
        if (in_enable) 
        begin
            for(i=0;i<(2**MAX_BIT_WIDTH_OF_BOOLEAN_VARIABLES_INDEX);i=i+1)
            begin
                if(in_variable_to_be_changed_index==i)
                begin
                    out_new_assignment_Boolean[i]=(~in_current_assignment_boolean[i]);// flib only the chosen variable
                end
                else begin
                    out_new_assignment_Boolean[i]=in_current_assignment_boolean[i];
                end        
            end
        end
        else begin
            out_new_assignment_Boolean=in_current_assignment_boolean; 
        end
    end
endmodule
