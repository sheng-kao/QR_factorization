module QR_top (
    clk,rst,
    a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44,
    a51, a52, a53, a54, a61, a62, a63, a64, a71, a72, a73, a74, a81, a82, a83, a84,
    r1, r2, r3, r4
);

input clk, rst;
input [12:0] a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44;
input [12:0] a51, a52, a53, a54, a61, a62, a63, a64, a71, a72, a73, a74, a81, a82, a83, a84;
output reg signed [12:0] r1, r2, r3, r4;

reg signed  [12:0]  GG_Xin11 , GG_Yin11, GR_Xin12 , GR_Yin12, GR_Xin13 , GR_Yin13, GR_Xin14 , GR_Yin14;
reg signed  [12:0]  GG_Xin21 , GG_Yin21, GR_Xin22 , GR_Yin22, GR_Xin23 , GR_Yin23;
reg signed  [12:0]  GG_Xin31 , GG_Yin31, GR_Xin32 , GR_Yin32;
reg signed  [12:0]  GG_Xin41 , GG_Yin41;


reg signed  [12:0]   regGR_Y12, regGR_Y13 , regGR_Y14;
reg signed  [12:0]   regGR_Y22, regGR_Y23;
reg signed  [12:0]   regGR_Y32;

wire signed  [12:0]  GG_Xout11 , GG_Yout11, GR_Xout12 , GR_Yout12, GR_Xout13 , GR_Yout13, GR_Xout14 , GR_Yout14;
wire signed  [12:0]  GG_Xout21 , GG_Yout21, GR_Xout22 , GR_Yout22, GR_Xout23 , GR_Yout23;
wire signed  [12:0]  GG_Xout31 , GG_Yout31, GR_Xout32 , GR_Yout32;
wire signed  [12:0]  GG_Xout41 , GG_Yout41;

wire signed  [7:0]   sign11to12, sign12to13, sign13to14;
wire signed  [7:0]   sign21to22, sign22to23;
wire signed  [7:0]   sign31to32;

reg k1;

reg en11;
reg en21;
reg en31;
reg en41;

wire en12, en13, en14;
wire en22, en23;
wire en32;

wire fin11, fin12, fin13, fin14;
wire fin21, fin22, fin23;
wire fin31, fin32;

wire ask11, ask12, ask13, ask14;
wire ask21, ask22, ask23;
wire ask31, ask32;

reg [3:0]  count_11;
reg [3:0]  count_12;
reg [3:0]  count_13;
reg [3:0]  count_14;

reg        fin12c;
reg        fin13c;
reg        fin14c;

reg        fin22c;
reg        fin23c;

reg        fin32c;

always@(*)begin
 regGR_Y12 = GR_Yout12;
 regGR_Y13 = GR_Yout13;
 regGR_Y14 = GR_Yout14;
 regGR_Y22 = GR_Yout22;
 regGR_Y23 = GR_Yout23;
 regGR_Y32 = GR_Yout32;
end

always @(*) begin
    r1 = GG_Xout11;
    r2 = GG_Xout21;
    r3 = GG_Xout31;
    r4 = GG_Xout41;
end

//----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----k1----

GG u11(
    .clk(clk), .rst(rst), .x(GG_Xin11), .y(GG_Yin11),.en(en11), .GG_Xout(GG_Xout11), .GG_Yout(GG_Yout11), 
    .d_sign(sign11to12), .fin(fin11), .ask(ask11),.next_en(en12));

GR u12(
    .clk(clk), .rst(rst), .d_sign(sign11to12), .x(GR_Xin12), .y(GR_Yin12), .en(en12), .GR_Xout(GR_Xout12),
     .GR_Yout(GR_Yout12),.d_sign_1(sign12to13),.ask(ask12),.fin(fin12),.next_en(en13));

GR u13(
    .clk(clk), .rst(rst), .d_sign(sign12to13), .x(GR_Xin13), .y(GR_Yin13), .en(en13), .GR_Xout(GR_Xout13),
     .GR_Yout(GR_Yout13),.d_sign_1(sign13to14),.ask(ask13),.fin(fin13),.next_en(en14));

