// GENERAL NOTE -> any probability will deal with it as an integer from 0->100 instead of 0 ->1
module TopModule;
    reg [7:0] pls0; // probability of local search move
    reg [7:0] temperature; // Hyper Parameter for tuning 
    reg [`CLAUSE_BIT_WIDTH-1:0] formula [0:`NUMBER_OF_CLAUSES-1] ; // contains all the coeffiecient 
    reg clk;
    
    reg [`NUMBER_OF_BOOLEAN_VARIABLES-1:0] initial_assigmnets_boolean;
    reg [(`NUMBER_OF_INTEGER_VARIABLES * `BIT_WIDTH_OF_INTEGER_VARIABLE)-1:0] initial_assigmnets_integer;
    
    
    reg [(`NUMBER_OF_BOOLEAN_VARIABLES*2)-1:0] integer_coefficients_solver_input;
    reg [(`NUMBER_OF_INTEGER_VARIABLES*`BIT_WIDTH_OF_INTEGER_COEFFICIENTS)-1:0] boolean_coefficients_solver_input;
    
    integer i=0;//some counters for looping
    
    // sizes buffer will  (constants values later)
    // read the formula from the text file generated from the pre-processing 
    
    always 
    begin
        #100 
        clk=~clk;
    end
    
    always @(posedge clk)
    begin
        if(i<`NUMBER_OF_CLAUSES)
        begin
            boolean_coefficients_solver_input<=formula[i][:(];
            integer_coefficients_solver_input<=formula[i];
            
        end
    end
    
    initial
    begin
    // before you start simulation you just put your input files path
        $readmemb("D:\\projects\\0IMP_Projects\\GP\\Hardware-MCMC-Constraints-Solver\\pre_processing.txt",formula);
         /* the loaded example
             -x0-x1+5<0
             x0+x1-15<0
             -x1<0 */
        $display("%b",formula[0]);
        pls0 = 7'b0;
        temperature = 'd1;
        initial_assigmnets_integer='d0;
        initial_assigmnets_boolean='d0;
        clk=0;
    end
    
    
    // control unit here to pass different clauses for the solver instances at every clock cycle     
    //Solver solver(formula[i],in_pls0,in_temperature,initial_assigmnets);
endmodule