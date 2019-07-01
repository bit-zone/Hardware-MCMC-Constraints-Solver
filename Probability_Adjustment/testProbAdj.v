
module testProbAdj;

    reg [7:0] in_Pls;
    
    reg in_clock;
    // the main clock of the system.
    reg in_reset; 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    reg in_enable;

    reg [7:0] in_seed; // initial value  , CANNOT be zero or negative
    
    wire out_is_local;




 initial begin
 
  in_clock = 0;
  forever
   #50 in_clock = ~ in_clock;
 
 end
   


 initial begin
  in_Pls = 8'd 50;
  in_reset = 0;
  in_enable = 0;

  // Wait 100 ns for global reset to finish
  #100;
      in_seed = 8'd 7;
      in_reset = 1;
      in_enable=1;
  
  #200;
  in_reset = 0;
  
  #100
  in_enable=0;
  #100
  
  in_enable=1;
  #100
  in_enable=0;
  #100
  in_enable=1;
  
   #100
   in_enable=0;
   #100
   in_enable=1;
   
    #100
    in_enable=0;
    #100
    in_enable=1;
    
     #100
     in_enable=0;
     #100
     in_enable=1;
     
      #100
      in_enable=0;
      #100
      in_enable=1;
      
  
  // Add stimulus here
  
 end





 initial begin
 $display("output of testing probability adjustment");
 $monitor(" local_move is %b , clk = %b", out_is_local, in_clock);
 end     



ProbabilityAdjustment uut(
    
    .in_Pls(in_Pls),
    
    .in_clock(in_clock),
     
    // the main clock of the system.
    
    .in_reset(in_reset),
     
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    
    .in_enable(in_enable),

    .in_seed(in_seed), // initial value  , CANNOT be zero or negative
    
    .out_is_local(out_is_local)
    );
    


endmodule
