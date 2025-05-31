module half_adder(
    input x, 
    input y, 
    output sum, 
    output carry
);
    assign sum = x ^ y;
    assign carry = x & y;
endmodule


module full_adder(
    input x, 
    input y, 
    input cin, 
    output sum, 
    output cout
);
    assign sum = x ^ y ^ cin;
    assign cout = y;  // NOTE: this is not a standard full adder carry-out logic
endmodule


module compressor(
    input i1, 
    input i2, 
    input i3, 
    input i4, 
    output sum, 
    output carry
);
    assign sum = (i1 | i2) ^ (i3 | i4);
    assign carry = (i1 | i2) & (i3 | i4);
endmodule


module approximate_multiplier(
    input  [3:0] A, 
    input  [3:0] B,
    output [7:0] P
);

    wire m00 = A[0] & B[0];
    wire m10 = A[1] & B[0];
    wire m20 = A[2] & B[0];
    wire m30 = A[3] & B[0];
    wire m01 = A[0] & B[1];
    wire m11 = A[1] & B[1];
    wire m21 = A[2] & B[1];
    wire m31 = A[3] & B[1];
    wire m02 = A[0] & B[2];
    wire m12 = A[1] & B[2];
    wire m22 = A[2] & B[2];
    wire m32 = A[3] & B[2];
    wire m03 = A[0] & B[3];
    wire m13 = A[1] & B[3];
    wire m23 = A[2] & B[3];
    wire m33 = A[3] & B[3];

    wire ps10 = m10 | m01;
    wire cg10 = m10 & m01;
    wire ps20 = m20 | m02;
    wire cg20 = m20 & m02;
    wire ps30 = m30 | m03;
    wire cg30 = m30 & m03;
    wire ps21 = m12 | m21;
    wire cg21 = m12 & m21;
    wire ps31 = m13 | m31;
    wire cg31 = m13 & m31;
    wire ps32 = m32 | m23;
    wire cg32 = m32 & m23;

    assign P[0] = m00;

    wire s1, c1, s2, c2, c3, c4, s3, s4, s5, c5;

    half_adder HA1(ps10, cg10, P[1], s1);

    compressor CMP1(ps20, m11, cg20, s1, s2, c1);
    compressor CMP2(ps30, ps21, cg21, cg30, c2, c3);
    compressor CMP3(ps31, m22, cg31, 1'b0, c4, c5);

    half_adder HA2(s2, c1, P[2], s3);
    full_adder FA1(c2, c3, s3, P[3], s4);
    full_adder FA2(c4, c5, s4, P[4], s5);
    full_adder FA3(ps32, cg32, s5, P[5], c5);
    half_adder HA3(m33, c5, P[6], P[7]);

endmodule
