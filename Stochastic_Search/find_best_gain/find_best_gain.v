`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2019 03:45:20 AM
// Design Name: 
// Module Name: find_best_gain
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


module find_best_gain
#
(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2,//gives us the maximum number of clauses
parameter TOTAL_NUMBER_OF_VARIABLES = (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)+(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)
)
(
input in_enable,
input in_clk,
input in_reset,


input [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)*TOTAL_NUMBER_OF_VARIABLES)-1:0]in_boolean_assignments,
input [(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)*TOTAL_NUMBER_OF_VARIABLES)-1:0]in_integer_assignments,


input [(TOTAL_NUMBER_OF_VARIABLES * (MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1))-1:0]in_gains,

output reg [ MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0] out_best_gain,

output reg [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0]out_best_integer_assignment,
output reg [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]out_best_boolean_assignment
   

  );
  //wires used in the generate for loop

     wire  [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX:0]  gain [0:((TOTAL_NUMBER_OF_VARIABLES*2) -1  )  -1]  ;
     wire  [(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))-1:0]  integer_assignment [0:((TOTAL_NUMBER_OF_VARIABLES*2) -1  )  -1]  ;
     wire  [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]  boolean_assignment [0:((TOTAL_NUMBER_OF_VARIABLES*2) -1  )  -1]  ;
   
   
   //flattening the input
   /////
    genvar k;//for loop variable
        //assigning the input to 2d array
        for( k=0;k<TOTAL_NUMBER_OF_VARIABLES;k=k+1)
        begin 
            assign gain[k]=in_gains[((k+1)*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1))-1:k*(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX+1)];
            assign integer_assignment[k]=in_integer_assignments[(((MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX))-1)+k*((MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)))):(k*(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)))];
            assign boolean_assignment[k]=in_boolean_assignments[(((MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1)+k*((MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)))):(k*(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)))];
        end  
   //////
   
   
   
     generate
     genvar i; 
    genvar j;
    for (i=0;i<((TOTAL_NUMBER_OF_VARIABLES*2) -1  );i=(i/2)+TOTAL_NUMBER_OF_VARIABLES)begin :generate_levels_of_comparator_tree
             for(j=i;j<(i/2)+TOTAL_NUMBER_OF_VARIABLES-1;j=j+2)begin : generate_ith_level
              compare_two_gains
             #
             (
                MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT,
                MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT,
                MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX,
                MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX,
                MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE,
                MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE,
                MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX       
             )
             (
            .in_gain1(gain[j]),
            .in_gain2(gain[j+1]),
             
            .in_integer_assignment1(integer_assignment[j]),
            .in_boolean_assignment1(boolean_assignment[j]),
             
            .in_integer_assignment2(integer_assignment[j+1]),
            .in_boolean_assignment2(boolean_assignment[j+1]),
             
            .out_best_gain(gain[(i/2)+TOTAL_NUMBER_OF_VARIABLES+((j-i)/2)]),
            .out_best_integer_assignment(integer_assignment[(i/2)+TOTAL_NUMBER_OF_VARIABLES+((j-i)/2)]),
            .out_best_boolean_assignment(boolean_assignment[(i/2)+TOTAL_NUMBER_OF_VARIABLES+((j-i)/2)])
             
                 );
             
                end
    end
    endgenerate
    
    always@(posedge in_clk)
    begin
    if(!in_reset && in_enable)
    begin
        out_best_gain <= gain  [((TOTAL_NUMBER_OF_VARIABLES*2) -1  )-1];
        out_best_integer_assignment <= integer_assignment  [((TOTAL_NUMBER_OF_VARIABLES*2) -1  )-1];
        out_best_boolean_assignment <= boolean_assignment  [((TOTAL_NUMBER_OF_VARIABLES*2) -1  )-1];
    end
    else
    begin
         out_best_gain <=0 ;
         out_best_integer_assignment <= 0 ;
         out_best_boolean_assignment <= 0 ;
    end
    end
        
endmodule
