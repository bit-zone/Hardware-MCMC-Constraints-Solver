`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2019 06:04:02 PM
// Design Name: 
// Module Name: stochasticControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stochasticControlUnit
#
(
parameter MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX = 2//gives us the maximum number of clauses
)
(
       input [1:0]in_current_state,//0(setup)....1(stochastic).....2(probabilistic)....3(checking)
       input in_clk,
       input in_local_done,
       input [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_clauses_enble,//existing clauses
       output reg [(2**MAXIMUM_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] out_clauses_enble,
       output reg out_find_best_gain_enable,
       output reg out_ready
       );
         parameter SETUP = 0;
         parameter RUNNING =1;
         parameter DONE = 2;
         parameter HOLD=3;
         
       reg [1:0] local_current_state = SETUP;
       reg [1:0] local_next_state;
  
       
       always@(*)
       begin
       case(local_current_state)
       SETUP:
       begin
           //control signals
           out_ready=0;
           out_clauses_enble=0;
           out_find_best_gain_enable = 0;
           //next state
           if(in_current_state == 0)
                   local_next_state=SETUP;
           if(in_current_state == 1)  
                   local_next_state=RUNNING;   
           else //probabilistic/checking
                   local_next_state=HOLD;     
       end
       RUNNING:
       begin
           //control signals
           out_ready=0;
           out_clauses_enble = in_clauses_enble;
           out_find_best_gain_enable = 1;
           //next state
           if(in_local_done)
           begin
            local_next_state=DONE; 
            out_ready=1;
           end
           else
           begin
            local_next_state=RUNNING;
           end
       end    
       DONE:
       begin
            //output of the module is ready
            out_ready=1;
            //next state
            if(in_current_state==0)
                local_next_state=SETUP;
            if(in_current_state==1)  
                local_next_state=DONE;   
            else//probabilistic/checking
                local_next_state=HOLD;
                   
       end
       HOLD:
       begin
            //control signals
            out_ready=0;
            out_clauses_enble=0;
            out_find_best_gain_enable = 0;
            //next state
             if(in_current_state ==0)
                    local_next_state=SETUP;
             if(in_current_state==1)  
                    local_next_state=RUNNING;   
             else//probabilistic/checking
                    local_next_state=HOLD;
       end
      
      
       endcase
       end
       
       
       always@(negedge in_clk)
       begin
       local_current_state <= local_next_state;
       end
       
endmodule