GR u14(
    .clk(clk), .rst(rst), .d_sign(sign13to14), .x(GR_Xin14), .y(GR_Yin14), .en(en14), .GR_Xout(GR_Xout14),
     .GR_Yout(GR_Yout14), .ask(ask14), .fin(fin14));


always@(posedge clk or posedge rst)begin //initiallize
    if (rst) begin
        en41        <= 1'd0;
        en31        <= 1'd0;
        en21        <= 1'd0;
        k1          <= 1'd1;
        GG_Xin11    <= a71;
        GG_Yin11    <= a81;
        GR_Xin12    <= a72;
        GR_Yin12    <= a82;
        GR_Xin13    <= a73;
        GR_Yin13    <= a83;
        GR_Xin14    <= a74;
        GR_Yin14    <= a84;
        en11        <= 1'd0;
        count_11    <= 3'd0;
        count_12    <= 3'd0;
        count_13    <= 3'd0;
        count_14    <= 3'd0;
        fin12c      <= 1'd0;
        fin13c      <= 1'd0;
        fin14c      <= 1'd0;
        fin22c      <= 1'd0;
        fin23c      <= 1'd0;
        fin32c      <= 1'd0;
    end

    else begin
        if(k1)begin
        en11        <= 1'd1;
        end
        if (ask11) begin
        case (count_11)
            3'd0: begin
                GG_Xin11    <= a61;
                count_11    <= count_11+1'd1;
            end
            3'd1: begin
                GG_Xin11    <= a51;
                count_11    <= count_11+1'd1;
            end
            3'd2: begin
                GG_Xin11    <= a41;
                count_11    <= count_11+1'd1;
            end
            3'd3: begin
                GG_Xin11    <= a31;
                count_11    <= count_11+1'd1;
            end
            3'd4: begin
                GG_Xin11    <= a21;
                count_11    <= count_11+1'd1;
            end
            3'd5: begin
                GG_Xin11    <= a11;
                count_11    <= 3'd0;
            end
        endcase
    end
    if (ask12) begin
        case (count_12)
            3'd0: begin
                GR_Xin12    <= a62;
                count_12    <= count_12+1'd1;
            end
            3'd1: begin
                GR_Xin12    <= a52;
                count_12    <= count_12+1'd1;
            end
            3'd2: begin
                GR_Xin12    <= a42;
                count_12    <= count_12+1'd1;
            end
            3'd3: begin
                GR_Xin12    <= a32;
                count_12    <= count_12+1'd1;
            end
            3'd4: begin
                GR_Xin12    <= a22;
                count_12    <= count_12+1'd1;
            end
            3'd5: begin
                GR_Xin12    <= a12;
                count_12    <= 3'd0;
            end
        endcase
    end
    if (ask13) begin
        case (count_13)
            3'd0: begin
                GR_Xin13    <= a63;
                count_13    <= count_13+1'd1;
            end
            3'd1: begin
                GR_Xin13    <= a53;
                count_13    <= count_13+1'd1;
            end
            3'd2: begin
                GR_Xin13    <= a43;
                count_13    <= count_13+1'd1;
            end
            3'd3: begin
                GR_Xin13    <= a33;
                count_13    <= count_13+1'd1;
            end
            3'd4: begin
                GR_Xin13    <= a23;
                count_13    <= count_13+1'd1;
            end
            3'd5: begin
                GR_Xin13    <= a13;
                count_13    <= 3'd0;
            end
        endcase
    end
    if (ask14) begin
        case (count_14)
            3'd0: begin
                GR_Xin14    <= a64;
                count_14    <= count_14+1'd1;
            end
            3'd1: begin
                GR_Xin14    <= a54;
                count_14    <= count_14+1'd1;
            end
            3'd2: begin
                GR_Xin14    <= a44;
                count_14    <= count_14+1'd1;
            end
            3'd3: begin
                GR_Xin14    <= a34;
                count_14    <= count_14+1'd1;
            end
            3'd4: begin
                GR_Xin14    <= a24;
                count_14    <= count_14+1'd1;
            end
            3'd5: begin
                GR_Xin14    <= a14;
                count_14    <= 3'd0;
            end
        endcase
    end
    if(fin12)begin
        case (fin12c)
            3'd0:begin
                GG_Yin21    <=  regGR_Y12;
                fin12c      <=  fin12c + 1'd1;
            end
            3'd1:begin
                GG_Xin21    <=  regGR_Y12;
                en21        <= 1'd1;
                fin12c      <=  fin12c;
            end
        endcase
    end
    if(fin13)begin
        case (fin13c)
            3'd0:begin
                GR_Yin22    <=  regGR_Y13;
                fin13c      <=  fin13c + 1'd1;
            end
            3'd1:begin
                GR_Xin22    <=  regGR_Y13;
                fin13c  <=  fin13c;
            end
        endcase
    end
    if(fin14)begin
        case (fin14c)
            3'd0:begin
                GR_Yin23    <=  regGR_Y14;
                fin14c      <=  fin14c + 1'd1;
            end
            3'd1:begin
                GR_Xin23    <=  regGR_Y14;
                fin14c  <=  fin14c;
            end
        endcase
    end
    if(fin22)begin
        case (fin22c)
            3'd0:begin
                GG_Yin31    <=  regGR_Y22;
                fin22c      <=  fin22c + 1'd1;
            end
            3'd1:begin
                GG_Xin31    <=  regGR_Y22;
                en31        <= 1'd1;
                fin22c      <=  fin22c;
            end
        endcase
    end
    if(fin23)begin
        case (fin23c)
            3'd0:begin
                GR_Yin32    <=  regGR_Y23;
                fin23c      <=  fin23c + 1'd1;
            end
            3'd1:begin
                GR_Xin32    <=  regGR_Y23;
                fin23c      <=  fin23c;
            end
        endcase
    end
    if(fin32)begin
        case (fin32c)
            3'd0:begin
                GG_Yin41    <=  regGR_Y32;
                fin32c      <=  fin32c + 1'd1;
            end
            3'd1:begin
                GG_Xin41    <=  regGR_Y32;
                en41        <= 1'd1;
                fin32c      <=  fin32c;
            end
        endcase
    end
    end
    
