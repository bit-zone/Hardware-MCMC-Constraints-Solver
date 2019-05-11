`timescale 1ns/1ns
/*
select a segment from the range of a variable
*/
module selectSegment(in_clock,in_reset,in_enable,in_seed,in_c_less_than,in_c_more_than,in_min_variable,
in_max_variable,in_flag,out_chosen_segment_type,out_chosen_segment_from,out_chosen_segment_to,
out_chosen_segment_weight);

    parameter WIDTH = 32;
//inputs
    input wire in_clock;
    // the main clock of the system.
    input wire in_reset; 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable;
    input wire [WIDTH:0] in_seed; // initial value  , CANNOT be zero or negative
    input wire signed [WIDTH-1:0] in_c_less_than;//y<c2
    input wire signed [WIDTH-1:0] in_c_more_than;//y>c1
    // minimum and maximum values for the chosen variable
    input wire signed [WIDTH-1:0] in_min_variable;
    input wire signed [WIDTH-1:0] in_max_variable;
    input wire [1:0] in_flag;//1,2,3
  //ouputs
    output wire  [1:0] out_chosen_segment_type ;// (the choosing segment type) : 3 , 1 ,or 2 .
    output wire signed [WIDTH-1:0] out_chosen_segment_from;
    output wire signed [WIDTH-1:0] out_chosen_segment_to;
    output wire  [WIDTH:0] out_chosen_segment_weight;
   

parameter EXPUP = 2'd2 ;
parameter EXPDOWN = 2'd1 ;
parameter UNIFORM = 2'd3 ;


wire  [WIDTH:0] weight0,weight1,weight2,weight3; // temporary variables 
wire signed [WIDTH-1:0] from0,to0,from1,to1,from2,to2;
wire [1:0] type0,type1,type2;
wire [1:0] choosen_segment_number;
wire signed [WIDTH-1:0] mid;
assign mid = (in_c_less_than+in_c_more_than)/2;

assign type0 = (in_flag == 1) ? UNIFORM : EXPUP;
assign type1 = ((in_flag == 1) ||((in_flag == 3)&&(in_c_less_than < in_c_more_than) )) ? EXPDOWN : UNIFORM;
assign type2 = EXPDOWN ;
assign from0 = in_min_variable;
assign to0 = (in_flag == 1) ? in_c_less_than : ((in_flag == 3)&&(in_c_less_than < in_c_more_than)) ? mid:in_c_more_than;
assign from1 = (in_flag == 1) ? in_c_less_than : ((in_flag == 3)&&(in_c_less_than < in_c_more_than)) ? mid:in_c_more_than;
assign to1 = ((in_flag == 3)&&(in_c_less_than >= in_c_more_than) ) ? in_c_less_than : in_max_variable;
assign from2 = in_c_less_than ;
assign to2 = in_max_variable ; 
assign weight0 = (in_flag == 1) ? to0-from0+1 : 2* (1-2**(-(to0-from0+1)));
assign weight1 = ((in_flag == 1) ||((in_flag == 3)&&(in_c_less_than < in_c_more_than) )) ? 2* (1-2**(-(to1-from1+1))): to1-from1+1;
assign weight2 = ((in_flag == 3)&&(in_c_less_than >= in_c_more_than) ) ? 2* (1-2**(-(to2-from2+1))) : 0;
assign weight3 = 0;
assign out_chosen_segment_type = (choosen_segment_number == 0) ? type0 :
(choosen_segment_number == 1) ? type1 : (choosen_segment_number == 2) ? type2 : 0;
assign out_chosen_segment_from = (choosen_segment_number == 0) ? from0 :
(choosen_segment_number == 1) ? from1 : (choosen_segment_number == 2) ? from2 : 0;
assign out_chosen_segment_to = (choosen_segment_number == 0) ? to0 :
(choosen_segment_number == 1) ? to1 : (choosen_segment_number == 2) ? to2 : 0;
assign out_chosen_segment_weight = (choosen_segment_number == 0) ? weight0 :
(choosen_segment_number == 1) ? weight1 : (choosen_segment_number == 2) ? weight2 : 0;

/*
always @ (*)
begin
    case (in_flag)
    // normal case
        3:
        // (expup uniform expdown)(2,3,1)
        begin
            if (in_c_less_than >= in_c_more_than)
            begin
                
                type0 = EXPUP;
                from0 = in_min_variable;
                to0 = in_c_more_than;
                weight0 = 2* (1-2**(-(to0-from0+1)));
                //////////////////////////////////////
                type1 = UNIFORM;
                from1 = in_c_more_than;
                to1 = in_c_less_than;
                weight1 = to1-from1+1;
                //////////////////////////////////////
                type2 = EXPDOWN;
                from2 = in_c_less_than;
                to2 = in_max_variable;
                weight2 = 2* (1-2**(-(to2-from2+1)));
                ///////////////////////////////////////
                weight3 = 0;

            end
        // (expup expdown)(2,1)
            if ( in_c_less_than < in_c_more_than )
            begin
                type0 = EXPUP;
                from0 = in_min_variable;
                to0 = mid;
                weight0 = 2* (1-2**(-(to0-from0+1)));
                //////////////////////////////////////
                type1 = EXPDOWN;
                from1 = mid;
                to1 = in_max_variable;
                weight1 = 2* (1-2**(-(to1-from1+1)));
                //////////////////////////////////////
                weight2 =0;
                weight3 =0;
            end
        end
    // greater than only
        2:
        begin
            type0 = EXPUP;
            from0 = in_min_variable;
            to0 = in_c_more_than;
            weight0 = 2* (1-2**(-(to0-from0+1)));
            ///////////////////////////////////////
            type1 = UNIFORM;
            from1 = in_c_more_than;
            to1 = in_max_variable;
            weight1 = to1-from1+1;
            ////////////////////////////////////////
            weight2 = 0;
            weight3 = 0;
        end
        1:
        begin
            type0 = UNIFORM;
            from0 = in_min_variable;
            to0 = in_c_less_than;
            weight0 = to0-from0+1;
            ///////////////////////////////////////
            type1 = EXPDOWN;
            from1 = in_c_less_than;
            to1 = in_max_variable;
            weight1 = 2* (1-2**(-(to1-from1+1)));
            ///////////////////////////////////////
            weight2 = 0;
            weight3 = 0;
        end
        default:
        begin
            weight0 <= 0;
            weight1 <= 0;
            weight2 <= 0;
            weight3 <= 0;
        end
    endcase
    case (choosen_segment_number)
        2'd0:
        begin
            out_chosen_segment_type <= type0 ;
            out_chosen_segment_from <= from0 ;
            out_chosen_segment_to <= to0 ;
            out_chosen_segment_weight <= weight0 ;
        end
        2'd1:
        begin
            out_chosen_segment_type<=type1;
            out_chosen_segment_from<=from1;
            out_chosen_segment_to<=to1;
            out_chosen_segment_weight<=weight1;
        end
        2'd2: 
        begin
            out_chosen_segment_type <= type2 ;
            out_chosen_segment_from <= from2 ;
            out_chosen_segment_to <= to2 ;
            out_chosen_segment_weight <= weight2;
        end
        default: 
        begin
            out_chosen_segment_type <= 0;
            out_chosen_segment_from <= 0;
            out_chosen_segment_to <= 0;
            out_chosen_segment_weight <= 0;
        end
    endcase
end
*/
    RandomChoose #(.WIDTH(WIDTH)) choose_segment (
  .in_clock(in_clock), 
  .in_reset(in_reset),
  .in_enable(in_enable),
  .in_weight0(weight0),
  .in_weight1(weight1),
  .in_weight2(weight2),
  .in_weight3(weight3),
  .in_seed(in_seed), 
  .out_segment_number(choosen_segment_number)
 );
endmodule
