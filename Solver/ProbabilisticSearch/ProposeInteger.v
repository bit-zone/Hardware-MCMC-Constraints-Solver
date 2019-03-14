module ProposeInteger(
    in_clause,
    in_variable_index,
    in_enable,
    in_assignments_old,

    out_assignments_new

);

ReduceClause reduce_clause(); 

CreateChooseSegment create_and_choose_segment();

Sampler sampler();

endmodule 