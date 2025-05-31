`timescale 1ns / 1ps

// Half Adder Module
module half_adder (
    input a, b,
    output sum, carry
);
    assign sum = a | b;
    assign carry = a & b;
endmodule

// Full Adder Module
module full_adder (
    input a, b, cin,
    output sum, cout
);
    assign sum = a | b | cin;
    assign cout = b;
endmodule

// 4:2 Compressor Module
module compressor (
    input in1, in2, in3, in4,
    output sum, carry
);
    assign sum = (in1 | in2) ^ (in3 | in4);
    assign carry = (in1 & in2) | (in3 & in4);
endmodule

// Approximate 4x4 Multiplier
module approximate_multiplier (
    input [3:0] a, b,
    output [7:0] result
);

    // Partial Product Generation
    wire pp00 = a[0] & b[0];
    wire pp10 = a[1] & b[0];
    wire pp20 = a[2] & b[0];
    wire pp30 = a[3] & b[0];

    wire pp01 = a[0] & b[1];
    wire pp11 = a[1] & b[1];
    wire pp21 = a[2] & b[1];
    wire pp31 = a[3] & b[1];

    wire pp02 = a[0] & b[2];
    wire pp12 = a[1] & b[2];
    wire pp22 = a[2] & b[2];
    wire pp32 = a[3] & b[2];

    wire pp03 = a[0] & b[3];
    wire pp13 = a[1] & b[3];
    wire pp23 = a[2] & b[3];
    wire pp33 = a[3] & b[3];

    // Pre-processing with OR and AND (Partial Compress)
    wire p1 = pp10 | pp01;
    wire g1 = pp10 & pp01;

    wire p2 = pp20 | pp02;
    wire g2 = pp20 & pp02;

    wire p3 = pp30 | pp03;
    wire g3 = pp30 & pp03;

    wire p4 = pp12 | pp21;
    wire g4 = pp12 & pp21;

    wire p5 = pp13 | pp31;
    wire g5 = pp13 & pp31;

    wire p6 = pp32 | pp23;
    wire g6 = pp32 & pp23;

    // Output Bit 0
    assign result[0] = pp00;

    // Intermediate Wires
    wire h1_carry, h1_sum;
    wire comp1_sum, comp1_carry;
    wire comp2_sum, comp2_carry;
    wire comp3_sum, comp3_carry;
    wire h2_sum, h2_carry;
    wire f1_sum, f1_carry;
    wire f2_sum, f2_carry;
    wire f3_sum, f3_carry;
    wire h3_sum, h3_carry;

    // Logic Processing
    half_adder ha1 (p1, g1, result[1], h1_carry);
    compressor comp1 (p2, pp11, g2, h1_carry, comp1_sum, comp1_carry);
    compressor comp2 (p3, p4, g4, g3, comp2_sum, comp2_carry);
    compressor comp3 (p5, pp22, g5, 1'b0, comp3_sum, comp3_carry);

    half_adder ha2 (comp1_sum, comp1_carry, result[2], h2_carry);
    full_adder fa1 (comp2_sum, comp2_carry, h2_carry, result[3], f1_carry);
    full_adder fa2 (comp3_sum, comp3_carry, f1_carry, result[4], f2_carry);
    full_adder fa3 (p6, g6, f2_carry, result[5], f3_carry);
    half_adder ha3 (pp33, f3_carry, result[6], result[7]);

endmodule


