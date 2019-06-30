module test_unsatisfied
#(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE=4,//gives us the maximum bitwidth of the value assigned to an integer variable
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE=1,//gives us the maximum bitwidth of the value assigned to a bool variable
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2//gives us the maximum number of clauses
);


// values of the module
reg in_clk;
reg in_reset=0;
reg [2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0]in_checker_enable=4'b1111;


// for clause register setup
reg [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]in_clause_coefficients_integer; //coefficients of integer literal for one clause only 

reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] in_clause_coefficients_boolean;//coefficients of boolean literals for one clause only

reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index; //the number of the clause



// ------ the assignment to check
reg [MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)-1:0] 
  in_integer_assignment = 8'h11 ; // x1 =1 , x2 = 1;
 
  
 
reg [MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)-1:0]
   in_boolean_assignment = 2'b10; // y1 = 0, y2 =1;






//outputs

wire [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
)*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]  out_clause_coefficients_integer; // the integer literal of the unsatisfied clause

wire [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] out_clause_coefficients_boolean; // the bool literal of the unsatisfied clause

wire out_satisfied;

//all the clauses in two memorys one for integer one for bool
  reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX) + 1)* MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT )-1:0] // c1x1 + c2x2 + b 
  clauses_coefficients_integer
  [0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];

  reg [((MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT) * (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)  ) -1:0] // 2 boolean variable in the clause only
  clauses_coefficients_boolean
  [0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];
  
  
  

  always
  begin
  #100;
  in_clk = ~in_clk;
  end


    initial
    begin
    // before you start simulation you just put your input files path
        $readmemb("C:\\Users\\dell\\Desktop\\MCMC-Hardware\\MCMC\\formula_integer.txt",clauses_coefficients_integer);
        $readmemb("C:\\Users\\dell\\Desktop\\MCMC-Hardware\\MCMC\\formula_bool.txt",clauses_coefficients_boolean);
    end
    
initial
begin
 in_clk = 0;

in_clause_coefficients_integer = clauses_coefficients_integer[0];
in_clause_coefficients_boolean = clauses_coefficients_boolean[0];
in_clause_index = 0;

#200;
in_clause_coefficients_integer = clauses_coefficients_integer[1];
in_clause_coefficients_boolean = clauses_coefficients_boolean[1];
in_clause_index = 1;



#200;
in_clause_coefficients_integer = clauses_coefficients_integer[2];
in_clause_coefficients_boolean = clauses_coefficients_boolean[2];
in_clause_index = 2;



#200;
in_clause_coefficients_integer = clauses_coefficients_integer[3];
in_clause_coefficients_boolean = clauses_coefficients_boolean[3];
in_clause_index = 3;


end



  initial
  begin
   $display("output of integer clause file..");
   $monitor(" the clause coeff's is : %b , %b ",out_clause_coefficients_integer, out_clause_coefficients_boolean );
   $monitor(" the formula is : %b", out_satisfied);
      
    end
    
UnsatisfiedClauses #(
.MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT) ,//gives us the maximum bitwidth of coefficients in integer literal
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT),//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX),//gives us the maximum number of integer variables in clause
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX),//gives us the maximum number of boolean variables in clause
.MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE(MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE),//gives us the maximum bitwidth of the value assigned to an integer variable
.MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE),//gives us the maximum bitwidth of the value assigned to a bool variable
.MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX(MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)//gives us the maximum number of clauses
)
    uut
    (
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_checker_enable(in_checker_enable),
    // for clause register setup
    .in_clause_coefficients_integer(in_clause_coefficients_integer),//coefficients of integer literal for one clause only 
    
    .in_clause_coefficients_boolean(in_clause_coefficients_boolean),//coefficients of boolean literals for one clause only
    
    .in_clause_index(in_clause_index),//the number of the clause    

    .in_integer_assignment(in_integer_assignment),
    .in_boolean_assignment(in_boolean_assignment),
    
    .out_clause_coefficients_integer(out_clause_coefficients_integer),
    .out_clause_coefficients_boolean(out_clause_coefficients_boolean),
    
    .out_satisfied(out_satisfied)
    );
       
      
endmodule
