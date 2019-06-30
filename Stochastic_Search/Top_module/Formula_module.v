
// this module to access the formula from the pre-processing

// inputs 
// 1) clause address
// 2) read enable 
// 3) clock
// ------------------

// outputs
// 1) integer clause coeff
// 2) bool clause coeff 



module FormulaModule
#(
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT = 4,//gives us the maximum bitwidth of coefficients in integer literal
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT = 2,//gives us the maximum bitwidth of coefficients in boolean literal(it always equals 2)
parameter MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX = 1,//gives us the maximum number of integer variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX = 1,//gives us the maximum number of boolean variables in clause
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 3//gives us the maximum number of clauses
)

(
    input [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_index,//the number of the clause
    input in_read_enable,
    input in_clk,
    
    output reg [((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX)+1//for the bias
    )*MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT-1:0]  out_clause_coefficients_integer,
    
    output reg [(MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT*(2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX))-1 : 0 ] out_clause_coefficients_boolean//coefficients of boolean literals for one clause only
    
);


//all the clauses in two memorys one for integer one for bool
  reg [(((2**MAXIMUM_BIT_WIDTH_OF_INTEGER_VARIABLE_INDEX) + 1)* MAXIMUM_BIT_WIDTH_OF_INTEGER_COEFFICIENT )-1:0] // c1x1 + c2x2 + b 
  clauses_coefficients_integer
  [0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];

  reg [((MAXIMUM_BIT_WIDTH_OF_BOOLEAN_COEFFICIENT) * (2**MAXIMUM_BIT_WIDTH_OF_BOOLEAN_VARIABLE_INDEX)  ) -1:0] // 2 boolean variable in the clause only
  clauses_coefficients_boolean
  [0:2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1];

 initial
    begin
    // before you start simulation you just put your input files path
        $readmemb("C:\\Users\\dell\\Desktop\\MCMC-Hardware\\MCMC\\formula_integer.txt",clauses_coefficients_integer);
        $readmemb("C:\\Users\\dell\\Desktop\\MCMC-Hardware\\MCMC\\formula_bool.txt",clauses_coefficients_boolean);
    end




always @ (posedge in_clk)
begin
    
    if(in_read_enable)
    begin
    out_clause_coefficients_integer <= clauses_coefficients_integer[in_clause_index];
    out_clause_coefficients_boolean <= clauses_coefficients_boolean[in_clause_index];
    end
    
end
  

endmodule
