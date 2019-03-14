module Solver(
input wire [CLAUSE_BIT_WIDTH-1:0] in_clause
input wire [7:0] in_pls0 // probability of local(stocastic) search -> let it be 8 bits right now
input wire [7:0] in_temperature // constant needed for (metropolis move) probablistic search-> let it be 8 bits right now
input wire [(NUMBER_OF_BOOLEAN_VARIABL+(NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_INTEGER_VARIABLE))-1:0]initial_assignment


output reg [(NUMBER_OF_BOOLEAN_VARIABL+(NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_INTEGER_VARIABLE))-1:0] solution
);
reg  [(NUMBER_OF_BOOLEAN_VARIABL+(NUMBER_OF_INTEGER_VARIABLES*BIT_WIDTH_OF_INTEGER_VARIABLE))-1:0]:] storage;
wire 

MUX mux(storage,initial_assignment,current_assignment,assignment_selector);//choose  

ProbabilisticSearch probabilisticsearch (); 




endmodule