/* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_xor4_2(a, b, out0);
  input [3:0] a;
  wire [3:0] a;
  input [3:0] b;
  wire [3:0] b;
  output [3:0] out0;
  wire [3:0] out0;
  LUT2 #(
    .INIT(4'h6)
  ) lut2_0 (
    .I0(a[0]),
    .I1(b[0]),
    .O(out0[0])
  );
  LUT2 #(
    .INIT(4'h6)
  ) lut2_1 (
    .I0(a[1]),
    .I1(b[1]),
    .O(out0[1])
  );
  LUT2 #(
    .INIT(4'h6)
  ) lut2_2 (
    .I0(a[2]),
    .I1(b[2]),
    .O(out0[2])
  );
  LUT2 #(
    .INIT(4'h6)
  ) lut2_3 (
    .I0(a[3]),
    .I1(b[3]),
    .O(out0[3])
  );
endmodule
