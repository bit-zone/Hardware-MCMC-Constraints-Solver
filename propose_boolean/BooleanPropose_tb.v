`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2019 02:13:52 PM
// Design Name: 
// Module Name: BooleanPropose_tb
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
module BooleanPropose_tb(
    );
    reg [0:`NUMBER_OF_BOOLEAN_VARIABLES-1] in_current_assignment_boolean;
    reg  in_variable_to_be_changed_index;
    reg in_enable;
    wire [0:`NUMBER_OF_BOOLEAN_VARIABLES-1]  out_new_assignment_boolean;
    BooleanPropose myBooleanPropose(in_current_assignment_boolean,in_variable_to_be_changed_index,in_enable,out_new_assignment_boolean);
    
    initial
    begin
       $monitor("%b",out_new_assignment_boolean);
        in_enable=1;
	#20
        in_current_assignment_boolean=2'b00;
        in_variable_to_be_changed_index=0;
        
        #20
        in_current_assignment_boolean=2'b01;
        in_variable_to_be_changed_index=0;
        
        #20
        in_current_assignment_boolean=2'b01;
        in_variable_to_be_changed_index=1;   
         
    end
endmodule
