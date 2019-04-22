`timescale 1ns / 1ps
module BooleanPropose_tb;
parameter MAX_BIT_WIDTH_OF_VARIABLES_INDEX =2;
    reg clock;
    reg [2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] current_assignment_boolean;
    
    reg [MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0] variable_to_be_changed_index;
    reg enable;
    
    integer i;
    
    wire [2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX-1:0]  new_assignment_boolean;
    
    
    BooleanPropose 
    #(
        .MAX_BIT_WIDTH_OF_VARIABLES_INDEX(MAX_BIT_WIDTH_OF_VARIABLES_INDEX)
    )
    myBooleanPropose
    (
    .in_clock(clock),
    .in_enable(enable),
    
    .in_current_assignment_boolean(current_assignment_boolean),
    .in_variable_to_be_changed_index(variable_to_be_changed_index),
    
    .out_new_assignment_Boolean(new_assignment_boolean)
    );
    
    initial begin
        clock=0;
        forever begin
            #50
            clock=~clock;
        end
    end
    initial
    begin
    current_assignment_boolean=4'b0;
    enable=1;
    $monitor ("time = %t   clk = %b new_assignment_boolean =%b ",$time,clock,new_assignment_boolean);
    
    $monitor  ("variable_to_be_changed_index monitor= %d",variable_to_be_changed_index);
    for (i=0;i<2**MAX_BIT_WIDTH_OF_VARIABLES_INDEX;i=i+1)begin
    
    #100
    
    variable_to_be_changed_index=i;
    end
    end
endmodule
