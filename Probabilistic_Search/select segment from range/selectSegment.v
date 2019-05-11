
/*
select a segment from the range of a variable
*/
module selectSegment(
//inputs
    input wire in_clock, 
    // the main clock of the system.
    input wire in_reset, 
    // if 1 , the module reads the seed value , 
    // it should be 1 only at beginning and 0 after beginning .
    input wire in_enable,
    input wire [7:0] in_seed, // initial value  , CANNOT be zero or negative
    input wire signed [7:0] in_c_less_than,
    input wire signed [7:0] in_c_more_than,
    input wire [1:0] in_flag,//1,2,3
  //ouputs
    output reg  [1:0] out_chosen_segment_type ,// (the choosing segment type) : 3 , 1 ,or 2 .
    output reg signed [7:0] out_chosen_segment_from,
    output reg signed [7:0] out_chosen_segment_to,
    output reg signed [7:0] out_chosen_segment_weight
    );

parameter EXPUP = 2'd2 ;
parameter EXPDOWN = 2'd1 ;
parameter UNIFORM = 2'd3 ;
parameter MINIMUM_VARIABLE = -8'd128 ;
parameter MAXIMUM_VARIABLE = 8'd127 ;

reg signed [7:0] weight0,weight1,weight2,weight3,from0,to0,from1,to1,from2,to2; // temporary variables 
reg [1:0] type0,type1,type2;
wire [1:0] choosen_segment_number;
wire signed [7:0] mid;
assign mid = (in_c_less_than+in_c_more_than)/2;
always @ (in_c_less_than,in_c_more_than,mid,in_flag,choosen_segment_number)
begin
    case (in_flag)
    // normal case
        3:
        // (expup uniform expdown)(2,3,1)
        begin
            if (in_c_less_than >= in_c_more_than)
            begin
                
                type0 = EXPUP;
                from0 = MINIMUM_VARIABLE;
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
                to2 = MAXIMUM_VARIABLE;
                weight2 = 2* (1-2**(-(to2-from2+1)));
                ///////////////////////////////////////
                weight3 = 0;

            end
        // (expup expdown)(2,1)
            if ( in_c_less_than < in_c_more_than )
            begin
                type0 = EXPUP;
                from0 = MINIMUM_VARIABLE;
                to0 = mid;
                weight0 = 2* (1-2**(-(to0-from0+1)));
                //////////////////////////////////////
                type1 = EXPDOWN;
                from1 = mid;
                to1 = MAXIMUM_VARIABLE;
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
            from0 = MINIMUM_VARIABLE;
            to0 = in_c_more_than;
            weight0 = 2* (1-2**(-(to0-from0+1)));
            ///////////////////////////////////////
            type1 = UNIFORM;
            from1 = in_c_more_than;
            to1 = MAXIMUM_VARIABLE;
            weight1 = to1-from1+1;
            ////////////////////////////////////////
            weight2 = 0;
            weight3 = 0;
        end
        1:
        begin
            type0 = UNIFORM;
            from0 = MINIMUM_VARIABLE;
            to0 = in_c_less_than;
            weight0 = to0-from0+1;
            ///////////////////////////////////////
            type1 = EXPDOWN;
            from1 = in_c_less_than;
            to1 = MAXIMUM_VARIABLE;
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
    RandomChoose  choose_segment (
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
