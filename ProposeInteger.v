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

ReduceClause reduce_clause1(variable_index,bias1,less_than1,active1);
ReduceClause reduce_clause2(variable_index,bias2,less_than2,active2);
ReduceClause reduce_clause3(variable_index,bias3,less_than3,active3);



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
bias1,less_than1,active1,
bias2,less_than2,active2,
bias3,less_than3,active3,


//Output

start,
_end,
type
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
start,
_end,
type?

//Output
,assignments_new);

endmodule 