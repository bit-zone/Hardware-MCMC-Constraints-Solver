// inputs
// 1- two indeces 
// 2- two flags for unsatisfied 
// 3- one control signal if 0 choose the first , if 1 choose the second

// ----------------------------------

// outputs
// the index of the clause 
// is it satisfied or not


module CompareTwoChecker
#(
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX =3//gives us the maximum number of clauses
)

(
input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_1_index,
input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_2_index,
input in_clause_1_satisfied,
input in_clause_2_satisfied,
input in_setting,
output [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] out_clause_index,
output out_clause_satisfied
);

reg  [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] index;
reg is_satisfied;

always @ *
begin

    // if the first clause is not satisfied and the second is satisfied propagate the first
    if(in_clause_1_satisfied == 0 && in_clause_2_satisfied == 1)
    begin
    index = in_clause_1_index;
    is_satisfied = 0;
    end


    // if the first clause is satisfied and the second is not propagate the second
    if(in_clause_1_satisfied == 1 && in_clause_2_satisfied == 0)
    begin
    index = in_clause_2_index;
    is_satisfied = 0;
    end
    

    // if the first clause is satisfied and the second is not propagate the second
    if(in_clause_1_satisfied == 1 && in_clause_2_satisfied == 0)
    begin
    index = in_clause_2_index;
    is_satisfied = 0;
    end


    // if booth not satisfied , choose the one from the control signal setting
    if(in_clause_1_satisfied == 0 && in_clause_2_satisfied == 0)
    begin
    
        if(in_setting == 0)
            index = in_clause_1_index;
        else
             index = in_clause_2_index;
            
    is_satisfied = 0;
    end
       

        // if booth satisfied , choose the one from the control signal setting
    if(in_clause_1_satisfied == 1 && in_clause_2_satisfied == 1)
    begin
    
        if(in_setting == 0)
            index = in_clause_1_index;
        else
             index = in_clause_2_index;
            
    is_satisfied = 1;
    end

 end
 

 assign out_clause_index = index;
 assign out_clause_satisfied = is_satisfied; 
 
endmodule
