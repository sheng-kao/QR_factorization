module GR(
    clk,rst,d_sign,x,y,en,
    GR_Xout,GR_Yout,d_sign_1,ask,fin,next_en);

input clk;
input rst;
input en;
input signed [12:0] x ;
input signed [12:0] y ;
input signed [7:0]   d_sign;

output reg signed   [7:0]   d_sign_1;
output reg signed   [12:0] GR_Xout;
output reg signed   [12:0] GR_Yout;

output reg ask;
output reg fin;
output reg next_en;
reg signed [12:0] reg_x_fin;
reg signed [12:0] reg_y_fin;

reg [2:0]   cur_state;
reg [2:0]   next_state;
reg signed [12:0] reg_x_out1;
reg signed [12:0] reg_y_out1;
reg signed [12:0] y_mux;

reg fir;

parameter   [2:0]   first   = 4'd0;
parameter   [2:0]   sec     = 4'd1;
parameter   [2:0]   third   = 4'd2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cur_state  <=  first;
    end
    else begin
        cur_state  <=  next_state;
    end
end

always@(*)begin
    case(cur_state)
        first:begin
            if (en == 0) begin
                next_state = first;
            end
            else begin
                next_state = sec;
            end
        end
        sec:begin
            if (en == 0) begin
                next_state = first;
            end
            else begin
                next_state = third;
            end
        end
        third:begin
            if (en == 0) begin
                next_state = first;
            end
            else begin
                next_state = first;
            end
        end
    endcase
end

always @(*) begin
    y_mux = fir ? reg_x_fin : y;
end

always@(posedge clk or posedge rst)begin

    if(rst == 1)begin
        GR_Xout 	<= 13'b0;
		GR_Yout 	<= 13'b0;
        fin         <=0;
        ask         <=0;
        next_en     <= 1'b0;
        fir         <= 1'b0;
    end
    else if(en)begin
        case(cur_state)
            first:begin
                iter(x,y_mux,4'd0,d_sign,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                fin         <= 1'b0;
                d_sign_1    <= d_sign;
                next_en     <= 1'b1;
                fir         <= 1'b1;
            end
            sec :begin
                iter(reg_x_out1,reg_y_out1,4'd4,d_sign,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                d_sign_1    <= d_sign;
                ask         <=  1'b1;
            end
            third:begin
                iter(reg_x_out1,reg_y_out1,4'd8,d_sign,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                d_sign_1    <=  d_sign;
                GR_Xout     <=  reg_x_fin;
                GR_Yout     <=  reg_y_fin;
                ask         <=  1'b0;
                fin         <=  1'b1;
            end
        endcase
    end
end

task iter;

    input   signed  [12:0]  reg_x;
    input   signed  [12:0]  reg_y;

    input   signed  [3:0]   i;
    input           [7:0]   d_sign;


    output  signed  [12:0]  reg_x_fin;
    output  signed  [12:0]  reg_y_fin;
    output  signed  [12:0]  reg_x_4;
    output  signed  [12:0]  reg_y_4;

    reg signed  [1:0]   sign1;
    reg signed  [1:0]   sign2;
    reg signed  [1:0]   sign3;
    reg signed  [1:0]   sign4;
    reg signed  [12:0]  reg_x0 ;
    reg signed  [12:0]  reg_y0 ;
    reg signed  [12:0]  reg_x1 ;
    reg signed  [12:0]  reg_y1 ;
    reg signed  [12:0]  reg_x_temp ;
    reg signed  [12:0]  reg_y_temp ;
    reg signed  [21:0]  reg_xx;
    reg signed  [21:0]  reg_yy;
    reg signed  [8:0]   k;  
      
    begin

        sign1   =   d_sign[1:0];
        sign2   =   d_sign[3:2];
        sign3   =   d_sign[5:4];
        sign4   =   d_sign[7:6];

        k = 9'b010011011; 
//i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------
        //sign1 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd0+i;
        reg_x1 = reg_x0*sign1;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd0+i;
        reg_y1 = reg_y0*sign1;
        reg_y  = reg_y_temp+reg_y1;
//i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------
        // sign2 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd1+i;
        reg_x1 = reg_x0*sign2;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd1+i;
        reg_y1 = reg_y0*sign2;
        reg_y  = reg_y_temp+reg_y1;
//i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------
        // sign3 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd2+i;
        reg_x1 = reg_x0*sign3;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd2+i;
        reg_y1 = reg_y0*sign3;
        reg_y  = reg_y_temp+reg_y1;
//i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------        
        // sign4 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd3+i;
        reg_x1 = reg_x0*sign4;
        reg_x_4  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd3+i;
        reg_y1 = reg_y0*sign4;
        reg_y_4  = reg_y_temp+reg_y1;

//-----------------------------------------------------------------------------------------------------------------------------------
        reg_xx = reg_x_4*k;
        reg_yy = reg_y_4*k;
        reg_x_fin = reg_xx[20:8];
        reg_y_fin = reg_yy[20:8];
    end

endtask

endmodule
