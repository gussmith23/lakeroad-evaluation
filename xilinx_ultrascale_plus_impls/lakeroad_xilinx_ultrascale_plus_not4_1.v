/* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

module lakeroad_xilinx_ultrascale_plus_not4_1(a, out0);
  input [3:0] a;
  wire [3:0] a;
  output [3:0] out0;
  wire [3:0] out0;
  LUT1 #(
    .INIT(2'h1)
  ) lut1_0 (
    .I0(a[0]),
    .O(out0[0])
  );
  LUT1 #(
    .INIT(2'h1)
  ) lut1_1 (
    .I0(a[1]),
    .O(out0[1])
  );
  LUT1 #(
    .INIT(2'h1)
  ) lut1_2 (
    .I0(a[2]),
    .O(out0[2])
  );
  LUT1 #(
    .INIT(2'h1)
  ) lut1_3 (
    .I0(a[3]),
    .O(out0[3])
  );
endmodule
