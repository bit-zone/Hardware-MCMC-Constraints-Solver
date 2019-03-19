module ProposeInteger(
    input in_variable_index,
    input in_enable,
    // we will assume that we only have three clauses here
    input in_clause1_coefficients,
    input in_clause2_coefficients,
    input in_clause3_coefficients,
    input in_assignments_old,
    output out_assignments_new,
    
);





/*
------------ Reduce Module ------------

-> Inputs :
- Variable index

-> Outputs :
- bias
- less_than : True; if less than , False; if greater than
- active : if the variable is in this clause or not
*/

ReduceClause reduce_clause1(in_variable_index,out_bias1,out_less_than1,out_active1);
ReduceClause reduce_clause2(in_variable_index,out_bias2,out_less_than2,out_active2);
ReduceClause reduce_clause3(in_variable_index,out_bias3,out_less_than3,out_active3);



/*
------------ CreateChooseSegment ------------

-> Inputs :
- All the reduce instances outputs

-> Outputs :
- start
- end
- type

*/

CreateChooseSegment create_and_choose_segment(

//Input
out_bias1,out_less_than1,out_active1,
out_bias2,out_less_than2,out_active2,
out_bias3,out_less_than3,out_active3,


//Output

out_start,
out_end,
out_type
)




/*
------------ Sampler ------------

-> Inputs :
- start
- end 
- type

->Outputs :
- new assignments

*/

Sampler sampler(
//Inputs
out_start,
out_end,
out_type

//Output
,out_assignments_new);

endmodule 