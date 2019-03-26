`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2019 01:33:11 PM
// Design Name: 
// Module Name: BooleanPropose
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 `include "headers.v"

module BooleanPropose(input [0:`NUMBER_OF_BOOLEAN_VARIABLES-1] in_current_assignment_boolean,//the current values assigned to boolean variables x1,x2,...
input  in_variable_to_be_changed_index,//the number of variable to be flipped
input in_enable,
output reg [0:`NUMBER_OF_BOOLEAN_VARIABLES-1]  out_new_assignment_boolean//the new values assigned to the boolean variables
    );
    reg [`BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX :0] i = 0;//index used in the for loop
    always@(*)
    begin
        if(in_enable)
        begin
            //flip the value of the variable in the current assignment
            for(i=0 ; i<=`NUMBER_OF_BOOLEAN_VARIABLES-1 ; i=i+1)
            begin
                //if it is the variable to be flipped,enter here
                if(i==in_variable_to_be_changed_index)
                    out_new_assignment_boolean[i]=~in_current_assignment_boolean[i];
                //if it is not, do nothing
                else
                    out_new_assignment_boolean[i]=in_current_assignment_boolean[i];     
       
            end
        end  
        else
        begin
            //if enable signal is zero make all outputs zero
             for(i=0 ; i<=`NUMBER_OF_BOOLEAN_VARIABLES-1 ; i=i+1)
             begin
                out_new_assignment_boolean[i]=0;
             end     
        end  
    end
endmodule
