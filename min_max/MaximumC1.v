
//This module will pass the maximum of two signed numbers

module MaximumC1
#( parameter NUMBER_SIZE=4 )
(
input wire signed [NUMBER_SIZE-1:0]first_number,
input wire first_number_activation,//tells the module if it should consider this number to compare with the other one
input wire first_number_sign,


input wire signed [NUMBER_SIZE-1:0]second_number,
input wire second_number_activation,
input wire second_number_sign,

output wire signed [NUMBER_SIZE-1:0] maximum,
output wire	maximum_activation //tells the socond layr if this maximum valid or not
);
assign maximum =((first_number>=second_number)?
                    ((first_number_activation==1&&first_number_sign==1)?(-1*first_number):(-1*second_number)):
                    ((second_number_activation==1&&second_number_sign==1)?(-1*second_number):(-1*first_number)));
                    
assign maximum_activation = (first_number_activation&first_number_sign)|(second_number_activation/*&second_number_sign*/);
                   
endmodule