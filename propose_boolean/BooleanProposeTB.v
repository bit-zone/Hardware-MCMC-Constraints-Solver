 `include "headers.v"
module BooleanPropose_tb(
    );
    reg [`NUMBER_OF_BOOLEAN_VARIABLES-1:0] in_current_assignment_boolean;
    reg  in_variable_to_be_changed_index;
    reg in_enable;
    wire [`NUMBER_OF_BOOLEAN_VARIABLES-1:0]  out_new_assignment_boolean;
    BooleanPropose myBooleanPropose(in_current_assignment_boolean,in_variable_to_be_changed_index,in_enable,out_new_assignment_boolean);
    
    initial
    begin
       $monitor("x0=%b---x1=%b",out_new_assignment_boolean[0],out_new_assignment_boolean[1]);
        in_enable=1;
//test case1
//current assignment: x0=0 , x1=0
//chosen variable x0
//output should be : x0=1 , x1=0
	#20
        in_current_assignment_boolean=2'b00;
        in_variable_to_be_changed_index=0;
//test case2
//current assignment: x0=1 , x1=0
//chosen variable x0
//output should be : x0=0 , x1=0
        
        #20
        in_current_assignment_boolean=2'b01;
        in_variable_to_be_changed_index=0;
//test case3
//current assignment: x0=1 , x1=0
//chosen variable x1
//output should be : x0=1 , x1=1
        
        #20
        in_current_assignment_boolean=2'b01;
        in_variable_to_be_changed_index=1;   
         
    end
endmodule
