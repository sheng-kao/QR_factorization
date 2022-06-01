module GG (clk, rst, x, y, en,/*iteration,*/ GG_Xout, GG_Yout,d_sign,fin,ask,next_en);

input clk;
input rst;
input signed [12:0] x ;
input signed [12:0] y ;
input en;
//input [4:0] iteration;

reg signed [8:0]k; //coefficient
output reg signed [12:0] GG_Xout;
output reg signed [12:0] GG_Yout;
output reg signed [7:0] d_sign; //store sign of GG to GR
output reg fin;
output reg ask;
output reg next_en;

reg signed [1:0] sign1 ;
reg signed [1:0] sign2 ;
reg signed [1:0] sign3 ;
reg signed [1:0] sign4 ;

reg signed  [12:0]  reg_x_fin ;
reg signed  [12:0]  reg_y_fin ;
reg signed  [12:0]  reg_x_out1 ;
reg signed  [12:0]  reg_y_out1 ;
reg signed  [12:0]  y_mux ;

reg [2:0]   cur_state;
reg [2:0]   next_state;
reg fir;

parameter   [2:0]   first   = 4'd0;
parameter   [2:0]   sec     = 4'd1;
parameter   [2:0]   third   = 4'd2;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        cur_state <= first ;
    end
    else begin
        cur_state <= next_state;
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
        GG_Xout 	<= 13'b0;
		GG_Yout 	<= 13'b0;
		d_sign	 	<= 8'b0;
        fin         <=0;
        ask         <=0;
        next_en     <= 1'b0;
        fir         <= 1'b0;
    end
    else if (en) begin
        case(cur_state)
            first:begin
                iter(x,y_mux,4'd0,sign1,sign2,sign3,sign4,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                fin     <= 1'b0;
                d_sign[1:0]  <= sign1;
                d_sign[3:2]  <= sign2;
                d_sign[5:4]  <= sign3;
                d_sign[7:6]  <= sign4;
                next_en      <= 1'b1;
                fir          <= 1'b1;
            end
            sec :begin
                iter(reg_x_out1,reg_y_out1,4'd4,sign1,sign2,sign3,sign4,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                d_sign[1:0]  <= sign1;
                d_sign[3:2]  <= sign2;
                d_sign[5:4]  <= sign3;
                d_sign[7:6]  <= sign4;
                ask          <=  1'b1;

            end
            third:begin
                iter(reg_x_out1,reg_y_out1,4'd8,sign1,sign2,sign3,sign4,reg_x_fin,reg_y_fin,reg_x_out1,reg_y_out1);
                d_sign[1:0]  <= sign1;
                d_sign[3:2]  <= sign2;
                d_sign[5:4]  <= sign3;
                d_sign[7:6]  <= sign4;
                GG_Xout <=  reg_x_fin;
                GG_Yout <=  reg_y_fin;
                fin          <=  1'b1;
                ask          <=  1'b0;
            end
        endcase
    end
end


task iter;
    input   signed  [12:0]  reg_x;
    input   signed  [12:0]  reg_y;
    input   signed  [3:0]   i;
    output  signed  [1:0]   sign1;
    output  signed  [1:0]   sign2;
    output  signed  [1:0]   sign3;
    output  signed  [1:0]   sign4;
    output  signed  [12:0]  reg_x_fin;
    output  signed  [12:0]  reg_y_fin;
    output  signed  [12:0]  reg_x_4;
    output  signed  [12:0]  reg_y_4;

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
        k = 9'b010011011; 
//i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------i1-------
        sign1 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd0+i;
        reg_x1 = reg_x0*sign1;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd0+i;
        reg_y1 = reg_y0*sign1;
        reg_y  = reg_y_temp+reg_y1;
//i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------i2-------
        sign2 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd1+i;
        reg_x1 = reg_x0*sign2;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd1+i;
        reg_y1 = reg_y0*sign2;
        reg_y  = reg_y_temp+reg_y1;
//i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------i3-------
        sign3 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

        reg_x_temp = reg_x;
        reg_y_temp = reg_y; 

        reg_x0 = reg_y_temp >>> 2'd2+i;
        reg_x1 = reg_x0*sign3;
        reg_x  = reg_x_temp-reg_x1;

        reg_y0 = reg_x_temp >>> 2'd2+i;
        reg_y1 = reg_y0*sign3;
        reg_y  = reg_y_temp+reg_y1;
//i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------i4-------        
        sign4 = (reg_x[12]^ reg_y[12]) ? 1 : -1;

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