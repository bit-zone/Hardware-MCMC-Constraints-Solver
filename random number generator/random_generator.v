`timescale 1ns/1ns
/*
the random generator module is similar to random.randint(form,to) in python . It simply outputs 
a random integer from the specified min and max (range).
The module is synchronized with clock and reset .
If reset=1 , then  the module assign seed value to the initial random number , similar to 
random.seed(seed) in python .
If enable signal=0 , then the output remains like the previous one.
If enable signal=1 .then a new random output will be generated.
*/

module RandomGenerator(in_clock,in_reset,in_enable,in_min,in_max,in_seed,out_random);
  
parameter WIDTH = 8; //default value
  //inputs
input wire in_clock;
    // the main clock of the system.
input wire in_reset;
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
input wire in_enable;
    // it should be 1 if you want new numbers to be generated every posetive clock edge .
    // if 0 , the output remains like the previous one.
input wire signed [WIDTH-1:0] in_min;
    // specifies the minimum value of the target range.
input wire signed [WIDTH-1:0] in_max;
    // specifies the maximum value of the target range.
input wire [WIDTH-1:0] in_seed; // initial value  , CANNOT be zero or negative
  //ouputs
output reg signed [WIDTH-1:0] out_random; 
    // the random number 
    

reg feedback;
reg signed [WIDTH-1:0] random ; // the register that contains the random value
wire signed [WIDTH-1:0] incremented_max; 
assign incremented_max = in_max+1; // to make the maximum value in range not (max-1)

// this is the standard permutation in LFSR from Xilinx . 
/*
wire feedback = (WIDTH==8)?(random[7] ^ random[5] ^ random[4] ^ random[3]):
(WIDTH==9)?(random[8] ^ random[4]):
(WIDTH==10)?(random[9] ^ random[6]):
(WIDTH==11)?(random[10] ^ random[8]):
(WIDTH==12)?(random[11] ^ random[5] ^ random[3] ^ random[0]):
(WIDTH==13)?(random[11] ^ random[5] ^ random[2] ^ random[0]):
; */

//combinational instead of assign like the commented code above
always @(*)
    begin
      case (WIDTH)
      // in case of WIDTH =2 the module may work not well
        2: begin
          feedback = random[1] ^ random[0];
        end
        3: begin
          feedback = random[2] ^ random[1];
        end
        4: begin
          feedback = random[3] ^ random[2];
        end
        5: begin
          feedback = random[4] ^ random[2];
        end
        6: begin
          feedback = random[5] ^ random[4];
        end
        7: begin
          feedback = random[6] ^ random[5];
        end
        8: begin
          feedback = random[7] ^ random[5] ^ random[4] ^ random[3];
        end
        9: begin
          feedback = random[8] ^ random[4];
        end
        10: begin
          feedback = random[9] ^ random[6];
        end
        11: begin
          feedback = random[10] ^ random[8];
        end
        12: begin
          feedback = random[11] ^ random[5] ^ random[3] ^ random[0];
        end
        13: begin
          feedback = random[12] ^ random[3] ^ random[2] ^ random[0];
        end
        14: begin
          feedback = random[13] ^ random[4] ^ random[2] ^ random[0];
        end
        15: begin
          feedback = random[14] ^ random[13];
        end
        16: begin
          feedback = random[15] ^ random[14] ^ random[12] ^ random[3];
          end
        17: begin
          feedback = random[16] ^ random[13];
        end
        18: begin
          feedback = random[17] ^ random[10];
        end
        19: begin
          feedback = random[18] ^ random[5] ^ random[1] ^ random[0];
        end
        20: begin
          feedback = random[19] ^ random[16];
        end
        21: begin
          feedback = random[20] ^ random[18];
        end
        22: begin
          feedback = random[21] ^ random[20];
        end
        23: begin
          feedback = random[22] ^ random[17];
        end
        24: begin
          feedback = random[23] ^ random[22] ^ random[21] ^ random[16];
        end
        25: begin
          feedback = random[24] ^ random[21];
        end
        26: begin
          feedback = random[25] ^ random[5] ^ random[1] ^ random[0];
        end
        27: begin
          feedback = random[26] ^ random[4] ^ random[1] ^ random[0];
        end
        28: begin
          feedback = random[27] ^ random[24];
        end
        29: begin
          feedback = random[28] ^ random[26];
        end
        30: begin
          feedback = random[29] ^ random[5] ^ random[3] ^ random[0];
        end
        31: begin
          feedback = random[30] ^ random[27];
        end
        32: begin
          feedback = random[31] ^ random[21] ^ random[1] ^ random[0];
        end
        33: begin
          feedback = random[32] ^ random[19];
        end
      endcase
      end



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
 else if(in_enable) // randomize!
 begin
   // shift left and insert the feedback value to 
   //the random variable (principal of LFSR)
   
   random = {random[WIDTH-2:0], feedback}; 
   
   //mapping from the real output of LFSR to the specified range by modulus approach.
   if(random>=0)
   begin
     out_random = ((random ) % (incremented_max - in_min ) + in_min);
   end
   if(random<0)
   begin
     out_random = ((random ) % (incremented_max - in_min ) + in_min + (incremented_max - in_min));
     if(out_random==incremented_max)// result of modulus is 0
     begin
       out_random=out_random-(incremented_max - in_min);
     end
   end
   
 end
end
  

endmodule