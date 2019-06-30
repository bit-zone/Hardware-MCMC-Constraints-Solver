`timescale 1ns / 1ps


module ProbabilisticSearchControlUnit
#(parameter MAX_BIT_WIDTH_OF_CLAUSES_INDEX=3)(
input in_clk,
input in_reset,
input [7:0]in_top_module_state,

input [1:0] in_choosen_variable_type,
input no_need_to_sample,

input [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0] in_active_modules,//used to activate reduce modules as needed example 0011 -> we have two modules activated

output wire [7:0] out_probabilistic_search_state,
output wire out_boolean_propose_enable,
output wire [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]out_reduce_enable,
output wire out_select_segment_enable,

output wire out_DiscreteVariablesSizes_enable,
output wire out_random_enable,
output wire out_DiscreteValuesTable_enable,

output wire out_chosen_variable_is_discrete,//needed to decide the sampler source input
output wire out_sampler_enable,
output wire out_catch_U,
output wire out_calculate_probability_enable,
output wire out_compute_for_proposed_value
    );
parameter PROBABALISTIC=1;

parameter IDLE=2;
parameter BOOLEAN_PROPOSE=3;
parameter REDUCE=4;
parameter SELECTING_SEGMENT=5;
parameter SAMPLING=6;

parameter GET_NUMBER_OF_DISCRETE_VALUES=7;
parameter CHOOSE_DISCRETE_VALUE=8;
parameter READ_DISCRETE_VALUE=9;
parameter READY_CHECK_ME=10;
parameter DONE=11;

reg [7:0] state;
reg [7:0] next_state;

reg boolean_propose_enable;
reg [(2**MAX_BIT_WIDTH_OF_CLAUSES_INDEX)-1:0]reduce_enable;
reg select_segment_enable;

reg DiscreteVariablesSizes_enable;
reg random_enable;
reg DiscreteValuesTable_enable;

reg chosen_variable_is_discrete;//needed to decide the sampler source input
reg sampler_enable;
reg catch_U;
reg calculate_probability_enable;
reg compute_for_proposed_value;

assign out_boolean_propose_enable=boolean_propose_enable;
assign out_reduce_enable=reduce_enable;
assign out_select_segment_enable=select_segment_enable;

assign out_DiscreteVariablesSizes_enable=DiscreteVariablesSizes_enable;
assign out_random_enable=random_enable;
assign out_DiscreteValuesTable_enable=DiscreteValuesTable_enable;

assign out_chosen_variable_is_discrete=chosen_variable_is_discrete;//needed to decide the sampler source input
assign out_sampler_enable=sampler_enable;
assign out_catch_U=catch_U;
assign out_calculate_probability_enable=calculate_probability_enable;

assign out_compute_for_proposed_value=compute_for_proposed_value;



assign out_probabilistic_search_state=state;
always@* begin //determine next state
if (in_reset)
next_state=IDLE;
else begin
case (state)
IDLE: begin
    if(in_top_module_state==PROBABALISTIC)
              begin
                  case (in_choosen_variable_type)
                  2'b00:begin//choosen variable is 
                        next_state=BOOLEAN_PROPOSE; 
                        end
                  2'b01:begin//choosen variable is integer continous range
                        //next state
                        next_state=REDUCE; 
                        end
                  2'b10:begin//choosen variable is integer discrete range
                        next_state=GET_NUMBER_OF_DISCRETE_VALUES;
                        end
                  default: next_state=IDLE;
                  endcase
              end
              else state=IDLE; 
          end                     
BOOLEAN_PROPOSE:next_state=READY_CHECK_ME;

REDUCE:next_state=SELECTING_SEGMENT;
SELECTING_SEGMENT:next_state=SAMPLING;
SAMPLING:next_state=READY_CHECK_ME;

GET_NUMBER_OF_DISCRETE_VALUES:next_state=CHOOSE_DISCRETE_VALUE;
CHOOSE_DISCRETE_VALUE:next_state=READ_DISCRETE_VALUE;
READ_DISCRETE_VALUE:begin
                     if(no_need_to_sample)
                        next_state=SAMPLING;
                     else
                        next_state=READY_CHECK_ME;
                     end
READY_CHECK_ME:next_state=DONE;
DONE:next_state=IDLE;            
default:next_state=IDLE;                  
endcase
end
end


//sequential part update state
always @ (negedge in_clk)
begin
state<=next_state;
end

// produce output
always @ *
begin 
case (state)
IDLE:begin
         //disables
         boolean_propose_enable=1'b0;
         
         reduce_enable=0;
         select_segment_enable=1'b0;
        
         DiscreteVariablesSizes_enable=1'b0;
         random_enable=1'b0;
         DiscreteValuesTable_enable=1'b0;
        
         chosen_variable_is_discrete=1'b0;
         sampler_enable=1'b0;
         
         catch_U=1'b0;
         calculate_probability_enable=1'b0;
         compute_for_proposed_value=1'b0;
         
     end
BOOLEAN_PROPOSE:begin
                    //enables
                    boolean_propose_enable=1'b1;
                    catch_U=1'b1;
                    //disables
                    reduce_enable=0;
                    select_segment_enable=1'b0;
                    
                    DiscreteVariablesSizes_enable=1'b0;
                    random_enable=1'b0;
                    DiscreteValuesTable_enable=1'b0;
                    
                    chosen_variable_is_discrete=1'b0;
                    sampler_enable=1'b0;
                    
                    calculate_probability_enable=1'b0;
                    compute_for_proposed_value=1'b0;
                end
                
REDUCE:begin
           //enables
           reduce_enable=in_active_modules;
           catch_U=1'b1;
           //disables
           boolean_propose_enable=1'b0;
           
           select_segment_enable=1'b0;
        
           DiscreteVariablesSizes_enable=1'b0;
           random_enable=1'b0;
           DiscreteValuesTable_enable=1'b0;
        
           chosen_variable_is_discrete=1'b0;
           sampler_enable=1'b0;
           
           calculate_probability_enable=1'b0;
           compute_for_proposed_value=1'b0;
       end  
SELECTING_SEGMENT:begin
                      //enables
                      select_segment_enable=1'b1;
                      //disables
                      boolean_propose_enable=1'b0;
                      
                      reduce_enable=0;
                      
                      DiscreteVariablesSizes_enable=1'b0;
                      random_enable=1'b0;
                      DiscreteValuesTable_enable=1'b0;
                   
                      chosen_variable_is_discrete=1'b0;
                      sampler_enable=1'b0;
                      
                      catch_U=1'b0;
                      calculate_probability_enable=1'b0;
                      compute_for_proposed_value=1'b0;
                  end
SAMPLING:begin
            //enables
            if(in_choosen_variable_type==2'b10)//variable is descrete
                begin chosen_variable_is_discrete=1'b1;end    
            else
                begin chosen_variable_is_discrete=1'b0;end
            sampler_enable=1'b1;
            //disables
            boolean_propose_enable=1'b0;
            
            reduce_enable=0;
            select_segment_enable=1'b0;
            
            DiscreteVariablesSizes_enable=1'b0;
            random_enable=1'b0;
            DiscreteValuesTable_enable=1'b0;
            
            catch_U=1'b0;
            calculate_probability_enable=1'b0;
            compute_for_proposed_value=1'b0;
         end  

GET_NUMBER_OF_DISCRETE_VALUES:begin
                                //enables
                                DiscreteVariablesSizes_enable=1'b1;
                                catch_U=1'b1;
                                //disables
                                boolean_propose_enable=1'b0;
                                
                                reduce_enable=0;
                                select_segment_enable=1'b0;
                                
                                
                                random_enable=1'b0;
                                DiscreteValuesTable_enable=1'b0;
                                
                                chosen_variable_is_discrete=1'b0;
                                sampler_enable=1'b0;
                                
                                calculate_probability_enable=1'b0;
                                compute_for_proposed_value=1'b0;
                              end 

CHOOSE_DISCRETE_VALUE:begin
                          //enables
                          random_enable=1'b1;
                          //disables
                          boolean_propose_enable=1'b0;
                          
                          reduce_enable=0;
                          select_segment_enable=1'b0;
                          
                          DiscreteVariablesSizes_enable=1'b0;
                          DiscreteValuesTable_enable=1'b0;
                          
                          chosen_variable_is_discrete=1'b0;
                          sampler_enable=1'b0;
                          
                          catch_U=1'b0;
                          calculate_probability_enable=1'b0;
                          compute_for_proposed_value=1'b0;
                       end 
READ_DISCRETE_VALUE:begin
                     //enables
                     random_enable=1'b1;
                     //disables
                     boolean_propose_enable=1'b0;
                     
                     reduce_enable=0;
                     select_segment_enable=1'b0;
                     
                     DiscreteVariablesSizes_enable=1'b0;
                     DiscreteValuesTable_enable=1'b0;
                     
                     chosen_variable_is_discrete=1'b0;
                     sampler_enable=1'b0;
                     
                     catch_U=1'b0;
                     calculate_probability_enable=1'b0;
                     compute_for_proposed_value=1'b0;
                    end 
                    
READY_CHECK_ME:begin
                //enables
                compute_for_proposed_value=1'b1;
                //diables
                 boolean_propose_enable=1'b0;
                 
                 reduce_enable=0;
                 select_segment_enable=1'b0;
                 
                 DiscreteVariablesSizes_enable=1'b0;
                 random_enable=1'b0;
                 DiscreteValuesTable_enable=1'b0;
                 
                 chosen_variable_is_discrete=1'b0;
                 sampler_enable=1'b0;
                 
                 catch_U=1'b0;
                 calculate_probability_enable=1'b0;
                end

DONE:begin
        //enables
        calculate_probability_enable=1'b1;                
        //diables
         boolean_propose_enable=1'b0;
         
         reduce_enable=0;
         select_segment_enable=1'b0;
         
         DiscreteVariablesSizes_enable=1'b0;
         random_enable=1'b0;
         DiscreteValuesTable_enable=1'b0;
         
         chosen_variable_is_discrete=1'b0;
         sampler_enable=1'b0;
         
         catch_U=1'b0;
         compute_for_proposed_value=1'b0;
     end


endcase
end

/*
PROPOSE_BOOLEAN

PROPOSE_INTEGER_CONTINOUS
    REDUCE
    SELECT_SEGMENT
    SAMPLE 

PROPOSE_INTEGER_DISCRETE
    GET_NUMBER_OF_DISCRETE_VALUES
    RANDOMIZE_DISCRETE_VALUE_ADRESS
    GET_DISCRETE_VALUE
    SAMPLE 
READY_CHECK_ME

 */
endmodule
