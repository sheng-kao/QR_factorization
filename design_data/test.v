`timescale 1ns/10ps
`define SDFFILE    "./QR_top_syn.sdf"

module test ;
reg clk, rst;

reg signed [12:0] a11, a12, a13, a14;
reg signed [12:0] a21, a22, a23, a24;
reg signed [12:0] a31, a32, a33, a34;
reg signed [12:0] a41, a42, a43, a44;
reg signed [12:0] a51, a52, a53, a54;
reg signed [12:0] a61, a62, a63, a64;
reg signed [12:0] a71, a72, a73, a74;
reg signed [12:0] a81, a82, a83, a84;

QR_top u0(
//input
.clk(clk), .rst(rst), 
.a11(a11), .a12(a12), .a13(a13), .a14(a14),
.a21(a21), .a22(a22), .a23(a23), .a24(a24), 
.a31(a31), .a32(a32), .a33(a33), .a34(a34), 
.a41(a41), .a42(a42), .a43(a43), .a44(a44),
.a51(a51), .a52(a52), .a53(a53), .a54(a54),
.a61(a61), .a62(a62), .a63(a63), .a64(a64), 
.a71(a71), .a72(a72), .a73(a73), .a74(a74),
.a81(a81), .a82(a82), .a83(a83), .a84(a84)
);

always #5 clk = ~clk;

initial begin
	$fsdbDumpfile("QR_top.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;
end

`ifdef SDF
	initial $sdf_annotate(`SDFFILE, u0);
`endif

initial begin
#10
clk = 1;
rst = 1;

a11 = 13'd256;					 a12 = 13'd512;					  a13 = 13'd768;						a14 = 13'd1024;
a21 = 13'd512;					 a22 = 13'd256;					  a23 = 13'd768;						a24 = 13'd1024;
a31 = 13'd512;					 a32 = 13'd768;				  	  a33 = 13'd256;						a34 = 13'd1024;
a41 = 13'd512;					 a42 = 13'd768;				      a43 = 13'd1024;					    a44 = 13'd256;
a51 = 13'd768;					 a52 = 13'd512;					  a53 = 13'd1024;						a54 = 13'd256;
a61 = 13'd768;					 a62 = 13'd1024;		          a63 = 13'd512;						a64 = 13'd256;
a71 = 13'd768;					 a72 = 13'd1024;				  a73 = 13'd256;						a74 = 13'd512;
a81 = 13'd1024;					 a82 = 13'd768;					  a83 = 13'd256;						a84 = 13'd512;

#5
rst = 0;

#500
$finish;
end 
endmodule

 
