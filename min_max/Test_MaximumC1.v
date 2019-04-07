`timescale 1ns / 1ps

module Test_MaximumOfTwoNumbers;
reg signed [7:0]first_number;
reg first_number_activation;//tells the module if it should consider this number to compare with the other one

reg signed [7:0]second_number;
reg second_number_activation;

wire signed [7:0] minimum;
wire minimum_activation; //tells the socond layr if this minimum valid or not

always
begin 
    #5
    first_number=-1;
    first_number_activation=1;
    second_number=-2;
    second_number_activation=1;
    #2
    first_number=-1;
    first_number_activation=0;
    second_number=-2;
    second_number_activation=0;
    #2
    first_number=1;
    first_number_activation=0;
    second_number=2;
    second_number_activation=1;
end

initial
begin 
    first_number=1;
    first_number_activation=0;
    second_number=-1;
    second_number_activation=1;
    $monitor("%d  %b",minimum,minimum_activation);
end

MaximumC1 _MaximumC1 (first_number,first_number_activation,
                                          second_number,second_number_activation,
                                          minimum,minimum_activation);

endmodule
