/* Generated by Yosys 0.19 (git sha1 a45c131b37c, clang 13.1.6 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_uge1_2(a, b, out0);
  input a;
  wire a;
  input b;
  wire b;
  output out0;
  wire out0;
  LUT2 #(
    .INIT(4'hd)
  ) lut2_0 (
    .I0(b),
    .I1(a),
    .O(out0)
  );
endmodule

