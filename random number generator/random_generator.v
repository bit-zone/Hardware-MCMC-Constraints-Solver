
/*
the random generator module is similar to random.randint(form,to) in python . It simply outputs 
a random integer from the specified min and max (range).
The module is synchronized with clock and reset .
If reset=1 , then  the module assign seed value to the initial random number , similar to 
random.seed(seed) in python .
If enable signal=0 , then the output remains like the previous one.
If enable signal=1 .then a new random output will be generated.
*/
module RandomGenerator(
  //inputs
    input wire in_clock, 
    // the main clock of the system.
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable,
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
    input wire signed [7:0] in_min,
    // specifies the minimum value of the target range.
    input wire signed[7:0] in_max,
    // specifies the maximum value of the target range.
    input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
  //ouputs
    output wire signed [7:0] out_random 
    // the random number 
    );

reg signed[7:0] random, random_next, random_done , incremented_max; // temporary variables 
wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3]; // this is the standard permutation
// in LFSR from Xilinx .
assign out_random = random_done; // just assign the value of reg to wire 

always @ (posedge in_clock)
begin
  // if in_reset= 1 , the module reads the seed value and assign it as initial value to the random variable , 
  // it should be 1 only at beginning and 0 after beginning .
 if (in_reset) // read the seed value
 begin
  random = in_seed; //assign seed as initial value to the random variable
 end
  // it should be 1 if you want new numbers to be generated every posetive clock edge .
  // if 0 , the output remains like the previous one.
 if(in_enable) // randomize!
 begin
   // shift left and insert the feedback value to 
   //the random variable (principal of LFSR)
   incremented_max=in_max+1; // to make the maximum value in range not (max-1)
   random_next = {random[6:0], feedback}; 
   random = random_next;
   //mapping from the real output of LFSR to the specified range by modulus approach.
   if(random_next>=0)
   begin
     random_done = ((random_next ) % (incremented_max - in_min ) + in_min);
   end
   if(random_next<0)
   begin
     random_done = ((random_next ) % (incremented_max - in_min ) + in_min + (incremented_max - in_min));
     if(random_done==incremented_max)// result of modulus is 0
     begin
       random_done=random_done-(incremented_max - in_min);
     end
   end
   
 end
end
  

endmodule