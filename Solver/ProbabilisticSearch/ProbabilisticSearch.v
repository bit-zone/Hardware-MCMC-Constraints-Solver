module ProbabilisticSearch(

);

/* VariableChooser module chooses a variable to propose a value for it
inputs:
1) number_of_boolean_variable  
2) number_of_integer_variable 
 for (1) and (2) idont know right know whether this the suitable way to feed the size limit to the module 
     or to feed it the bit width of all idecies,
     so it is will be up to who will write this module  

3) seed ->to initiate the random generator 

outputs:
1) variable_index
2) propose_enable -> 1 to enable ProposeBoolean
                  -> 0 to enable ProposeInteger          
*/


VariableChooser variable_chooser(variable_index,propose_enable);// propose_enable 1 to enable ProposeInteger & 0 to enable ProposeBoolean


/* ProposeInteger module should flip the choosed boolean variable
inputs:
1)propose_enable -> enable the module
2) boolean_assignmets_before_move -> values of boolean variables before the move
3)reset -> to reset the module if needed

outputs:
1) boolean_assignments_after_move
 */

ProposeBoolean propose_boolean(propose_enable,boolean_assignmets_before_move,boolean_assignments_after_move);

/* ProposeInteger module that propose a new assignment for the chosen variable 
inputs:
1)propose_enable -> enable the module
2)integer_assignmets_before_move -> values of boolean variables before the move
3)reset -> to reset the module if needed

outputs:
1} integer_assignments_after_move
*/
ProposeInteger Propose_integer(propose_enable,integer_assignmets_before_move,reset,integer_assignments_after_move);

CalculatFailedConstraintsNumberBeforeMove Calculat_failed_constraints_number_before(
boolean_assignmets_before_move,
integer_assignmets_before_move,
number_of_failed_constraints_before);

CalculatFailedConstraintsNumberAfterMove Calculat_failed_constraints_number_after(
boolean_assignments_after_move,
integer_assignments_after_move,
number_of_failed_constraints_after
);

CalculateProbability Calculate_probability(
    number_of_failed_constraints_before,
    number_of_failed_constraints_after,
    move_decision
);


endmodule
