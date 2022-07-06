module baseline(a, b, out0);
  input [7:0] a;
  input [7:0] b;
  output [7:0] out0;
  wire zero;
  wire [8-1:0] p;
  GND GND(.G(zero));
  LUT2 #(.INIT(4'h6)) l0 (.I0(a[0]), .I1(b[0]), .O(p[0]));
  LUT2 #(.INIT(4'h6)) l1 (.I0(a[1]), .I1(b[1]), .O(p[1]));
  LUT2 #(.INIT(4'h6)) l2 (.I0(a[2]), .I1(b[2]), .O(p[2]));
  LUT2 #(.INIT(4'h6)) l3 (.I0(a[3]), .I1(b[3]), .O(p[3]));
  LUT2 #(.INIT(4'h6)) l4 (.I0(a[4]), .I1(b[4]), .O(p[4]));
  LUT2 #(.INIT(4'h6)) l5 (.I0(a[5]), .I1(b[5]), .O(p[5]));
  LUT2 #(.INIT(4'h6)) l6 (.I0(a[6]), .I1(b[6]), .O(p[6]));
  LUT2 #(.INIT(4'h6)) l7 (.I0(a[7]), .I1(b[7]), .O(p[7]));
  CARRY8 #(.CARRY_TYPE("SINGLE_CY8")) carry0 (.CI(zero), .CI_TOP(zero), .DI(a), .S(p), .O(out0), .CO());
endmodule

module main #
(
    parameter W = 8,
    parameter N = 4
)
(
    input clock,
    input reset,
    input [W-1:0] a [N-1:0],
    input [W-1:0] b [N-1:0],
    output [W-1:0] y [N-1:0]
);

    logic [W-1:0] s [N-1:0];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            baseline inst (.a(a[i]), .b(b[i]), .out0(s[i]));
            assign y[i] = s[i];
        end
    endgenerate
endmodule
