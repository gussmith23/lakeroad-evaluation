/* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_xor1_2(a, b, out0);
  input a;
  wire a;
  input b;
  wire b;
  output out0;
  wire out0;
  LUT2 #(
    .INIT(4'h6)
  ) lut2_0 (
    .I0(a),
    .I1(b),
    .O(out0)
  );
endmodule

