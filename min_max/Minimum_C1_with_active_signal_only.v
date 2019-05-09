`timescale 1ns / 1ps

module Minimum_C1_with_active_signal_only// we use this module in both c1 and c2 as the biases are already separated with MaximumC1 and MaximumC2 modules
#( parameter NUMBER_SIZE=4 )
(
input wire signed [NUMBER_SIZE-1:0]first_number,
input wire first_number_activation,//tells the module if it should consider this number to compare with the other one



input wire signed [NUMBER_SIZE-1:0]second_number,
input wire second_number_activation,


output wire signed [NUMBER_SIZE-1:0] maximum,
output wire	maximum_activation //tells the socond layr if this maximum valid or not
);
assign maximum =((first_number<=second_number)?
                    ((first_number_activation==1)?(first_number):(second_number)):
                    ((second_number_activation==1)?(second_number):(first_number)));
                    
assign maximum_activation = (first_number_activation)|(second_number_activation);
                   
endmodule