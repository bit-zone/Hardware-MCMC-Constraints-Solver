`timescale 1ns / 1ps
//This module will pass the minimum of two signed numbers

module MaximumC1(
input wire signed [7:0]first_number,
input wire first_number_activation,//tells the module if it should consider this number to compare with the other one
input wire first_number_sign,


input wire signed [7:0]second_number,
input wire second_number_activation,
input wire second_number_sign,

output wire signed [7:0] minimum,
output wire	minimum_activation //tells the socond layr if this minimum valid or not
);
assign minimum =((first_number>=second_number)?
                    ((first_number_activation==1&&first_number_sign==0)?(first_number):(second_number)):
                    ((second_number_activation==1&&first_number_sign==0)?(second_number):(first_number)));
                    
assign minimum_activation = (first_number_activation&(~first_number_sign))|(second_number_activation&(~second_number_sign));
                   
endmodule