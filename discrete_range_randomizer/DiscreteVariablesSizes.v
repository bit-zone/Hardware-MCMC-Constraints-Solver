`include "TopModuleHeaders.vh"



// the number of elements inside the "insside constraints"
module DiscreteVariablesSizes(
    input [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH - 1 : 0] in_variable_index,
    output[`DISCRETE_VALUES_NUMBER_BIT_WIDTH - 1:0] number_of_discrete_assignments    
   );
    
    
    reg [`DISCRETE_VARIABLE_INDEX_BIT_WIDTH - 1 : 0] inside_index_table [0:`DISCRETE_VALUES_NUMBER_BIT_WIDTH - 1]; // we have maximum 4 variables and maximum 4 elements inside

    initial
        begin
        // before you start simulation you just put your input files path
            $readmemb("C:\\Users\\dell\\Desktop\\MCMC-Hardware\\MCMC\\MCMC.srcs\\sources_1\\new\\tables.txt",inside_index_table);
             /* the loaded example
                 011
                 010
                 000
                 100
                 000
                 010
                 010
                 000
                  */
                  
            $display("Who Cares? ");
            $display("%b",inside_index_table[0]);
        end
            
endmodule