end


//----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----k2----
GG u21(
    .clk(clk), .rst(rst), .x(GG_Xin21), .y(GG_Yin21),.en(en21), .GG_Xout(GG_Xout21), .GG_Yout(GG_Yout21), 
    .d_sign(sign21to22), .fin(fin21), .ask(ask21),.next_en(en22));

GR u22(
    .clk(clk), .rst(rst), .d_sign(sign21to22), .x(GR_Xin22), .y(GR_Yin22), .en(en22), .GR_Xout(GR_Xout22),
     .GR_Yout(GR_Yout22),.d_sign_1(sign22to23),.ask(ask22),.fin(fin22),.next_en(en23));

GR u23(
    .clk(clk), .rst(rst), .d_sign(sign22to23), .x(GR_Xin23), .y(GR_Yin23), .en(en23), .GR_Xout(GR_Xout23),
     .GR_Yout(GR_Yout23), .ask(ask23),.fin(fin23));


//----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----k3----

GG u31(
    .clk(clk), .rst(rst), .x(GG_Xin31), .y(GG_Yin31),.en(en31), .GG_Xout(GG_Xout31), .GG_Yout(GG_Yout31), 
    .d_sign(sign31to32), .fin(fin31), .ask(ask31),.next_en(en32));

GR u32(
    .clk(clk), .rst(rst), .d_sign(sign31to32), .x(GR_Xin32), .y(GR_Yin32), .en(en32), .GR_Xout(GR_Xout32),
     .GR_Yout(GR_Yout32), .ask(ask32),.fin(fin32));


//----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----k4----

GG u41(
    .clk(clk), .rst(rst), .x(GG_Xin41), .y(GG_Yin41),.en(en41), .GG_Xout(GG_Xout41) 
    );

endmodule
