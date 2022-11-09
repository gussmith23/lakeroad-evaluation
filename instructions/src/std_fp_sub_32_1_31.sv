module std_fp_sub_32_1_31 #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 1,
    parameter FRAC_WIDTH = 31
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out
);
  assign out = left - right;
endmodule