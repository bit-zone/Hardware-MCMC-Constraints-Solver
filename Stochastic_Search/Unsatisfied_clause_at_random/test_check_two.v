
module TestCheckTwo
#(
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 1//gives us the maximum number of clauses
);
 
 // Inputs
 reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_1_index;
 reg [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] in_clause_2_index;
 reg in_clause_1_satisfied;
 reg in_clause_2_satisfied;
 reg in_setting;
 
 // Outputs
  wire [MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX-1:0] out_clause_index;
  wire out_clause_satisfied;


initial begin  
 #10
 in_setting = 0;
 in_clause_1_index = 0;
 in_clause_2_index = 1;
 in_clause_1_satisfied = 0;
 in_clause_2_satisfied = 1;

 #10
 in_setting = 0;
 in_clause_1_index = 0;
 in_clause_2_index = 1;
 in_clause_1_satisfied = 1;
 in_clause_2_satisfied = 0;


 #10
 in_setting = 0;
 in_clause_1_index = 0;
 in_clause_2_index = 1;
 in_clause_1_satisfied = 1;
 in_clause_2_satisfied = 1;


 #10
 in_setting = 1;
 in_clause_1_index = 0;
 in_clause_2_index = 1;
 in_clause_1_satisfied = 0;
 in_clause_2_satisfied = 0;


 
end
 



 initial begin
 $display("output of testing..");
 $monitor(" the index is %d",  out_clause_index);
 $monitor(" the clause is satisfied : %d",  out_clause_satisfied);
 end     


 // Instantiate the Unit Under Test (UUT)
 CompareTwoChecker  uut (
  .in_clause_1_index(in_clause_1_index), 
  .in_clause_2_index(in_clause_2_index),
  .in_clause_1_satisfied(in_clause_1_satisfied),
  .in_clause_2_satisfied(in_clause_2_satisfied),
  .in_setting(in_setting),
  .out_clause_index(out_clause_index),
  .out_clause_satisfied(out_clause_satisfied)
 );
 
endmodule  
