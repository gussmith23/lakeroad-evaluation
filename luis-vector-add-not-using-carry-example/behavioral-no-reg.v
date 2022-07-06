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
            assign s[i] = a[i] + b[i];
            assign y[i] = s[i];
        end
    endgenerate
endmodule
